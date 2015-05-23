.include "m32def.inc"

;Mapping of all the interrupts, must be the first include!
.include "Interrupt_Mapping.asm"

;Library includes
.include "Macros.asm"
.include "Math.asm"
.include "SRAM-Mapping.asm"
.include "USART_Library.asm"
.include "Delays.asm"
.include "Motor_Control.asm"
.include "I2C.asm"
.include "MPU-6050.inc"
.include "MPU-6050.asm"
.include "Time.asm"
.include "WheelSpeed.asm"
.include "LapCounter.asm"
.include "Communication_Protocol.asm"
.include "Setup.asm"

Init:
	Setup
	
			ldi		R16, 250
			call	Delay_MS
			ldi		R16, 250
			call	Delay_MS
			ldi		R16, 250
			call	Delay_MS
			ldi		R16, 250
			call	Delay_MS
			ldi		R16, 250
			call	Delay_MS
			ldi		R16, 250
			call	Delay_MS
			ldi		R16, 250
			call	Delay_MS
			ldi		R16, 250
			call	Delay_MS
			
	ldi	R16, 80
	out 	OCR2, R16
	clr		R16					
	sts		SREG_1, R16				; clear SREG_1

	sei					;Enable global interrupt	
	rjmp Main

Main:	
			lds		R16, SREG_1			
			;sbrc	R16, 2							; bit 0 represents the current edge that's being measured - 0 = EDGE1, 1 = EDGE2
			;rjmp	Brake
			
			rjmp	Main
			sbi		PORTB, 0
			
						
			ldi		R16, 250
			call	Delay_MS
			ldi		R16, 250
			call	Delay_MS
			
			cbi		PORTB, 0
			
			ldi		R16, 250
			call	Delay_MS
			ldi		R16, 250
			call	Delay_MS	
			
			rjmp	Main
			
			rjmp	Main
	
	
Brake: 		clr		R16
			out		OCR2, R16
			
			cbi		DDRD, 7							; set motor pin as input
	
			nop
			
			sbi		PORTB, 0
			
			cli
			ldi		R16, 250
			call	Delay_MS
			ldi		R16, 250
			call	Delay_MS
			ldi		R16, 200
			;call	Delay_MS
			
			cbi		PORTB, 0
			
Wait:		rjmp	Wait

			
Brake2:		;rjmp	Brake

			sbi		DDRD, 7
			nop
			nop
			
			ldi		R16, 80
			out		OCR2, R16
			
			rjmp  	Brake2
