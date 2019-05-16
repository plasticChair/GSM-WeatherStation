EESchema Schematic File Version 4
LIBS:weatherStation-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 2 2
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text Label 3300 1850 0    50   ~ 0
Batt+
Text Label 1400 2000 2    50   ~ 0
Batt_int
Wire Wire Line
	1850 2100 2500 2100
Wire Wire Line
	1850 2800 1850 2300
Wire Wire Line
	2500 2100 2500 1850
$Comp
L CustomComponents:BQ24210 U13
U 1 1 5C1F2052
P 7650 1150
F 0 "U13" H 7750 767 50  0000 C CNN
F 1 "BQ24210" H 7750 676 50  0000 C CNN
F 2 "Package_SON:WSON-10-1EP_2x3mm_P0.5mm_EP0.84x2.4mm" H 7650 1150 50  0001 C CNN
F 3 "" H 7650 1150 50  0001 C CNN
	1    7650 1150
	-1   0    0    -1  
$EndComp
Wire Wire Line
	2500 1850 4250 1850
$Comp
L Device:R_Small_US R9
U 1 1 5C1F2C20
P 6550 2150
F 0 "R9" V 6600 2250 50  0000 C CNN
F 1 "100k" V 6450 2150 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 6550 2150 50  0001 C CNN
F 3 "~" H 6550 2150 50  0001 C CNN
	1    6550 2150
	0    -1   -1   0   
$EndComp
$Comp
L Device:R_Small_US R10
U 1 1 5C1F2CF0
P 8150 2350
F 0 "R10" V 8200 2450 50  0000 C CNN
F 1 "RT" V 8050 2350 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 8150 2350 50  0001 C CNN
F 3 "~" H 8150 2350 50  0001 C CNN
	1    8150 2350
	0    -1   -1   0   
$EndComp
Text Label 8300 2450 0    50   ~ 0
NTC
Text Label 1400 2200 0    50   ~ 0
NTC
Wire Wire Line
	6000 2150 6000 1850
$Comp
L Device:R_Small_US R11
U 1 1 5C1F45AD
P 7550 2900
F 0 "R11" V 7600 3000 50  0000 C CNN
F 1 "750" V 7450 2900 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 7550 2900 50  0001 C CNN
F 3 "~" H 7550 2900 50  0001 C CNN
	1    7550 2900
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small_US R12
U 1 1 5C1F4626
P 7750 2900
F 0 "R12" V 7800 3000 50  0000 C CNN
F 1 "330" V 7650 2900 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 7750 2900 50  0001 C CNN
F 3 "~" H 7750 2900 50  0001 C CNN
	1    7750 2900
	1    0    0    -1  
$EndComp
Wire Wire Line
	7750 3000 7550 3000
Wire Wire Line
	7350 2800 7350 3000
Wire Wire Line
	7350 3000 7550 3000
Connection ~ 7550 3000
Text Label 5050 3000 0    50   ~ 0
Pack-
$Comp
L Connector_Generic:Conn_01x02 J5
U 1 1 5C1F5970
P 9700 1800
F 0 "J5" H 9780 1792 50  0000 L CNN
F 1 "Conn_01x02" H 9780 1701 50  0000 L CNN
F 2 "Connector_JST:JST_EH_B02B-EH-A_1x02_P2.50mm_Vertical" H 9700 1800 50  0001 C CNN
F 3 "~" H 9700 1800 50  0001 C CNN
	1    9700 1800
	1    0    0    -1  
$EndComp
Wire Wire Line
	9000 1900 9000 3000
Wire Wire Line
	9000 3000 8550 3000
Connection ~ 7750 3000
$Comp
L Device:C_Small C16
U 1 1 5C1F6717
P 8550 1900
F 0 "C16" H 8642 1946 50  0000 L CNN
F 1 "1uF" H 8642 1855 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 8550 1900 50  0001 C CNN
F 3 "~" H 8550 1900 50  0001 C CNN
	1    8550 1900
	1    0    0    -1  
$EndComp
Connection ~ 8550 1800
Wire Wire Line
	8550 2000 8550 3000
