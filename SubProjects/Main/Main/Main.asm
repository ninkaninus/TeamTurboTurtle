;.include "m32def.inc"

;Mapping of all the interrupts, must be the first include!
.include "Interrupt_Mapping.asm"

;Library includes
.include "Macros.asm"
.include "Math.asm"
.include "SRAM-Mapping.asm"
.include "USART_Library.asm"
.include "WheelSpeed.asm"
.include "Delays.asm"
.include "Motor_Control.asm"
.include "I2C.asm"
.include "MPU-6050.inc"
.include "MPU-6050.asm"
.include "Time.asm"
.include "AI.asm"
.include "LapCounter.asm"
.include "Communication_Protocol.asm"
.include "Speed.asm"
.include "Setup.asm"

Init:
	Setup
	clr	R16
	sts		SREG_1, R16
	
	sts		AI_Check_Lap,	R16
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

	ldi		R16, 100
	out		OCR2, R16
	clr		ZH
					
	sei					;Enable global interrupt	
	rjmp Main
	
	
	
Main:	

		

	lds		R16, Pulse_Time_L
	lds		R17, Pulse_Time_H
	;call	USART_Decimal_16
	;		USART_NewLine
			
			ldi R16, LOW(1)
			sts Speed_L, R16
			ldi R16, HIGH(1)
			sts Speed_H, R16

	clr		R16					
	sts		SREG_1, R16				; clear SREG_1

	ldi R16, 100
	out OCR2, R16
	sei					;Enable global interrupt	
	rjmp Main

Main:	rjmp	Main
