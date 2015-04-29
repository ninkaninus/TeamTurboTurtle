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
P 2200 1150
F 0 "P3" H 2200 1700 50  0000 C CNN
F 1 "ToyRaceCar_V2_REV3_J2" V 2500 1150 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x10" H 2200 1150 60  0001 C CNN
F 3 "" H 2200 1150 60  0000 C CNN
	1    2200 1150
	1    0    0    -1  
$EndComp
$Comp
L ToyRaceCar_V2_REV3_J3 P2
U 1 1 5536E214
P 3800 5450
F 0 "P2" H 3800 6000 50  0000 C CNN
F 1 "ToyRaceCar_V2_REV3_J3" V 4300 5450 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x10" H 3800 5450 60  0001 C CNN
F 3 "" H 3800 5450 60  0000 C CNN
	1    3800 5450
	1    0    0    -1  
$EndComp
$Comp
L ToyRaceCar_V2_REV3_J4 P1
U 1 1 5536E349
P 950 1150
F 0 "P1" H 950 1700 50  0000 C CNN
F 1 "ToyRaceCar_V2_REV3_J4" V 1450 1150 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x10" H 950 1150 60  0001 C CNN
F 3 "" H 950 1150 60  0000 C CNN
	1    950  1150
	1    0    0    -1  
$EndComp
$Comp
L ToyRaceCar_V2_REV3_J1 P4
U 1 1 55381BB2
P 3800 2750
F 0 "P4" H 3800 3100 50  0000 C CNN
F 1 "ToyRaceCar_V2_REV3_J1" V 4200 2750 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x06" H 3800 2750 60  0001 C CNN
F 3 "" H 3800 2750 60  0000 C CNN
	1    3800 2750
	1    0    0    -1  
$EndComp
$Comp
L ToyRaceCar_V2_REV3_J5 P6
U 1 1 55381BE9
P 3100 1050
F 0 "P6" H 3100 1300 50  0000 C CNN
F 1 "ToyRaceCar_V2_REV3_J5" V 3700 1050 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x04" H 3100 1050 60  0001 C CNN
F 3 "" H 3100 1050 60  0000 C CNN
	1    3100 1050
	1    0    0    -1  
$EndComp
$Comp
L MPU-6050 P5
U 1 1 55381C69
P 3800 4250
F 0 "P5" H 3800 4700 50  0000 C CNN
F 1 "MPU-6050" V 4050 4300 50  0000 C CNN
F 2 "Sensorboard:MPU-6050" H 3800 4250 60  0001 C CNN
F 3 "" H 3800 4250 60  0000 C CNN
	1    3800 4250
	1    0    0    -1  
$EndComp
$Comp
L R R3
U 1 1 55382378
P 1800 3550
F 0 "R3" V 1700 3550 50  0000 C CNN
F 1 "10K" V 1800 3550 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 1730 3550 30  0001 C CNN
F 3 "" H 1800 3550 30  0000 C CNN
	1    1800 3550
	1    0    0    -1  
$EndComp
$Comp
L R R4
U 1 1 553823F8
P 1950 3550
F 0 "R4" V 2030 3550 50  0000 C CNN
F 1 "10K" V 1950 3550 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 1880 3550 30  0001 C CNN
F 3 "" H 1950 3550 30  0000 C CNN
	1    1950 3550
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 5538245D
P 1300 4100
F 0 "R1" V 1380 4100 50  0000 C CNN
F 1 "10K" V 1300 4100 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 1230 4100 30  0001 C CNN
F 3 "" H 1300 4100 30  0000 C CNN
	1    1300 4100
	1    0    0    -1  
$EndComp
$Comp
L R R2
U 1 1 553824EF
P 1600 4100
F 0 "R2" V 1680 4100 50  0000 C CNN
F 1 "10K" V 1600 4100 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 1530 4100 30  0001 C CNN
F 3 "" H 1600 4100 30  0000 C CNN
	1    1600 4100
	-1   0    0    1   
$EndComp
$Comp
L BSS138 Q1
U 1 1 55382588
P 900 3600
F 0 "Q1" V 800 3700 50  0000 L CNN
F 1 "BSS138" V 1250 3350 50  0000 L CNN
F 2 "Housings_SOT-23_SOT-143_TSOT-6:SOT-23_Handsoldering" V 1150 3350 50  0001 L CIN
F 3 "" H 900 3600 50  0000 L CNN
	1    900  3600
	0    -1   -1   0   
$EndComp
$Comp
L BSS138 Q2
U 1 1 553825E4
P 1400 3600
F 0 "Q2" V 1300 3700 50  0000 L CNN
F 1 "BSS138" V 1750 3300 50  0000 L CNN
F 2 "Housings_SOT-23_SOT-143_TSOT-6:SOT-23_Handsoldering" V 1650 3300 50  0001 L CIN
F 3 "" H 1400 3600 50  0000 L CNN
	1    1400 3600
	0    -1   -1   0   
$EndComp
Text Notes 750  4400 0    60   ~ 0
I2C Logic Level Shifter 3.3V<->5V
Text Label 3400 5000 0    60   ~ 0
+5V
Text Label 3400 5100 0    60   ~ 0
GND
Text Label 3350 3900 0    60   ~ 0
+5V
Text Label 3350 4000 0    60   ~ 0
GND
Text Label 950  4250 0    60   ~ 0
+3.3V
Text Label 2000 3700 0    60   ~ 0
+5V
NoConn ~ 750  900 
NoConn ~ 750  1000
NoConn ~ 750  1100
NoConn ~ 750  1200
NoConn ~ 750  1300
NoConn ~ 750  1400
NoConn ~ 750  1500
NoConn ~ 2000 900 
NoConn ~ 2000 1000
NoConn ~ 2000 1100
NoConn ~ 2000 1200
NoConn ~ 2000 1300
NoConn ~ 2000 1400
NoConn ~ 2000 1500
NoConn ~ 2000 1600
NoConn ~ 2900 900 
NoConn ~ 2900 1000
NoConn ~ 2900 1100
NoConn ~ 3600 2700
NoConn ~ 3600 2900
NoConn ~ 3600 3000
NoConn ~ 3600 5500
NoConn ~ 3600 5400
NoConn ~ 3600 5300
NoConn ~ 3600 4300
NoConn ~ 3600 4400
NoConn ~ 3600 4500
Text Label 3300 2500 0    60   ~ 0
+3.3V
$Comp
L CNY70 P7
U 1 1 5538F827
P 3800 3400
F 0 "P7" H 3800 3650 50  0000 C CNN
F 1 "CNY70" V 4400 3400 50  0000 C CNN
F 2 "Sensorboard:KK254-4" H 3800 3400 60  0001 C CNN
F 3 "" H 3800 3400 60  0000 C CNN
	1    3800 3400
	1    0    0    -1  
$EndComp
Text Label 3400 5900 0    60   ~ 0
GND
Text Label 3300 2600 0    60   ~ 0
GND
Text Label 2650 1200 0    60   ~ 0
GND
Text Label 550  700  0    60   ~ 0
+5V
Text Label 550  800  0    60   ~ 0
GND
Text Label 1800 700  0    60   ~ 0
+5V
Text Label 1800 800  0    60   ~ 0
GND
Text Label 2000 3300 0    60   ~ 0
SDA(5V)
Text Label 2000 3400 0    60   ~ 0
SCL(5V)
Text Label 2000 3800 0    60   ~ 0
SCL(3.3V)
Text Label 2000 3900 0    60   ~ 0
SDA(3.3V)
Text Label 3200 4100 0    60   ~ 0
SCL(3.3V)
Text Label 3200 4200 0    60   ~ 0
SDA(3.3V)
Text Label 3250 5800 0    60   ~ 0
SDA(5V)
Text Label 3250 5700 0    60   ~ 0
SCL(5V)
Text Label 3350 3350 0    60   ~ 0
+5V
Text Label 3350 3450 0    60   ~ 0
+5V
$Comp
L R R6
U 1 1 553C6BF8
P 3400 3550
F 0 "R6" V 3480 3550 50  0000 C CNN
F 1 "150R" V 3400 3550 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 3330 3550 30  0001 C CNN
F 3 "" H 3400 3550 30  0000 C CNN
	1    3400 3550
	0    1    1    0   
$EndComp
$Comp
L R R5
U 1 1 553C6C67
P 3250 3250
F 0 "R5" V 3330 3250 50  0000 C CNN
F 1 "20K" V 3250 3250 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 3180 3250 30  0001 C CNN
F 3 "" H 3250 3250 30  0000 C CNN
	1    3250 3250
	0    -1   -1   0   
$EndComp
Text Label 3050 3550 0    60   ~ 0
GND
Text Label 550  1600 0    60   ~ 0
VIN
Text Label 2950 3250 0    60   ~ 0
GND
$Comp
L AD623AN U1
U 1 1 553F98F8
P 1650 5100
F 0 "U1" H 1950 5350 70  0000 C CNN
F 1 "AD623AN" H 2050 4850 70  0000 C CNN
F 2 "Housings_DIP:DIP-8__300" H 1650 5100 60  0001 C CNN
F 3 "" H 1650 5100 60  0000 C CNN
	1    1650 5100
	1    0    0    -1  
