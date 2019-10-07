/*
* SAMD21_shieldtest.cpp
*
* Created: 3/20/2019 1:38:12 AM
*  Author: mosta
*/
// Visual Micro is in vMicro>General>Tutorial Mode
//
/*
Name:       SAMD21_shieldtest.ino
Created:	3/15/2019 10:55:07 AM
Author:     DESKTOP-4LJLPCB\mosta
*/

// Define User Types below here or use a .h file
//


#include "MKR1400_Wx.h"

#define debug_GSM_EN 1
#define debug_Sleep_EN 1

GSMBand band;
GSMClient client;
GPRS gprs;
GSM gsmAccess(0);

// temp vars
int specialRTC_flag = 0;
int tempCount = 0;
bool updateFlag = 0;
int timeoutMs = 0;
bool maxDataSend = 0;
int LPMCounter = 0;

bool gsmTxStatus = false;
int gsmTxCount = 0;

// Define Function Prototypes that use User Types below here or use a .h file
#define IS_MTB_ENABLED \
REG_MTB_MASTER & MTB_MASTER_EN
#define DISABLE_MTB \
REG_MTB_MASTER = REG_MTB_MASTER & ~MTB_MASTER_EN
#define ENABLE_MTB \
REG_MTB_MASTER = REG_MTB_MASTER | MTB_MASTER_EN

__attribute__((aligned(1024)))
volatile char __tracebuffer__[1024];
volatile int __tracebuffersize__ = sizeof(__tracebuffer__);
void InitTraceBuffer()
{
	int index = 0;
	uint32_t mtbEnabled = IS_MTB_ENABLED;
	DISABLE_MTB;
	for(index =0; index<1024; index++)
	{
		__tracebuffer__[index];
		__tracebuffersize__;
	}
	if(mtbEnabled)
	ENABLE_MTB;
}
	


void setup()
{
	
	bool status = false;
	/* ----- Init vals ----- */
	init_vars();


	/* ----- GPIOs ----- */
	GPIOSetup();
	GPIODefaults();

	
	GPIO_dance();
	Serial1.println(F("\r\n*************** Power ON *********************"));
	
	/* ----- Extneral WD ----- */
	resetWatchDog();

	/* ----- Anemometer ----- */
	Anemometer_Enable();

	/* ----- Power Mode ----- */
	powerSave();

	/* ----- Timer ----- */
	timerSetup();

	/* ----- GSM ----- */
	GSM_Disable();
	delay(100);
	
	/* ----- RTC ----- */	
	rtcSetup();
	rtcEnable();
	
	/* ----- Peripherals ----- */
	setup_BME280();
	setup_fram();
	setup_battMang();
	
	//--------- Check battery voltage and sleep if low
	LPModeCheckStartup();
		
	Serial1.println("Setup RTC");
//	framWrite16(FRAM_NUM_P0INTS_Addr, 0);
	#if debug_GSM_EN
	//	MODEM.debug();
		// Rest if too many connection failures
		if ( fram.read8(FRAM_ERR_CNT_Addr) > 3 ){
			Serial1.print(" Error Count : ");
			Serial1.println(fram.read8(FRAM_ERR_CNT_Addr));
			fram.write8(FRAM_ERR_CNT_Addr, 0);
			enterSleep();			
		}
		// delete memory if too many bad status failures
		if (fram.read8(FRAM_DATA_ERR_CNT_Addr) > 5){
			fram.write8(FRAM_DATA_ERR_CNT_Addr,0);
			fram.write8(FRAM_MEM_POINTER_Addr,0);
			fram.write8(FRAM_NUM_P0INTS_Addr,0);
		}

		GSM_Enable();
		delay(9000);
		if(sendToServer(true)){
			Serial1.println("***Sent***");
		}		
		else{
			Serial1.println(F("*****************RESET**************"));
			Watchdog.enable(1000);
			delay(2000);
		}
	#else
	framWrite16(FRAM_NUM_P0INTS_Addr, 0);

	#endif
//	delay(100000);
	/* ----- RTC ----- */
	delay(10);
	rtcSetAlarm(0, MstrCntrl.measInterval);
	rtcUpdateTime();

	/* ----- User ----- */
	Serial1.println("Entering Loop...");
	delay(10);
	digitalWrite(GPLED1, LED_OFF);

	printCurTime();
	resetWatchDog();
	
	/* ----- ISR ----- */
	rtc.attachInterrupt(rtcISR);
	attachInterrupt(digitalPinToInterrupt(ANE_PULSE), pulseISR, FALLING);
	EIC_Setup();
	measTime_SeverTx = (rtcTime.currTime.min + MstrCntrl.serverInterval) % 60;

	Serial1.println(F("Starting ********************************************"));

//	InitTraceBuffer();
	MstrCntrl.sleepSingle = true;
	delay(10);
}

