;Addresser
.def	Hastighed = R19 		;Den målte hastighed
.def	Hastighed_out = R20		;Den outputtede hastighed
.def	Hastighed_set = R21		;Den ønskede hastighed
.def	Hastighed_D = R22		;Forøgelsen af hastighed
.def	Laengde = R23			;Laengden af vejstykket
.def	Type = R24				;Type af vejstykket
.def	check = R25				;checker om den første tur er begyndt.

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
		ldi		check,			0				;Sætter check til 0 - initial omgang indtil målstregen rammes
		ldi		Hastighed_out,	80				;Sætter hastigheden til 80, så bilen langsomt bevæger sig mod målstregen uden problemer
		ldi		Hastighed_set,	100
		ldi		Hastighed_D,	0				;Den passive hastighedsforøgelse bliver sat til 0. Hver gang bilen passerer målstregen efter den første vil denne blive forøget med 1.
		
		clr		R27								;Clear MSB del af X
		ldi		R26,			Map_start		;Første Ram hukommelse tildelt til mapping
		
		;out		OCR2,			Hastighed_out	;Outputter hastigheden til motoren
.ENDMACRO

AI_Preround:
		cli	
		cpi		check,			0				;Indtil den første omgang er færdig skal der ikke ske noget
		brne	FIRST_ROUND
		ldi R16, 'P'
		call USART_Transmit

		sei
rjmp	AI_Preround

FIRST_ROUND:		;Den første omgang begynder. Der er plads til at indsætte kode der skal bearbejdes før vejtypen checkes.
		ldi R16, 'D'
		call USART_Transmit
		rjmp FIRST_ROUND

		/*
SKIFT_TEST:								;Dette loop påbegyndes når der skiftes mellem banetyperne. Den benytter acceleration til at bestemme hvilken banetype bilen befinder sig på

		ldi		Laengde		0			;Start på et nyt stykke
;		in		Accel, accelerometer	;Indlæs værdien for accelerometeret

		cpi		Accel,		80
		brsh	test1
		cpi		Accel,		Accel_h1		;juster værdi, Værdi for acceleration ved lille højre sving
		brsh	RIGHT_TURN
		
test1:
		cpi		Accel,		Accel_v1		;juster værdi, Værdi for acceleration ved lille venstre sving
		brsh	LEFT_TURN


LIGEUD:									;Hvis banetypen bestemmes til at være et lige stykke starter dette kontinuære loop,
;										som checker om accelerometeret angiver et sving. Når bilen kommer ind i et sving
;										hopper den til skift

;		in		Accel, accelerometer	;Indlæs værdien for accelerometeret
		ldi		Type,		0			;Sætter vejtypen til ligeud
		
		cpi		Accel,		80
		brsh	test2
		cpi		Accel,		Accel_h1	;juster værdi, Værdi for acceleration ved lille højre sving
		brsh	SKIFT
		
test2
		cpi		Accel,		Accel_v1	;juster værdi, Værdi for acceleration ved lille venstre sving
		brsh	SKIFT

rjmp	LIGEUD

RIGHT_TURN:								;Hvis banetypen bestemmes til at være et højre sving starter dette kontinuære loop,
;										som checker om accelerometeret angiver et lige stykke. Når bilen kommer ud af et sving
;										hopper den til skift

;		in		Accel, accelerometer	;Indlæs værdien for accelerometeret
		cpi		Accel,		Accel_h2	;juster værdi, Værdi for acceleration ved stort højre sving
		brsh	RIGHT_TURN2
		
		cpi		Accel,		Accel_h1	;juster værdi, Værdi for acceleration ved lille højre sving
		brlo	SKIFT

		ldi		Type,		1			;Sætter vejtypen til lille højre

rjmp	RIGHT_TURN

LEFT_TURN:								;Hvis banetypen bestemmes til at være et venstre sving starter dette kontinuære loop,
;										som checker om accelerometeret angiver et lige stykke. Når bilen kommer ud af et sving
;										hopper den til skift

;		in		Accel, accelerometer	;Indlæs værdien for accelerometeret
		cpi		Accel,		Accel_v2	;juster værdi, Værdi for acceleration ved stort venstre sving
		brsh	LEFT_TURN2
		
		cpi		Accel,		Accel_v1	;juster værdi, Værdi for acceleration ved lille venstre sving
		brlo	SKIFT

		ldi		Type,		2			;Sætter vejtypen til lille venstre

rjmp	LEFT_TURN

RIGHT_TURN2:							;Hvis banetypen bestemmes til at være et stort højre sving starter dette kontinuære loop,
;										som checker om accelerometeret angiver et lige stykke. Når bilen kommer ud af et sving
;										hopper den til skift

;		in		Accel, accelerometer	;Indlæs værdien for accelerometeret
		cpi		Accel,		Accel_h1	;juster værdi, Værdi for acceleration ved lille højre sving
		brlo	SKIFT
		
		ldi		Type,		3			;Sætter vejtypen til stort højre
		
rjmp	RIGHT_TURN2

LEFT_TURN2:								;Hvis banetypen bestemmes til at være et stort venstre sving starter dette kontinuære loop,
;										som checker om accelerometeret angiver et lige stykke. Når bilen kommer ud af et sving
;										hopper den til skift

;		in		Accel, accelerometer	;Indlæs værdien for accelerometeret
		cpi		Accel,		Accel_v1	;juster værdi, Værdi for acceleration ved lille venstre sving
		brlo	SKIFT

		ldi		Type,		4			;Sætter vejtypen til stort venstre
		
rjmp	LEFT_TURN2

SKIFT:									;Indlæser vejtypen og Laengden, hvorefter der hoppes tilbage til skift_test

		inc		Antal					;Forøg antal med en enkelt - Bruges til at checke hvor lang listen er
		st		X+,			Laengde		;Sæt Laengden ind først-
		st		X+,			Type		;og derefter vejtypen.

jmp		SKIFT_TEST

*/

