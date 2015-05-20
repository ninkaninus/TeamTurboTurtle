AI_Lap:
	lds		R17,	AI_Check_Lap
	inc		R17							;Runde tæller
	sts		AI_Check_Lap,	R17

	cpi		R17,	1
	breq	Mapping
	
	cpi		R17,	3
	brsh	Run_Time

;First round								Vi sætter der første stykke bane oveni, så vi ikke løber tør for bane.

		mov		R16,		YL
		mov		R17,		YH
		ldi		YH,			HIGH(Map_Start)		
		ldi		YL,			LOW(Map_Start)		

		ld			Length_L,		Y+
		ld			Length_H,		Y+
		ld			Type,			Y+
		
		mov		YL,			R16
		mov		YH,			R17

		st		Y+,		Length_L
		st		Y+,		Length_H
		st		Y+,		Type
		
Run_Time:

		ldi		YH,			HIGH(Map_Start)		
		ldi		YL,			LOW(Map_Start)		

		ld			Length_L,		Y+
		ld			Length_H,		Y+
		ld			Type,			Y+

ret

Mapping:

call	Gyro_Kontrol
		mov		Type,		R16

ret