void pulseISR()
{
	detachInterrupt(digitalPinToInterrupt(ANE_PULSE));

	EIC->EVCTRL.bit.EXTINTEO2 = 0;
	pulseData.countVal = TC4->COUNT32.COUNT.bit.COUNT;
	if ((TC4->COUNT32.COUNT.bit.COUNT >700) && (pulseData.RTCFlag == false)) {  // min time between pulses,  )
		// Reset counter
		tcReset();

		// Set flags
		PulseISR_flag = true;
		PulseLed_state = !PulseLed_state;

		// Median filter
		medGustData();

		// Store in circular buffer
		pulseData.buffer[pulseData.buffIdx] = pulseData.countVal;
		pulseData.buffIdx++;
		if (pulseData.buffIdx >= PULSEDT_BUFFLENGTH) {
			pulseData.buffIdx = 0;
			findRunningPeaks();
		}
	}
	else {
		// Handle RTC
		pulseData.RTCFlag = false;
		tcReset();
	}
	EIC->EVCTRL.bit.EXTINTEO2 = 1;
	attachInterrupt(digitalPinToInterrupt(ANE_PULSE), pulseISR, FALLING);
	
}



// Add the main program code into the continuous loop() function
void loop()
{

	/*---------------------------------------*/
	//  Pulse ISR Flag
	/*---------------------------------------*/
	if (PulseISR_flag) {
	//	Serial1.print("Pulse is: ");
		//Serial1.println(pulseData.countVal);
		//	Serial1.println(1.0F/(pulseData.countVal/32768.0F) * 60.0F/54.0F);
		PulseISR_flag = false;
		//	delay(10);
		//	digitalWrite(GPLED1,PulseLed_state);
	}


	/*---------------------------------------*/
	//  Capture Data
	/*---------------------------------------*/
	if (rtcISR_flag && !MstrCntrl.sleepModeEn) {
		updateFlag = 1;
		detachInterrupt(digitalPinToInterrupt(ANE_PULSE));
		tcReset();
		rtcISR_flag = 0;
		MstrCntrl.RTCUpdateFlag = 1;
		
		/*-----Notify and reset RTC------*/
		Serial1.println(F("Measure sensors ---------------"));
		
		// Setup RTC
		rtcSetAlarm(0, MstrCntrl.measInterval);
		rtcUpdateTime();
		framTimeSave();
		// Get data
		collectData();
		saveData();
		framSaveData();
		LPModeCheck();
		
		Serial1.print(" Gust  ");
		Serial1.println(sampledData.gustMax);
		
		
	//	printSampeledData();

		// Prepare for sending GSM data
		if ((measTime_SeverTx - rtcTime.currTime.min) <= 1) {
			sendData_flag = true;
			#if debug_GSM_EN
				Serial1.println("Turning on GSM");
				GSM_Enable();
			#endif
		}
	
		if(framRead16(FRAM_NUM_P0INTS_Addr) > 250){
			maxDataSend = 1;
			sendData_flag = true;
		}
	
		if ((rtcTime.currTime.hour > MstrCntrl.sCmd_t_hours+1)  && (rtcTime.currTime.min > MstrCntrl.sCmd_t_mins)){
			MstrCntrl.serverInterval = ServerTx_INTERVAL;
		}


		//Check night time, if between hours of sleep and be sure this only happens once
		if (((rtcTime.currTime.hour >= MstrCntrl.sleepHour) || (rtcTime.currTime.hour < MstrCntrl.wakeupHour)) && MstrCntrl.sleepSingle  && debug_Sleep_EN){
			Serial1.println(F("----------------- Sleep En --------------------------"));
			printCurTime();
			MstrCntrl.sleepModeEn = true;
			MstrCntrl.sleepModeSet = true;
			measTime_SeverTx = rtcTime.currTime.min;
			if ( framRead16(FRAM_NUM_P0INTS_Addr) > 5)	sendData_flag = true;
		}

		resetWatchDog();
		resetMaxGust();
	//	printCurTime();
		Serial1.println("End RTc Sample");
		delay(10);
		attachInterrupt(digitalPinToInterrupt(ANE_PULSE), pulseISR, FALLING);
	}



	/*---------------------------------------*/
	//  Server Send
	/*---------------------------------------*/
	if (((rtcTime.currTime.min >= measTime_SeverTx)|| (maxDataSend)) && sendData_flag) {
		
		updateFlag = 1;
		Serial1.println(F("Send data to Server**************************************"));
		rtcDisable();
		sendData_flag = 0;
		
		// Get data
		rtcUpdateTime();
		framTimeSave();
		
		//Send Data
		#if debug_GSM_EN
			sendToServer(false);
		#endif
	
		resetWatchDog();
		rtcEnable();
		rtcSetAlarm(0, MstrCntrl.measInterval);
		
		delay(10);
	}


	/*---------------------------------------*/
	//  Set night time sleep mode
	/*---------------------------------------*/
	if (MstrCntrl.sleepModeEn &&  MstrCntrl.sleepModeSet && debug_Sleep_EN) {
		updateFlag = 1;
		Serial1.println("set night time sleep mode*******************************************");
		rtcUpdateTime();
		printCurTime();
		
		rtcSetAlarm(((24-rtcTime.currTime.hour)+ WAKE_HOUR)*60 - rtcTime.currTime.min, 0); // 8 hours later, change to certain time

		//Dettach interrupt
 		tcReset();
		rtcISR_flag = 0;
		attachInterrupt(digitalPinToInterrupt(WAKE), watchdogISR, RISING);
		detachInterrupt(digitalPinToInterrupt(ANE_PULSE));
		Anemometer_Disable();
		GSM_Disable();
		resetWatchDog();
		//Add sleep to BME280 and batt management

		rtcUpdateTime();
		
		//Only set sleep mode once
		 MstrCntrl.sleepModeSet = false;
	}


	/*---------------------------------------*/
	//  Handle night time sleep mode wake up
	/*---------------------------------------*/
	if ((rtcTime.currTime.hour >= MstrCntrl.wakeupHour) && (rtcTime.currTime.hour < MstrCntrl.sleepHour) && (MstrCntrl.sleepModeEn)) {
		updateFlag = 1;
		MstrCntrl.sleepModeEn = false;
		MstrCntrl.sleepSingle = false;
		Serial1.println(F("----------------- Wake up from Sleep ----------------"));
		printCurTime();
		Serial1.println(F("**********RESET**********"));
		Watchdog.enable(1000);
		delay(2000);
	}

	/*---------------------------------------*/
	//  Handle Low Power Situation
	/*---------------------------------------*/
	if ((MstrCntrl.LP_Mode == 1)  && (MstrCntrl.RTCUpdateFlag == 1))
	{
		updateFlag = 1;
		Serial1.println("Check for LPM");
		MstrCntrl.RTCUpdateFlag = 0;
		//Remove low power mode if > 3.6V
		if (sampledData.batteryP >= LOWPOWER_ULIMIT_PCNT)
		{
			Serial1.println(F("-----------set LP state OFF"));
			MstrData.weather.LowPwrMode = 0;
			MstrCntrl.LP_Mode = 0;
			LPMCounter = 0;
			MstrCntrl.serverInterval = ServerTx_INTERVAL;
			MstrCntrl.measInterval = MEAS_INTERVAL;
		}
		//low power mode if < 3.35V, increase interval every time
		if ((sampledData.batteryP <= LOWPOWER_LIMIT_PCNT) && ((LPMCounter) >= (LOWPOWER_ULIMIT_PCNT+5)))
		{
			LPMCounter = 0;
			Serial1.print(F("------------- set LP state again - "));
			Serial1.println(sampledData.batteryV);
			Serial1.println(MstrCntrl.measInterval);
			MstrData.weather.LowPwrMode = 1;
			MstrCntrl.measInterval += MEAS_INTERVAL;
			MstrCntrl.serverInterval += 5;
		}
	}
	
	
	if (MstrCntrl.WDFlag){
	
		digitalWrite(DONE, HIGH);
		delay(2);
		digitalWrite(DONE, LOW);
		Serial1.println(F("Watch Dog ISR backgound**************************"));
		printCurTime();
		MstrCntrl.WDFlag = false;
		delay(10);
		updateFlag = true;
		MstrCntrl.sleepModeCount++;
		if (MstrCntrl.sleepModeCount == 4)  Anemometer_Enable();
	}
	
	if (MstrCntrl.sleepModeEn && (MstrCntrl.sleepModeCount >=5) && debug_Sleep_EN) {
		MstrCntrl.sleepModeCount = 0;
		collectData();
		saveData();
		framSaveData();
		Anemometer_Disable();
	}
	

	if(updateFlag){
		updateFlag = 0;
		Serial1.println("Curr time");
		printCurTime();
		Serial1.println("Going to sleep");
		Serial1.println("Alarm set for: ");
		Serial1.print(rtc.getAlarmHours());
		Serial1.print("hour : ");
		
		Serial1.print(rtc.getAlarmMinutes());
		Serial1.print("min : ");
		Serial1.print(rtc.getAlarmSeconds());
		Serial1.print("sec : ");
		Serial1.print(rtc.getAlarmDay());
		Serial1.print("day : ");
		Serial1.print(rtc.getAlarmMonth());
		Serial1.print("month : ");
		Serial1.print(rtc.getAlarmYear());
		Serial1.println("year");
		
		Serial1.print("Server send time = ");
		Serial1.println(measTime_SeverTx);
		delay(30);

	}
	
	//Serial1.println("SLEEEEEEP");
//	delay(10);
	enterSleep();
//	Serial1.println("AWOKEEEEEEEEE");
	

}

void rtcISR()
{
	rtcISR_flag = 1;
	rtcUpdateTime();

specialRTC_flag = 1;
//delay(3);
}


void TC4_Handler(void) {
	TC4->COUNT32.INTFLAG.bit.MC0 = 1; //part of the timer code
}

void lowPowerISR()
{
	MstrCntrl.LP_Mode = 1;
	MstrCntrl.serverInterval += 15;
}

void watchdogISR()
{
	rtcUpdateTime();
	MstrCntrl.WDFlag = true;
}


void TC3_Handler(void) {
	TC3Disable();
	TC3Reset();
	digitalWrite(DONE, LOW);
	TC3->COUNT32.INTFLAG.bit.MC0 = 1; //part of the timer code
}