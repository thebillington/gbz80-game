INCLUDE "hardware.inc"

Section "Header", rom0[$100]

EntryPoint:
    di
    jp Start

rept $150 - $104
    db 0
endr

Section "GameCode", rom0

Start:

; Wait for blank screen
.waitVBlank
    ld a, [rLY]
    cp 144
    jr c, .waitVBlank

    ; Load 0 into a and copy to the LCDC register
    xor a ; (ld a, 0)
    ld [rLCDC], a

    ; Load hl with the address in memory of the VRAM
    ld hl, $9000
    ld de, ImageData
    ld bc, EndImageData - ImageData

; Copy the images into memory
.copyImage
    ld a, [de]
    ld [hli], a ; Load a into hl and increment hl
    inc de
    dec bc
    ld a, b
    or c
    jr nz, .copyImage

    call ClearScreen
    ld hl, $9801
    ld d, $01
    call SetPixel
    
    ld hl, $9802
    ld d, $02
    call SetPixel
    
    ld hl, $9803
    ld d, $03
    call SetPixel

    ; Load colour pallet
    ld a, %11100100
    ld [rBGP], a

    ; Set the scroll x and y positions
    xor a ; (ld a, 0)
    ld [rSCX], a
    ld [rSCY], a

    ; Turn off sound
    ld [rNR52], a

    ; Turn screen back on
    ld a, %10000001
    ld [rLCDC], a

; Lock thread
.lockup
    jr .lockup

SetPixel:
    ld a, d
    ld [hl], a
    ret

ClearScreen:
    ld hl, $9800
    ld de, $9000
    ld bc, $5A00
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

Section "Image", rom0

ImageData:

    ; First
    db %00000000
    db %00000000

    db %00000000
    db %00000000
    
    db %00000000
    db %00000000
    
    db %00000000
    db %00000000
    
    db %00000000
    db %00000000
    
    db %00000000
    db %00000000
    
    db %00000000
    db %00000000
    
    db %00000000
    db %00000000

    ; Second
    db %11111111
    db %00000000
    
    db %11111111
    db %00000000
    
    db %11111111
    db %00000000
    
    db %11111111
    db %00000000
    
    db %11111111
    db %00000000
    
    db %11111111
    db %00000000
    
    db %11111111
    db %00000000

    db %11111111
    db %00000000

    ; Third
    db %00000000
    db %11111111

    db %00000000
    db %11111111
    
    db %00000000
    db %11111111
    
    db %00000000
    db %11111111
    
    db %00000000
    db %11111111
    
    db %00000000
    db %11111111
    
    db %00000000
    db %11111111
    
    db %00000000
    db %11111111

    ; Fourth
    db %11111111
    db %11111111
    
    db %11111111
    db %11111111
    
    db %11111111
    db %11111111
    
    db %11111111
    db %11111111
    
    db %11111111
    db %11111111
    
    db %11111111
    db %11111111
    
    db %11111111
    db %11111111

    db %11111111
    db %11111111
EndImageData: