EESchema Schematic File Version 4
LIBS:weatherStation-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 2
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
L power:GND #PWR03
U 1 1 5C18B5E4
P 3600 1900
F 0 "#PWR03" H 3600 1650 50  0001 C CNN
F 1 "GND" H 3750 1800 50  0000 C CNN
F 2 "" H 3600 1900 50  0001 C CNN
F 3 "" H 3600 1900 50  0001 C CNN
	1    3600 1900
	1    0    0    -1  
$EndComp
Text Label 3500 2000 2    50   ~ 0
RESET
$Comp
L power:+3V3 #PWR08
U 1 1 5C1A7663
P 8450 3950
F 0 "#PWR08" H 8450 3800 50  0001 C CNN
F 1 "+3V3" V 8465 4078 50  0000 L CNN
F 2 "" H 8450 3950 50  0001 C CNN
F 3 "" H 8450 3950 50  0001 C CNN
	1    8450 3950
	1    0    0    -1  
$EndComp
Text Label 7050 4000 0    50   ~ 0
ANE_Pulse
Text Label 7200 4150 0    50   ~ 0
ANE_Tx
$Comp
L Device:C C1
U 1 1 5C1AEA54
P 10350 3700
F 0 "C1" H 10600 3600 50  0000 C CNN
F 1 "100nF" H 10600 3700 50  0000 C CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 10388 3550 50  0001 C CNN
F 3 "~" H 10350 3700 50  0001 C CNN
	1    10350 3700
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR06
U 1 1 5C1AECC4
P 10350 3850
F 0 "#PWR06" H 10350 3600 50  0001 C CNN
F 1 "GND" H 10550 3800 50  0000 R CNN
F 2 "" H 10350 3850 50  0001 C CNN
F 3 "" H 10350 3850 50  0001 C CNN
	1    10350 3850
	1    0    0    -1  
$EndComp
Text Label 3600 2300 2    50   ~ 0
I2C_SCL
Text Label 3600 2400 2    50   ~ 0
I2C_SDA
Text Label 8650 3850 0    50   ~ 0
ANE_Vcc
$Comp
L EbayParts:BME280 U3
U 1 1 5C1BD82E
P 7500 2600
F 0 "U3" H 7281 2818 60  0000 R CNN
F 1 "BME280" H 7281 2712 60  0000 R CNN
F 2 "Connector_JST:JST_EH_B04B-EH-A_1x04_P2.50mm_Vertical" H 7500 2600 60  0001 C CNN
F 3 "" H 7500 2600 60  0001 C CNN
	1    7500 2600
	-1   0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR010
U 1 1 5C1BF054
P 7300 2300
F 0 "#PWR010" H 7300 2150 50  0001 C CNN
F 1 "+3V3" H 7315 2473 50  0000 C CNN
F 2 "" H 7300 2300 50  0001 C CNN
F 3 "" H 7300 2300 50  0001 C CNN
	1    7300 2300
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR011
U 1 1 5C1BF09F
P 7300 2400
F 0 "#PWR011" H 7300 2150 50  0001 C CNN
F 1 "GND" H 7305 2272 50  0000 R CNN
F 2 "" H 7300 2400 50  0001 C CNN
F 3 "" H 7300 2400 50  0001 C CNN
	1    7300 2400
	0    1    1    0   
$EndComp
Text Label 7300 2600 2    50   ~ 0
I2C_SDA
Text Label 7300 2500 2    50   ~ 0
I2C_SCL
$Comp
L EbayParts:FDW254p U4
U 1 1 5C1D8FDD
P 8850 4200
F 0 "U4" H 9150 4150 60  0000 C CNN
F 1 "FDW254p" H 9150 4500 60  0000 C CNN
F 2 "Package_SO:TSSOP-8_4.4x3mm_P0.65mm" H 9100 4850 60  0001 C CNN
F 3 "" H 9100 4850 60  0001 C CNN
	1    8850 4200
	1    0    0    -1  
$EndComp
Text Label 8250 4150 2    50   ~ 0
ANE_Vcc_EN
Wire Wire Line
	8650 4100 8650 4050
