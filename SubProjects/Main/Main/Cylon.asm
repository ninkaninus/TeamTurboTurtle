Cylon1:									
	lds		R16, SREG_1
	sbrs	R16, 3
	rjmp	Left

Right:
	
	in		R16, PORTA
	lsr		R16
	out		PORTA, R16
	
	cpi		R16, (1<<PA0)
	breq	Left_End

Right_End:
	Set_SREG_1		3	
	ret
									; Cylon scanner from side to side.
Left:

	in		R16, PORTA
	lsl		R16
	out		PORTA, R16
	
	cpi		R16, (1<<PA6)
	breq	Right_End

Left_End:
	Clear_SREG_1	3
	ret
	
;--------------------------------------------------------------------------------------------------------------

Cylon2:
	lds		R16, SREG_1
	sbrs	R16, 4
	rjmp	Inwards

Outwards:
	clr		R16
	mov		R12, R16
	
	in		R16, PORTA
	andi	R16, 0b00001111
	in		R17, PORTA
	andi	R17, 0b01111000
		
	lsr		R16
	lsl		R17
		
	or		R12, R16
	or		R12, R17
	out		PORTA, R12
	
	cpi		R16, (1<<PA0)
	breq	Inwards_End
	
Outwards_End:
	Set_SREG_1		4	
	ret
									; Cylon scanner from the middle and outwards and back again
Inwards:
	clr		R16
	mov		R12, R16
	
	in		R16, PORTA
	andi	R16, 0b00001111
	in		R17, PORTA
	andi	R17, 0b01111000
	
	lsl		R16
	lsr		R17
		
	or		R12, R16
	or		R12, R17
	out		PORTA, R12
	
	cpi		R16, (1<<PA3)
	breq	Outwards_End
	
Inwards_End:
	Clear_SREG_1		4
	ret
	
;----------------------------------------------------------------------------------

Cylon3:
	clc
	in		R16, PORTA
	cpi		R16, 0
	
	in 		R17, SREG						; Cylon scanner that rotates LED's to the right
	sbrc	R17, 1
	sec
	
	ror		R16
	out		PORTA, R16
	
	ret	
	
;------------------------------------------------------------------------------------

Cylon4:
	clc
	in		R16, PORTA
	cpi		R16, 0
	
	in 		R17, SREG						; Cylon scanner that rotates LED's to the left
	sbrc	R17, 1
	sec
	
	rol		R16
	out		PORTA, R16
	
	ret	

;------------------------------------------------------------------------------------
