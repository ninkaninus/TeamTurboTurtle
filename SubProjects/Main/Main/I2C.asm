/*
 * I2C.asm
 *
 *  Created: 26-03-2015 17:49:44
 *   Author: StjerneIdioten
 */ 

 .MACRO I2C_Init
	;Set Prescaler
	ldi R16, @0
	out TWSR, R16
	
	;Set scl to 400 KHz at 16MHz clock
	ldi R16, @1
	out TWBR, R16

	;Enable it
	ldi R16, (1<<TWEN)
	out TWCR, R16

 .ENDMACRO

I2C_Start:
	;Send Start condition
	ldi r16, (1<<TWINT)|(1<<TWSTA)|(1<<TWEN) 
	out TWCR, r16

I2C_Start_Wait:	
	;Wait for the start condition transmit			
	in r16,TWCR
	sbrs r16,TWINT
	jmp I2C_Start_Wait

	/*;Check if the status register is loaded with start
	call I2C_Status
	cpi r16, 0x08
	brne I2C_Error*/
ret

I2C_Stop:
	;Send Stop condition
	ldi r16, (1<<TWINT)|(1<<TWSTO)|(1<<TWEN) 
	out TWCR, r16
ret

I2C_Write:
	out TWDR, r16
	ldi r16, (1<<TWINT) | (1<<TWEN)
	out TWCR, r16

I2C_Write_Wait:
	in r16,TWCR
	sbrs r16,TWINT
	jmp I2C_Write_Wait
ret

I2C_Read:
	ldi r16, (1<<TWINT) | (1<<TWEN)
	out TWCR, r16

I2C_Read_Wait:
	in r16,TWCR
	sbrs r16,TWINT
	jmp I2C_Read_Wait

	in R16, TWDR
ret

I2C_Status:
	in r16,TWSR
	andi r16, 0xF8
ret

.MACRO I2C_Error
I2C_Error_Start:
	ldi R16, 'E'
	USART_Transmit_Var
	rjmp I2C_Error_Start
.ENDMACRO
