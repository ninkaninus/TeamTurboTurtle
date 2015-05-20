Read_Map:

		subi		Length_L,		1
		sbci		Length_H,		0

		cpi			Length_L,		0
		brne		Road_Reaction
		
		cpi			Length_H,		0
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

;Ellers ligeud

		ldi		R16,	Motor_Ligeud
;		out		OCR2,	R16				;Slå til for reference motor output
		
		ldi	R16, HIGH(Periode_Ligeud)	;Reference periode.
call	Speed_Control

ret

Lille_Sving:

		ldi		R16,	Motor_Lille_Sving
;		out		OCR2,	R16				;Slå til for reference motor output

		ldi	R16, HIGH(Periode_Lille_Sving)	;Reference periode.
call	Speed_Control

ret

Stor_Sving:

		ldi		R16,	Motor_Stort_Sving
;		out		OCR2,	R16				;Slå til for reference motor output

		ldi	R16, HIGH(Periode_Stort_Sving)	;Reference periode.
call	Speed_Control

ret

