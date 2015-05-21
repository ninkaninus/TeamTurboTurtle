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
.include "AI.asm"
.include "WheelSpeed.asm"
.include "LapCounter.asm"
.include "Communication_Protocol.asm"
.include "Setup.asm"



Init:
	Setup
	clr	R16
	sts		SREG_1, R16
	sts		AI_Check_Lap,	R16
			
	ldi		R16,	Motor_Preround
	out		OCR2,	R16
					
	sei					;Enable global interrupt	
	rjmp Main


		
Main:	




rjmp Main

USART_LENGTH_TYPE:


		mov		R16,	Length_L
		mov		R17,	Length_H
call	USART_Decimal_16

		ldi		R16,	','
call	USART_Transmit

		mov		R16,	Type
call	USART_Decimal_8
		USART_Newline

ret


		ldi		R16,	0b00111110
		out		DDRA,	R16








		ldi		R16,	250
call	Delay_MS



		lds		R16,	AI_Check_Lap
;call	USART_Decimal_8

	lds		R16,	AI_Check_Lap
	cpi		R16,	6
	brsh	TEST






		
		ldi		R16,	250
call	Delay_MS

		USART_Newline
		
		mov		R16,	Length_L
		mov		R17,	Length_H
call	USART_Decimal_16

		ldi		R16,	250
call	Delay_MS

		ldi		R16,	','
call	USART_Transmit
		
		ldi		R16,	250
call	Delay_MS

		mov		R16,	Type
call	USART_Decimal_8

		ldi		R16,	250
call	Delay_MS

		ldi		R16,	','
call	USART_Transmit

		ldi		R16,	250
call	Delay_MS

		mov		R16,	YL
		mov		R17,	YH
		call	USART_Decimal_16

rjmp Main


TEST:


		ldi		R16,	0
		out		OCR2,	R16
rjmp Main
