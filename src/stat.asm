INCLUDE "src/include/macros.inc"

SECTION "STAT Interrupt", ROM0[$0048]

STATInterrupt:
	push bc
	push de
	jp STATHandler
	
	
SECTION "STAT Handler", ROM0

STATHandler:
	ldh a, [rLYC]
	inc a
	cp 143
	jr nz, .skip0
	xor a
.skip0
	ldh [rLYC], a	
	
	ldh a, [rLY]
	
	ld c, a
	ld b, 0
		
	ld hl, LYAddresses
	add hl, bc
	
	ld l, [hl]
	ld h, $FF
	
	wait_vram
	ld a, [hl]
	ldh [rSCX], a

.ret:
	pop de
	pop bc
	
    reti

SECTION "Hardcoded STAT addresses", ROM0

LYAddresses::

REPT(31)
DB LOW(hMountainScrollIndex)
ENDR

REPT(8)
DB LOW(hLands1ScrollIndex)
ENDR

REPT(16)
DB LOW(hLands0ScrollIndex)
ENDR

REPT(88)
DB LOW(hMainScrollIndex)
ENDR

