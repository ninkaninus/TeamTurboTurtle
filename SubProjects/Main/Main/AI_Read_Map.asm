Read_Map:


		subi		Length_L,		1
		sbci		Length_H,		0

		cpi			Length_H,		0
		brne		Road_Reaction
		
		cpi			Length_L,		0
		brne		Road_Reaction
		
		ld			Length_L,		Y+
		ld			Length_H,		Y+
		ld			Type,			Y+

		

Road_Reaction:



		cpi		Type,		1
		breq	Lille_Sving
		cpi		Type,		2
		breq	Stor_Sving

		cpi		Type,		4
		breq	Stor_Sving
		cpi		Type,		5
		breq	Lille_Sving

Ligeud1:

		cpi		Length_H,		0
		brne	Bare_Ligeud
		ldi		R16,	Motor_Ligeud
;		out		OCR2,	R16				;Slå til for reference motor output
		
		ldi		R17,	High(Periode_Lille_Sving)
		add		R17,	Length_L
		rol		R17
		ldi		R16,	HIGH(Periode_Ligeud)	;Reference periode.
		
		cp		R16,	R17
		brlo	Ligeud_Test
		
		mov		R16,	R17
		
Ligeud_Test:

call	Hastigheds_kontrol

ret

Bare_Ligeud:

		ldi		R16,	Motor_Ligeud
;		out		OCR2,	R16				;Slå til for reference motor output
		
		ldi		R16,	HIGH(Periode_Ligeud)	;Reference periode.
call	Hastigheds_kontrol

ret

Lille_Sving:

		cpi		Length_H,		0
		brne	Lille_Sving_Test
		cpi		Length_L,		20
		;brlo	Ligeud1

Lille_Sving_Test:

		ldi		R16,	Motor_Lille_Sving
;		out		OCR2,	R16				;Slå til for reference motor output

		ldi	R16, HIGH(Periode_Lille_Sving)	;Reference periode.
call	Hastigheds_kontrol

ret

Stor_Sving:

		cpi		Length_H,		0
		brne	Lille_Sving_Test
		cpi		Length_L,		40
		;brlo	Ligeud1

Stor_Sving_Test:

		ldi		R16,	Motor_Stort_Sving
;		out		OCR2,	R16				;Slå til for reference motor output

		ldi	R16, HIGH(Periode_Stort_Sving)	;Reference periode.
call	Hastigheds_kontrol

ret

