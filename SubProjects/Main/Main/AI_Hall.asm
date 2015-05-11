AI_HALL_INTERRUPT:						;Interrupt fra hall sensoren der fungerer som et tachometer

		lds		R20,		AI_Check_Lap
		cpi		R20,		0			;AI_Check_Lap om den første runde er begyndt, ellers skal der ikke ske noget
		brne	HALL_First_Lap
		ret
		
HALL_First_Lap:							;I den første runde skal der blot måles op, så her laver hall interruptet ikke andet end at
										;måle "afstanden" og justerer hastigheden så accelerometeret får gode resultater.
		lds		R20,		AI_Check_Lap
		cpi		R20,		1			;AI_Check_Lap om den første runde er færdig.
		brne	HALL2

		inc		Laengde
		
		lds		R20,		AI_Hastighed_set	;Indlæser den satte hastighed
		lds		R21,		Pulse_Time_L	;Indlæser den målte hastighed
		cp		R21,		R20				;Sammenlig
		brlo	LOW						;AI_Check_Laper om hastigheden er for høj eller for lav
		
										;Hvis det bliver nødvendigt, så benyt resultatet fra skift test til at ændre "AI_Hastighed_set"
		lds		R20,		AI_Hastighed_out
		dec		R20						;Hvis hastigheden er for høj sættes den lidt ned
		out		OCR2,		R20
		
ret

LOW:									;Hvis hastigheden er for lav sættes den lidt op

		lds		R20,		AI_Hastighed_out
		inc		R20						;Hvis hastigheden er for høj sættes den lidt ned
		out		OCR2,		R20

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

		ldi		R20,		Hastighed_l		;Hastigheden sættes. Denne del skal uddybes betydeligt, men dette er ikke nødvendigt lige nu.
		lds		R21,		AI_Hastighed_D
		add		R20,		R21
		out		OCR2,		R20
rjmp	RUN_DONE								;Hop til run_done når hastigheden er sat

RUN_S1:
		ldi		R20,		Hastighed_s1		;Hastigheden sættes. Denne del skal uddybes betydeligt, men dette er ikke nødvendigt lige nu.
		lds		R21,		AI_Hastighed_D
		add		R20,		R21
		out		OCR2,		R20
rjmp	RUN_DONE



RUN_S2:
		ldi		R20,		Hastighed_s2		;Hastigheden sættes. Denne del skal uddybes betydeligt, men dette er ikke nødvendigt lige nu.
		lds		R21,		AI_Hastighed_D
		add		R20,		R21
		out		OCR2,		R20
rjmp	RUN_DONE

RUN_DONE:
		dec		Laengde					;Sætter den tilbageværende "Laengde" ned med en.
ret









