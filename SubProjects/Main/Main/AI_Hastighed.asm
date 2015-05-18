;Hastigheds_kontrol:				;Skal bruge R16 som den satte periode, og R17 som den nuværende periode, og R18 som hastighed_out.
	in R18, OCR2

	cp		R17,	R16
	brlo	SPEED_IS_HIGH	;The speed is too high

	cp		R16,	R17
	brlo	SPEED_IS_LOW	;The speed is too low

	jmp Hastigheds_kontrol_end

;SPEED_IS_HIGH:
	subi R18, 2
	ldi	 R16, 60
	cp	R18, R16
	brlo	Too_low
	out OCR2, R18
	jmp Hastigheds_kontrol_end

SPEED_IS_LOW:
	ldi R17, 2
	add R18, R17
	out OCR2, R18
	jmp Hastigheds_kontrol_end

Hastigheds_kontrol_end:
	mov R16, R18
	;call USART_Decimal_8
	;USART_Newline
ret

Too_low:	ldi		R16, 60
			out		OCR2, R16
			ret
;/*
Hastigheds_kontrol:				;Skal bruge R16 som den satte periode, og R17 som den nuværende periode, og R18 som hastighed_out.
		in R18, OCR2
		cp		R17,	R16
		brlo	SPEED_IS_HIGH	;The speed is too high

;		cp		R16,	R17
;		brlo	SPEED_IS_LOW	;The speed is too low

;		lds		R16,	AI_Hastighed_out
;		lds		R17,	AI_Hastighed_D
;		add		R16,	R17
;		brcs	FULD_KRAFT
;		out		OCR2,	R16

;HASTIGHED_SET_SLUT:
;ret

;SPEED_IS_LOW:					;R17>R16

		sub		R16,	R17
		ldi		R17,	1
		cpi		R16,	5
		brlo	HASTIGHED_SET_LOW
		ldi		R17,	2
		cpi		R16,	10
		brlo	HASTIGHED_SET_LOW
		ldi		R17,	3
		cpi		R16,	15
		brlo	HASTIGHED_SET_LOW
		ldi		R17,	4
		cpi		R16,	20
		brlo	HASTIGHED_SET_LOW
		ldi		R17,	5
		
HASTIGHED_SET_LOW:
		
		mov		R16,	R18
		add		R16,	R17
		brcs	FULD_KRAFT
		lds		R17,	AI_Hastighed_D
		add		R16,	R17
		brcs	FULD_KRAFT
		out		OCR2,	R16

	jmp Hastigheds_kontrol_end
;rjmp	HASTIGHED_SET_SLUT

FULD_KRAFT:
		ldi		R16,	255
		out		OCR2,	R16
	jmp Hastigheds_kontrol_end


SPEED_IS_HIGH:						;R16>R17

		sub		R17,	R16
		mov		R16,	R17
		ldi		R17,	1
		cpi		R16,	5
		brlo	HASTIGHED_SET_HIGH
		ldi		R17,	2
		cpi		R16,	10
		brlo	HASTIGHED_SET_HIGH
		ldi		R17,	3
		cpi		R16,	15
		brlo	HASTIGHED_SET_HIGH
		ldi		R17,	4
		cpi		R16,	20
		brlo	HASTIGHED_SET_HIGH
		ldi		R17,	5

HASTIGHED_SET_HIGH:

		mov		R16,	R18
		sub		R16,	R17
		lds		R17,	AI_Hastighed_D
		add		R16,	R17
		out		OCR2,	R16

	jmp Hastigheds_kontrol_end

;HASTIGHED_SET:

;*/










