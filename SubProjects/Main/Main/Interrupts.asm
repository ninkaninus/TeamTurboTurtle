; This library deals with the setup of interrupts

.MACRO Interrupts_Init

			;Timer0
			ldi		R16, (1<<OCIE0)|(1<<TICIE1)		;Enable interrupt on output compare match for timer0
			out		TIMSK, R16						;Timer/interrupt masking register
			
			;Comparator
			ldi R16, 0x48							;Initialize comparator with bandgap reference and enable interrupt
			out ACSR, R16							;

			in R16, SFIOR							;
			andi R16, ~(1<<ACME)					;Disable comparator multiplexer (AIN1 = inverting input for comparator)
			out SFIOR, R16							;

			;Global interrupt
			sei										;Enable global interrupt
.ENDMACRO
