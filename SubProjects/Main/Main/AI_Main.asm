;Den her fil indeholde det der skal initializeres for at AI kan virke, samt diverse konstanter.

;Addresser
.def	Laengde = R22			;Laengden af vejstykket
.def	Type = R23				;Type af vejstykket
.def	Accel = R24				;Gyro værdi

.include "AI_Lap.asm"
.include "AI_Hastighed.asm"
.include "AI_Hall.asm"

;Konstanter
.equ	Accel_Stort_Sving=40				;Disse værdier skal justeres
.equ	Accel_Lille_Sving=75
.equ	Periode_l=250			;Periode når vi kører ligeud
.equ	Periode_s2=12000			;-- stort sving
.equ	Periode_s1=12000			;-- lille sving
.equ	Periode_m=8000			;Perioden i mapping round

.equ AI_Lap_Preround = 0
.equ AI_Lap_Mapping = 1
.equ AI_Lap_Speed = 2

;Initialize først
.MACRO AI_Init
		ldi R16, AI_Lap_Preround				;Gemmer AI_Check_Lap i ram til 0		
		sts AI_Check_Lap, R16					;			
		sts AI_Hastighed_D, R16					;Den passive hastighedsforøgelse bliver sat til 0. Hver gang bilen passerer målstregen efter den første vil denne blive forøget med 1.
		
;		ldi		R20,			100				;Initial værdi for AI_Hastighed_set, dette bruges til at bestemme hastigheden i den første runde 
;		sts		AI_Hastighed_set, R20

		ldi		YH,			HIGH(Map_Start)		;Indlæser første Ram hukommelse tildelt til mapping
		ldi		YL,			LOW(Map_Start)		;
		
		;out		OCR2,			AI_Hastighed_out	;Outputter hastigheden til motoren
.ENDMACRO

;-------------------------------

