INCLUDE "src/include/notes.inc"
INCLUDE "src/include/macros.inc"

; prerendered frequencies for musical notes
; http://www.devrs.com/gb/files/sndtab.html

SECTION "Musical notes", ROMX, ALIGN[8]

MusicalNotes::

DB $00, $2C ; C_3
DB $00, $9C ; C#3
DB $01, $06 ; D_3
DB $01, $6B ; D#3
DB $01, $C9 ; E_3
DB $02, $23 ; F_3
DB $02, $77 ; F#3
DB $02, $C6 ; G_3
DB $03, $12 ; G#3
DB $03, $56 ; A_3
DB $03, $9B ; A#3
DB $04, $DA ; B_3
DB $04, $16 ; C_4
DB $04, $4E ; C#4
DB $04, $83 ; D_4
DB $04, $B5 ; D#4
DB $04, $E5 ; E_4
DB $05, $11 ; F_4
DB $05, $3B ; F#4
DB $05, $63 ; G_4
DB $05, $89 ; G#4
DB $05, $AC ; A_4
DB $05, $CE ; A#4
DB $05, $ED ; B_4
DB $06, $0A ; C_5
DB $06, $27 ; C#5
DB $06, $42 ; D_5
DB $06, $5B ; D#5
DB $06, $72 ; E_5
DB $06, $89 ; F_5
DB $06, $9E ; F#5
DB $06, $B2 ; G_5
DB $06, $C4 ; G#5
DB $06, $D6 ; A_5
DB $06, $E7 ; A#5
DB $06, $F7 ; B_5
DB $07, $06 ; C_6
DB $07, $14 ; C#6
DB $07, $21 ; D_6
DB $07, $2D ; D#6
DB $07, $39 ; E_6
DB $07, $44 ; F_6
DB $07, $4F ; F#6
DB $07, $59 ; G_6
DB $07, $62 ; G#6
DB $07, $6B ; A_6
DB $07, $73 ; A#6
DB $07, $7B ; B_6
DB $07, $83 ; C_7

SECTION "Process Music Code", ROMX

ProcessMusic::
	ld a, [wCooldown]
	or a
	jr nz, .skipmusic
	
.readNote:
	ld h, HIGH(Music)
	ld a, [wMusicOffset]
	ld l, a
	inc a
	ld [wMusicOffset], a
	ld a, [hl]
	
	cp $FF
	jr z, .pauseinmusic
	
	ld l, a
		
	ldh a, [rNR51]
	or $22
	ldh [rNR51], a
	
	ld a, $77
	ldh [rNR50], a
	
	ld  a, $82
	ldh [rNR21], a
	ld  a, $a4
	ldh [rNR22], a
	
	ld h, HIGH(MusicalNotes)
	inc l
	ld a, [hld]
	ldh [rNR23], a
	
	ld a, [hl]
	or $80
	ldh [rNR24], a
	
.pauseinmusic:
	ld a, 5
	ld [wCooldown], a
	ret
.skipmusic:
	ld a, [wCooldown]
	dec a
	ld [wCooldown], a
	ret
	
SECTION "Music", ROM0, ALIGN[10]

Music::	
	REPT(4)
	DB B_5, B_5, B_5, C_5, D_5, G_5, G_5, G_5, F_5, G_5, A_5, A_5, A_5, B_5, C_5, B_5, A_5, B_5, G_5
	DB A_5, B_5, B_5, B_5, C_5, D_5, C_5, D_5, B_5, A_5, G_5, F_5, E_5, D_5, A_5, B_5, C_5, D_5, A_5, F_5, D_5, D_5, D_5, D_5, D_5, D_5, D_5, D_5, D_5, D_5,
    DB D_5, E_5, D_5, D_5, E_5, F_5, E_5, D_5, E_5, D_5, C_5, B_5, A_5, B_5, G_5, F_5, E_5, F_5, D_5, 
	DB D_5, G_5, G_5, G_5, A_5, F_5, E_5, E_5, E_5, F_5, G_5, A_5, A_5, A_5, B_5, G_5, F_5, E_5, F_5, D_5, D_5, C_5, B_5, A_5, G_5, D_5, E_5, F_5, G_5, G_5,
	ENDR
	