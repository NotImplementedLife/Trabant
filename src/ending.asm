INCLUDE "src/include/macros.inc"

SECTION "Ending", ROM0

Ending::
	ld bc, STATHandlerEnding
	call STATCopy
	
	call waitForVBlank
	ld a, $80
	ld [rBGPI], a
	ld hl, EndingPalettes
	REPT(8)
	call loadPaletteFromHL
	ENDR
	
	ld hl, $8000
	ld de, EndingImageTiles
	ld bc, EndingImageTilesEnd
	call loadMemoryDOUBLE
	
	xor a
	ld hl, $9800
	ld de, 12
	ld c, 18
.loopY
	ld b, 20
	.loopX
		push af
		wait_vram
		pop af
		ld [hli], a
		inc a
		dec b
		jr nz, .loopX
	
	add hl, de
	dec c
	jr nz, .loopY
	
	ld a, 1
	ldh [rVBK], a
	
	ld hl, $9800
	ld de, EndingAttributes
	ld bc, EndingAttributesEnd
	call loadMemoryDOUBLE
	
	xor a
	ldh [rVBK], a
	
	call waitForVBlank
	
	ldh a, [rSTAT]
	or $40
	ldh [rSTAT], a
	
	ld a, [rIE]
	or 2
	ld [rIE], a ; Enable STAT interrupt

.loop:
	call waitForVBlank
	call updateJoypadState	
	ld a, [wJoypadState]
	and a
	jr z, .loop
	
	; disable STAT
	ld a, $83
	ldh [rSTAT], a
	call waitForVBlank
	xor a
	ldh [rSCX], a
	ldh [rSCY], a
	
	ld a, $91
	ldh [rLCDC], a
	
	ld a, $80
	ld [rBGPI], a
	ld a, $FF
	REPT(64)
		ldh [rBGPD], a
	ENDR
	
	call clearVRAM		
	
	; reinit tile attributes
	ld a, 1
	ldh [rVBK], a
	
	ld d, $00
	ld hl, $9800
	ld bc, 1024
	call fillMemory
	
	xor a
	ldh [rVBK], a
	
	ret

SECTION "Ending STAT", ROM0

STATHandlerEnding::
	ldh a, [rLYC]
	inc a
	cp 143
	jr nz, .skip0
	xor a
.skip0
	ldh [rLYC], a	
	
	ld hl, rLCDC
	
	ldh a, [rLY]
	cp 90	
	call c, SetLCDC0
	call nc, SetLCDC1

.ret:
	pop de
	pop bc
    reti
	
SetLCDC0::
	ld b, $91
	ld [hl], b
	ret
	
SetLCDC1::
	ld b, $81
	ld [hl], b
	ret
	