Connection ~ 8550 3000
Wire Wire Line
	8550 3000 7750 3000
Wire Wire Line
	8050 1800 8550 1800
$Comp
L Device:C_Small C9
U 1 1 5C1F9204
P 7250 3900
F 0 "C9" H 7158 3854 50  0000 R CNN
F 1 "0.1uF" H 7158 3945 50  0000 R CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 7250 3900 50  0001 C CNN
F 3 "~" H 7250 3900 50  0001 C CNN
	1    7250 3900
	-1   0    0    1   
$EndComp
Wire Wire Line
	7250 3800 7600 3800
Wire Wire Line
	7250 3700 7250 3800
Connection ~ 7250 3800
Wire Wire Line
	7250 4000 7600 4000
Connection ~ 7600 4000
Text GLabel 8300 3800 2    50   Input ~ 0
I2C_SDA
Text GLabel 8300 3900 2    50   Input ~ 0
I2C_SCL
Text GLabel 8300 3700 2    50   Input ~ 0
BATT_ALRT
Wire Notes Line
	5350 1400 5350 3100
Wire Notes Line
	5350 3100 2200 3100
Wire Notes Line
	2200 3100 2200 1400
Wire Notes Line
	2200 1400 5350 1400
Wire Notes Line
	5850 3150 8750 3150
Wire Notes Line
	8750 1400 5850 1400
Wire Notes Line
	8750 1400 8750 3150
Wire Notes Line
	5850 1400 5850 3150
Text Notes 3200 1500 0    50   ~ 0
Battery Protection
Text Notes 6100 1500 0    50   ~ 0
Solar Charger
Wire Notes Line
	7200 3350 8800 3350
Wire Notes Line
	8800 3350 8800 4150
Wire Notes Line
	8800 4150 7200 4150
Wire Notes Line
	7200 4150 7200 3350
Text Notes 8200 3450 0    50   ~ 0
Battery Monitor
$Comp
L Switch:SW_SPDT SW?
U 1 1 5C2339B4
P 1650 2000
AR Path="/5C2339B4" Ref="SW?"  Part="1" 
AR Path="/5C1E5C92/5C2339B4" Ref="SW2"  Part="1" 
F 0 "SW2" H 1650 2285 50  0000 C CNN
F 1 "SW_SPDT" H 1650 2194 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x03_P2.54mm_Vertical" H 1650 2000 50  0001 C CNN
F 3 "" H 1650 2000 50  0001 C CNN
	1    1650 2000
	1    0    0    -1  
$EndComp
NoConn ~ 1850 1900
Wire Wire Line
	1400 2100 1400 2000
Wire Wire Line
	1400 2000 1450 2000
$Comp
L Connector_Generic:Conn_01x03 J2
U 1 1 5C26230A
P 1200 2200
F 0 "J2" H 1350 1900 50  0000 C CNN
F 1 "Conn_01x03" H 1400 2000 50  0000 C CNN
F 2 "Connector_JST:JST_PH_B3B-PH-K_1x03_P2.00mm_Vertical" H 1200 2200 50  0001 C CNN
F 3 "~" H 1200 2200 50  0001 C CNN
	1    1200 2200
	-1   0    0    1   
$EndComp
Wire Wire Line
	1400 2300 1850 2300
Wire Wire Line
	8300 4000 8300 4100
Wire Wire Line
	8300 4100 7600 4100
Wire Wire Line
	7600 4100 7600 4000
Text Label 8300 1800 0    50   ~ 0
Solar+
$Comp
L CustomComponents:MAX17048 U11
U 1 1 5C3982DE
P 8250 3250
F 0 "U11" H 7950 3115 50  0000 C CNN
F 1 "MAX17048" H 7950 3024 50  0000 C CNN
F 2 "CustomFP:TQFN-8_2x2x0.75" H 8250 3250 50  0001 C CNN
F 3 "" H 8250 3250 50  0001 C CNN
	1    8250 3250
	1    0    0    -1  
$EndComp
Wire Wire Line
	7600 3900 7600 4000
Wire Wire Line
	9000 1900 9500 1900
