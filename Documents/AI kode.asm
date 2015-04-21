

;Addresser
.def	R16=Hastighed			;Den målte hastighed
.def	R17=Hastighed_out		;Den outputtede hastighed
.def	R18=Hastighed_set		;Den ønskede hastighed
.def	R19=Hastighed_D			;Forøgelsen af hastighed
.def	R20=lystest				;Værdi fra lysdioden
.def	R21=Længde				;Længden af vejstykket
.def	R22=Type				;Type af vejstykket
.def	R23=check				;checker om den første tur er begyndt.

;Stack Initialize

ldi		STACK,LOW(RAMEND)
out		SPL,STACK
ldi		STACK,HIGH(RAMEND)
out		SPH,STACK

;Input
;lysdiode						;inputtet fra lap sensor
;timer							;inputtet fra timeren der checker hastigheden





%% Første omgang
INITIAL_ROUND:
		ldi		check,			0
		ldi		Hastighed_out,	50
		ldi		Hastighed_D,	0
		out		OCR2,			Hastighed_out

		in		lystest,	lysdiode		;Tester om den første lap er begyndt
		cpi		lystest,		0
		breq	INITIAL_ROUND
	
		in		lystest,	lysdiode		;Tester om bilen stadig er på målstregen
		cpi		lystest,		0xFF
		brne	FIRST_ROUND
		
FIRST_ROUND:

		ldi		check,			1				;viser at den første tur er begyndt.







;		in		Accel_prior, accelerometer
SKIFT_TEST:

		ldi		Længde		0			;Start på et nyt stykke
		in		Accel, accelerometer	;Indlæs værdien for accelerometeret

		cpi		Accel,		20			;juster værdi, Værdi for acceleration ved lille højre sving
		brsh	RIGHT_TURN
		
		cpi		Accel,		10			;juster værdi, Værdi for acceleration ved lille venstre sving
		brsh	LEFT_TURN


LIGEUD:

		in		Accel, accelerometer	;Indlæs værdien for accelerometeret
		ldi		Type,		0			;Sætter vejtypen til ligeud

		cpi		Accel,		20			;juster værdi, Værdi for acceleration ved lille højre sving
		brsh	SKIFT
		
		cpi		Accel,		10			;juster værdi, Værdi for acceleration ved lille venstre sving
		brsh	SKIFT

rjmp	LIGEUD

RIGHT_TURN:

		in		Accel, accelerometer	;Indlæs værdien for accelerometeret
		cpi		Accel,		25			;juster værdi, Værdi for acceleration ved stort højre sving
		brsh	RIGHT_TURN2
		
		cpi		Accel,		20			;juster værdi, Værdi for acceleration ved lille højre sving
		brlo	SKIFT

		ldi		Type,		1			;Sætter vejtypen til lille højre

rjmp	RIGHT_TURN

LEFT_TURN:

		in		Accel, accelerometer	;Indlæs værdien for accelerometeret
		cpi		Accel,		15			;juster værdi, Værdi for acceleration ved stort venstre sving
		brsh	LEFT_TURN2
		
		cpi		Accel,		10			;juster værdi, Værdi for acceleration ved lille venstre sving
		brlo	SKIFT

		ldi		Type,		2			;Sætter vejtypen til lille venstre

rjmp	LEFT_TURN

RIGHT_TURN2:

		in		Accel, accelerometer	;Indlæs værdien for accelerometeret
		cpi		Accel,		20			;juster værdi, Værdi for acceleration ved lille højre sving
		brlo	SKIFT
		
		ldi		Type,		3			;Sætter vejtypen til stort højre
		
rjmp	RIGHT_TURN2

LEFT_TURN2:

		in		Accel, accelerometer	;Indlæs værdien for accelerometeret
		cpi		Accel,		10			;juster værdi, Værdi for acceleration ved lille venstre sving
		brlo	SKIFT

		ldi		Type,		4			;Sætter vejtypen til stort venstre
		
rjmp	LEFT_TURN2

SKIFT:

Gem Type og Længde

jmp		SKIFT_TEST


HALL_INTERRUPT:

		inc		Længde
		in		Hastighed,	timer
		cpi		Hastighed_set,	Hastighed
		brlo	LOW
		
		inc		Hastighed_out
		add		Hastighed_out,	Hastighed_D
		out		OCR2,		Hastighed_out
ret

LOW:

		dec		Hastighed_out
		add		Hastighed_out,	Hastighed_D
		out		OCR2,		Hastighed_out

ret

LAP_INTERRUPT:

		inc		Hastighed_D






ret




















Skift:
		in		Hall, Hsensor
		kø		Længde, Hall
		
			com		Accel, lige
			Skip if not equal
			kø		vejtype, 0
		
			com		Accel, lille sving
			Skip if not equal
			kø		vejtype, 1
		
			com		Accel, stort sving
			Skip if not equal
			kø		vejtype, 2
		
		in		Accel-prior
		
		in		lystest, lysdiode
		cpi		lystest, 1
		breq	sidste strækning
		
rjmp			Skift test
		
sidste strækning:

		kø		Længde, Hall
		
			com		Accel, lige
			Skip if not equal
			kø		vejtype, 0
		
			com		Accel, lille sving
			Skip if not equal
			kø		vejtype, 1
		
			com		Accel, stort sving
			Skip if not equal
			kø		vejtype, 2

Andre omgange:
