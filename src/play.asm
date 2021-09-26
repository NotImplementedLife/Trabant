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
	REPT(7)
	call loadPaletteFromHL
	ENDR

	
	
	ld hl, $8000
	ld de, TrabantSideTiles
	ld bc, TrabantSideTiles_End
	call loadMemoryDOUBLE
	
	ld hl, $9010
	ld de, BackgroundGrassTiles
	ld bc, BackgroundGrassTilesEnd
	call loadMemoryDOUBLE
	
	ld hl, $9100
	ld de, BackgroundHighwayTiles
	ld bc, BackgroundHighwayTilesEnd
	call loadMemoryDOUBLE
	
	ld hl, $8800
	ld de, LandscapeTiles
	ld bc, LandscapeTiles + 16*128
	call loadMemoryDOUBLE
	
	ld hl, $9200
	ld de, LandscapeTiles + 16*128
	ld bc, LandscapeTilesEnd
	call loadMemoryDOUBLE
	
	ld hl, $9800
	ld de, Background
	ld bc, BackgroundEnd
	call loadMemoryDOUBLE
	
	call waitForVBlank
	; Set tiles attributes (especially palettes)
	ld a, 1
	ldh [rVBK], a

	ld d, $05
	ld hl, $9800
	ld bc, 4*32
	call fillMemory
	
	ld d, $06
	ld hl, $9880
	ld bc, 32
	call fillMemory
	
	ld d, $07
	ld hl, $98A0
	ld bc, 2*32
	call fillMemory
	
	ld d, $02
	ld hl, $98E0
	ld bc, 32
	call fillMemory
	
	ld d, $04
	ld hl, $9900
	ld bc, 32
	call fillMemory
	
	ld d, $03
	ld hl, $9920
	ld bc, 6*32
	call fillMemory
	
	ld d, $83  ; bottom guardrail over sprite 
	ld hl, $99E0
	ld bc, 32
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
	
.loop
	call waitForVBlank
	call updateJoypadState
	ld a, [wJoypadState]
	and PADF_UP;
	call nz, MoveUp
	ld a, [wJoypadState]
	and PADF_DOWN
	call nz, MoveDown
	jr .loop
	
	
	jr @