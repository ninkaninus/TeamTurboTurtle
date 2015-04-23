EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:special
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:ToyRaceCar_V2_REV3
LIBS:Breakout_Boards
LIBS:Sensorboard-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L ToyRaceCar_V2_REV3_J2 P3
U 1 1 5536E168
P 3250 1300
F 0 "P3" H 3250 1850 50  0000 C CNN
F 1 "ToyRaceCar_V2_REV3_J2" V 3550 1300 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x10" H 3250 1300 60  0001 C CNN
F 3 "" H 3250 1300 60  0000 C CNN
	1    3250 1300
	1    0    0    -1  
$EndComp
$Comp
L ToyRaceCar_V2_REV3_J3 P2
U 1 1 5536E214
P 2750 2750
F 0 "P2" H 2750 3300 50  0000 C CNN
F 1 "ToyRaceCar_V2_REV3_J3" V 3250 2750 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x10" H 2750 2750 60  0001 C CNN
F 3 "" H 2750 2750 60  0000 C CNN
	1    2750 2750
	0    -1   -1   0   
$EndComp
$Comp
L ToyRaceCar_V2_REV3_J4 P1
U 1 1 5536E349
P 1100 1350
F 0 "P1" H 1100 1900 50  0000 C CNN
F 1 "ToyRaceCar_V2_REV3_J4" V 1600 1350 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x10" H 1100 1350 60  0001 C CNN
F 3 "" H 1100 1350 60  0000 C CNN
	1    1100 1350
	1    0    0    -1  
$EndComp
$Comp
L ToyRaceCar_V2_REV3_J1 P4
U 1 1 55381BB2
P 4450 1700
F 0 "P4" H 4450 2050 50  0000 C CNN
F 1 "ToyRaceCar_V2_REV3_J1" V 4850 1700 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x06" H 4450 1700 60  0001 C CNN
F 3 "" H 4450 1700 60  0000 C CNN
	1    4450 1700
	1    0    0    -1  
$EndComp
$Comp
L ToyRaceCar_V2_REV3_J5 P6
U 1 1 55381BE9
P 4800 850
F 0 "P6" H 4800 1100 50  0000 C CNN
F 1 "ToyRaceCar_V2_REV3_J5" V 5400 850 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x04" H 4800 850 60  0001 C CNN
F 3 "" H 4800 850 60  0000 C CNN
	1    4800 850 
	1    0    0    -1  
$EndComp
$Comp
L MPU-6050 P5
U 1 1 55381C69
P 4200 4150
F 0 "P5" H 4200 4600 50  0000 C CNN
F 1 "MPU-6050" V 4450 4200 50  0000 C CNN
F 2 "Sensorboard:MPU-6050" H 4200 4150 60  0001 C CNN
F 3 "" H 4200 4150 60  0000 C CNN
	1    4200 4150
	1    0    0    -1  
$EndComp
$Comp
L R R3
U 1 1 55382378
P 2950 3800
F 0 "R3" V 2850 3800 50  0000 C CNN
F 1 "10K" V 2950 3800 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 2880 3800 30  0001 C CNN
F 3 "" H 2950 3800 30  0000 C CNN
	1    2950 3800
	1    0    0    -1  
$EndComp
$Comp
L R R4
U 1 1 553823F8
P 3100 3800
F 0 "R4" V 3180 3800 50  0000 C CNN
F 1 "10K" V 3100 3800 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 3030 3800 30  0001 C CNN
F 3 "" H 3100 3800 30  0000 C CNN
	1    3100 3800
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 5538245D
P 2450 4300
F 0 "R1" V 2530 4300 50  0000 C CNN
F 1 "10K" V 2450 4300 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 2380 4300 30  0001 C CNN
F 3 "" H 2450 4300 30  0000 C CNN
	1    2450 4300
	1    0    0    -1  
$EndComp
$Comp
L R R2
U 1 1 553824EF
P 2750 4300
F 0 "R2" V 2830 4300 50  0000 C CNN
F 1 "10K" V 2750 4300 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 2680 4300 30  0001 C CNN
F 3 "" H 2750 4300 30  0000 C CNN
	1    2750 4300
	-1   0    0    1   
$EndComp
$Comp
L BSS138 Q1
U 1 1 55382588
P 2050 3800
F 0 "Q1" V 1950 3900 50  0000 L CNN
F 1 "BSS138" V 2400 3550 50  0000 L CNN
F 2 "Housings_SOT-23_SOT-143_TSOT-6:SOT-23_Handsoldering" V 2300 3550 50  0001 L CIN
F 3 "" H 2050 3800 50  0000 L CNN
	1    2050 3800
	0    -1   -1   0   
