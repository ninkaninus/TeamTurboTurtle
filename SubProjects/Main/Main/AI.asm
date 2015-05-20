;Addresser
.def	Type = R22				;Type af vejstykket
.def	Gyro = R23				;Gyro værdi
.def	Length_L = R24			;Længden af vejstykket
.def	Length_H = R25			;Længden af vejstykket

.include "AI_Gyro.asm"
.include "AI_Skift.asm"
.include "AI_Read_Map.asm"
.include "AI_Speed_Control.asm"
.include "AI_Lap.asm"
.include "AI_Hall.asm"

;Konstanter
.equ	Gyro_Stort_Sving=80				;Disse værdier skal justeres
.equ	Gyro_Lille_Sving=252
.equ	Periode_Ligeud=8000			;Periode når vi kører ligeud
.equ	Periode_Stort_Sving=32000			;-- stort sving
.equ	Periode_Lille_Sving=16000			;-- lille sving
.equ	Periode_Mapping=8000	
.equ	Motor_Ligeud=120			;Motor outpot som kan sættes som reference
.equ	Motor_Stort_Sving=90			
.equ	Motor_Lille_Sving=80
.equ	Motor_Mapping=110	
.equ	Motor_Preround=100

;Initialize først
.MACRO AI_Init

		ldi		YH,			HIGH(Map_Start)		;Indlæser første Ram hukommelse tildelt til mapping
		ldi		YL,			LOW(Map_Start)		;
		ldi		Type,		0
		ldi		Length_L,	0
		ldi		Length_H,	0
		ldi		R17,		0
		sts		AI_Check_Lap,	R17
		

		
.ENDMACRO




















