INCLUDE "src/include/macros.inc"

SECTION "Game logic", ROM0

GamePlay::
	call clearVRAM
	
	call waitForVBlank
	ld hl, $8000
	ld de, TrabantSideTiles
	ld bc, TrabantSideTiles_End
	call loadMemoryDOUBLE
	
	ld hl, ShadowOAM
	ld de, TrabantSideSprite
	ld bc, TrabantSideSprite_End - TrabantSideSprite
	call loadMemory
	
	call waitForVBlank
	initOAM ShadowOAM
	
	ldh a, [rLCDC]
	or LCDCF_OBJON
	ldh [rLCDC], a
	
	ld a, $80
	ldh [rOBPI], a
	
	ld hl, IntroTrabantPalette0
	call loadObjPaletteFromHL
	
	
	
	jr @