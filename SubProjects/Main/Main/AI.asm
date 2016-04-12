;Addresser
.def	Type = R22				;Type af vejstykket
.def	Gyro = R23				;Gyro værdi
.def	Length_L = R24			;Længden af vejstykket
.def	Length_H = R25			;Længden af vejstykket

.include "AI_Gyro.asm"
.include "AI_Skift.asm"
.include "AI_Read_Map.asm"
;.include "AI_Speed_Control.asm"
;.include "AI_Hastighed.asm"
;.include "Speed.asm"
.include "AI_Lap.asm"
.include "AI_Hall.asm"

;Konstanter
.equ	Gyro_Stort_Sving=40				;Disse værdier skal justeres
.equ	Gyro_Lille_Sving=85
.equ	Periode_Ligeud=1		;Periode når vi kører ligeud
.equ	Periode_Kort_Ligeud=14000
.equ	Periode_Stort_Sving=22000			;-- stort sving
.equ	Periode_Lille_Sving=25000			;-- lille sving
.equ	Periode_Mapping=22000	
.equ	Periode_UdAfSving = 3000
.equ	Brake_Time	= 140
;.equ	Motor_Ligeud=0			;Motor outpot som kan sættes som reference
;.equ	Motor_Ligeud_Min=20		;Motor outpot som kan sættes som reference
;.equ	Motor_Ligeud_Max=100			;Motor outpot som kan sættes som reference
;.equ	Motor_Stort_Sving=80
;.equ	Motor_Stort_Sving_Min=50
;.equ	Motor_Stort_Sving_Max=180
;.equ	Motor_Lille_Sving=80
;.equ	Motor_Lille_Sving_Min=50
;.equ	Motor_Lille_Sving_Max=180
;.equ	Motor_Mapping=100
;.equ	Motor_Mapping_Min=20
;.equ	Motor_Mapping_Max=100
;.equ	Motor_Preround=100

;.equ	Motor_Too_Slow=250
;.equ	Periode_Too_Slow=8000
;.equ	Motor_Ud_Af_Sving=200
.equ	Afstand_Ud_Af_Sving=5
.equ	Afstand_Kort_Lige=150

;Initialize først
.MACRO AI_Init

		ldi		YH,			HIGH(Map_Start)		;Indlæser første Ram hukommelse tildelt til mapping
		ldi		YL,			LOW(Map_Start)		;
		ldi		Type,		3
		ldi		Length_L,	10
		ldi		Length_H,	0
		ldi		R17,		0
		sts		AI_Check_Lap,	R17
		
		ldi		R16, high(Periode_Stort_Sving)
		sts		Periode_Stort_Sving_H, R16
		ldi		R16, low(Periode_Stort_Sving)
		sts		Periode_Stort_Sving_L, R16
		
		ldi		R16, high(Periode_Lille_Sving)
		sts		Periode_Lille_Sving_H, R16
		ldi		R16, low(Periode_Lille_Sving)
		sts		Periode_Lille_Sving_L, R16
		
		ldi		R16, high(Periode_Mapping)
		sts		Periode_Mapping_H, R16
		ldi		R16, low(Periode_Mapping)
		sts 	Periode_Mapping_L, R16
		
		ldi		R16, high(Periode_Kort_Ligeud)
		sts		Periode_Kort_Ligeud_H, R16
		ldi		R16, low(Periode_Kort_Ligeud)
		sts		Periode_Kort_Ligeud_L, R16
		
		ldi		R16, low(Periode_Ligeud)
		sts		Periode_Ligeud_L,R16
		ldi		R16, high(Periode_Ligeud)
		sts		Periode_Ligeud_H,R16
		
		ldi		R16, low(Periode_UdAfSving)
		sts		Periode_UdAfSving_L,R16
		ldi		R16, high(Periode_UdAfSving)
		sts		Periode_UdAfSving_H,R16
		
		ldi R16, 0b00111110
		out DDRA, R16

.ENDMACRO

Speed_Increase:

		lds		R10, AI_Check_Lap
		ldi		R16, 250
		
		mul		R10, R16

		lds		R16, Periode_Stort_Sving_L
		lds		R17, Periode_Stort_Sving_H
		
		sub		R16, R0
		sbc		R17, R1
		
		sts		Periode_Stort_Sving_L, R16
		sts		Periode_Stort_Sving_H, R17
		
		lds		R16, Periode_Lille_Sving_L
		lds		R17, Periode_Lille_Sving_H
		
		sub		R16, R0
		sbc		R17, R1

		sts		Periode_Stort_Sving_L, R16
		sts		Periode_Stort_Sving_H, R17
		
ret




