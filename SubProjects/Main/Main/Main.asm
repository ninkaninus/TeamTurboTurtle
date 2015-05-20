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

		
	lds		R16, Pulse_Time_L
	lds		R17, Pulse_Time_H
	;call	USART_Decimal_16
	;		USART_NewLine
			
	;mov		R16, Laengde
	;call	USART_Decimal_8
	;		USART_NewLine
	;		USART_NewLine

	lds		R16, SREG_1
	sbrs	R16, 2
	rjmp 	Main

	ldi		R16, high(16000)
	lds		R17, Pulse_Time_H
	call	Hastigheds_kontrol

rjmp Main	

	ldi		R16, 110
	out		OCR2, R16
	
	ldi		R16, 150
	call	Delay_MS
	
	in		R16, OCR2
	call	USART_Decimal_8
				USART_NewLine
		


