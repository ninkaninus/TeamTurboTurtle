;Denne fil beskriver hvad der skal ske i forhold til AI når bilen har kørt et tick.

AI_HALL_INTERRUPT:							;Interrupt fra hall sensoren der fungerer som et tachometer
cli
		lds		R20, AI_Check_Lap			

		cpi		R20, AI_Lap_Speed			;Checks if we are currently running a speed lap.
		breq	Hall_Speed_Lap

		cpi		R20, AI_Lap_Mapping			;Checks if we are currently running a mapping lap.
		breq	Hall_Map_Lap


		ldi		R20,			100			;Sætter hastigheden til 100, så bilen langsomt bevæger sig mod målstregen uden problemer1
		out		OCR2,			R20	
		
;Bilen skal skuppes i gang, så belaster vi ikke motoren ved at holde på den.
sei
ret
		
;I den første runde skal der blot måles op, så her laver hall interruptet ikke andet end at
;måle "afstanden" og justerer hastigheden så accelerometeret får gode resultater.
Hall_Map_Lap:
		
		
call	Gyro_Kontrol	
		inc	Laengde

		ldi	R16, HIGH(Periode_m)	;Reference periode.
		lds	R17, Pulse_Time_H		;Indlæser den målte hastighed (periode)


		call	Hastigheds_kontrol

sei
ret

Hall_Speed_Lap:									;Hvis den første omgang er færdig skal Hall interruptet stadig måle op
;										og justerer hastigheden. Den skal dog yderligere skifte mellem de målte banestykker


		cpi		Laengde,	0			;Først checkes om der er noget af Laengden tilbage.
		brne	RUN
		ld		Laengde,	Y+			;Ellers indlæses det næste stykke
		ld		Type,		Y+
		
		
RUN:

		cpi		Type,		1			;check om lille højre
		breq	RUN_S1
		cpi		Type,		2			;check om lille venstre
		breq	RUN_S1
		cpi		Type,		3			;check om stor højre
		breq	RUN_S2
		cpi		Type,		4			;check om stor venstre
		breq	RUN_S2
										;Hvis alle check fejler må der være tale om et lige stykke


		ldi		R16,	Periode_l			;Reference periode.;		lds		R17,	Pulse_Time_H		;Indlæser den målte hastighed (periode)
		
call	Hastigheds_kontrol

rjmp	RUN_DONE								;Hop til run_done når hastigheden er sat

RUN_S1:



		ldi		R16,	Periode_s1			;Reference periode.
		lds		R17,	Pulse_Time_H		;Indlæser den målte hastighed (periode)
		
call	Hastigheds_kontrol

rjmp	RUN_DONE



RUN_S2:

		ldi		R20,			100			;Sætter hastigheden til 80, så bilen langsomt bevæger sig mod målstregen uden problemer
		out		OCR2,			R20	

		ldi		R16,	Periode_s2			;Reference periode.
		lds		R17,	Pulse_Time_H		;Indlæser den målte hastighed (periode)
		
call	Hastigheds_kontrol

rjmp	RUN_DONE

RUN_DONE:
		dec		Laengde					;Sætter den tilbageværende "Laengde" ned med en.
sei
ret