Text Label 2000 2800 0    50   ~ 0
Batt-
Wire Wire Line
	7250 3700 7600 3700
Wire Wire Line
	5550 1850 5550 3700
Connection ~ 7250 3700
Connection ~ 7250 4000
Text Label 6850 3600 0    50   ~ 0
BattMon+
Text Label 6850 3900 0    50   ~ 0
BattMon-
Wire Wire Line
	6850 3900 6850 4000
Wire Wire Line
	6850 4000 7250 4000
Wire Wire Line
	6850 3600 6850 3700
Wire Wire Line
	6850 3700 7250 3700
Wire Wire Line
	6700 3700 6850 3700
Connection ~ 6850 3700
Connection ~ 6850 4000
Wire Wire Line
	5550 3700 6500 3700
Wire Wire Line
	5000 4000 6500 4000
Wire Wire Line
	8550 1800 9500 1800
Text Label 1550 3650 0    50   ~ 0
Batt+
Text Label 1550 3750 0    50   ~ 0
Pack-
$Comp
L Connector:Conn_01x02_Female J3
U 1 1 5C687E5F
P 1350 3750
F 0 "J3" H 1244 3425 50  0000 C CNN
F 1 "Conn_01x02_Female" H 1244 3516 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 1350 3750 50  0001 C CNN
F 3 "~" H 1350 3750 50  0001 C CNN
	1    1350 3750
	-1   0    0    1   
$EndComp
Wire Wire Line
	8050 2450 8250 2450
Wire Wire Line
	8250 2350 8250 2450
Connection ~ 8250 2450
Wire Wire Line
	8250 2450 8300 2450
$Comp
L Device:Net-Tie_2 NT1
U 1 1 5C7CAC81
P 6600 3700
F 0 "NT1" H 6600 3878 50  0000 C CNN
F 1 "Net-Tie_2" H 6600 3787 50  0000 C CNN
F 2 "NetTie:NetTie-2_SMD_Pad0.5mm" H 6600 3700 50  0001 C CNN
F 3 "~" H 6600 3700 50  0001 C CNN
	1    6600 3700
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C2
U 1 1 5CC95C3C
P 4250 2350
F 0 "C2" H 4342 2396 50  0000 L CNN
F 1 "1uF" H 4342 2305 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 4250 2350 50  0001 C CNN
F 3 "~" H 4250 2350 50  0001 C CNN
	1    4250 2350
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small_US R1
U 1 1 5CCE065A
P 7000 2300
F 0 "R1" V 7050 2400 50  0000 C CNN
F 1 "10k" V 6900 2300 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 7000 2300 50  0001 C CNN
F 3 "~" H 7000 2300 50  0001 C CNN
	1    7000 2300
	1    0    0    -1  
$EndComp
Text GLabel 6550 2450 0    50   Input ~ 0
CHRG_EN
Wire Wire Line
	7000 2450 6750 2450
Wire Wire Line
	7000 2200 7000 2150
Connection ~ 7000 2150
Wire Wire Line
	7000 2150 7050 2150
Wire Wire Line
	7000 2400 7000 2450
Wire Wire Line
	7000 2450 7050 2450
Connection ~ 7000 2450
$Comp
L Device:Net-Tie_2 NT2
U 1 1 5CD3AAA8
P 5800 1850
F 0 "NT2" H 5800 2028 50  0000 C CNN
F 1 "Net-Tie_2" H 5800 1937 50  0000 C CNN
F 2 "NetTie:NetTie-2_SMD_Pad0.5mm" H 5800 1850 50  0001 C CNN
F 3 "~" H 5800 1850 50  0001 C CNN
	1    5800 1850
	1    0    0    -1  
$EndComp
Wire Wire Line
	5900 1850 6000 1850
Connection ~ 6000 1850
Wire Wire Line
	5700 1850 5550 1850
Connection ~ 5550 1850
Text Label 6500 1850 0    50   ~ 0
Batt_Chrg+
Wire Wire Line
	4250 2250 4250 1850
Connection ~ 4250 1850
Wire Wire Line
	4250 1850 5550 1850