$EndComp
Text Label 1550 4750 1    60   ~ 0
+5V
Text Label 1550 5600 1    60   ~ 0
GND
NoConn ~ 1750 4800
$Comp
L R R10
U 1 1 553FD89B
P 1750 5600
F 0 "R10" V 1830 5600 50  0000 C CNN
F 1 "3K3" V 1750 5600 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 1680 5600 30  0001 C CNN
F 3 "" H 1750 5600 30  0000 C CNN
	1    1750 5600
	1    0    0    -1  
$EndComp
$Comp
L POT RV1
U 1 1 553FE324
P 1050 5450
F 0 "RV1" H 1050 5350 50  0000 C CNN
F 1 "10K" H 1050 5450 50  0000 C CNN
F 2 "Potentiometers:Potentiometer_Bourns_3006P_Angular_ScrewFront" H 1050 5450 60  0001 C CNN
F 3 "" H 1050 5450 60  0000 C CNN
	1    1050 5450
	1    0    0    -1  
$EndComp
Text Label 750  5650 1    60   ~ 0
+5V
Text Label 1350 5650 1    60   ~ 0
GND
$Comp
L LM311N U2
U 1 1 554008E9
P 1950 6450
F 0 "U2" H 2150 6750 70  0000 C CNN
F 1 "LM311N" H 2150 6650 70  0000 C CNN
F 2 "Housings_DIP:DIP-8__300" H 1950 6450 60  0001 C CNN
F 3 "" H 1950 6450 60  0000 C CNN
	1    1950 6450
	1    0    0    -1  
$EndComp
Text Label 1850 7050 1    60   ~ 0
GND
Text Label 1850 6050 2    60   ~ 0
+5V
NoConn ~ 2050 6850
NoConn ~ 2450 6550
$Comp
L R R7
U 1 1 5540394A
P 1000 6350
F 0 "R7" V 1080 6350 50  0000 C CNN
F 1 "6K8" V 1000 6350 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 930 6350 30  0001 C CNN
F 3 "" H 1000 6350 30  0000 C CNN
	1    1000 6350
	0    1    1    0   
$EndComp
$Comp
L R R11
U 1 1 554039C3
P 2550 6250
F 0 "R11" V 2630 6250 50  0000 C CNN
F 1 "10K" V 2550 6250 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 2480 6250 30  0001 C CNN
F 3 "" H 2550 6250 30  0000 C CNN
	1    2550 6250
	1    0    0    -1  
$EndComp
$Comp
L R R9
U 1 1 55403A1C
P 1200 6550
F 0 "R9" V 1280 6550 50  0000 C CNN
F 1 "6K8" V 1200 6550 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 1130 6550 30  0001 C CNN
F 3 "" H 1200 6550 30  0000 C CNN
	1    1200 6550
	1    0    0    -1  
$EndComp
$Comp
L R R8
U 1 1 55403A82
P 1200 6150
F 0 "R8" V 1280 6150 50  0000 C CNN
F 1 "20K" V 1200 6150 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 1130 6150 30  0001 C CNN
F 3 "" H 1200 6150 30  0000 C CNN
	1    1200 6150
	1    0    0    -1  
$EndComp
Wire Wire Line
	1600 3500 1600 3950
Wire Wire Line
	1200 3500 1200 3400
Wire Wire Line
	1200 3400 2000 3400
Wire Wire Line
	700  3500 700  3300
Wire Wire Line
	700  3300 2000 3300
Wire Wire Line
	1950 3300 1950 3400
Wire Wire Line
	1450 4250 1450 3800
Connection ~ 950  4250
Wire Wire Line
	950  3800 950  4250
Connection ~ 1300 4250
Connection ~ 1450 4250
Connection ~ 1600 3800
Connection ~ 1950 3300
Wire Wire Line
	1800 3400 1800 3400
Connection ~ 1800 3400
Wire Wire Line
	1800 3700 2000 3700
Connection ~ 1950 3700
Wire Wire Line
	3350 4000 3600 4000
Wire Wire Line
	3600 3900 3350 3900
Wire Wire Line
	3600 5000 3400 5000
Wire Wire Line
	3600 5100 3400 5100
Wire Wire Line
	950  4250 1600 4250
Wire Wire Line
	3600 2500 3300 2500
Wire Wire Line
	3600 5900 3400 5900
Wire Wire Line
	3600 2600 3300 2600
Wire Wire Line
	2900 1200 2650 1200
Wire Wire Line
	750  700  550  700 
Wire Wire Line
	750  800  550  800 
