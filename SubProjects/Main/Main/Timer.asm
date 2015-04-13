; This library handles all initial setup of timer operations



; Initialize timer0 to generate an output compare interrupt every 1[ms]
.MACRO Timer0_Init
			ldi		R16, 0b00001011			; CTC-mode, 1/64 prescaling -> 250 cycles pr ms.
			out		TCCR0, R16
			ldi		R16, 0x00
			out		TCNT0, R16				; Counter0 initialization
			ldi		R16, 249				; 249+1 cycles = 1[ms] for every output compare match
			out		OCR0, R16
			
			clr		R16
			sts		Timer_1ms_L, R16
			sts		Timer_1ms_M, R16
			sts		Timer_1ms_H, R16	
.ENDMACRO

; Timer subroutines

Timer_Update:
			
			ldi		R20, 0x01
			lds		Timer_1ms_L, R0
			add		R0, R20	
			sts		Timer_1ms_L, R0	
			brcc	Timer_Update_End
			
			ldi		R20, 0x00
			lds		Timer_1ms_M, R1
			adc		R1, R20
			sts		Timer_1ms_M, R1	
			brcc	Timer_Update_End
			
			lds		Timer_1ms_H, R2
			adc		R2, R20
			sts		Timer_1ms_H, R2
			brcc	Timer_Update_End
			
Timer_Update_End:			
			reti
