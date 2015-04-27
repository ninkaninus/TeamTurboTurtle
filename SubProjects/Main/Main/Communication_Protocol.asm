.Macro Comm_Init
	ldi R16, 0x01
	sts Comm_Received_Byte_Num, R16
	clr R16
	sts Comm_Received_Byte_1, R16
	sts Comm_Received_Byte_2, R16
	sts Comm_Received_Byte_3, R16
.ENDMACRO


;Define types
.equ Comm_Type_SET = 0x55
.equ Comm_Type_GET = 0xAA

;Define commands
.equ Comm_Command_Start = 0x10
.equ Comm_Command_Stop = 0x11


;Implemetation of the required communication protocol
Comm_Received:
	lds R16, Comm_Received_Byte_Num			;What byte # did we receive

	cpi R16, 0x01							;If it was the first
	breq Comm_Received_Type					;Set the type

	cpi R16, 0x02							;If it was the second
	breq Comm_Received_Command				;Set the command

	;Working under the assumption that if it was not the first or second byte, then it must be the third.

	rjmp Comm_Received_Execute


;Received a type
Comm_Received_Type:
	ldi R16, 0x02							;Set the counter to two
	sts Comm_Received_Byte_Num, R16			;Store it

	in r16, UDR								;Read in the received type
	sts Comm_Received_Byte_1, R16
	reti

;Received a command
Comm_Received_Command:
	ldi R16, 0x03							;Set the counter to three
	sts Comm_Received_Byte_Num, R16			;Store it

	in r16, UDR								;Read in the received command
	sts Comm_Received_Byte_2, R16
	reti

;Execute the telegram received
Comm_Received_Execute:
	in r16, UDR								;Read in the received parameter
	sts Comm_Received_Byte_3, R16			;Store it
	
	ldi R16, 0x01							;Reset the counter
	sts Comm_Received_Byte_Num, R16			;Store it

;---------------------------------------------------------------------------------------------------------------------
;Types
;---------------------------------------------------------------------------------------------------------------------

	;SET
	lds R16, Comm_Received_Byte_1			;Check if we received a SET and branch if it was
	cpi R16, Comm_Type_SET					;
	breq Comm_Received_Type_Set				;

	;GET
	lds R16, Comm_Received_Byte_1			;Check if we received a GET and branch if it was
	cpi R16, Comm_Type_GET					;
	breq Comm_Received_Type_Get				;


;---------------------------------------------------------------------------------------------------------------------
;SET's
;---------------------------------------------------------------------------------------------------------------------

Comm_Received_Type_Set:
	lds R16, Comm_Received_Byte_2			;Load in the second byte
	cpi R16, Comm_Command_Start				;Check if we received a Start command
	breq Comm_Received_Type_Set				;

	cpi R16, Comm_Command_Start				;Check if we received a Stop command
	breq Comm_Received_Type_Set				;

	reti									;Do nothing if it was not a legit code

;Start
Comm_Received_Command_Start:
	ldi R16, 0x01
	sts Program_Running, R16
	lds R16, Comm_Received_Byte_3
	out OCR2, R16 
	reti

;Stop
Comm_Received_Command_Stop:
	ldi R16, 0x00
	sts Program_Running, R16
	ldi R16, 0x00
	out OCR2, R16
	reti


;---------------------------------------------------------------------------------------------------------------------
;GET's
;---------------------------------------------------------------------------------------------------------------------

Comm_Received_Type_Get:	
	reti									;Do nothing if it was not a legit code