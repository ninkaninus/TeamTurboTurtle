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

	sei					;Enable global interrupt	
	rjmp Main

Main:
	;Check if the program should be running
	
			ldi	R16, 20
			;call Motor_Set
			
			ldi R16, Ticks_Lap_L
			lds R17, Ticks_Lap_H
		
			;call USART_Decimal_16
			;USART_Newline
			
			ldi		R16, 250
			call	Delay_MS
	;Insert program code here
	sei
	

rjmp Main
