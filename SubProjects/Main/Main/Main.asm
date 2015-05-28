.include "m32def.inc"

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
.include "Cylon.asm"
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

	ldi		R16, high(Periode_Mapping)
	sts		Speed_H, R16
	ldi		R16, low(Periode_Mapping)
	sts		Speed_L, R16

	cli
	ldi		R16, 100
	out		OCR2, R16
	
	ldi		R16, 0xFF
	out		DDRA, R16
	
	sbi		PORTA, 3
					
	sei					;Enable global interrupt	
	rjmp Main
	
Main: 	ldi		R16, 85
		call	Delay_MS
		
		cli
		call	Cylon2
		sei
		
		call	MPU6050_Read_Gyro_Z
		lds		R16, GYRO_ZOUT_L
		lds		R17, GYRO_ZOUT_H
		call	USART_Decimal_S16
				USART_NewLine

		
		rjmp	Main
