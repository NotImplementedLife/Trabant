INCLUDE "src/include/macros.inc"

; Routine to copy a rectangular tilemap region from ROM to VRAM
SECTION "TilemapLoader", ROM0

; b  = width
; c  = height
; de = source
; hl = destination
TilemapLoadRect::
.colsLoop
	
	push bc
	.rowsLoop
		wait_vram
		ld a, [de]
		inc de
		ld [hli], a
		dec b
		jr nz, .rowsLoop 
	pop bc
	push bc
	
	ld a, b
	cpl
	add 33
	ld c, a
	xor a
	ld b, a
	add hl, bc
	pop bc

	dec c
	jr nz, .colsLoop
	ret
