Hastigheds_kontrol:				;Skal bruge R16 som den satte periode, og R17 som den nuværende periode.


		cp		R17,	R16
		brlo	SPEED_IS_HIGH
		cp		R16,	R17
		brlo	SPEED_IS_LOW

		lds		R16,	AI_Hastighed_out
		lds		R17,	AI_Hastighed_D
		add		R16,	R17
		brcs	FULD_KRAFT
		out		OCR2,	R16


HASTIGHED_SET_SLUT:
ret

SPEED_IS_LOW:

		sub		R16,	R17
		ldi		R17,	0
		cpi		R16,	5
		brlo	HASTIGHED_SET_LOW
		ldi		R17,	5
		cpi		R16,	10
		brlo	HASTIGHED_SET_LOW
		ldi		R17,	10
		cpi		R16,	15
		brlo	HASTIGHED_SET_LOW
		ldi		R17,	15
		cpi		R16,	20
		brlo	HASTIGHED_SET_LOW
		ldi		R17,	20

HASTIGHED_SET_LOW:
		
		lds		R16,	AI_Hastighed_out
		add		R16,	R17
		lds		R17,	AI_Hastighed_D
		add		R16,	R17
		brcs	FULD_KRAFT
		out		OCR2,	R16


rjmp	HASTIGHED_SET_SLUT

FULD_KRAFT:
		ldi		R16,	255
		out		OCR2,	R16
rjmp	HASTIGHED_SET_SLUT


SPEED_IS_HIGH:

		sub		R17,	R16
		mov		R16,	R17
		ldi		R17,	0
		cpi		R16,	5
		brlo	HASTIGHED_SET_HIGH
		ldi		R17,	5
		cpi		R16,	10
		brlo	HASTIGHED_SET_HIGH
		ldi		R17,	10
		cpi		R16,	15
		brlo	HASTIGHED_SET_HIGH
		ldi		R17,	15
		cpi		R16,	20
		brlo	HASTIGHED_SET_HIGH
		ldi		R17,	20

HASTIGHED_SET_HIGH:

		lds		R16,	AI_Hastighed_out
		dec		R16,	R17
		lds		R17,	AI_Hastighed_D
		add		R16,	R17
		out		OCR2,	R16

rjmp	HASTIGHED_SET_SLUT

HASTIGHED_SET:










