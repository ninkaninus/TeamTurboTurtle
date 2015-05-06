
.MACRO WheelSpeed_Init
			ldi		R16, 0x00
			out		TCCR1A, R16
			ldi		R16, 0b10000010			; Falling edge triggered, 1/1024 prescaling
			out		TCCR1B, R16	

			clr		R16
			sts		Edge1_L, R16
			sts		Edge1_H, R16

			in		R16, TIMSK
			ori		R16, (1<<TICIE1)		;Enable interrupt on output compare match for timer0
			out		TIMSK, R16				;Timer/interrupt masking register

			ldi R16, 'P'
			call USART_Transmit
			USART_Newline
			
			ldi		YL, low(Pulse_Time_L1)
			ldi		YH, high(Pulse_Time_L1)

.ENDMACRO

.MACRO WheelSpeed_Calc
			lds		R18, Pulse_Time_L
			sbr		R16, 0xFF
			sbr		R17, 0xFF
			call	Div16_8
			sts		Wheel_speed_L, R16
			sts		Wheel_speed_H, R17
.ENDMACRO

; Use desired braking time in MS as argument
.MACRO Brake_MS
		in		R16, OCR0
		push	R16
		clr		R16
		out		R16, OCR0
		
		sbi		PORTB, BRAKE
		cli
		ldi		R16, @0
		call	Delay_MS
		sei
		cbi		PORTB, BRAKE
		
		pop		R16
		out		OCR0, R16
.ENDMACRO

Input_Capture:

			push	R0
			push	R1
			push	R2
			push	R3
			push	R16
			in		R16, SREG
			push	R16

			ldi R16, 'D'
			call USART_Transmit

			lds		R16, SREG_1			
			sbrc	R16, 0							; bit 0 represents the current edge that's being measured - 0 = EDGE1, 1 = EDGE2
			rjmp	EDGE2
			
EDGE1:		in		R0, ICR1L
			in		R1, ICR1H
			
			sts		Edge1_L, R0
			sts		Edge1_H, R1
			
			
			sbr		R16, 0b00000001					; set bit 0 in R16 (performs a logical ORI instruction)
			sts		SREG_1, R16
			
			pop		R16
			out		SREG, R16
			pop		R16
			pop		R3
			pop		R2
			pop		R1
			pop		R0
			
			reti
			
EDGE2:		lds		R0, Edge1_L
			lds		R1, Edge1_H
			
			in		R2, ICR1L
			in		R3, ICR1H
			
			sub		R2, R0
			sbc		R3, R1
						
			st		Y+, R2
			st		Y+, R3
			
			ldi		R16, 0x00
			out		TCNT1H, R16						; Temp = R16
			out		TCNT1L, R16						; TCNT1L = R16 & TCNT1H = Temp
			
			lds		R16, SREG_1
			cbr		R16, 0b00000001					; clear bit 0 in R16 (performs logical AND with complement of operand)
			sts		SREG_1, R16
			
; Compares the last two pulse times and checks to see if they're below a set threshold

			cpi		YL, low(Pulse_Time_H2)			; jump to end if pointer register is not set to Pulse_Time_H2
			brne	end
			
			lds 	R0, Pulse_Time_L1
			lds 	R1, Pulse_Time_H1
			
			lds		R2, Pulse_Time_L2
			lds		R3, Pulse_Time_H2
			
.def	Threshold = R16

			ldi		Threshold, high(6000)
			
			cp		R1, R3							; compares high bytes to see if Pulse1_H < Pulse2_H
			brlo	P1_LO
			
			cp		R1, R3							; checks to see if high bytes are equal
			brne	P2_LO

			cp		R2, R0							; if high bytes are equal, low bytes are compared to see if Pulse2_L < Pulse1_L
			brlo	P2_LO
			
; Pulse 1 < Pulse 2			
P1_LO:		sub		R2, R0
			sbc		R3, R1
			
			cp		R3, Threshold
			brlo	NO_GO
			
			rjmp	GO
			
; Pulse 2 < Pulse 1			
P2_LO:		sub		R0, R2
			sbc		R1, R3
			
			cp		R1, Threshold
			brlo	NO_GO
			
Go:			lds		R2, Pulse_Time_L2								; Latest pulse time is considered valid and stored for use
			lds		R3, Pulse_Time_H2
			
			sts		Pulse_Time_L, R2
			sts		Pulse_Time_H, R3 
			
			ldi		YL, low(Pulse_Time_L1)							; Pointer register is reset
			ldi		YH, high(Pulse_Time_L1)

			rjmp	end
			
NO_GO:		ldi		YL, low(Pulse_Time_L1)							; Pointer register is reset
			ldi		YH, high(Pulse_Time_L1)

end:
			lds R16, Pulse_Time_L
			lds R17, Pulse_Time_H

			call USART_Decimal_16
			USART_Newline

			end1:

			pop		R16
			out		SREG, R16
			pop		R16
			pop		R3
			pop		R2
			pop		R1
			pop		R0
			
			reti
