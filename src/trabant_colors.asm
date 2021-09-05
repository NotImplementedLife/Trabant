INCLUDE "src/include/macros.inc"
SECTION "Trabant Colors", ROMX, BANK[1], ALIGN[4]

TrabantColors::

DB $1F, $00 ; red
DB $D9, $42 ; beige
DB $A0, $25 ; blue
DB $30, $77 ; sky blue
DB $F7, $03 ; lime
DB $98, $65 ; purple
DB $1F, $01 ; orange
DB $22, $22 ; turqoise


SECTION "Trabant Front Color Setter", ROM0

; a = color id (0-7)
TrabantFrontSetColor::
	rlca
	ld hl, TrabantColors
	add l
	ld l, a
	ld a, $82
	ldh [rBGPI], a
	ld a, [hli]
	ldh [rBGPD], a
	ld a, [hli]
	ldh [rBGPD], a
	ret

SECTION "Color Selection Sprite Tiles", ROMX

ColorSelectionTiles::
DB $00, $00, $01, $01, $03, $03, $07, $07, $0f, $0f, $07, $07, $03, $03, $01, $01 ; Arrow cap
DB $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $00, $00, $00, $00, $00, $00 ; Horizontal line
ColorSelectionTiles_End::

SECTION "Color Selection Sprites", ROMX

ColorSelectionSprites::
DB $44, $0C, $54, %00000000
DB $44, $14, $55, %00000000
DB $44, $94, $55, %00000000
DB $44, $9C, $54, %00100000
ColorSelectionSprites_End::




