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
	sei					;Enable global interrupt	
	rjmp Main


		
Main:	

		ldi		R16,	250
call	Delay_MS
		ldi		R16,	250
call	Delay_MS
		ldi		R16,	250
call	Delay_MS
		ldi		R16,	250
call	Delay_MS
		ldi		R16,	250
call	Delay_MS
		ldi		R16,	250
call	Delay_MS
		ldi		R16,	250
call	Delay_MS
		ldi		R16,	250
call	Delay_MS

ldi		R16,	Motor_Preround
		out		OCR2,	R16

rjmp Main
