Hastigheds_kontrol:

		sub		R16, R17						; R16 = Ønsket pulstid, R17 = Sidst målte pulstid
		brpl	TooLow								; Hvis resultatet er positivt, er den aktuelle pulstid for lav, branch til low
		
; Den aktuelle pulstid er for høj
TooHigh:neg 	R16
		;cpi		R16, 3
		;brlo	Speed_End
		
		ldi		R20, 2
		
		cpi		R16, 6
		in		R17, SREG
		sbrs	R17, 0
		ldi		R20, 2
		
		cpi		R16, 9
		in		R17, SREG
		sbrs	R17, 0
		ldi		R20, 4
		
		cpi		R16, 10
		in		R17, SREG
		sbrs	R17, 0
		ldi		R20, 8
				
		in		R17, OCR2
		add		R17, R20
		cpi		R17, 240
		brsh	Speed_End
		out		OCR2, R17
		
		rjmp	Speed_End

; Den aktuelle pulstid er for lav
TooLow:	;cpi		R16, 3
		;brlo	Speed_End
		
		ldi		R20, 2
		
		cpi		R16, 4
		in		R17, SREG
		sbrs	R17, 0
		ldi		R20, 2
		
		cpi		R16, 6
		in		R17, SREG
		sbrs	R17, 0
		ldi		R20, 4
		
		cpi		R16, 8
		in		R17, SREG
		sbrs	R17, 0
		ldi		R20, 8	
		
		in		R17, OCR2
		sub		R17, R20
		cpi		R17, 15
		brlo	Speed_End
		out		OCR2, R17
		
Speed_End:

;		ldi		R16, 20
;		call	Delay_MS
		
;		inc		ZH
;		cpi		ZH, 10
;		brlo	Speed_End2
=======
.equ Diff_Max = 8192
.equ ForgivenessZone = 4096

Hastigheds_kontrol:
		
		lds		R16, SREG_1			
		sbrc	R16, 7							; bit 7 is the delay enable 
		rjmp	Braking

		lds		R16, Speed_L 
		lds		R17, Speed_H
		lds		R18, Pulse_Time_L
		lds		R19, Pulse_Time_H

		sub		R16, R18						; R16 = Ønsket pulstid, R17 = Sidst målte pulstid
		sbc		R17, R19
		
		in		R16, SREG
		sbrc	R16, 2
		rjmp	Langsommere
		
Hurtigere:		
		
		lds		R0, Timer_1ms_L
		lds		R1, Timer_1ms_M
		lds		R2, Timer_1ms_H
		
		sts		Time_Stamp_Braking_L, R0
		sts		Time_Stamp_Braking_M, R1
		sts		Time_Stamp_Braking_H, R2
		
		ldi		R20, 0
		out		OCR2, R20
		
		cpi		R17, high(ForgivenessZone)
		brlo	Braking_End
		
		cpi		R17, high(Diff_Max - ForgivenessZone)
		brsh	Max_Brake
		
		lsr		R17
		ror		R16
		lsr		R17
		ror		R16				; divider med 64
		lsr		R17
		ror		R16	
		lsr		R17
		ror		R16	
		lsr		R17
		ror		R16
		
		sts		Delay_Amount, R16
		
		sbi		PORTB, PB0
		Set_SREG_1 7
		
		ret

Max_Brake:		
		ldi		R20, 255
		sts		Delay_Amount, R17
		
		sbi		PORTB, PB0
		Set_SREG_1 7
		
		ret
		
Braking:

		clr R16
		out OCR2, R16
 
		lds		R0, Timer_1ms_L				
		lds		R1, Timer_1ms_M				; Current time since startup in ms
		lds		R2, Timer_1ms_H				 
				
		lds		R3, Time_Stamp_Braking_L			
		lds		R4, Time_Stamp_Braking_M			; Time stamp at start of lap
		lds		R5, Time_Stamp_Braking_H
							
		sub		R0, R3						
		sbc		R1, R4						; Difference between current time and last time stamp
		sbc		R2, R5
		
		lds		R6, Delay_Amount

		tst		R1
		brne	Braking_End
		
		cp		R0, R6
		brsh	Braking_End
		


		ret
		
Braking_End:
		cbi		PORTB, PB0
		Clear_SREG_1 7
		
		ret

Langsommere:
		subi	R16, 1
		sbci	R17, 0
		com		R16
		com		R17
			
		cpi		R17, high(Diff_Max)
		brsh	MaxGas
				
		lsr		R17
		ror		R16
		lsr		R17
		ror		R16				; divider med 32
		lsr		R17
		ror		R16	
		lsr		R17
		ror		R16	
		lsr		R17
		ror		R16
	
		
		out		OCR2, R16
		
		ret
		

MaxGas: 
		ldi		R20, 255
		out		OCR2, R20
		
		ret
		