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
			
			sts		Lap_time_L, R16
			sts		Lap_time_M, R16
			sts		Lap_time_H, R16
.ENDMACRO

; Timer subroutines

Timer0_Update:
			
			ldi		R20, 0x01
			lds		R0, Timer_1ms_L
			add		R0, R20	
			sts		Timer_1ms_L, R0	
			brcc	Timer_Update_End
			
			ldi		R20, 0x00
			lds		R1, Timer_1ms_M
			adc		R1, R20
			sts		Timer_1ms_M, R1	
			brcc	Timer_Update_End
			
			lds		R2, Timer_1ms_H
			adc		R2, R20
			sts		Timer_1ms_H, R2
			brcc	Timer_Update_End
			
Timer_Update_End:	
		
			reti
			
Lap_Time:	lds		R0, Timer_1ms_L				; current time since startup in ms
			lds		R1, Timer_1ms_M				
			lds		R2, Timer_1ms_H				 
			
			lds		R3, Lap_time_L				; time stamp at start of lap
			lds		R4, Lap_time_M
			lds		R5, Lap_time_H
			
			sts		Lap_time_L, R0				; new time stamp for next lap
			sts		Lap_time_M, R1				
			sts		Lap_time_H, R2	
			
			sub		R0, R3						; difference between current time and last time stamp
			sbc		R1, R4
			sbc		R2, R5
			
			mov		R0, lapL
			mov		R1, lapM
			mov		R2, lapH
			
			com		lapL
			com		lapM
			com		lapH
			
			ldi		R16, (0<<INT1)			; disable external interrupt INT1
			out		GICR, R16				; global interrupt register
			
			sei								; enable global interrupt							
			call 	delay250ms
			cli								; disable global interrupt
			
			ldi		R16, (1<<INT1)			; enable external interrupt INT1
			out		GICR, R16				; global interrupt register

			reti			

