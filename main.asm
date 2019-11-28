INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"
INCLUDE "dma.asm"
INCLUDE "constants.asm"

; INCLUDE "Paddle.asm"
INCLUDE "Frog.asm"

; -------- INTERRUPT VECTORS --------
; specific memory addresses are called when a hardware interrupt triggers

; Vertical-blank triggers each time the screen finishes drawing. Video-RAM
; (VRAM) is only available during VBLANK. So this is when updating OAM /
; sprites is executed.
SECTION "VBlank", ROM0[$0040]
    jp _HRAM

; LCDC interrupts are LCD-specific interrupts (not including vblank) such as
; interrupting when the gameboy draws a specific horizontal line on-screen
SECTION "LCDC", ROM0[$0048]
    reti

; Timer interrupt is triggered when the timer, rTIMA, ($FF05) overflows.
; rDIV, rTIMA, rTMA, rTAC all control the timer.
SECTION "Timer", ROM0[$0050]
    reti

; Serial interrupt occurs after the gameboy transfers a byte through the
; gameboy link cable.
SECTION "Serial", ROM0[$0058]
    reti

; Joypad interrupt occurs after a button has been pressed. Usually we don't
; enable this, and instead poll the joypad state each vblank
SECTION "Joypad", ROM0[$0060]
    reti

; -------- END INTERRUPT VECTORS --------

Section "Header", rom0[$100]

EntryPoint:
    di  ; Disable interrupts
    jp Start    ; Jump to code start

; RGBASM will fix header code later
rept $150 - $104
    db 0
endr

Section "GameCode", rom0

Start:

    ld SP, $FFFF  ; Set stack pointer to the top of HRAM

    call ClearHRAM
    call ClearRAM   ; Fills RAM with 0's

    DMA_COPY    ; Move DMA routine into HRAM so it is accessible throughout DMA access

    ld a, IEF_VBLANK    ; Load VBlank mask into A Register
    ld [rIE], a ; Set VBlank interrupt flag
    ei  ; Enable interrupts

; Wait for blank screen for initial loads
.waitVBlank
    ld a, [rLY]
    cp 144
    jr c, .waitVBlank

    ; Load 0 into a and copy to the LCDC register
    xor a ; (ld a, 0)
    ld [rLCDC], a

    call ClearScreen

    ; Load images into VRAM
    ld hl, _SPRITE_VRAM
    ld de, FROG
    ld bc, FROGEND - FROG
    call CopyImageData

    ; Load colour pallet
    ld a, %11100100
    ld [rBGP], a    ; BG pallet
    ld [rOBP0], a   ; OBJ0 pallet

    ; Set the scroll x and y positions
    xor a ; (ld a, 0)
    ld [rSCX], a
    ld [rSCY], a

    ; Turn off sound
    ld [rNR52], a

    ; Turn screen back on
    xor a
    or LCDCF_ON
    or LCDCF_BGON
    or LCDCF_OBJ8
    or LCDCF_OBJON
    ld [rLCDC], a

    ; -------- Initialize physics ----------
    ld hl, GRAVITY
    ld [hl], 1
    ld hl, FALL_SPEED
    ld [hl], 4
    ld hl, Y_VELOCITY
    ld [hl], 1

    ld hl, SPRITE_X
	ld	[hl], X_ORIGIN	; set X to left
    ld hl, SPRITE_Y
	ld	[hl], Y_ORIGIN + (SCREEN_H / 2) - $08	; set Y to mid screen

.loop

    halt    ; Wait until interrupt is triggered (Only VBlank enabled)
    nop

    ; -------- Frame Rate Monitoring --------
    ld a, [FCNT]    ; Load frame count to A
    inc a           ; Incriment frame count
    ld [FCNT], a    ; Load A to frame count

    ; -------- Ground checks ---------------
    ld a, [SPRITE_Y]
    cp 120
    jr z, .GRAVITY
    ld a, [SPRITE_Y]
    cp 121
    jr z, .GRAVITY
    ld a, [SPRITE_Y]
    cp 122
    jr z, .GRAVITY
    ld a, [SPRITE_Y]
    cp 123
    jr z, .GRAVITY

.FALLING
    ; -------- Falling ---------------
    ld a, [Y_VELOCITY]      ; Load the y velocity
    ld b, a                 ; Store in b
    ld a, [SPRITE_Y]        ; Load the sprites y location
    add b                   ; Increase the y location by the current y velocity
    ld [SPRITE_Y], a        ; Store back

    ; ------- GRAVITY ------------------
.GRAVITY
    ld a, [FALL_SPEED]  ; Load the fall speed into register a
    ld b, a             ; Store in register b
    ld a, [Y_VELOCITY]       ; Load register a with the current Y velocity
    cp b                ; Compare this to the fall speed
    jr z, .JOYPAD    ; If already at max speed, continue

    ; ------- INCREASE_Y_VEL -----------
    ld a, [Y_VELOCITY]       ; Load register a with the current Y velocity
    inc a           ; Increment Y vel
    ld [Y_VELOCITY], a   ; Store the new Y velocity

    ; -------- Joypad Code --------
