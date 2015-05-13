AI_HALL_INTERRUPT:						;Interrupt fra hall sensoren der fungerer som et tachometer

		lds		R20,		AI_Check_Lap
		cpi		R20,		0			;AI_Check_Lap om den første runde er begyndt, ellers skal der ikke ske noget
		brne	HALL_First_Lap
		
		ldi		R16,	Periode_p			;Reference periode.
		lds		R17,	Pulse_Time_L		;Indlæser den målte hastighed (periode)
		ldi		R18,	Hastighed_p			;Sætter motor output standard
		ret
		
HALL_First_Lap:							;I den første runde skal der blot måles op, så her laver hall interruptet ikke andet end at
										;måle "afstanden" og justerer hastigheden så accelerometeret får gode resultater.
		lds		R20,		AI_Check_Lap
		cpi		R20,		1			;AI_Check_Lap om den første runde er færdig.
		brne	HALL2

		inc		Laengde

		ldi		R16,	Periode_m			;Reference periode.
		lds		R17,	Pulse_Time_L		;Indlæser den målte hastighed (periode)
		ldi		R18,	Hastighed_m			;Sætter motor output standard


call	Hastigheds_kontrol

ret

HALL2:									;Hvis den første omgang er færdig skal Hall interruptet stadig måle op
;										og justerer hastigheden. Den skal dog yderligere skifte mellem de målte banestykker

		cpi		Laengde,	0			;Først AI_Check_Lapes om der er noget af Laengden tilbage.
		brne	RUN
		ld		Laengde,	x+			;Ellers indlæses det næste stykke
		ld		Type,		x+
RUN:

		cpi		Type,		1			;AI_Check_Lap om lille højre
		breq	RUN_S1
		cpi		Type,		2			;AI_Check_Lap om lille venstre
		breq	RUN_S1
		cpi		Type,		3			;AI_Check_Lap om stor højre
		breq	RUN_S2
		cpi		Type,		4			;AI_Check_Lap om stor venstre
		breq	RUN_S2
										;Hvis alle AI_Check_Laps fejler må der være tale om et lige stykke

		ldi		R16,	Periode_l			;Reference periode.
		lds		R17,	Pulse_Time_L		;Indlæser den målte hastighed (periode)
		ldi		R18,	Hastighed_l			;Sætter motor output standard
		
call	Hastigheds_kontrol

rjmp	RUN_DONE								;Hop til run_done når hastigheden er sat

RUN_S1:

		ldi		R16,	Periode_s1			;Reference periode.
		lds		R17,	Pulse_Time_L		;Indlæser den målte hastighed (periode)
		ldi		R18,	Hastighed_s1		;Sætter motor output standard
		
call	Hastigheds_kontrol

rjmp	RUN_DONE



RUN_S2:

		ldi		R16,	Periode_s2			;Reference periode.
		lds		R17,	Pulse_Time_L		;Indlæser den målte hastighed (periode)
		ldi		R18,	Hastighed_s2		;Sætter motor output standard
		
call	Hastigheds_kontrol

rjmp	RUN_DONE

RUN_DONE:
		dec		Laengde					;Sætter den tilbageværende "Laengde" ned med en.
ret












