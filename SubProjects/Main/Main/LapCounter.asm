.MACRO LapCounter_Init

	clr	R16
	sts	Time_Stamp_L, R16
	sts	Time_Stamp_M, R16
	sts	Time_Stamp_H, R16
			
	sts	Lap_time_L, R16
	sts	Lap_time_M, R16
	sts	Lap_time_H, R16

	in R16, ACSR
	ori R16, 0x48						;Initialize comparator with bandgap reference and enable interrupt
	out ACSR, R16						;

	in R16, SFIOR						;
	andi R16, ~(1<<ACME)				;Disable comparator multiplexer (AIN1 = inverting input for comparator)
	out SFIOR, R16						;

	cbi DDRB,PB3						;Make PB3 input for the comparator

.ENDMACRO

Lap_Time:	

	push	R0
	push	R1
	push	R2
	push	R3
	push	R4
	push	R5
	push	R16
	in		R16, SREG
	push	R16

	lds		R0, Timer_1ms_L				
	lds		R1, Timer_1ms_M				; Current time since startup in ms
	lds		R2, Timer_1ms_H				 
			
	lds		R3, Time_Stamp_L			
	lds		R4, Time_Stamp_M			; Time stamp at start of lap
	lds		R5, Time_Stamp_H
			
	sts		Time_Stamp_L, R0			
	sts		Time_Stamp_M, R1			; New time stamp for next lap
	sts		Time_Stamp_H, R2	
			
	sub		R0, R3						
	sbc		R1, R4						; Difference between current time and last time stamp
	sbc		R2, R5
			
	tst R1
	breq Lap_Time_End

	sts		Lap_time_L, R0				
	sts		Lap_time_M, R1				; Latest lap time
	sts		Lap_time_H, R2
			
	ldi		R16, 0x40					; Disable Comparator interrupt
	out		ACSR, R16					; Global interrupt register
			
	ldi		R16, 0b01011000				; Enable Comparator interrupt and clear comparator interrupt flag
	out		ACSR, R16					; Global interrupt register

	
	ldi R16, 'G'
	call USART_Transmit
	USART_Newline
	
	
Lap_Time_End:

	pop		R16
	out		SREG
	pop		R16
	pop		R5
	pop		R4
	pop		R3
	pop		R2
	pop		R1
	pop		R0

			reti			
