SECTION "Vars", WRAM0

wTrabantColorId::
	DS 1
	
wCooldown::
	DS 1

wMusicOffset::
	DS 1
	
SECTION "OAM", WRAMX, ALIGN[0]

ShadowOAM::
	DS 160
	
SECTION "Variable STAT Interrupt", WRAM0

STATHandler::

DS 1024
	
	
SECTION "HRAM Vars", HRAM
	
hMountainScrollIndex:: DS 1
hLands0ScrollIndex:: DS 1	
hLands1ScrollIndex:: DS 1
hMainScrollIndex:: DS 1
	
hSpeed:: DS 1

	
hMountainCounter:: DS 1
hLands0Counter:: DS 1
hLands1Counter:: DS 1
hMainCounter:: DS 1

hTrabantY:: DS 1
