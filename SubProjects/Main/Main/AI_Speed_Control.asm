Hastigheds_kontrol:

		lds	R17, Pulse_Time_H

		cp		R16,	R17
		brsh	Speed_High

		in		R16,	OCR2
		ldi		R17,	1
		add		R16,	R17
		out		OCR2,	R16

ret

Speed_High:
		
		in		R16,	OCR2
		ldi		R17,	1
		sub		R16,	R17
		out		OCR2,	R16
		
ret
