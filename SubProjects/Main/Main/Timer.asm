; This library handles all initial setup of timer operations



; Initialize timer0 to generate an output compare interrupt every 1[ms]

			ldi		R16, 0b00001011			; CTC-mode, 1/64 prescaling -> 250 cycles pr ms.
			out		TCCR0, R16
			ldi		R16, 0x00
			out		TCNT0, R16				; Counter0 initialization
			ldi		R16, 249				; 249+1 cycles = 1[ms] for every output compare match
			out		OCR0, R16
			
