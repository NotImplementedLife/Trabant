INCLUDE "src/include/macros.inc"

SECTION "Main", ROM0

Main::
	xor a
	ld [wTrabantColorId], a
	
	xor a
	ld b, 40
	ld hl, ShadowOAM
.initShadowOAM
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, .initShadowOAM
	
	ld hl, ShadowOAM
	ld de, ColorSelectionSprites
	ld bc, ColorSelectionSprites_End - ColorSelectionSprites
	call loadMemory
	
	call waitForVBlank
	ld a, $80
	ldh [rBGPI], a
	ld a, $FF
	ldh [rBGPD], a
	ldh [rBGPD], a
	ldh [rBGPD], a
	ldh [rBGPD], a
	ldh [rBGPD], a
	ldh [rBGPD], a
	ldh [rBGPD], a
	ldh [rBGPD], a
	
	ld hl, $8000
	ld de, TrabantFrontTiles
	ld bc, TrabantFrontTiles_End
	call loadMemoryDOUBLE
	
	ld hl, $8540
	ld de, ColorSelectionTiles
	ld bc, ColorSelectionTiles_End
	call loadMemoryDOUBLE
	
	ld hl, $8800
	ld de, TitleScreenMessageTiles
	ld bc, TitleScreenMessageTiles_End
	call loadMemoryDOUBLE
	
	ld b, 12
	ld c, 12
	ld de, TrabantFrontTilemap
	ld hl, $9824
	call TilemapLoadRect
	
	ld b, 18
	ld c, 4
	ld hl, $9C01
	ld de, TitleScreenMessageTilemap
	call TilemapLoadRect
	
	call waitForVBlank
	initOAM ShadowOAM
	
	ldh a, [rLCDC]
	or LCDCF_OBJON | LCDCF_WINON | LCDCF_WIN9C00
	ldh [rLCDC], a
	
	ld a, 8
	ldh [rWX], a
	
	ld a, 104
	ldh [rWY], a
	
	ld hl, IntroTrabantPalette0
	ld a, $80
	ldh [rBGPI], a
	call loadPaletteFromHL
	
.loopTitleScreen
	call waitForVBlank
	call updateJoypadState
	ld   a, [wJoypadPressed]
	push af
	and PADF_LEFT
	call nz, ChoosePrevColor
	pop af
	push af
	and PADF_RIGHT
	call nz, ChooseNextColor
	pop af
	and PADF_START
	jr z, .loopTitleScreen
	
	ldh a, [rLCDC]
	and  %11011101 ;NOT(LCDCF_OBJON | LCDCF_WINON)
	ldh [rLCDC], a
	
	ld a, $80
	ldh [rNR52], a
	ld a, $11
	ldh [rNR51], a
	ld a, $77
	ldh [rNR50], a
	
	ld  a, $26
	ldh [rNR10], a
	ld  a, $80
	ldh [rNR11], a
	ld  a, $f7
	ldh [rNR12], a
	ld  a, $27
	ldh [rNR13], a
	ld  a, $86
	ldh [rNR14], a
	
	ld b, 10
	ld hl, rSCY
.scroll
	call waitForVBlank
	dec [hl]
	dec b
	jr nz, .scroll
	
	ld b, 50
.scrollDelay
	call waitForVBlank
	dec b
	jr nz, .scrollDelay
	
	ld a, $80
	ldh [rNR52], a
	ld a, $22
	ldh [rNR51], a
	ld a, $77
	ldh [rNR50], a
	
	ld  a, $c1
	ldh [rNR21], a
	ld  a, $f7
	ldh [rNR22], a
	ld  a, $06
	ldh [rNR23], a
	ld  a, $81
	ldh [rNR24], a
	
	ld b, 16
	ld hl, rBGPI
.fadeOut
	ld a, $80
	ld [hl], a
	
	ld c, 4
	.solveOneColor
		push bc
		push af
		
		ld a, [rBGPD]
		ld c, a
		
		inc [hl]
		
		ld a, [rBGPD]
		ld b, a
		
		ld a, [hl]
		dec a
		ld [hl], a

		call FadeOut
		
		ld a, c
		ld [rBGPD], a
		ld a, b
		ld [rBGPD], a
		
		
		call waitForVBlank
		pop af
		pop bc
		dec c
		jr nz, .solveOneColor
	dec b
	jr nz, .fadeOut
	
	ld a, $80
	ldh [rBGPI], a
	
	ld a, $FF
	ld b, 8
:
	ldh [rBGPD], a
	dec b
	jr nz, :-

	
	jr @

SECTION "Input React", ROM0

ChoosePrevColor::
	ld c, -4
	ld a, [wTrabantColorId]
	dec a
	jr ChooseNextColor.SaveAndSet
	
ChooseNextColor::
	ld c, 4
	ld a, [wTrabantColorId]
	inc a
.SaveAndSet::
	push af
	
	ld hl, rSCX
	ld b, 32
	.loop1
		call waitForVBlank
		ld a, [hl]
		add c
		ld [hl], a
		dec b
		jr nz, .loop1
	
	pop af
	and 7
	ld [wTrabantColorId], a
	call TrabantFrontSetColor
	
	ld hl, rSCX
	ld b, 32
	.loop2
		call waitForVBlank
		ld a, [hl]
		add c
		ld [hl], a
		dec b
		jr nz, .loop2
	ret
	
SECTION "Fade out Process", ROM0

; bc = RGB15 color
; this function applies a transparent white overlay to this color
; new_color = old_color * 7/8 + white * 1/8
FadeOut::
	; make old_color * 7/8
	; process red component
	ld a, c
	and 31
	ld e, a
	rrca
	rrca
	rrca
	and %00011111
	cpl
	inc a
	add e
	ld e, a
	
	; process green component
	ld a, c
	and %11100000
	swap a
	rrca
	ld c, a
	
	ld a, b
	and %00000011
	rlca
	rlca
	rlca
	or c
	ld d, a
	rrca
	rrca
	rrca
	and %00011111
	cpl
	inc a
	add d
	ld d, a
	
	; process blue component
	ld a, b
	rrca
	rrca
	and %00011111
	ld c, a
	rrca
	rrca
	rrca
	and %00011111
	cpl
	inc a
	add c
	ld c, a
	
	; white/8 = rgb15(3,3,3) => add 3 to each component
	
	inc c
	inc c
	inc c
	
	inc d
	inc d
	inc d
	
	inc e
	inc e
	inc e
	
	; pack everything to bc
	
	ld a, c
	rlca 
	rlca
	ld b, a
	ld a, d
	rrca
	rrca
	rrca
	and 7
	or b
	ld b, a
	
	ld a, d
	rrca
	rrca
	rrca
	and %11100000
	or e
	ld c, a	
	
	ret
	
	