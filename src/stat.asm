SECTION "STAT Interrupt", ROM0[$0048]

STATInterrupt:
	push bc
	push de
	jp STATHandler
	
	
SECTION "STAT copier", ROMX

; copies code from bc address until finds "reti" instruction
; bc = source
STATCopy::
	ld hl, STATHandler
.loop
	ld a, [bc]
	inc bc
	ld [hli], a
	cp $D9 ; reti
	jr nz, .loop
	ret