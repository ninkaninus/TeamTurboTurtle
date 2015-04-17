; This library deals with the setup of interrupts

.MACRO Interrupts_Init
			ldi		R16, (1<<OCIE0)			; enable interrupt on output compare match for timer0
			out		TIMSK, R16				; timer/interrupt masking register
			
			ldi		R16, (1<<INT1)			; enable external interrupt INT1
			out		GICR, R16				; global interrupt register
			cbi		DDRD, 3					; PD3(INT1) = input
			sbi		PORTD, 3				; enable pull-up resistor
			
			sei								; enable global interrupt
.ENDMACRO
