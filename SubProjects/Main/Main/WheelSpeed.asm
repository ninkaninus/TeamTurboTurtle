
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

.ENDMACRO

Input_Capture:

			;ldi R16, 'D'
			;call USART_Transmit

			lds		R16, SREG_1
			sbrc	R16, 0
			rjmp	EDGE2
			
EDGE1:		in		R0, ICR1L
			in		R1, ICR1H
			
			sts		Edge1_L, R0
			sts		Edge1_H, R1
			
			
			sbr		R16, 0b00000001					; set bit 0 in R16 (performs a logical ORI instruction)
			sts		SREG_1, R16
			reti
			
EDGE2:		lds		R0, Edge1_L
			lds		R1, Edge1_H
			
			in		R2, ICR1L
			in		R3, ICR1H
			
			sub		R2, R0
			sbc		R3, R1
			
			sts		Pulse_Time_L, R2
			sts		Pulse_Time_H, R3
			
			ldi		R16, 0x00
			out		TCNT1H, R16						; Temp = R16
			out		TCNT1L, R16						; TCNT1L = R16 & TCNT1H = Temp
			
			
			lds		R16, SREG_1
			cbr		R16, 0b00000001					; clear bit 0 in R16 (performs logical AND with complement of operand)
			sts		SREG_1, R16
			
			reti
