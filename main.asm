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

    ; Load images into VRAM
    ld hl, $9000
    ld de, NatImage
    ld bc, EndNatImage - NatImage
    call CopyImageData

    call ClearScreen
    ld hl, $9821
    ld d, $01
    call SetPixel
    
    ld hl, $9822
    ld d, $02
    call SetPixel
    
    ld hl, $9823
    ld d, $03
    call SetPixel
    
    ld hl, $9824
    ld d, $04
    call SetPixel

    ld hl, $9841
    ld d, $05
    call SetPixel
    
    ld hl, $9842
    ld d, $06
    call SetPixel
    
    ld hl, $9843
    ld d, $07
    call SetPixel
    
    ld hl, $9844
    ld d, $08
    call SetPixel
    
    ld hl, $9845
    ld d, $09
    call SetPixel
    
    ld hl, $9861
    ld d, $0A
    call SetPixel
    
    ld hl, $9862
    ld d, $0B
    call SetPixel
    
    ld hl, $9863
    ld d, $0C
    call SetPixel
    
    ld hl, $9864
    ld d, $0D
    call SetPixel
    
    ld hl, $9865
    ld d, $0E
    call SetPixel
    
    ld hl, $9881
    ld d, $0F
    call SetPixel
    
    ld hl, $9882
    ld d, $10
    call SetPixel
    
    ld hl, $9883
    ld d, $11
    call SetPixel
    
    ld hl, $9884
    ld d, $12
    call SetPixel
    
    ld hl, $9885
    ld d, $13
    call SetPixel
    
    ld hl, $98A1
    ld d, $14
    call SetPixel
    
    ld hl, $98A2
    ld d, $15
    call SetPixel
    
    ld hl, $98A3
    ld d, $16
    call SetPixel
    
    ld hl, $98A4
    ld d, $17
    call SetPixel
    
    ld hl, $98A5
    ld d, $00
    call SetPixel
    
    ld hl, $98C1
    ld d, $00
    call SetPixel
    
    ld hl, $98C2
    ld d, $19
    call SetPixel
    
    ld hl, $98C3
    ld d, $1A
    call SetPixel
    
    ld hl, $98C4
    ld d, $00
    call SetPixel
    
    ld hl, $98C5
    ld d, $00
    call SetPixel
    
    ld hl, $98E1
    ld d, $00
    call SetPixel
    
    ld hl, $98E2
    ld d, $1B
    call SetPixel
    
    ld hl, $98E3
    ld d, $1C
    call SetPixel
    
    ld hl, $98E4
    ld d, $00
    call SetPixel
    
    ld hl, $98E5
    ld d, $00
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

Section "Images", rom0

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

NatImage:
DB $FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$06,$07,$08,$0F
DB $FF,$FF,$00,$00,$00,$00,$0F,$0F,$73,$7F,$F4,$FF,$0B,$FF,$EC,$FF
DB $FF,$FF,$00,$00,$00,$00,$FF,$FF,$E7,$FF,$19,$FF,$84,$FF,$42,$FF
DB $FF,$FF,$00,$00,$00,$00,$00,$00,$E0,$E0,$F8,$F8,$5C,$FC,$2E,$FE
DB $16,$1B,$2D,$36,$5A,$6D,$41,$7F,$92,$FE,$94,$FC,$96,$FD,$9C,$F8
DB $18,$FF,$4B,$FF,$EF,$FF,$00,$00,$00,$00,$00,$00,$20,$C0,$00,$00
DB $22,$FF,$21,$FF,$91,$FF,$99,$FF,$59,$7F,$55,$77,$E5,$7F,$63,$63
DB $26,$FE,$13,$FF,$13,$FF,$8B,$FF,$8B,$FF,$8B,$FF,$8B,$FF,$8B,$FF
DB $00,$00,$00,$00,$00,$00,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
DB $99,$F8,$99,$FB,$DF,$FE,$D2,$FE,$D6,$FE,$76,$7A,$69,$71,$10,$20
DB $80,$00,$80,$C0,$C0,$E0,$A0,$A0,$E0,$E0,$C0,$A0,$40,$80,$00,$00
DB $7F,$43,$7D,$3F,$7F,$5F,$D6,$97,$1F,$9F,$1F,$92,$64,$1C,$00,$00
DB $4B,$7F,$5F,$7F,$D8,$7F,$51,$78,$E2,$64,$40,$40,$41,$40,$12,$01
DB $80,$80,$80,$80,$80,$80,$00,$80,$00,$80,$00,$80,$00,$80,$80,$80
DB $10,$20,$10,$20,$48,$70,$42,$7C,$48,$7F,$49,$7F,$49,$7F,$49,$7F
DB $00,$00,$10,$00,$00,$0F,$00,$00,$40,$80,$87,$F8,$F8,$FF,$E4,$FF
DB $00,$00,$00,$80,$00,$00,$03,$00,$18,$07,$83,$7F,$08,$FF,$08,$FF
DB $21,$1F,$2D,$1F,$D0,$3F,$20,$FF,$E0,$FF,$F0,$FF,$F0,$FF,$F1,$FF
DB $80,$80,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$80,$80
DB $29,$3F,$3D,$3F,$17,$17,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00
DB $E8,$FF,$EB,$FC,$DB,$FC,$13,$5C,$17,$98,$37,$98,$17,$78,$1F,$1F
DB $08,$FF,$C9,$3F,$C6,$3E,$C4,$3C,$E2,$1E,$E2,$1F,$E2,$1E,$FE,$FE
DB $F1,$FF,$73,$FF,$AE,$6E,$00,$40,$40,$20,$00,$20,$00,$C0,$00,$00
DB $80,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $08,$0F,$09,$0F,$08,$0F,$10,$1F,$10,$1F,$1F,$1F,$3F,$3F,$27,$3F
DB $04,$FC,$C4,$FC,$84,$FC,$82,$FE,$82,$FE,$FE,$FE,$FF,$FF,$E7,$FF
DB $3F,$3F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
EndNatImage: