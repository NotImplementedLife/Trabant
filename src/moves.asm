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
	
	ldh a, [hTrabantY]
	add b
	ldh [hTrabantY], a
	
	ret

IncreaseSpeed::
	ldh a, [hSpeed]
	cp 9
	ret z
	inc a
	ldh [hSpeed], a	
	ret
	
DecreaseSpeed::
	ldh a, [hSpeed]
	cp 2
	ret z
	dec a
	ldh [hSpeed], a
	ret


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
