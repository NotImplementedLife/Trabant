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
	
	ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_WINON | LCDCF_WIN9C00
	ldh [rLCDC], a
	
	ld a, $80
	ldh [rOBPI], a
	
	ld hl, IntroTrabantPalette0
	call loadObjPaletteFromHL
	
	ld a, [wTrabantColorId]
	call TrabantFrontSetColorObj
	
	
	
	jr @