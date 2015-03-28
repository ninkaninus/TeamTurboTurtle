;Author: StjerneIdioten
;I2C communication library 

 .equ I2C_ACK = 0x01	;Value for ACK used with I2C_Read
 .equ I2C_NACK = 0x00	;Value for NACK used with I2C_Read


 .MACRO I2C_Init ;First argument is prescaler, second argument is TWBR
	;Set Prescaler
	ldi R16, @0
	out TWSR, R16
	
	;Set TWBR
	ldi R16, @1
	out TWBR, R16

	;Enable I2C module
	ldi R16, (1<<TWEN)
	out TWCR, R16

 .ENDMACRO


;This function sends a start command
I2C_Start:
	;Send Start condition
	ldi r16, (1<<TWINT)|(1<<TWSTA)|(1<<TWEN) 
	out TWCR, r16

I2C_Start_Wait:	
	;Wait for the start condition transmit			
	in r16,TWCR
	sbrs r16,TWINT
	rjmp I2C_Start_Wait
ret


;This function sends a stop command
I2C_Stop:
	;Send Stop condition
	ldi r16, (1<<TWINT)|(1<<TWSTO)|(1<<TWEN) 
	out TWCR, r16
ret


;This function writes the data from R16, onto the I2C data line
I2C_Write:
	out TWDR, r16
	ldi r16, (1<<TWINT) | (1<<TWEN)
	out TWCR, r16

I2C_Write_Wait:
	in r16,TWCR
	sbrs r16,TWINT
	rjmp I2C_Write_Wait
ret


;This function reads in data from the I2C data line and stores it in R16.
;Remember to set R16 to either I2C_ACK or I2C_NACK before calling the function!
;Failure to do so may result in unwanted behaviour.
I2C_Read:
	sbrc r16,0
	rjmp I2C_Read_ACK
	ldi r16, (1<<TWINT) | (1<<TWEN)
	rjmp I2C_Read_Continue
I2C_Read_ACK:
	ldi r16, (1<<TWINT) | (1<<TWEN) | (1<<TWEA)
I2C_Read_Continue:
	out TWCR, r16
I2C_Read_Wait:
	in r16,TWCR
	sbrs r16,TWINT
	rjmp I2C_Read_Wait

	in R16, TWDR
ret


