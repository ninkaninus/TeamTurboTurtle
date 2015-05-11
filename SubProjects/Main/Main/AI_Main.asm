.include "AI_Lap.asm"
;.include "AI_Hastighed.asm"
;.include "AI_Hall.asm"

;Addresser
.def	Laengde = R22			;Laengden af vejstykket
.def	Type = R23				;Type af vejstykket
.def	Accel = R24				;Checker om den første tur er begyndt.

;Konstanter
.equ	Accel_v1=10				;Disse værdier skal justeres
.equ	Accel_v2=15
.equ	Accel_h1=20
.equ	Accel_h2=25
.equ	Hastighed_l=100			;Hastigheden når vi kører ligeud
.equ	Hastighed_s2=50			;-- stort sving
.equ	Hastighed_s1=70			;-- lille sving

;Initialize først
.MACRO AI_Init
		clr R16									;Gemmer AI_Check_Lap i ram til 0		
		sts AI_Check_Lap, R16					;			
		sts AI_Hastighed_D, R16					;Den passive hastighedsforøgelse bliver sat til 0. Hver gang bilen passerer målstregen efter den første vil denne blive forøget med 1.
		
		;ldi		R20,			80			;Sætter hastigheden til 80, så bilen langsomt bevæger sig mod målstregen uden problemer
		;out		OCR2,			R20			;Sætter bilen i gang
		
		ldi		R20,			100				;Initial værdi for AI_Hastighed_set, dette bruges til at bestemme hastigheden i den første runde 
		sts		AI_Hastighed_set, R20

		ldi		XH,			HIGH(Map_start)		;Clear MSB del af X
		ldi		XL,			LOW(Map_start)		;Første Ram hukommelse tildelt til mapping
		
		;out		OCR2,			AI_Hastighed_out	;Outputter hastigheden til motoren
.ENDMACRO

;-------------------------------

AI_START:
AI_Preround:
		
		cli
		lds		R20,			AI_Check_Lap
		cpi		R20,			0				;Indtil den første omgang er færdig skal der ikke ske noget
		brne	FIRST_ROUND

		ldi R16, 25
		call Motor_Set_Percentage
		sei

rjmp	AI_Preround

;-------------------------------


FIRST_ROUND:		;Den første omgang begynder. Der er plads til at indsætte kode der skal bearbejdes før vejtypen checkes.
		
		cli
		lds		R20,			AI_Check_Lap			;Checker om den første omgang er slut
		cpi		R20,			2
		breq	RUN_TIME
		
		ldi R16, 40
		call Motor_Set_Percentage		
		sei

rjmp	FIRST_ROUND


;-------------------------------

RUN_TIME:
		cli
		nop								;Hvis der skal ske noget mens bilen kører de øvrige baner skal det skrives her
		ldi R16, 55
		call Motor_Set_Percentage	
		sei
rjmp	RUN_TIME

;------------------------------

/*

SKIFT_TEST:									;Dette loop påbegyndes når der skiftes mellem banetyperne. Den benytter acceleration til at bestemme hvilken banetype bilen befinder sig på

		ldi		Laengde		0				;Start på et nyt stykke
		lds		Accel,		ACCEL_YOUT_H	;Indlæs værdien for accelerometeret

		cpi		Accel,		0x80			;Tester fortegn
		brsh	test1
		cpi		Accel,		Accel_h1		;juster værdi, Værdi for acceleration ved lille højre sving
		brsh	RIGHT_TURN
		
test1:
		cpi		Accel,		Accel_v1		;juster værdi, Værdi for acceleration ved lille venstre sving
		brsh	LEFT_TURN


LIGEUD:									;Hvis banetypen bestemmes til at være et lige stykke starter dette kontinuære loop,
;										som AI_Check_Laper om accelerometeret angiver et sving. Når bilen kommer ind i et sving
;										hopper den til skift

		lds		Accel,		ACCEL_YOUT_H	;Indlæs værdien for accelerometeret
		ldi		Type,		0			;Sætter vejtypen til ligeud
		cpi		Accel,		0x80		;Tester fortegn
		brsh	test2
		cpi		Accel,		Accel_h1	;juster værdi, Værdi for acceleration ved lille højre sving
		brsh	SKIFT
		
test2
		cpi		Accel,		Accel_v1	;juster værdi, Værdi for acceleration ved lille venstre sving
		brsh	SKIFT

rjmp	LIGEUD

RIGHT_TURN:								;Hvis banetypen bestemmes til at være et højre sving starter dette kontinuære loop,
;										som AI_Check_Laper om accelerometeret angiver et lige stykke. Når bilen kommer ud af et sving
;										hopper den til skift

		lds		Accel,		ACCEL_YOUT_H	;Indlæs værdien for accelerometeret
		cpi		Accel,		Accel_h2	;juster værdi, Værdi for acceleration ved stort højre sving
		brsh	RIGHT_TURN2
		
		cpi		Accel,		Accel_h1	;juster værdi, Værdi for acceleration ved lille højre sving
		brlo	SKIFT

		ldi		Type,		1			;Sætter vejtypen til lille højre

rjmp	RIGHT_TURN

LEFT_TURN:								;Hvis banetypen bestemmes til at være et venstre sving starter dette kontinuære loop,
;										som AI_Check_Laper om accelerometeret angiver et lige stykke. Når bilen kommer ud af et sving
;										hopper den til skift

		lds		Accel,		ACCEL_YOUT_H	;Indlæs værdien for accelerometeret
		cpi		Accel,		Accel_v2	;juster værdi, Værdi for acceleration ved stort venstre sving
		brsh	LEFT_TURN2
		
		cpi		Accel,		Accel_v1	;juster værdi, Værdi for acceleration ved lille venstre sving
		brlo	SKIFT

		ldi		Type,		2			;Sætter vejtypen til lille venstre

rjmp	LEFT_TURN

RIGHT_TURN2:							;Hvis banetypen bestemmes til at være et stort højre sving starter dette kontinuære loop,
;										som AI_Check_Laper om accelerometeret angiver et lige stykke. Når bilen kommer ud af et sving
;										hopper den til skift

		lds		Accel,		ACCEL_YOUT_H	;Indlæs værdien for accelerometeret
		cpi		Accel,		Accel_h1	;juster værdi, Værdi for acceleration ved lille højre sving
		brlo	SKIFT
		
		ldi		Type,		3			;Sætter vejtypen til stort højre
		
rjmp	RIGHT_TURN2

LEFT_TURN2:								;Hvis banetypen bestemmes til at være et stort venstre sving starter dette kontinuære loop,
;										som AI_Check_Laper om accelerometeret angiver et lige stykke. Når bilen kommer ud af et sving
;										hopper den til skift

		lds		Accel,		ACCEL_YOUT_H	;Indlæs værdien for accelerometeret
		cpi		Accel,		Accel_v1	;juster værdi, Værdi for acceleration ved lille venstre sving
		brlo	SKIFT

		ldi		Type,		4			;Sætter vejtypen til stort venstre
		
rjmp	LEFT_TURN2

;------------------------------

SKIFT:									;Indlæser vejtypen og Laengden, hvorefter der hoppes tilbage til skift_test

		inc		Antal					;Forøg antal med en enkelt - Bruges til at checke hvor lang listen er
		st		X+,			Laengde		;Sæt Laengden ind først-
		st		X+,			Type		;og derefter vejtypen.

jmp		SKIFT_TEST

*/