.JOYPAD
    ld a, READ_D_PAD       ; Mask to pull bit 4 low (read the D pad)
    ld [_HW], a     ; Pull bit 4 low
    ld a, [_HW]     ; Read the value of the inputs
    ld a, [_HW]     ; Read again to avoid debounce

    cpl             ; (A = ~A)
    and $0F         ; Remove top 4 bits

    swap a          ; Move the lower 4 bits to the upper 4 bits
    ld b, a         ; Save the buttons states to b

    ld a, READ_BUTTONS       ; Mask to pull bit 4 low (read the buttons pad)
    ld [_HW], a     ; Pull bit 4 low
    ld a, [_HW]     ; Read the value of the inputs
    ld a, [_HW]     ; Read again to avoid debounce

    cpl             ; (A = ~A)
    and $0F         ; Remove top 4 bits

    or b            ; Combine with the button states
    cp a, $0        ; Check if value is zero

    ; jr nz, .lockup  ; If input detected, halt

    push af         ; Save the joypad state
    and PADF_UP     ; If up then set NZ flag

    jr z, .JOY_RIGHT     ; If z flag then skip JOY_UP

    ; -------- JOY_UP --------
    ld a, [SPRITE_Y]    ; Get current Y value
    dec a           ; Move the sprite upwards
    ld [SPRITE_Y], a    ; write the new Y value to the sprite sheet

.JOY_RIGHT
    pop af          ; Load the joypad state
    push af         ; Save the joypad state
    and PADF_RIGHT  ; If Right then set NZ flag

    jr z, .JOY_DOWN

    ; -------- JOY_RIGHT --------
    ld a, [_RAM + $1]   ; Get current X value
    inc a               ; Move the sprite East
    ld [_RAM + $1], a   ; write the new X value to the sprite sheet

    ld a, OAMF_XFLIP    ; Load a with the sprite flipped x value
    ld [SPRITE_SETTINGS], a

.JOY_DOWN
    pop af          ; Load the joypad state
    push af         ; Save the joypad state
    and PADF_DOWN   ; If Right then set NZ flag

    jr z, .JOY_LEFT

    ; -------- JOY_DOWN --------
    ld a, [SPRITE_Y]   ; Get current Y value
    inc a          ; Move the sprite downwards
    ld [SPRITE_Y], a   ; write the new Y value to the sprite sheet

.JOY_LEFT
    pop af          ; Load the joypad state
    push af         ; Save the joypad state
    and PADF_LEFT   ; If Right then set NZ flag

    jr z, .JOY_A

    ; -------- JOY_LEFT --------
    ld a, [_RAM + $1]   ; Get current X value
    dec a               ; Move the sprite West
    ld [_RAM + $1], a   ; write the new X value to the sprite sheet

    ld a, 0
    ld [SPRITE_SETTINGS], a

.JOY_A
    pop af          ; Load the joypad state
    push af         ; Save the joypad state
    and PADF_A      ; If A then set the NZ flag

    jr z, .JOY_B

    ; -------- JOY_A -----------
    ld hl, Y_VELOCITY   
    ld [hl], -10        ; Set the Y_VELOCITY to move up

    ld a, [SPRITE_Y]    ; Load the sprite y location
    add 4               ; Add 4 to avoid platform lock
    ld [SPRITE_Y], a    ; Store back in the y location

.JOY_B
    pop af          ; Load the joypad state
    and PADF_B      ; If B then set the NZ flag

    jp z, .loop

    ; -------- JOY_B -----------
    ld a, [_RAM]    ; Get the current y value
    add $a          ; Move down by 10
    ld [_RAM], a    ; Write the new y value to the DMA

    ; -------- END Joypad Code --------

    ; -------- Frame Count Limiting ----
.FRAME_COUNT_LIMIT

    ld a, [FCNT]
    cp 30           ; check if frame count is 30
    jp nz, .loop     ; If frame count is 30, scroll X

    ; ------- Runs once every 30 frames -------

    ; ------- RESET_FRAME_COUNT -------------
.RESET_FRAME_COUNT
    ld a, 0
    ld [FCNT], a

    jp .loop        ; Restart the game loop

.lockup         ; Should never be reached
    jr .lockup

ClearRAM:
    ld hl, $C000
    ld bc, $DFFF - $C000
.clearLoop
    ld a, $00
    ld [hl], a
    inc hl
    dec bc
    ld a, c
    or b
    jr nz, .clearLoop
    ret

CopyImageData:
; Copy the images into memory
.copyImage
    ld a, [de]
    ld [hli], a ; Load a into hl and increment hl
    inc de
    dec bc
    ld a, b
    or c
    jr nz, .copyImage
    ret

LoadMap:
    ld hl, $9800
.mapLoadLoop
    push hl
    ld h, d
    ld l, e
    ld a, [hl]
    inc de
    pop hl
    ld [hl], a
    inc hl
    dec bc
    ld a, c
    or b
    jr nz, .mapLoadLoop
    ret

ClearScreen:
    ld hl, $9800
    ld de, $9000
    ld bc, $9FF0 - $9800
.clearLoop
    ld a, d
    ld [hl], a
    ld a, e
    ld [hl], a
    inc hl
    dec bc
    ld a, c
    or b
    jr nz, .clearLoop
    ret

ClearHRAM:
    ld hl, $FF80
    ld bc, $FF8D - $FF80
.clearLoopHRAM
    ld a, $00
    ld [hl], a
    inc hl
    dec bc
    ld a, c
    or b
    jr nz, .clearLoopHRAM
    ret

; -------- End Routines --------