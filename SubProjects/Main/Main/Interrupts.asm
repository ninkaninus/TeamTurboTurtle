; This library deals with the setup of interrupts

.MACRO Interrupts_Init
			ldi		R16, (1<<OCIE0)			; enable interrupt on output compare match for timer0
			out		TIMSK, R16				; timer/interrupt masking register
			sei								; enable global interrupt
.ENDMACRO
