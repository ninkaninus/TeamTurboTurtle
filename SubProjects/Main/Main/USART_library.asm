/*
 * USART_library.asm
 *
 *  Created: 26-03-2015 12:27:09
 *   Author: StjerneIdioten
 */ 

 .MACRO  USART_Init
	;Set Baud Rate to 9600
	ldi R16,	0b01100111	
	ldi R17,	0b00000000

	out	UBRRH,	R17
	out UBRRL,	R16

	;Enable receiver and transmitter
	ldi R16,	(1<<RXEN)|(1<<TXEN)
	out	UCSRB,	R16

	; Set frame format: 8data, 2stop bit
	ldi	R16,	(1<<URSEL)|(3<<UCSZ0)
	out	UCSRC,	R16
 .ENDMACRO

 ;Waits for an empty transmit buffer and then moves R16 to the transmit buffer
 USART_Transmit: 
 USART_Transmit_Start:
	; Wait for empty transmit buffer
	sbis	UCSRA,	UDRE
	rjmp	USART_Transmit_Start
	out	UDR, R16
ret


;Waits for a byte to be recived and outputs it to R16
USART_Receive:
USART_Receive_Start:
	; Wait for data to be received
	sbis UCSRA, RXC
	rjmp USART_Receive_Start
	; Get and return received data from buffer
	in r16, UDR
ret


;Outputs a newline to serial. In the format of '\r\n'
.Macro USART_Newline
	ldi R16, 0x0D
	call USART_Transmit 
	ldi R16, 0x0A
	call USART_Transmit 
.ENDMACRO

;Outputs the byte in R16 as a string of 8 ascii 1's or 0's
USART_Binary:
	mov R17, R16			;Copy R16 to R17
	ldi R18, 0x00			;Set the counter to zero
USART_Binary_Loop:
	sbrs R17, 7				;Skip if bit 7 in R17 is set
	rjmp USART_Binary_0		;Jump here if the it was 0
	ldi R16, '1'			;Load in ascii 1 in R16
	call USART_Transmit		;Transmit the 1
	rjmp USART_Binary_End	;Jump to the end
USART_Binary_0:				
	ldi R16, '0'			;Load in ascii 0 in R16
	call USART_Transmit
USART_Binary_End:
	lsl R17					;Left shift R17
	inc R18					;Increment R18
	cpi R18, 0x08			;Check if we have converted and sent an entire byte yet
	brne USART_Binary_Loop	;Repeat if we haven't
ret

USART_Decimal

ret