Wire Wire Line
	4250 2450 4250 2800
Wire Wire Line
	1850 2800 4250 2800
Connection ~ 4250 2800
Wire Wire Line
	4250 2800 5000 2800
Wire Wire Line
	5000 2800 5000 3000
$Comp
L Device:Net-Tie_2 NT3
U 1 1 5CD40254
P 5750 3000
F 0 "NT3" H 5750 3178 50  0000 C CNN
F 1 "Net-Tie_2" H 5750 3087 50  0000 C CNN
F 2 "NetTie:NetTie-2_SMD_Pad0.5mm" H 5750 3000 50  0001 C CNN
F 3 "~" H 5750 3000 50  0001 C CNN
	1    5750 3000
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 3000 5000 3000
Connection ~ 5000 3000
Wire Wire Line
	5000 3000 5000 4000
Wire Wire Line
	5850 3000 7350 3000
Connection ~ 7350 3000
Wire Wire Line
	6150 2000 6200 2000
Wire Wire Line
	6150 1850 7050 1850
Wire Wire Line
	6000 1850 6150 1850
Connection ~ 6150 1850
Wire Wire Line
	6150 2000 6150 1850
$Comp
L Device:Jumper_NO_Small JP4
U 1 1 5C77B575
P 6300 2000
F 0 "JP4" H 6300 2185 50  0000 C CNN
F 1 "J_NO" H 6250 1950 50  0000 C CNN
F 2 "Jumpers:SMT-JUMPER_2_NO_NO-SILK" H 6300 2000 50  0001 C CNN
F 3 "~" H 6300 2000 50  0001 C CNN
	1    6300 2000
	1    0    0    -1  
$EndComp
Wire Wire Line
	6400 2000 7050 2000
Wire Wire Line
	6650 2150 7000 2150
Wire Wire Line
	6000 2150 6450 2150
$Comp
L Device:Net-Tie_2 NT4
U 1 1 5CD4943D
P 6600 4000
F 0 "NT4" H 6600 4178 50  0000 C CNN
F 1 "Net-Tie_2" H 6600 4087 50  0000 C CNN
F 2 "NetTie:NetTie-2_SMD_Pad0.5mm" H 6600 4000 50  0001 C CNN
F 3 "~" H 6600 4000 50  0001 C CNN
	1    6600 4000
	1    0    0    -1  
$EndComp
Wire Wire Line
	6700 4000 6850 4000
$Comp
L power:GND #PWR0107
U 1 1 5CD4A675
P 4250 2800
F 0 "#PWR0107" H 4250 2550 50  0001 C CNN
F 1 "GND" H 4255 2627 50  0000 C CNN
F 2 "" H 4250 2800 50  0001 C CNN
F 3 "" H 4250 2800 50  0001 C CNN
	1    4250 2800
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0108
U 1 1 5CD4A817
P 6850 4000
F 0 "#PWR0108" H 6850 3750 50  0001 C CNN
F 1 "GND" H 6855 3827 50  0000 C CNN
F 2 "" H 6850 4000 50  0001 C CNN
F 3 "" H 6850 4000 50  0001 C CNN
	1    6850 4000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0109
U 1 1 5CD4AB4A
P 7350 3000
F 0 "#PWR0109" H 7350 2750 50  0001 C CNN
F 1 "GND" H 7355 2827 50  0000 C CNN
F 2 "" H 7350 3000 50  0001 C CNN
F 3 "" H 7350 3000 50  0001 C CNN
	1    7350 3000
	1    0    0    -1  
$EndComp
$Comp
L Device:Jumper_NO_Small JP5
U 1 1 5CD4A8BB
P 6650 2450
F 0 "JP5" H 6650 2635 50  0000 C CNN
F 1 "J_NO" H 6600 2400 50  0000 C CNN
F 2 "Jumpers:SMT-JUMPER_2_NO_NO-SILK" H 6650 2450 50  0001 C CNN
F 3 "~" H 6650 2450 50  0001 C CNN
	1    6650 2450
	1    0    0    -1  
$EndComp
$EndSCHEMATC
