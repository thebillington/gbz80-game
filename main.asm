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

    call ClearRAM

    ld hl, $C000
    ld bc, $9801
    ld [hl], c
    inc hl
    ld [hl], b

; Wait for blank screen
.waitVBlank
    ld a, [rLY]
    cp 144
    jr c, .waitVBlank

    ; Load 0 into a and copy to the LCDC register
    xor a ; (ld a, 0)
    ld [rLCDC], a

    ; Load images into VRAM
    ld hl, $9000
    ld de, LogoImageTile
    ld bc, LogoImageTileEnd - LogoImageTile
    call CopyImageData

    call ClearScreen

    ld de, LogoImageMap
    ld bc, LogoImageMapEnd - LogoImageMap
    call LoadMap

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

LogoImageMap:
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D
DB $0E,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$01,$0F,$10,$11,$12,$13,$14,$15,$16,$17,$18,$01,$19
DB $1A,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$1B,$1C,$1D,$1E,$1F,$20,$21,$22,$23,$24,$25,$26,$1F
DB $27,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$28,$29,$2A,$2B,$29,$2C,$2D,$2E,$2F,$30,$31,$28,$32,$29,$33
DB $34,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$01,$35,$36,$37,$38,$39,$3A,$3B,$3C,$3D,$3E,$3F,$40,$41,$42
DB $43,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$44,$45,$46,$47,$48,$49,$4A,$4B,$4C,$4D,$4E,$4F,$50,$51,$52
DB $53,$54,$55,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
LogoImageMapEnd:

