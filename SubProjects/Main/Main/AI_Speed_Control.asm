Speed_Control:

		lds	R17, Pulse_Time_H

		cp		R16,	R17
		brsh	Speed_Is_High

		in		R16,	OCR2
		ldi		R17,	5
		add		R16,	R17
		out		OCR2,	R16

ret

Speed_Is_High:
		
		in		R16,	OCR2
		ldi		R17,	5
		sub		R16,	R17
		out		OCR2,	R16
		
ret
