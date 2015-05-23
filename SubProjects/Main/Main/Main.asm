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

	ldi	R16, 255
	out 	OCR2, R16
	ldi		R16, 0					; clear bit 0 in R16 (performs logical AND with complement of operand)
	sts		SREG_1, R16

	sei					;Enable global interrupt	
	rjmp Main

Main:	
			lds		R18, SREG_1			
			sbrc	R18, 2							; bit 0 represents the current edge that's being measured - 0 = EDGE1, 1 = EDGE2
			rjmp	Brake
			rjmp	Main
	
	
Brake: 		ldi		R16, 0
			out		OCR2, R16
			
			cbi		DDRD, 7
	
			nop
			
			sbi		PORTC, 5
			
			cli
			ldi		R16, 250
			call	Delay_MS
			ldi		R16, 250
			call	Delay_MS
			ldi		R16, 200
			;call	Delay_MS
			
			cbi		PORTC, 5
			
Wait:		rjmp	Wait

			
Brake2:		;rjmp	Brake

			sbi		DDRD, 7
			nop
			nop
			
			ldi		R16, 80
			out		OCR2, R16
			
			rjmp  	Brake2
