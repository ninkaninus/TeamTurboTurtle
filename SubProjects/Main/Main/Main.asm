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
;.include "EXT1.asm"
.include "WheelSpeed.asm"
.include "LapCounter.asm"
.include "Communication_Protocol.asm"
.include "Setup.asm"
.include "AI_Main.asm"

Init:
	Setup
	AI_Init
	clr	R16
	mov	R10, R16
	mov	R11, R16
	sts		SREG_1, R16
	ldi		R16, 80
	out		OCR2, R16
	clr		ZH
					
	sei					;Enable global interrupt	
	rjmp Main
	
	
	
Main:	

		mov		R16,	Length_L
		mov		R17,	Length_H
call	USART_Decimal_16

		ldi		R16, ','
call	USART_Transmit

		mov		R16,	Type
call	USART_Decimal_8

		ldi		R16, ','
call	USART_Transmit

call	Gyro_Mean
		mov		R16,	Accel
call	USART_Decimal_8
		USART_Newline

		ldi		R16,	60
call	Delay_MS

rjmp Main	

	ldi		R16, 110
	out		OCR2, R16
	
	ldi		R16, 150
	call	Delay_MS
	
	in		R16, OCR2
	call	USART_Decimal_8
				USART_NewLine
		