NoConn ~ 9600 4150
NoConn ~ 9600 4100
NoConn ~ 9600 4050
NoConn ~ 9600 4000
$Sheet
S 7450 850  800  450 
U 5C1E5C92
F0 "Sheet5C1E5C91" 50
F1 "BMS.sch" 50
$EndSheet
$Comp
L CustomComponents:MB85RC64 U6
U 1 1 5C245ABE
P 5850 700
F 0 "U6" H 5600 450 50  0000 C CNN
F 1 "MB85RC64" H 6100 450 50  0000 C CNN
F 2 "Package_SO:SSOP-8_3.9x5.05mm_P1.27mm" H 5850 700 50  0001 C CNN
F 3 "" H 5850 700 50  0001 C CNN
	1    5850 700 
	1    0    0    -1  
$EndComp
Wire Wire Line
	5450 1100 5450 1200
Wire Wire Line
	5450 1300 5450 1200
Connection ~ 5450 1200
$Comp
L power:GND #PWR032
U 1 1 5C247225
P 5850 1500
F 0 "#PWR032" H 5850 1250 50  0001 C CNN
F 1 "GND" H 6050 1450 50  0000 C CNN
F 2 "" H 5850 1500 50  0001 C CNN
F 3 "" H 5850 1500 50  0001 C CNN
	1    5850 1500
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR031
U 1 1 5C247311
P 5850 900
F 0 "#PWR031" H 5850 750 50  0001 C CNN
F 1 "+3V3" H 5700 1000 50  0000 C CNN
F 2 "" H 5850 900 50  0001 C CNN
F 3 "" H 5850 900 50  0001 C CNN
	1    5850 900 
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR033
U 1 1 5C24863F
P 6250 1100
F 0 "#PWR033" H 6250 850 50  0001 C CNN
F 1 "GND" V 6255 972 50  0000 R CNN
F 2 "" H 6250 1100 50  0001 C CNN
F 3 "" H 6250 1100 50  0001 C CNN
	1    6250 1100
	0    -1   -1   0   
$EndComp
Text Label 6250 1300 0    50   ~ 0
I2C_SDA
Text Label 6250 1200 0    50   ~ 0
I2C_SCL
Text Notes 5550 700  0    50   ~ 0
External Memory
Text GLabel 2500 2900 0    50   Input ~ 0
BATT_ALRT
Text Label 9300 2550 0    50   ~ 0
I2C_SCL
Text Label 9300 2700 0    50   ~ 0
I2C_SDA
$Comp
L Device:R_Small_US R14
U 1 1 5C1CFF28
P 10200 2100
F 0 "R14" H 10268 2146 50  0000 L CNN
F 1 "5k" H 10268 2055 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 10200 2100 50  0001 C CNN
F 3 "~" H 10200 2100 50  0001 C CNN
	1    10200 2100
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small_US R15
U 1 1 5C1D001D
P 10450 2100
F 0 "R15" H 10518 2146 50  0000 L CNN
F 1 "5k" H 10518 2055 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 10450 2100 50  0001 C CNN
F 3 "~" H 10450 2100 50  0001 C CNN
	1    10450 2100
	1    0    0    -1  
$EndComp
Text GLabel 9400 1950 0    50   Input ~ 0
3V3
Wire Notes Line
	8950 600  8950 3050
Wire Notes Line
	5150 600  11000 600 
Wire Notes Line
	6600 600  6600 4250
Wire Wire Line
	5850 1500 5450 1500
Wire Wire Line
	5450 1500 5450 1300
Connection ~ 5850 1500
Connection ~ 5450 1300
$Comp
L power:+3V3 #PWR0104
U 1 1 5C35FC1F
P 10350 3550
F 0 "#PWR0104" H 10350 3400 50  0001 C CNN
F 1 "+3V3" H 10200 3700 50  0000 C CNN
F 2 "" H 10350 3550 50  0001 C CNN
F 3 "" H 10350 3550 50  0001 C CNN
	1    10350 3550
	1    0    0    -1  
$EndComp
Wire Notes Line
	5150 1700 11000 1700
Wire Notes Line
	11000 600  11000 4250
