; This library handles all initial setup of timer operations



; Initialize timer0 to generate an output compare interrupt every 1[ms]
.MACRO Timer0_Init
			ldi		R16, 0b00001011			; CTC-mode, 1/64 prescaling -> 250 cycles pr ms.
			out		TCCR0, R16
			ldi		R16, 0x00
			out		TCNT0, R16				; Counter0 initialization
			ldi		R16, 249				; 249+1 cycles = 1[ms] for every output compare match
			out		OCR0, R16
			
			ldi		R16, 0x00
			out		TCCR1A, R16
			ldi		R16, 0b10000101			; Falling edge triggered, 1/1024 prescaling
			out		TCCR1B, R16	
			
			clr		R16
			sts		Timer_1ms_L, R16
			sts		Timer_1ms_M, R16
			sts		Timer_1ms_H, R16	
			
			sts		Time_Stamp_L, R16
			sts		Time_Stamp_M, R16
			sts		Time_Stamp_H, R16
			
			sts		Lap_time_L, R16
			sts		Lap_time_M, R16
			sts		Lap_time_H, R16
			
			sts		Edge1_L, R16
			sts		Edge1_H, R16
.ENDMACRO

; Timer subroutines

Timer0_Update:
			
			ldi		R20, 0x01
			lds		R0, Timer_1ms_L			
			add		R0, R20						;Advance time by 1ms whenever timer0 has compare match
			sts		Timer_1ms_L, R0	
			brcc	Timer_Update_End
			
			ldi		R20, 0x00
			lds		R1, Timer_1ms_M				;24 bits = 16777 seconds = 4.6 hours... ish :D
			adc		R1, R20
			sts		Timer_1ms_M, R1	
			brcc	Timer_Update_End
			
			lds		R2, Timer_1ms_H
			adc		R2, R20
			sts		Timer_1ms_H, R2
			brcc	Timer_Update_End
			
Timer_Update_End:	
		
			reti
			
Lap_Time:	lds		R0, Timer_1ms_L				
			lds		R1, Timer_1ms_M				; Current time since startup in ms
			lds		R2, Timer_1ms_H				 
			
			lds		R3, Time_Stamp_L			
			lds		R4, Time_Stamp_M			; Time stamp at start of lap
			lds		R5, Time_Stamp_H
			
			sts		Time_Stamp_L, R0			
			sts		Time_Stamp_M, R1			; New time stamp for next lap
			sts		Time_Stamp_H, R2	
			
			sub		R0, R3						
			sbc		R1, R4						; Difference between current time and last time stamp
			sbc		R2, R5
			
			sts		Lap_time_L, R0				
			sts		Lap_time_M, R1				; Latest lap time
			sts		Lap_time_H, R2
			
			ldi		R16, 0x40					; Disable Comparator interrupt
			out		ACSR, R16					; Global interrupt register
			
			
			ldi		R16, 50
			call 	Delay_MS
			cli									; Disable global interrupt
			
			
			ldi		R16, 0b01011000				; Enable Comparator interrupt and clear comparator interrupt flag
			out		ACSR, R16					; Global interrupt register

			/*
			ldi R16, 'G'
			call USART_Transmit
			USART_Newline
			*/

			reti			

Input_Capture:
			
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
