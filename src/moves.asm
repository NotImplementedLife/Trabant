INCLUDE "src/include/macros.inc"

SECTION "Moves", ROM0

MoveUp::
	ldh a, [hTrabantY]
	cp $54
	ret z
	ld b, -1
	jr UpdateY
	
MoveDown::
	ldh a, [hTrabantY]
	cp $86
	ret z
	ld b, 1
	jr UpdateY
	
UpdateY::	
	; experimentally, it proves very uneffective to use ShadowOAM here
	; therefore, write directly to OAM
	ld hl, $FE00
	REPT(23) ; # of sprites
	ld a, [hl]
	add b
	ld [hli], a
	inc l
	inc l
	inc l
	ENDR
	
	ldh a, [hTrabantY]
	add b
	ldh [hTrabantY], a
	
	ret

IncreaseSpeed::
	ldh a, [hSpeed]
	cp 15
	ret z
	inc a
	ldh [hSpeed], a	
	jp UpdateSpeedSprite
	
DecreaseSpeed::
	ldh a, [hSpeed]
	cp 1
	ret z
	dec a
	ldh [hSpeed], a
	jp UpdateSpeedSprite


; hl = target
; bc = counter
; e = overflow
; basically while ([bc]+[hSpeed]>e) [bc]-=e, inc [hl]
AdjustScrollX::
	ldh a, [hSpeed]
	ld d, a
	ld a, [bc]
	add d
	ld [bc], a
	
	cp e
	ret c
	
	ld a, [bc]
.loop
	inc [hl]
	sub e
	cp e
	jr nc, .loop
	
	ld [bc], a
	ret
	
	
SECTION "Speed Indicator", ROMX

SpeedTextTiles::

DB $0f, $0f, $09, $09, $08, $08, $06, $06, $01, $01, $09, $09, $0f, $0f, $00, $00
DB $00, $00, $00, $00, $79, $79, $2a, $2a, $2b, $2b, $2a, $2a, $31, $31, $20, $20
DB $00, $00, $00, $00, $99, $99, $aa, $aa, $32, $32, $22, $22, $99, $99, $00, $00
DB $c0, $c0, $40, $40, $c8, $c8, $40, $40, $40, $40, $40, $40, $e8, $e8, $00, $00
; Next: Digits (will come at $8200)
DB $00, $00, $18, $18, $24, $24, $24, $24, $24, $24, $24, $24, $18, $18, $00, $00
DB $00, $00, $30, $30, $10, $10, $10, $10, $10, $10, $10, $10, $38, $38, $00, $00
DB $00, $00, $18, $18, $24, $24, $04, $04, $08, $08, $10, $10, $3c, $3c, $00, $00
DB $00, $00, $3c, $3c, $04, $04, $08, $08, $04, $04, $24, $24, $18, $18, $00, $00
DB $00, $00, $20, $20, $20, $20, $28, $28, $3c, $3c, $08, $08, $08, $08, $00, $00
DB $00, $00, $3c, $3c, $20, $20, $38, $38, $04, $04, $04, $04, $38, $38, $00, $00
DB $00, $00, $18, $18, $20, $20, $38, $38, $24, $24, $24, $24, $18, $18, $00, $00
DB $00, $00, $3c, $3c, $04, $04, $08, $08, $10, $10, $10, $10, $10, $10, $00, $00
DB $00, $00, $18, $18, $24, $24, $18, $18, $24, $24, $24, $24, $18, $18, $00, $00
DB $00, $00, $18, $18, $24, $24, $24, $24, $1c, $1c, $04, $04, $18, $18, $00, $00

DB $00, $00, $c0, $c0, $80, $80, $bd, $bd, $ca, $ca, $ca, $ca, $b2, $b2, $00, $00
DB $00, $00, $0c, $0c, $14, $14, $96, $96, $a9, $a9, $aa, $aa, $cb, $cb, $00, $00

SpeedTextTilesEnd::

SpeedSprites::
DB $12, $08, $1C, $01
DB $12, $10, $1D, $01
DB $12, $18, $1E, $01
DB $12, $20, $1F, $01
DB $12, $28, $20, $01
DB $12, $2E, $22, $01
DB $12, $34, $20, $01
DB $12, $3C, $2A, $01
DB $12, $44, $2B, $01


SpeedSpritesEnd::

UpdateSpeedSprite::
	or a     
	daa
	
	ld b, a
	swap a
	and $0F
	or $20
	ld [$FE72], a
	
	ld a, b
	and $0F
	or $20
	ld [$FE76], a
	
	
	ret
