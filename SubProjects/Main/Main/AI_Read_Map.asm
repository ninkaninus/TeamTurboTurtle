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

;		in			R16,		OCR2
;		cpi			R16,		20
;		brlo		Road_Reaction
;		subi		R16,		10
;		out			OCR2,		R16
		

Road_Reaction:



		cpi		Type,		1
		breq	Lille_Sving
		cpi		Type,		2
		breq	Stor_Sving

		cpi		Type,		4
		breq	Stor_Sving
		cpi		Type,		5
		breq	Lille_Sving

;Ligeud1:

		cpi		Length_H,		0
		brne	Bare_Ligeud				;Hvis der er mere end 255 tilbage, så bare ligeud.
		
		ldi		R16,	Motor_Ligeud
;		out		OCR2,	R16				;Slå til for reference motor output
		
		ldi		R17,	High(Periode_Lille_Sving)
		mov		R16,	Length_L
		ror		R16
		ror		R16
		ror		R16
		sub		R17,	R16

		ldi		R16,	HIGH(Periode_Ligeud)	;Reference periode.
		
		cp		R17,	R16
		brsh	Bare_Ligeud

		ldi		R16,	High(Periode_Lille_Sving)	;Reference periode.
		ldi		R17,	50
		add		R16,	R17
		
		ldi	R16,	0
		out		OCR2,		R16
;		ldi	R19,	Motor_Lille_Sving_Max
;call	Hastigheds_kontrol

ret

Bare_Ligeud:

		ldi		R16,	Motor_Ligeud
;		out		OCR2,	R16				;Slå til for reference motor output
		
		ldi		R16,	HIGH(Periode_Ligeud)	;Reference periode.
		ldi	R18,	Motor_Ligeud_Min
		ldi	R19,	Motor_Ligeud_Max
call	Hastigheds_kontrol

ret

Lille_Sving:

		cpi		Length_H,		0
		brne	Lille_Sving_Test
		cpi		Length_L,		Afstand_Ud_Af_Sving
		brlo	Ud_Af_Sving

Lille_Sving_Test:

		ldi		R16,	Motor_Lille_Sving
		out		OCR2,	R16				;Slå til for reference motor output

		ldi	R16, HIGH(Periode_Lille_Sving)	;Reference periode.
		ldi	R18,	Motor_Lille_Sving_Min
		ldi	R19,	Motor_Lille_Sving_Max
call	Hastigheds_kontrol

ret

Stor_Sving:

		cpi		Length_H,		0
		brne	Lille_Sving_Test
		cpi		Length_L,		Afstand_Ud_Af_Sving
		brlo	Ud_Af_Sving

Stor_Sving_Test:

		ldi		R16,	Motor_Stort_Sving
		out		OCR2,	R16				;Slå til for reference motor output

		ldi	R16, HIGH(Periode_Stort_Sving)	;Reference periode.
		ldi	R18,	Motor_Stort_Sving_Min
		ldi	R19,	Motor_Stort_Sving_Max
call	Hastigheds_kontrol

ret

Ud_Af_Sving:

		ldi		R16,	Motor_Ud_Af_Sving

		out		OCR2,	R16
		
ret

