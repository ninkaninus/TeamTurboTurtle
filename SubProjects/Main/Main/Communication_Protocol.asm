.Macro Comm_Init
	ldi R16, 0x01
	sts Comm_Received_Byte_Num, R16
	clr R16
	sts Comm_Received_Byte_1, R16
	sts Comm_Received_Byte_2, R16
	sts Comm_Received_Byte_3, R16

.ENDMACRO



;Implemetation of the required communication protocol
Comm_Received:
	lds R16, Comm_Received_Byte_Num			;What byte # did we receive

	cpi R16, 0x01							;If it was the first
	breq Comm_Received_Type					;Set the type

	cpi R16, 0x02							;If it was the second
	breq Comm_Received_Command				;Set the command

	cpi R16, 0x03							;If it was the third
	breq Comm_Received_Parameter			;Set the parameter

;---------------------------------------------------------------------------------------------------------------------
;Define Types here
;---------------------------------------------------------------------------------------------------------------------

.equ Comm_Type_SET = 0x55
.equ Comm_Type_GET = 0xAA

;Received a type
Comm_Received_Type:
	lds R16, Comm_Received_Byte_Num			;Load in the byte counter
	inc R16									;Increment the counter
	sts Comm_Received_Byte_Num, R16			;Store it

	in r16, UDR								;Read in the received type

	cpi R16, 0x55							;Check if a SET was received
	breq Comm_Received_Type_SET				;

	cpi R16, 0xAA							;Check if a GET was received	
	breq Comm_Received_Type_GET				;

	ldi R16, 0x01							;
	sts Comm_Received_Byte_Num, R16			;Clear the receive byte counter since the communication was invalid
	reti									;Return if we did not received a useful value


Comm_Received_Type_SET:						;Received a SET	
	sts Comm_Received_Byte_1, R16			;Store it as the first byte
	reti									;Return

Comm_Received_Type_GET:						;Received a GET
	sts Comm_Received_Byte_1, R16			;Store it as the first byte
	reti									;Return

;---------------------------------------------------------------------------------------------------------------------
;Define Commands here
;---------------------------------------------------------------------------------------------------------------------

.equ Comm_Command_Start = 0x10
.equ Comm_Command_Stop = 0x11

;Received a command
Comm_Received_Command:
	lds R16, Comm_Received_Byte_Num			;Load in the byte counter
	inc R16									;Increment the counter
	sts Comm_Received_Byte_Num, R16			;Store it

	in r16, UDR								;Read in the received command

	cpi R16, 0x10							;Check if a Start was received
	breq Comm_Received_Command_Start		;

	cpi R16, 0x11							;Check if a Stop was received	
	breq Comm_Received_Command_Stop			;

	ldi R16, 0x01							;
	sts Comm_Received_Byte_Num, R16			;Clear the receive byte counter since the communication was invalid
	reti									;Return if we did not received a useful value


Comm_Received_Command_Start:				;Received a Start	
	sts Comm_Received_Byte_2, R16			;Store it as the second byte
	reti									;Return

Comm_Received_Command_Stop:					;Received a Stop
	sts Comm_Received_Byte_2, R16			;Store it as the fsecond byte
	reti									;Return

;---------------------------------------------------------------------------------------------------------------------

Comm_Received_Parameter:

	

	
reti