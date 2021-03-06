    IF !DEF(MEMORY_MAP_INC)
MEMORY_MAP_INC SET 1

; Sprite VRAM map location
_SPRITE_VRAM EQU $8000

; Button read values
READ_D_PAD EQU $20
READ_BUTTONS EQU $10

; Sprites
SPRITE_Y EQU _RAM + $00
SPRITE_X EQU _RAM + $01
SPRITE_TILE_NO EQU _RAM + $02
SPRITE_SETTINGS EQU _RAM + $03

SPRITE_TWO_Y EQU _RAM + $04
SPRITE_TWO_X EQU _RAM + $05
SPRITE_TWO_TILE_NO EQU _RAM + $06
SPRITE_TWO_SETTINGS EQU _RAM + $07

SPRITE_THREE_Y EQU _RAM + $08
SPRITE_THREE_X EQU _RAM + $09
SPRITE_THREE_TILE_NO EQU _RAM + $0A
SPRITE_THREE_SETTINGS EQU _RAM + $0B

SPRITE_FOUR_Y EQU _RAM + $0C
SPRITE_FOUR_X EQU _RAM + $0D
SPRITE_FOUR_TILE_NO EQU _RAM + $0E
SPRITE_FOUR_SETTINGS EQU _RAM + $0F

SPRITE_FIVE_Y EQU _RAM + $10
SPRITE_FIVE_X EQU _RAM + $11
SPRITE_FIVE_TILE_NO EQU _RAM + $12
SPRITE_FIVE_SETTINGS EQU _RAM + $13

SPRITE_SIX_Y EQU _RAM + $14
SPRITE_SIX_X EQU _RAM + $15
SPRITE_SIX_TILE_NO EQU _RAM + $16
SPRITE_SIX_SETTINGS EQU _RAM + $17

SPRITE_SEVEN_Y EQU _RAM + $18
SPRITE_SEVEN_X EQU _RAM + $19
SPRITE_SEVEN_TILE_NO EQU _RAM + $1A
SPRITE_SEVEN_SETTINGS EQU _RAM + $1B

SPRITE_EIGHT_Y EQU _RAM + $1C
SPRITE_EIGHT_X EQU _RAM + $1D
SPRITE_EIGHT_TILE_NO EQU _RAM + $1E
SPRITE_EIGHT_SETTINGS EQU _RAM + $1F

; Frame counter
FCNT EQU _RAM + $100

; Gravity variables
GRAVITY EQU _RAM + $200
FALL_SPEED EQU _RAM + $201
Y_VELOCITY EQU _RAM + $202
JUMP_SPEED EQU _RAM + $203
PHYSICS_FRAME_COUNT EQU _RAM + $204

; Player state variables
JUMPING EQU _RAM + $205
HAS_JUMPED EQU _RAM + $206

ENDC