Text Notes 7650 1800 0    50   ~ 0
BME280
Text Notes 8900 3150 0    50   ~ 0
Anemometer/Wind Vane
$Comp
L power:+3V3 #PWR0101
U 1 1 5C3BAFAA
P 9700 1950
F 0 "#PWR0101" H 9700 1800 50  0001 C CNN
F 1 "+3V3" H 9715 2123 50  0000 C CNN
F 2 "" H 9700 1950 50  0001 C CNN
F 3 "" H 9700 1950 50  0001 C CNN
	1    9700 1950
	1    0    0    -1  
$EndComp
Connection ~ 9700 1950
Wire Wire Line
	10200 2550 10200 2200
Wire Wire Line
	9300 2550 10200 2550
Wire Wire Line
	10450 2700 10450 2200
Wire Wire Line
	9300 2700 10450 2700
Wire Wire Line
	10200 2000 10200 1950
Wire Wire Line
	10450 2000 10450 1950
Wire Wire Line
	10450 1950 10200 1950
Connection ~ 10200 1950
$Comp
L Device:R_Small_US R13
U 1 1 5C3FDC27
P 8450 4050
F 0 "R13" H 8550 4150 50  0000 L CNN
F 1 "10k" H 8550 4050 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 8450 4050 50  0001 C CNN
F 3 "~" H 8450 4050 50  0001 C CNN
	1    8450 4050
	-1   0    0    -1  
$EndComp
Wire Wire Line
	8250 4150 8450 4150
Wire Wire Line
	8450 4150 8650 4150
Connection ~ 8450 4150
Wire Wire Line
	8650 4050 8600 4050
Wire Wire Line
	8600 4050 8600 3950
Wire Wire Line
	8600 3950 8450 3950
Connection ~ 8650 4050
Connection ~ 8450 3950
$Comp
L power:+3V3 #PWR0103
U 1 1 5C40D3D9
P 5850 1950
F 0 "#PWR0103" H 5850 1800 50  0001 C CNN
F 1 "+3V3" H 5865 2123 50  0000 C CNN
F 2 "" H 5850 1950 50  0001 C CNN
F 3 "" H 5850 1950 50  0001 C CNN
	1    5850 1950
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small_US R18
U 1 1 5C40D432
P 5850 2350
F 0 "R18" H 5918 2396 50  0000 L CNN
F 1 "300" H 5918 2305 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 5850 2350 50  0001 C CNN
F 3 "~" H 5850 2350 50  0001 C CNN
	1    5850 2350
	1    0    0    1   
$EndComp
$Comp
L Device:LED D8
U 1 1 5C40D871
P 5850 2600
F 0 "D8" V 5850 2750 50  0000 C CNN
F 1 "3V3 OK" V 5750 2750 50  0000 C CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 5850 2600 50  0001 C CNN
F 3 "~" H 5850 2600 50  0001 C CNN
	1    5850 2600
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0105
U 1 1 5C40DC2F
P 5850 2750
F 0 "#PWR0105" H 5850 2500 50  0001 C CNN
F 1 "GND" H 5855 2622 50  0000 R CNN
F 2 "" H 5850 2750 50  0001 C CNN
F 3 "" H 5850 2750 50  0001 C CNN
	1    5850 2750
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR0106
U 1 1 5C40E9D7
P 5550 3300
F 0 "#PWR0106" H 5550 3150 50  0001 C CNN
F 1 "+3V3" H 5565 3473 50  0000 C CNN
F 2 "" H 5550 3300 50  0001 C CNN
F 3 "" H 5550 3300 50  0001 C CNN
	1    5550 3300
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small_US R19
U 1 1 5C40E9DD
P 5850 3600
F 0 "R19" H 5918 3646 50  0000 L CNN
F 1 "300" H 5918 3555 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 5850 3600 50  0001 C CNN
F 3 "~" H 5850 3600 50  0001 C CNN
	1    5850 3600
	-1   0    0    -1  
$EndComp
$Comp
L Device:LED D9
U 1 1 5C40E9E4
P 5850 3850
F 0 "D9" V 5850 4000 50  0000 C CNN
F 1 "GPLED" V 5750 4000 50  0000 C CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 5850 3850 50  0001 C CNN
F 3 "~" H 5850 3850 50  0001 C CNN
	1    5850 3850
	0    -1   -1   0   