Wire Wire Line
	2000 700  1800 700 
Wire Wire Line
	2000 800  1800 800 
Wire Wire Line
	1600 3800 2000 3800
Wire Wire Line
	1100 3500 1100 3900
Connection ~ 1300 3900
Wire Wire Line
	1300 3950 1300 3900
Wire Wire Line
	1100 3900 2000 3900
Wire Notes Line
	650  3200 2450 3200
Wire Notes Line
	2450 3200 2450 4300
Wire Notes Line
	2450 4300 650  4300
Wire Notes Line
	650  4300 650  3200
Wire Wire Line
	3600 4100 3200 4100
Wire Wire Line
	3600 4200 3200 4200
Wire Wire Line
	3600 5800 3250 5800
Wire Wire Line
	3600 5700 3250 5700
Wire Wire Line
	3600 3450 3350 3450
Wire Wire Line
	3600 3350 3350 3350
Wire Wire Line
	3600 3550 3550 3550
Wire Wire Line
	3250 3550 3050 3550
Wire Wire Line
	750  1600 550  1600
Wire Wire Line
	3600 2800 3500 2800
Wire Wire Line
	3500 2800 3500 3250
Wire Wire Line
	3400 3250 3600 3250
Connection ~ 3500 3250
Wire Wire Line
	3100 3250 2950 3250
Wire Wire Line
	1550 4800 1550 4750
Wire Wire Line
	1550 5400 1550 5600
Wire Wire Line
	1750 5400 1750 5450
Wire Wire Line
	1750 5750 1650 5750
Wire Wire Line
	1650 5750 1650 5400
Wire Wire Line
	1250 5200 1050 5200
Wire Wire Line
	1050 5200 1050 5300
Wire Wire Line
	800  5450 750  5450
Wire Wire Line
	750  5450 750  5650
Wire Wire Line
	1300 5450 1350 5450
Wire Wire Line
	1350 5450 1350 5650
Wire Wire Line
	1250 5000 1100 5000
Wire Wire Line
	1100 5000 1100 4900
Wire Wire Line
	1850 6850 1850 7050
Wire Wire Line
	1950 6850 1950 6950
Wire Wire Line
	1950 6950 1850 6950
Connection ~ 1850 6950
Wire Wire Line
	2050 5100 2100 5100
Text Label 2100 5100 0    60   ~ 0
AD623AN_Out
Wire Wire Line
	1450 6550 1450 7050
Text Label 1450 7050 1    60   ~ 0
AD623AN_Out
Wire Wire Line
	1150 6350 1450 6350
Wire Wire Line
	1200 6300 1200 6400
Wire Wire Line
	1200 6700 1200 6900
Text Label 1200 6900 1    60   ~ 0
+5V
Connection ~ 1200 6350
Text Label 700  6350 0    60   ~ 0
GND
Wire Wire Line
	1200 6000 1200 5900
Wire Wire Line
	1200 5900 2450 5900
Wire Wire Line
	2450 5900 2450 6450
Wire Wire Line
	2450 6450 2800 6450
Wire Wire Line
	2550 6450 2550 6400
Connection ~ 2550 6450
Text Label 2550 6000 0    60   ~ 0
+5V
Wire Wire Line
	2550 6000 2550 6100
Wire Wire Line
	850  6350 700  6350
Wire Notes Line
	650  4550 650  7100
Wire Notes Line
	650  7100 2900 7100
Wire Notes Line
	2900 7100 2900 4550
Wire Notes Line
	2900 4550 650  4550
Text Notes 1250 7250 0    60   ~ 0
Hall Sensor Input Stage
Wire Wire Line
	3600 5600 3250 5600
Text Label 3250 5600 0    60   ~ 0
PD6
Text Label 2800 6450 2    60   ~ 0
PD6
$Comp
L SS495A P8
U 1 1 55413F69
P 850 5100
F 0 "P8" H 850 5300 50  0000 C CNN
F 1 "SS495A" V 1050 5100 50  0000 C CNN
F 2 "" H 850 5100 60  0000 C CNN
F 3 "" H 850 5100 60  0000 C CNN
	1    850  5100
	0    1    1    0   
$EndComp
Wire Wire Line
	1100 4900 950  4900
Wire Wire Line
	750  4900 750  4650
Wire Wire Line
	850  4900 850  4650
Text Label 850  4650 3    60   ~ 0
+5V
Text Label 750  4650 3    60   ~ 0
GND
Wire Wire Line
	3600 4600 3250 4600
Wire Wire Line
	3250 4600 3250 5200
Wire Wire Line
	3250 5200 3600 5200
$EndSCHEMATC
