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
.equ	Periode_l=100			;Periode når vi kører ligeud
.equ	Periode_s2=100			;-- stort sving
.equ	Periode_s1=100			;-- lille sving
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

		ldi		YH,			HIGH(Map_start)		;Indlæser første Ram hukommelse tildelt til mapping
		ldi		YL,			LOW(Map_start)		;
		
		;out		OCR2,			AI_Hastighed_out	;Outputter hastigheden til motoren
.ENDMACRO

;-------------------------------

AI_START:
AI_Preround:
		
		ldi		R20,			80			;Sætter hastigheden til 80, så bilen langsomt bevæger sig mod målstregen uden problemer
		out		OCR2,			R20			;Sætter bilen i gang
		
		cli
		lds		R20,			AI_Check_Lap
		cpi		R20,			AI_Lap_Preround		;Indtil den første omgang er færdig skal der ikke ske noget
		brne	FIRST_ROUND

		sei

rjmp	AI_Preround

;-------------------------------


;FIRST_ROUND:		;Den første omgang begynder. Der er plads til at indsætte kode der skal bearbejdes før vejtypen checkes.
		
		cli
		lds		R20,			AI_Check_Lap			;Checker om den første omgang er slut
		cpi		R20,			AI_Lap_Speed
		breq	RUN_TIME

		sei

rjmp	FIRST_ROUND


;-------------------------------

RUN_TIME:
		cli
		nop								;Hvis der skal ske noget mens bilen kører de øvrige baner skal det skrives her

		ldi		R16, 'D'
		call	USART_Transmit
		USART_NewLine
		ldi		R16,	250
call	Delay_MS

		sei
rjmp	RUN_TIME

;------------------------------

FIRST_ROUND:		;Den første omgang begynder. Der er plads til at indsætte kode der skal bearbejdes før vejtypen checkes.

		ldi		Laengde,	5
		ldi		Type,		2
		
jmp	SKIFT

Nyt_Banestykke:									;Dette loop påbegyndes når der skiftes mellem banetyperne. Den benytter acceleration til at bestemme hvilken banetype bilen befinder sig på

		ldi		Laengde,		0				;Start på et nyt stykke
		


call	Gyro_Mean						;Indlæser gennemsnitsværdien af to gyro læsninger

		
		cpi		Accel,		Accel_Stort_Sving		;juster værdi, Værdi for acceleration ved lille højre sving
		brsh	Fortegns_test


LIGEUD:									;Hvis banetypen bestemmes til at være et lige stykke starter dette kontinuære loop,
;										som AI_Check_Laper om accelerometeret angiver et sving. Når bilen kommer ind i et sving
;										hopper den til skift

call	Gyro_Mean						;Indlæser gennemsnitsværdien af to gyro læsninger


		
		cpi		Accel,		Accel_Stort_Sving	;juster værdi, Værdi for acceleration ved lille højre sving
		in		R16,		SREG
		sbrs	R16,		0			;For lang afstand til SKIFT, same or higher (BRSH)
		jmp		SKIFT								

cli
		lds		R20,		AI_Check_Lap			;Checker om den første omgang er slut
		cpi		R20,		AI_Lap_Speed
		breq	RUN_TIME
		
		ldi		Type,		0			;Sætter vejtypen til ligeud
sei
		
rjmp	LIGEUD

Fortegns_test:

call	MPU6050_Read_Gyro_Z
		lds		Accel,		GYRO_ZOUT_H	;Indlæs værdien for accelerometeret, SKAL ÆNDRES TIL GYRO
		sbrs	Accel,		7
		rjmp	LEFT_TURN
		
RIGHT_TURN:								;Hvis banetypen bestemmes til at være et højre sving starter dette kontinuære loop,
;										som AI_Check_Laper om accelerometeret angiver et lige stykke. Når bilen kommer ud af et sving
;										hopper den til skift

		
call	Gyro_Mean						;Indlæser gennemsnitsværdien af to gyro læsninger
		
		cpi		Accel,		Accel_Lille_Sving	;juster værdi, Værdi for acceleration ved stort højre sving
		brsh	RIGHT_TURN2				;Hopper til at banestykket er et lille højre sving.
		
		cpi		Accel,		Accel_Stort_Sving	;juster værdi, Værdi for acceleration ved lille højre sving
		brlo	SKIFT					;Nyt banestykke