RUN_TIME:
		nop								;Hvis der skal ske noget mens bilen kører de øvrige baner skal det skrives her
rjmp	RUN_TIME



/*
AI_HALL_INTERRUPT:							;Interrupt fra hall sensoren der fungerer som et tachometer

		cpi		check,		0			;Check om den første runde er begyndt, ellers skal der ikke ske noget
		brne	HALL1
		ret
		
HALL1:									;I den første runde skal der blot måles op, så her laver hall interruptet ikke andet end at
;										måle "afstanden" og justerer hastigheden så accelerometeret får gode resultater.

		cpi		check,		1			;Check om den første runde er færdig.
		brne	HALL2

		inc		Laengde
		ld		Hastighed,	Pulse_Time_L
		cp		Hastighed,	Hastighed_set
		brlo	LOW						;Checker om hastigheden er for høj eller for lav
		
										;Hvis det bliver nødvendigt, så benyt resultatet fra skift test til at ændre "Hastighed_set"
										
		dec		Hastighed_out			;Hvis hastigheden er for høj sættes den lidt ned
		out		OCR2,		Hastighed_out
		
ret

LOW:									;Hvis hastigheden er for lav sættes den lidt op

		inc		Hastighed_out
		add		Hastighed_out,	Hastighed_D
		out		OCR2,		Hastighed_out

ret

HALL2:									;Hvis den første omgang er færdig skal Hall interruptet stadig måle op
;										og justerer hastigheden. Den skal dog yderligere skifte mellem de målte banestykker

		cpi		Laengde,		0			;Først checkes om der er noget af Laengden tilbage.
		brne	RUN
		ld		Laengde,		x+			;Ellers indlæses det næste stykke
		ld		Type,		x+
RUN:

		cpi		Type,		1			;Check om lille højre
		breq	RUN_S1
		cpi		Type,		2			;Check om lille venstre
		breq	RUN_S1
		cpi		Type,		3			;Check om stor højre
		breq	RUN_S2
		cpi		Type,		4			;Check om stor venstre
		breq	RUN_S2
										;Hvis alle checks fejler må der være tale om et lige stykke
		ldi		Hastighed_out,	Hastighed_l		;Hastigheden sættes. Denne del skal uddybes betydeligt, men dette er ikke nødvendigt lige nu.
		add		Hastighed_out,	Hastighed_D
		out		OCR2,			Hastighed_out
rjmp	RUN_DONE								;Hop til run_done når hastigheden er sat

RUN_S1:
		ldi		Hastighed_out,	Hastighed_s1	;Hastigheden sættes. Denne del skal uddybes betydeligt, men dette er ikke nødvendigt lige nu.
		add		Hastighed_out,	Hastighed_D
		out		OCR2,			Hastighed_out
rjmp	RUN_DONE



RUN_S2:
		ldi		Hastighed_out,	Hastighed_s2	;Hastigheden sættes. Denne del skal uddybes betydeligt, men dette er ikke nødvendigt lige nu.
		add		Hastighed_out,	Hastighed_D
		out		OCR2,			Hastighed_out
rjmp	RUN_DONE



RUN_DONE:
		dec		Laengde					;Sætter den tilbageværende "Laengde" ned med en.
ret
*/

AI_LAP_INTERRUPT:							;Lap interrupt skifter fra initial runden til den første runde til alle resterende.
		inc		check
		cpi		check,		1
		brne	TEST_PASS
		ret						;Hopper til den første runde

TEST_PASS:
		cpi		check,		2
		brne	TEST_PASS2

		ldi R16, 'T'
		call USART_Transmit

		clr		R27						;Nulstiller X
		ldi		R26,			Map_start
		ret

TEST_PASS2:

		ldi R16, 'C'
		call USART_Transmit
		/*
		inc		Hastighed_D
		clr		R27						;Nulstiller X
		ldi		R26,			Map_start
		ldi		check,		2
		ld		Laengde,		x+			;Indlæser den første del af af det gemte map.
		ld		Type,		x+
		*/
		ret















