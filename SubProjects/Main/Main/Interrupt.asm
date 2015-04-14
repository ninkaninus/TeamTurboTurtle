; This library deals with the setup of interrupts

			sei								; enable global interrupt
			
			ldi		R16, (1<<OCIE0)			; enable interrupt on output compare match for timer0
			out		TIMSK, R16				; timer/interrupt masking register