cli
		lds		R20,			AI_Check_Lap			;Checker om den første omgang er slut
		cpi		R20,			AI_Lap_Speed
		breq	RUN_TIME

		ldi		Type,		1			;Sætter vejtypen til lille højre
sei

rjmp	RIGHT_TURN

LEFT_TURN:								;Hvis banetypen bestemmes til at være et venstre sving starter dette kontinuære loop,
;										som AI_Check_Laper om accelerometeret angiver et lige stykke. Når bilen kommer ud af et sving
;										hopper den til skift

		
call	Gyro_Mean						;Indlæser gennemsnitsværdien af to gyro læsninger
		
		cpi		Accel,		Accel_Lille_Sving	;juster værdi, Værdi for acceleration ved stort højre sving
		brsh	LEFT_TURN2				;Hopper til at banestykket er et lille højre sving.
		
		cpi		Accel,		Accel_Stort_Sving	;juster værdi, Værdi for acceleration ved lille højre sving
		brlo	SKIFT					;Nyt banestykke

cli
		lds		R20,			AI_Check_Lap			;Checker om den første omgang er slut
		cpi		R20,			AI_Lap_Speed
		in		R16,		SREG		;For langt til RUN_TIME, branch if equal.
		sbrc	R16,		1
		jmp	RUN_TIME

		ldi		Type,		2			;Sætter vejtypen til lille højre
sei

rjmp	LEFT_TURN

RIGHT_TURN2:							;Hvis banetypen bestemmes til at være et stort højre sving starter dette kontinuære loop,
;										som AI_Check_Laper om accelerometeret angiver et lige stykke. Når bilen kommer ud af et sving
;										hopper den til skift

		
call	Gyro_Mean						;Indlæser gennemsnitsværdien af to gyro læsninger
		
		cpi		Accel,		Accel_Stort_Sving	;juster værdi, Værdi for acceleration ved lille højre sving
		brlo	SKIFT

cli
		lds		R20,		AI_Check_Lap			;Checker om den første omgang er slut
		cpi		R20,		AI_Lap_Speed
		in		R16,		SREG		;For langt til RUN_TIME, branch if equal.
		sbrc	R16,		1
		jmp	RUN_TIME

		ldi		Type,		3			;Sætter vejtypen til stort højre
sei
		
rjmp	RIGHT_TURN2

LEFT_TURN2:								;Hvis banetypen bestemmes til at være et stort venstre sving starter dette kontinuære loop,
;										som AI_Check_Laper om accelerometeret angiver et lige stykke. Når bilen kommer ud af et sving
;										hopper den til skift

		
call	Gyro_Mean						;Indlæser gennemsnitsværdien af to gyro læsninger
		
		cpi		Accel,		Accel_Stort_Sving	;juster værdi, Værdi for acceleration ved lille venstre sving
		brlo	SKIFT

cli
		lds		R20,			AI_Check_Lap			;Checker om den første omgang er slut
		cpi		R20,			AI_Lap_Speed
		in		R16,		SREG		;For langt til RUN_TIME, branch if equal.
		sbrc	R16,		1
		jmp	RUN_TIME

		ldi		Type,		4			;Sætter vejtypen til stort venstre
sei
	
rjmp	LEFT_TURN2

;------------------------------

SKIFT:									;Indlæser vejtypen og Laengden, hvorefter der hoppes tilbage til skift_test

		st		Y+,			Laengde		;Sæt Laengden ind først-
		st		Y+,			Type		;og derefter vejtypen.
		
		mov		R16,		Laengde
		call	USART_Decimal_8
		USART_NewLine
		
		mov		R16,		Type
		call	USART_Decimal_8
		USART_NewLine
		USART_NewLine
		

jmp		Nyt_Banestykke


Gyro_Mean:

call	MPU6050_Read_Gyro_Z
		lds		R10,		GYRO_ZOUT_H	;Indlæs værdien for accelerometeret, SKAL ÆNDRES TIL GYRO
		sbrc	R10,		7
		neg		R10
		
		ldi		R16, 1
call	Delay_MS
		
call	MPU6050_Read_Gyro_Z
		lds		R11,		GYRO_ZOUT_H	;Indlæs værdien for accelerometeret, SKAL ÆNDRES TIL GYRO
		sbrc	R11,		7
		neg		R11
	
		add		R10,	R11
		ror		R10
				
		mov		Accel, R10
		
ret

