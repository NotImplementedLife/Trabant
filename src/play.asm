INCLUDE "src/include/macros.inc"

SECTION "Game logic", ROM0

GamePlay::
	call clearVRAM
	
	call waitForVBlank
	
	xor a
	ldh [rSCY], a
	
	ld a, $80+8
	ld [rBGPI], a
	ld hl, BackgroundGrassPalette0
	call loadPaletteFromHL
	
	ld hl, BackgroundGrassPalette1
	call loadPaletteFromHL
	
	ld hl, BackgroundGrassPalette2
	call loadPaletteFromHL
	
	
	ld hl, $8000
	ld de, TrabantSideTiles
	ld bc, TrabantSideTiles_End
	call loadMemoryDOUBLE
	
	ld hl, $9010
	ld de, BackgroundGrassTiles
	ld bc, BackgroundGrassTilesEnd
	call loadMemoryDOUBLE
	
	ld hl, $9800
	ld de, Background
	ld bc, BackgroundEnd
	call loadMemoryDOUBLE
	
	call waitForVBlank
	; Set tiles attributes (especially palettes)
	ld a, 1
	ldh [rVBK], a

	ld d, $03
	ld hl, $9960
	ld bc, 160
	call fillMemory
	
	ld d, $02
	ld hl, $9A00
	ld bc, 32
	call fillMemory
	
	ld d, $01
	ld hl, $9A20
	ld bc, 32
	call fillMemory
	
	xor a
	ldh [rVBK], a
	
	ld hl, ShadowOAM
	ld de, TrabantSideSprite
	ld bc, TrabantSideSprite_End - TrabantSideSprite
	call loadMemory
	
	call waitForVBlank
	initOAM ShadowOAM
	
	ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_WIN9C00
	ldh [rLCDC], a
	
	ld a, $80
	ldh [rOBPI], a
	
	ld hl, IntroTrabantPalette0
	call loadObjPaletteFromHL
	
	ld a, [wTrabantColorId]
	call TrabantFrontSetColorObj
	
	
	
	jr @