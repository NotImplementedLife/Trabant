INCLUDE "src/include/macros.inc"

SECTION "Game logic", ROM0

GamePlay::
	ld bc, STATHandlerParallax
	call STATCopy
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
	
	ld a, $80+14
	ldh [rOBPI], a
	ld a, $4A
	ldh [rOBPD], a
	ld a, $84
	ldh [rOBPD], a
	
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
	
	ld hl, $81C0
	ld de, SpeedTextTiles
	ld bc, SpeedTextTilesEnd
	call loadMemoryDOUBLE
	
	ld hl, ShadowOAM+24*4
	ld de, SpeedSprites
	ld bc, SpeedSpritesEnd-SpeedSprites
	call loadMemory
	
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
	
	xor a
	ldh [hMainScrollIndex], a
	ldh [hMountainScrollIndex], a	
	ldh [hLands0ScrollIndex], a
	ldh [hLands1ScrollIndex], a
	
	ldh [hMainCounter], a
	ldh [hMountainCounter], a	
	ldh [hLands0Counter], a
	ldh [hLands1Counter], a
	
	ld [wCooldown], a
	ld [wMusicOffset], a
	
	ld a, 2
	ldh [hSpeed], a
	
	ld a, $80
	ldh [hTrabantY], a

	call waitForVBlank
	
	ldh a, [rSTAT]
	or $40
	ldh [rSTAT], a
	
	ld a, [rIE]
	or 2
	ld [rIE], a ; Enable STAT interrupt
	
.loop
	call waitForVBlank	
	
	call updateJoypadState
	ld a, [wJoypadState]
	and PADF_UP | PADF_LEFT
	call nz, MoveUp
	ld a, [wJoypadState]
	and PADF_DOWN | PADF_RIGHT
	call nz, MoveDown
	
	call ProcessMusic
	
	ld hl, hMainScrollIndex
	ld bc, hMainCounter
	ld e, 1
	call AdjustScrollX
	
	ld hl, hLands0ScrollIndex
	ld bc, hLands0Counter
	ld e, 3
	call AdjustScrollX
	
	ld hl, hLands1ScrollIndex
	ld bc, hLands1Counter
	ld e, 5
	call AdjustScrollX
	
	ld hl, hMountainScrollIndex
	ld bc, hMountainCounter
	ld e, 7
	call AdjustScrollX
	
	ld a, [wJoypadPressed]
	and PADF_A
	call nz, IncreaseSpeed
	
	ld a, [wJoypadPressed]
	and PADF_B
	call nz, DecreaseSpeed
	
	ld a, [wJoypadPressed]
	and PADF_START
	jp nz, Restart
	
	jr .loop
	
Restart::
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
	
	; reset stack
	ld hl, $FFFE
	ld sp, hl
	
	jp Main