$EndComp
$Comp
L Device:R_Small_US R20
U 1 1 5C411557
P 6000 3600
F 0 "R20" H 6068 3646 50  0000 L CNN
F 1 "300" H 6068 3555 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 6000 3600 50  0001 C CNN
F 3 "~" H 6000 3600 50  0001 C CNN
	1    6000 3600
	1    0    0    1   
$EndComp
$Comp
L Device:LED D10
U 1 1 5C41155E
P 6000 3850
F 0 "D10" V 6000 3650 50  0000 C CNN
F 1 "GPLED" V 5900 3600 50  0000 C CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 6000 3850 50  0001 C CNN
F 3 "~" H 6000 3850 50  0001 C CNN
	1    6000 3850
	0    -1   -1   0   
$EndComp
Text Label 2250 2300 0    50   ~ 0
GPLED1
Text Label 2250 2200 0    50   ~ 0
GPLED2
Text Label 5850 4150 2    50   ~ 0
GPLED1
Text Label 6000 4150 0    50   ~ 0
GPLED2
$Comp
L Switch:SW_Push SW3
U 1 1 5C42AE1B
P 5750 3350
F 0 "SW3" H 5900 3650 50  0000 C CNN
F 1 "LED_Push" H 6000 3500 50  0000 C CNN
F 2 "EbayParts:Tact_SMD_Switch" H 5750 3550 50  0001 C CNN
F 3 "" H 5750 3550 50  0001 C CNN
	1    5750 3350
	1    0    0    -1  
$EndComp
$Comp
L Device:Jumper_NC_Small JP3
U 1 1 5C4350C1
P 5650 3500
F 0 "JP3" H 5500 3600 50  0000 R CNN
F 1 "Jmp LED" H 5450 3500 50  0000 R CNN
F 2 "Jumpers:SMT-JUMPER_2_NO_NO-SILK" H 5650 3500 50  0001 C CNN
F 3 "~" H 5650 3500 50  0001 C CNN
	1    5650 3500
	1    0    0    -1  
$EndComp
$Comp
L Device:Jumper_NC_Small JP2
U 1 1 5C442F26
P 5850 2150
F 0 "JP2" V 5850 2350 50  0000 R CNN
F 1 "Jmp PwrLED" V 5950 2650 50  0000 R CNN
F 2 "Jumpers:SMT-JUMPER_2_NO_NO-SILK" H 5850 2150 50  0001 C CNN
F 3 "~" H 5850 2150 50  0001 C CNN
	1    5850 2150
	0    -1   -1   0   
$EndComp
Wire Wire Line
	5850 2050 5850 1950
Text Label 9300 2850 0    50   ~ 0
ANE_Tx
$Comp
L Device:R_Small_US R25
U 1 1 5C470D43
P 10700 2100
F 0 "R25" H 10768 2146 50  0000 L CNN
F 1 "10k" H 10768 2055 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 10700 2100 50  0001 C CNN
F 3 "~" H 10700 2100 50  0001 C CNN
	1    10700 2100
	1    0    0    -1  
$EndComp
Wire Wire Line
	9300 2850 10700 2850
Wire Wire Line
	10700 2850 10700 2200
Wire Wire Line
	10700 2000 10700 1950
Wire Wire Line
	10700 1950 10450 1950
Connection ~ 10450 1950
$Comp
L Device:C C18
U 1 1 5C481E4E
P 10600 3700
F 0 "C18" V 10450 3650 50  0000 C CNN
F 1 "100nF" H 10450 3750 50  0000 C CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 10638 3550 50  0001 C CNN
F 3 "~" H 10600 3700 50  0001 C CNN
	1    10600 3700
	-1   0    0    1   
$EndComp
Wire Wire Line
	10600 3850 10350 3850
Connection ~ 10350 3850
Text Label 10600 3550 0    50   ~ 0
ANE_Vcc
Text Label 2250 2500 0    50   ~ 0
ANE_Tx
$Comp
L CustomComponents:TPL5010 U7
U 1 1 5C51815F
P 9550 1150
F 0 "U7" H 9925 1325 50  0000 C CNN
F 1 "TPL5010" H 9925 1234 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-23-6" H 9700 1100 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/tpl5010.pdf" H 9800 1200 50  0001 C CNN
	1    9550 1150
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR0112
U 1 1 5C518273
P 9450 1000
F 0 "#PWR0112" H 9450 850 50  0001 C CNN
F 1 "+3V3" H 9300 1000 50  0000 C CNN
F 2 "" H 9450 1000 50  0001 C CNN
F 3 "" H 9450 1000 50  0001 C CNN
	1    9450 1000
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small_US R17
U 1 1 5C51F48B
P 9300 1400
F 0 "R17" H 9368 1446 50  0000 L CNN
F 1 "33k" H 9368 1355 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 9300 1400 50  0001 C CNN
F 3 "~" H 9300 1400 50  0001 C CNN
	1    9300 1400
	-1   0    0    1   
