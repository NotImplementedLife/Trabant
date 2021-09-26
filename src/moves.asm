INCLUDE "src/include/macros.inc"

SECTION "Moves", ROM0

MoveUp::
	ld b, -1
	jr UpdateY
	
MoveDown::
	ld b, 1
	jr UpdateY
	
UpdateY::
	ld hl, ShadowOAM
	ld c, 23
.loop
	ld a, [hl]
	add b
	ld [hli], a
	inc l
	inc l
	inc l
	dec c
	jr nz, .loop
	initOAM ShadowOAM
	ret
