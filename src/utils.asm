INCLUDE "src/include/macros.inc"
SECTION "Filler", ROM0


; fillMemory
; arguments:
; 	d = value to fill 
;	hl = destination address
;	bc = data size
;--------------------------------------------------------------
fillMemory::	
	wait_vram
	ld a, d
    ld [hli], a
    dec bc
    ld a ,b               ; Check if count is 0, since `dec bc` doesn't update flags
    or c                  ; Basically check if b == c == 0
    jr nz, fillMemory
	ret
	