$EndComp
Wire Wire Line
	9450 1300 9300 1300
$Comp
L power:GND #PWR0113
U 1 1 5C52626A
P 9450 1500
F 0 "#PWR0113" H 9450 1250 50  0001 C CNN
F 1 "GND" H 9350 1400 50  0000 R CNN
F 2 "" H 9450 1500 50  0001 C CNN
F 3 "" H 9450 1500 50  0001 C CNN
	1    9450 1500
	1    0    0    -1  
$EndComp
Wire Wire Line
	9300 1500 9450 1500
Wire Wire Line
	9450 1400 9450 1500
Connection ~ 9450 1500
$Comp
L Device:Jumper_NO_Small JP1
U 1 1 5C5327D1
P 10500 1200
F 0 "JP1" V 10600 1350 50  0000 R CNN
F 1 "Jmp_NO" V 10500 1550 50  0000 R CNN
F 2 "Jumpers:SMT-JUMPER_2_NO_NO-SILK" H 10500 1200 50  0001 C CNN
F 3 "~" H 10500 1200 50  0001 C CNN
	1    10500 1200
	1    0    0    -1  
$EndComp
Text Label 10950 1200 2    50   ~ 0
RESET
Text Label 10700 1300 2    50   ~ 0
WAKE
Text Label 10700 1400 2    50   ~ 0
DONE
Wire Wire Line
	10400 1400 10700 1400
Wire Wire Line
	10400 1300 10700 1300
Text Label 2300 2700 0    50   ~ 0
DONE
Text Notes 9750 700  0    50   ~ 0
Watchpuppy
$Comp
L power:+3V3 #PWR02
U 1 1 5C18B547
P 3400 1800
F 0 "#PWR02" H 3400 1650 50  0001 C CNN
F 1 "+3V3" H 3415 1973 50  0000 C CNN
F 2 "" H 3400 1800 50  0001 C CNN
F 3 "" H 3400 1800 50  0001 C CNN
	1    3400 1800
	1    0    0    -1  
$EndComp
Wire Notes Line
	5150 3000 11000 3000
Text Label 2300 2800 0    50   ~ 0
WAKE
Wire Wire Line
	3400 1800 3250 1800
Wire Wire Line
	3250 1900 3600 1900
Wire Wire Line
	3250 2000 3500 2000
Wire Wire Line
	3250 2300 3600 2300
Wire Wire Line
	3250 2400 3600 2400
Wire Wire Line
	2550 2900 2500 2900
Wire Wire Line
	2300 2800 2550 2800
Wire Wire Line
	2300 2700 2550 2700
Text Label 2150 1800 0    50   ~ 0
ANE_Pulse
Wire Wire Line
	2550 2500 2250 2500
Text Label 2100 2400 0    50   ~ 0
ANE_Vcc_EN
Wire Wire Line
	2550 2400 2100 2400
Wire Wire Line
	2250 2200 2550 2200
Wire Wire Line
	2550 2300 2250 2300
Wire Wire Line
	9400 1950 9700 1950
Wire Wire Line
	9700 1950 10200 1950
Wire Wire Line
	10600 1200 10950 1200
Wire Wire Line
	9450 1200 9450 1000
Wire Wire Line
	5550 3300 5550 3350
Wire Wire Line
	5550 3350 5550 3500
Connection ~ 5550 3350
Wire Wire Line
	5750 3500 5850 3500
Wire Wire Line
	5950 3350 6000 3350
Wire Wire Line
	6000 3350 6000 3500
Wire Wire Line
	6000 4000 6000 4150
Wire Wire Line
	5850 4000 5850 4150
Wire Notes Line
	5150 4250 11000 4250
Wire Notes Line
	5150 600  5150 4250