$EndComp
$Comp
L BSS138 Q2
U 1 1 553825E4
P 2550 3800
F 0 "Q2" V 2450 3900 50  0000 L CNN
F 1 "BSS138" V 2900 3500 50  0000 L CNN
F 2 "Housings_SOT-23_SOT-143_TSOT-6:SOT-23_Handsoldering" V 2800 3500 50  0001 L CIN
F 3 "" H 2550 3800 50  0000 L CNN
	1    2550 3800
	0    -1   -1   0   
$EndComp
Text Notes 1750 4700 0    60   ~ 0
I2C Logic Level Shifter 3.3V<->5V
Text Label 2300 3150 0    60   ~ 0
+5V
Wire Wire Line
	2750 3700 2750 4150
Wire Wire Line
	2750 4000 4000 4000
Wire Wire Line
	2250 3700 2250 4100
Wire Wire Line
	2250 4100 4000 4100
Wire Wire Line
	2350 3700 2350 3600
Wire Wire Line
	2350 3600 3000 3600
Wire Wire Line
	3000 3600 3000 2950
Wire Wire Line
	1850 3700 1850 3500
Wire Wire Line
	1850 3500 3100 3500
Wire Wire Line
	3100 2950 3100 3650
Wire Wire Line
	2600 4450 2600 4000
Connection ~ 2100 4450
Wire Wire Line
	2100 4000 2100 4450
Connection ~ 2450 4450
Connection ~ 2600 4450
Connection ~ 2750 4000
Wire Wire Line
	2450 4150 2450 4100
Connection ~ 2450 4100
Connection ~ 3100 3500
Wire Wire Line
	2950 3650 2950 3600
Connection ~ 2950 3600
Wire Wire Line
	2950 3950 3350 3950
Connection ~ 3100 3950
Wire Wire Line
	3750 3900 4000 3900
Wire Wire Line
	4000 3800 3750 3800
Wire Notes Line
	3250 3350 3250 4600
Wire Notes Line
	3250 4600 1800 4600
Wire Notes Line
	1800 4600 1800 3350
Wire Notes Line
	1800 3350 3250 3350
Wire Wire Line
	2300 2950 2300 3150
Wire Wire Line
	2400 2950 2400 3050
Text Label 2400 3050 0    60   ~ 0
GND
Text Label 3750 3800 0    60   ~ 0
+5V
Text Label 3750 3900 0    60   ~ 0
GND
Wire Wire Line
	2250 3050 2300 3050
Connection ~ 2300 3050
Wire Wire Line
	2100 4450 2750 4450
Text Label 2100 4450 0    60   ~ 0
+3.3V
Text Label 3350 3950 0    60   ~ 0
+5V
NoConn ~ 900  900 
NoConn ~ 900  1000
NoConn ~ 900  1100
NoConn ~ 900  1200
NoConn ~ 900  1300
NoConn ~ 900  1400
NoConn ~ 900  1500
NoConn ~ 900  1600
NoConn ~ 900  1700
NoConn ~ 900  1800
NoConn ~ 3050 850 
NoConn ~ 3050 950 
NoConn ~ 3050 1050
NoConn ~ 3050 1150
NoConn ~ 3050 1250
NoConn ~ 3050 1350
NoConn ~ 3050 1450
NoConn ~ 3050 1550
NoConn ~ 3050 1650
NoConn ~ 3050 1750
NoConn ~ 4600 700 
NoConn ~ 4600 800 
NoConn ~ 4600 900 
NoConn ~ 4600 1000
NoConn ~ 4250 1650
NoConn ~ 4250 1750
NoConn ~ 4250 1850
NoConn ~ 4250 1950
NoConn ~ 3200 2950
NoConn ~ 2900 2950
NoConn ~ 2800 2950
NoConn ~ 2700 2950
NoConn ~ 2600 2950
NoConn ~ 2500 2950
NoConn ~ 4250 1550
NoConn ~ 4000 4200
NoConn ~ 4000 4300
NoConn ~ 4000 4400
NoConn ~ 4000 4500
Wire Wire Line
	4250 1450 3950 1450
Text Label 3950 1450 0    60   ~ 0
+3.3V
$Comp
L CNY70 P7
U 1 1 5538F827
P 4200 2950
F 0 "P7" H 4200 3200 50  0000 C CNN
F 1 "CNY70" V 4800 2950 50  0000 C CNN
F 2 "" H 4200 2950 60  0000 C CNN
F 3 "" H 4200 2950 60  0000 C CNN
	1    4200 2950
	1    0    0    -1  
$EndComp
$EndSCHEMATC