LogoImageTile:
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $3F,$1F,$3F,$1F,$3F,$1F,$3F,$1F,$3F,$1F,$3F,$1F,$3F,$1F,$3F,$1F
DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$80,$00,$80,$00
DB $C0,$E0,$E0,$F0,$F0,$F8,$F8,$FC,$F8,$FC,$F8,$FC,$F8,$FC,$F8,$FC
DB $FF,$7F,$FF,$7F,$FF,$7F,$FF,$7F,$FD,$7E,$FC,$7C,$FC,$7C,$FF,$7C
DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$FF,$00
DB $E3,$F1,$E3,$F1,$E3,$F1,$E3,$F1,$F3,$01,$02,$01,$00,$00,$C0,$00
DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$07,$FF,$03,$07,$03,$07
DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$E0,$FF,$E0,$E0,$E0,$E0
DB $8F,$C7,$8F,$C7,$8F,$C7,$8F,$C7,$8F,$C7,$0F,$C7,$0F,$07,$0F,$07
DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$E0,$C0,$E0,$C0,$E0,$C0
DB $F0,$F8,$F8,$FC,$FC,$FE,$FE,$FF,$FE,$FF,$3E,$3F,$3E,$3F,$3E,$3F
DB $03,$07,$07,$0F,$0F,$1F,$3F,$1F,$3F,$1F,$3F,$1F,$3F,$1F,$3F,$1F
DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$FF,$00,$00,$00,$00
DB $C0,$E0,$E0,$F0,$F0,$F8,$F8,$FC,$F8,$FC,$F8,$FC,$78,$FC,$78,$FC
DB $80,$00,$FF,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$81,$00,$80,$00
DB $F8,$FC,$FC,$F8,$F0,$F8,$F8,$F0,$F8,$F8,$F8,$FC,$F8,$FC,$F8,$FC
DB $FF,$7F,$FF,$7F,$FF,$7F,$FF,$7F,$FC,$7C,$FC,$7C,$FC,$7C,$FF,$7F
DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$00,$FF,$FF
DB $E0,$C0,$E0,$C0,$E0,$C0,$E0,$C0,$00,$00,$00,$00,$00,$00,$E0,$F0
DB $03,$07,$03,$07,$03,$07,$03,$07,$03,$07,$03,$07,$03,$07,$03,$07
DB $E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
DB $0F,$07,$0F,$07,$0F,$07,$0F,$07,$0F,$07,$0F,$07,$0F,$07,$0F,$07
DB $E0,$C0,$FF,$C0,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$E0,$C0,$E0,$C0
DB $3E,$3F,$FF,$3E,$FC,$FE,$FE,$FC,$FE,$FE,$FE,$FF,$7E,$3F,$3E,$3F
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$FF,$FF,$FF,$FF
DB $78,$FC,$78,$FC,$78,$FC,$78,$FC,$78,$FC,$78,$FC,$F8,$FC,$F8,$FC
DB $3F,$1F,$3F,$1F,$3F,$1F,$1F,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $80,$00,$80,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $F8,$FC,$F8,$FC,$F8,$FC,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $FF,$7F,$FF,$7F,$FF,$7F,$7F,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $E0,$F0,$E0,$F0,$E0,$F0,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $03,$07,$03,$07,$03,$07,$07,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $E0,$E0,$E0,$E0,$E0,$E0,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $0F,$07,$0F,$07,$0F,$07,$07,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $E0,$C0,$E0,$C0,$E0,$C0,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $3E,$3F,$3E,$3F,$3E,$3F,$3E,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $1F,$1F,$0F,$0F,$07,$07,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $FC,$F8,$F8,$F0,$F0,$E0,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$3F,$1F,$3F,$1F,$3F,$1F,$3F,$1F
DB $00,$00,$00,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
DB $00,$00,$00,$00,$00,$00,$00,$00,$C0,$E0,$E0,$F0,$F0,$F8,$F8,$FC
DB $00,$00,$00,$00,$00,$00,$00,$00,$FF,$7F,$FF,$7F,$FF,$7F,$FF,$7F
DB $00,$00,$00,$00,$00,$00,$00,$00,$E3,$F1,$E3,$F1,$E3,$F1,$E3,$F1
DB $00,$00,$00,$00,$00,$00,$00,$00,$F8,$F0,$F8,$F0,$F8,$F0,$F8,$F0
DB $00,$00,$00,$00,$00,$00,$00,$00,$1F,$0F,$1F,$0F,$1F,$0F,$1F,$0F
DB $00,$00,$00,$00,$00,$00,$00,$00,$8F,$C7,$8F,$C7,$8F,$C7,$8F,$C7
DB $00,$00,$00,$00,$00,$00,$00,$00,$C7,$C3,$C7,$C3,$C7,$C3,$C7,$C3
DB $00,$00,$00,$00,$00,$00,$00,$00,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
DB $00,$00,$00,$00,$00,$00,$00,$00,$01,$83,$03,$87,$07,$8F,$1F,$8F
DB $00,$00,$00,$00,$00,$00,$00,$00,$F0,$F0,$F8,$F8,$FC,$FC,$FC,$FE
DB $00,$00,$00,$00,$00,$00,$00,$00,$7E,$3E,$7E,$3E,$7E,$3E,$7E,$3E
DB $FF,$FF,$80,$00,$80,$00,$80,$00,$80,$00,$FF,$00,$FF,$FF,$FF,$FF
DB $F8,$FC,$F8,$FC,$F8,$FC,$F8,$FC,$F8,$FC,$FC,$F8,$F0,$F8,$F8,$F0
DB $FD,$7E,$FC,$7C,$FC,$7C,$FF,$7C,$FF,$7F,$FF,$7F,$FF,$7F,$FF,$7F
DB $FF,$00,$00,$00,$00,$00,$FF,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
DB $F3,$01,$03,$01,$03,$01,$C3,$01,$E3,$C1,$E3,$C1,$E3,$C1,$E3,$C1
DB $F8,$F0,$F8,$F0,$F8,$F0,$F8,$F0,$F8,$F0,$F8,$F0,$F8,$F0,$F8,$F8
DB $1F,$0F,$1F,$0F,$1F,$0F,$1F,$0F,$1F,$0F,$1F,$0F,$1F,$0F,$0F,$1F
DB $8F,$C7,$8F,$C7,$8F,$C7,$8F,$C7,$8F,$C7,$8F,$C7,$8F,$C7,$8F,$C7
DB $C7,$C3,$C7,$C3,$C7,$C3,$C7,$C3,$C7,$C3,$C7,$C3,$C7,$C3,$C7,$C3
DB $F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$F0
DB $3F,$1F,$3F,$1F,$3F,$1F,$3F,$1F,$3F,$1F,$3F,$1F,$3F,$1F,$1F,$3F
DB $1F,$8F,$1F,$8F,$1F,$8F,$1F,$8F,$1F,$8F,$1F,$8F,$1F,$8F,$1F,$8F
DB $FF,$FF,$80,$FF,$80,$80,$80,$80,$80,$80,$80,$80,$FF,$FF,$FF,$FF
DB $FC,$FE,$7C,$FE,$3C,$7E,$3C,$7E,$3C,$7E,$3C,$7E,$FC,$FE,$FC,$FE
DB $7E,$3E,$7E,$3E,$7E,$3E,$7E,$3E,$7E,$3E,$7E,$3E,$7E,$3E,$7E,$3E
DB $3F,$1F,$3F,$1F,$3F,$1F,$3F,$1F,$3F,$1F,$3F,$1F,$3F,$1F,$1F,$00
DB $FF,$FF,$FF,$FF,$81,$00,$80,$00,$80,$00,$80,$00,$80,$00,$00,$00
DB $F8,$F8,$F8,$FC,$F8,$FC,$F8,$FC,$F8,$FC,$F8,$FC,$F8,$FC,$F8,$00
DB $FC,$7C,$FC,$7C,$FC,$7C,$FF,$7F,$FF,$7F,$FF,$7F,$FF,$7F,$7F,$00
DB $00,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00
DB $03,$01,$00,$01,$00,$00,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$00
DB $FC,$FC,$FE,$FE,$7F,$FF,$3F,$7F,$1F,$3F,$0F,$1F,$07,$0F,$07,$00
DB $1F,$3F,$3F,$7F,$7F,$FF,$FE,$FE,$FC,$FC,$F8,$F8,$F0,$F0,$E0,$00
DB $8F,$C7,$8F,$87,$0F,$07,$0F,$07,$0F,$07,$0F,$07,$0F,$07,$07,$00
DB $C7,$C3,$C1,$C3,$C0,$C1,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$00
DB $F8,$F8,$FC,$FC,$FE,$FF,$7F,$FF,$3F,$7F,$1F,$3F,$0F,$1F,$0F,$00
DB $3F,$7F,$7F,$FF,$FE,$FE,$FC,$FC,$F8,$F8,$F0,$F0,$E0,$E0,$C0,$00
DB $1F,$8F,$1F,$0F,$1F,$0F,$1F,$0F,$1F,$0F,$1F,$0F,$1F,$0F,$0F,$00
DB $FF,$FF,$FF,$FF,$FF,$FF,$80,$FF,$80,$80,$80,$80,$80,$80,$80,$00
DB $FC,$FE,$FC,$FE,$FC,$FE,$7C,$FE,$3C,$7E,$3C,$7E,$3C,$7E,$7C,$00
DB $7E,$3E,$7F,$3E,$7F,$3F,$7F,$3F,$7F,$3F,$7F,$3F,$7F,$3F,$3F,$00
DB $00,$00,$FF,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00
DB $00,$00,$F8,$00,$F0,$F8,$F0,$F8,$F0,$F8,$F0,$F8,$F0,$F8,$F0,$00
LogoImageTileEnd: