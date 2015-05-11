AI_Lap_Interrupt:						;Lap interrupt skifter fra initial runden til den første runde til alle resterende.

		lds		R20, AI_Check_Lap		

		cpi		R20, 1
		brsh	AI_Test_Speed_Laps

		ldi		R20, 1
		sts		AI_Check_Lap, R20

		ldi R16, 'F'
		call USART_Transmit


		ret								;Hopper til den første runde

AI_Test_Speed_Laps:
		
		ldi R16, 'R'
		call USART_Transmit

		ldi		R20, 2
		sts     AI_Check_Lap, R20

		/*
		lds		R20,		AI_Hastighed_D
		inc		R20
		sts		AI_Hastighed_D,R20

		clr		R27						;Nulstiller X
		ldi		R26,		Map_start
		ldi		R16, 2
		sts		AI_Check_Lap, R16
		ld		Laengde,	x+			;Indlæser den første del af af det gemte map.
		ld		Type,		x+
		*/

		ret















