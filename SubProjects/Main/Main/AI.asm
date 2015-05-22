;Addresser
.def	Type = R22				;Type af vejstykket
.def	Gyro = R23				;Gyro værdi
.def	Length_L = R24			;Længden af vejstykket
.def	Length_H = R25			;Længden af vejstykket

.include "AI_Gyro.asm"
.include "AI_Skift.asm"
.include "AI_Read_Map.asm"
.include "AI_Speed_Control.asm"
;.include "AI_Hastighed.asm"
;.include "Speed.asm"
.include "AI_Lap.asm"
.include "AI_Hall.asm"

;Konstanter
.equ	Gyro_Stort_Sving=20				;Disse værdier skal justeres
.equ	Gyro_Lille_Sving=75
.equ	Periode_Ligeud=8000		;Periode når vi kører ligeud
.equ	Periode_Stort_Sving=9000			;-- stort sving
.equ	Periode_Lille_Sving=9000			;-- lille sving
.equ	Periode_Mapping=12000	
.equ	Motor_Ligeud=0			;Motor outpot som kan sættes som reference
.equ	Motor_Ligeud_Min=100			;Motor outpot som kan sættes som reference
.equ	Motor_Ligeud_Max=255			;Motor outpot som kan sættes som reference
.equ	Motor_Stort_Sving=0	
.equ	Motor_Stort_Sving_Min=80
.equ	Motor_Stort_Sving_Max=185
.equ	Motor_Lille_Sving=0
.equ	Motor_Lille_Sving_Min=80
.equ	Motor_Lille_Sving_Max=180
.equ	Motor_Mapping=100
.equ	Motor_Mapping_Min=100
.equ	Motor_Mapping_Max=120
.equ	Motor_Preround=100
.equ	Motor_Ud_Af_Sving=200


.equ	Motor_Too_Slow=180
.equ	Periode_Too_Slow=15000

;Initialize først
.MACRO AI_Init

		ldi		YH,			HIGH(Map_Start)		;Indlæser første Ram hukommelse tildelt til mapping
		ldi		YL,			LOW(Map_Start)		;
		ldi		Type,		3
		ldi		Length_L,	0
		ldi		Length_H,	0
		ldi		R17,		0
		sts		AI_Check_Lap,	R17
;		ldi		R16,	0b00111110
;		out		DDRA,	R16
		

		
.ENDMACRO





;LED:

		cpi		R16,	1
		breq	LED1
		cpi		R16,	2
		breq	LED2
		cpi		R16,	3
		breq	LED3
		cpi		R16,	4
		breq	LED4
		cpi		R16,	5
		breq	LED5

		ldi		R16,	0b00000000
		out		PORTA,	R16

ret

LED1:

		ldi		R16,	0b00000010
		out		PORTA,	R16

ret

LED2:

		ldi		R16,	0b00000100
		out		PORTA,	R16

ret

LED3:

		ldi		R16,	0b00001000
		out		PORTA,	R16

ret

LED4:

		ldi		R16,	0b00010000
		out		PORTA,	R16

ret

LED5:

		ldi		R16,	0b00100000
		out		PORTA,	R16

ret