$Comp
L power:GND #PWR09
U 1 1 5C1A729B
P 7450 3750
F 0 "#PWR09" H 7450 3500 50  0001 C CNN
F 1 "GND" H 7455 3622 50  0000 R CNN
F 2 "" H 7450 3750 50  0001 C CNN
F 3 "" H 7450 3750 50  0001 C CNN
	1    7450 3750
	1    0    0    -1  
$EndComp
Wire Wire Line
	7550 3750 7550 4000
Wire Wire Line
	7550 4000 7050 4000
Wire Wire Line
	7750 3750 7750 4150
Wire Wire Line
	7750 4150 7200 4150
Text Label 8350 2050 2    50   ~ 0
I2C_SCL
Text Label 8350 1950 2    50   ~ 0
I2C_SDA
Text GLabel 8350 2050 2    50   Input ~ 0
I2C_SCL
Text GLabel 8350 1950 2    50   Input ~ 0
I2C_SDA
NoConn ~ 2550 1600
NoConn ~ 2550 1700
NoConn ~ 2550 2000
NoConn ~ 2550 2100
NoConn ~ 3250 2900
NoConn ~ 3250 2800
NoConn ~ 3250 2700
NoConn ~ 3250 2600
NoConn ~ 3250 2500
NoConn ~ 3250 1700
NoConn ~ 3250 1600
Wire Wire Line
	2550 1800 2150 1800
$Comp
L Connector_Generic:Conn_01x02 J1
U 1 1 5CC053C4
P 7450 3550
F 0 "J1" V 7450 3750 50  0000 R CNN
F 1 "Conn_01x02" V 7600 3800 50  0000 R CNN
F 2 "Connector_JST:JST_EH_B02B-EH-A_1x02_P2.50mm_Vertical" H 7450 3550 50  0001 C CNN
F 3 "~" H 7450 3550 50  0001 C CNN
	1    7450 3550
	0    -1   -1   0   
$EndComp
$Comp
L Connector_Generic:Conn_01x02 J4
U 1 1 5CC05977
P 7750 3550
F 0 "J4" V 7716 3362 50  0000 R CNN
F 1 "Conn_01x02" V 7850 3450 50  0000 R CNN
F 2 "Connector_JST:JST_EH_B02B-EH-A_1x02_P2.50mm_Vertical" H 7750 3550 50  0001 C CNN
F 3 "~" H 7750 3550 50  0001 C CNN
	1    7750 3550
	0    -1   -1   0   
$EndComp
Wire Wire Line
	8650 3750 7850 3750
Wire Wire Line
	8650 3750 8650 4000
$Comp
L CustomComponents:MKRGSM1400 U1
U 1 1 5C641CB2
P 2900 1900
F 0 "U1" H 2900 2425 50  0000 C CNN
F 1 "MKRGSM1400" H 2900 2334 50  0000 C CNN
F 2 "CustomFP:MKRGSM1400" H 2900 1900 50  0001 C CNN
F 3 "" H 2900 1900 50  0001 C CNN
	1    2900 1900
	1    0    0    -1  
$EndComp
NoConn ~ 2550 2600
$Comp
L Connector:Conn_01x03_Female J6
U 1 1 5CC0BAEE
P 4350 2200
F 0 "J6" H 4377 2226 50  0000 L CNN
F 1 "Conn_01x03_Female" H 4377 2135 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x03_P2.54mm_Vertical" H 4350 2200 50  0001 C CNN
F 3 "~" H 4350 2200 50  0001 C CNN
	1    4350 2200
	1    0    0    -1  
$EndComp
Wire Wire Line
	3250 2100 4150 2100
Wire Wire Line
	4150 2200 3250 2200
$Comp
L power:GND #PWR0102
U 1 1 5CC0DEA5
P 4150 2300
F 0 "#PWR0102" H 4150 2050 50  0001 C CNN
F 1 "GND" H 4300 2200 50  0000 C CNN
F 2 "" H 4150 2300 50  0001 C CNN
F 3 "" H 4150 2300 50  0001 C CNN
	1    4150 2300
	1    0    0    -1  
$EndComp
Text GLabel 2550 1900 0    50   Input ~ 0
CHRG_EN
$EndSCHEMATC
