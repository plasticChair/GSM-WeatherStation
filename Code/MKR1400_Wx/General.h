// General.h

#ifndef _GENERAL_h
#define _GENERAL_h

#if defined(ARDUINO) && ARDUINO >= 100
	#include "arduino.h"
#else
	#include "WProgram.h"
#endif

#define MIN(a,b) (((a)<(b))?(a):(b))
#define MAX(a,b) (((a)>(b))?(a):(b))

#include "UserParams.h"
#include "GSMFun.h"
#include "pinMapGSM.h"
#include "time.h"

extern storeDataUnion  MstrData;
extern BME280 BME;
extern MAX17048 pwr_mgmt;
extern Adafruit_FRAM_I2C fram;
extern nativeData sampledData;
extern volatile CntrlStruct MstrCntrl;
extern wxSFStruct  wxSF;
extern volatile pulseStruct pulseData;
extern volatile RTCStruct rtcTime;
extern char preJSONArray[jsonBufferSize][(wxPackageSize*2+4)];
extern LaCrosse_TX23     anemometer;

extern int LPMCounter;


void printHex(int num, int precision) {
	char tmp[16];
	char format[128];

	sprintf(format, "%%.%dX", precision);

	sprintf(tmp, format, num);
	Serial1.print(tmp);
}

void Anemometer_Enable()
{
	digitalWrite(ANE_Vcc_EN, false);
}

void Anemometer_Disable()
{
	digitalWrite(ANE_Vcc_EN, true);
}

void GSM_Enable()
{
	digitalWrite(PIN_SERIAL2_DTR, HIGH);  // Previously commented out, TODO
	digitalWrite(GSM_RESETN, LOW);
}

void GSM_Disable()
{
	digitalWrite(GSM_RESETN, HIGH);
}

void GSM_PowerSave()
{
	//SerialGSM.println("AT+UPSV");
	delay(50);
	//SerialGSM.println("AT+CPWROFF");
}

bool tcIsSyncing()
{
	return TC4->COUNT32.STATUS.reg & TC_STATUS_SYNCBUSY;
}

//disable TC5
void tcDisable()
{
	TC4->COUNT32.CTRLA.reg &= ~TC_CTRLA_ENABLE;
	while (tcIsSyncing());
}

void tcReset()
{
	TC4->COUNT32.COUNT.bit.COUNT = (uint32_t)(0);
	while (tcIsSyncing());
}

//This function enables TC5 and waits for it to be ready
void tcStartCounter()
{
	TC4->COUNT32.CTRLA.reg |= TC_CTRLA_ENABLE; //set the CTRLA register
	while (tcIsSyncing()); //wait until snyc'd
}

void enterSleep()
{
	__DSB(); // Complete any pending buffer writes.
	SCB->SCR |= SCB_SCR_SLEEPDEEP_Msk;
	//SCB->SCR = SCB_SCR_SLEEPDEEP_Msk;
	//PM->SLEEP.bit.IDLE = 0x02;
	__WFI();
}

void BME_Force()
{
	uint8_t value = BME.readRegister(BME280_CTRL_MEAS_REG);
	value = (value & 0xFC) + 0x01;
	BME.writeRegister(BME280_CTRL_MEAS_REG, value);
	delay(10);
	sampledData.temp  = BME.readTempC();
	sampledData.press = BME.readFloatPressure()/100.0;
	sampledData.humid = BME.readFloatHumidity();

}

void getBatteryInfo()
{
	sampledData.batteryV = pwr_mgmt.voltage();
	delay(3);
	sampledData.batteryP = pwr_mgmt.accuratePercent();

	
}

unsigned long floatLimit(float *value, float scalefactor, int offset, float max_in, float min_in)
{

	float temp;
	temp = MIN(*value, max_in);
	temp = MAX(temp, min_in);
	temp = (temp - (float)offset) * scalefactor;

	return (unsigned long)temp;
}

void findRunningPeaks()
{
	if (sampledData.gustMax > sampledData.gustAvg) {
		sampledData.gustMax = sampledData.gustAvg;
	}
}

void medGustData()
{
	
	 volatile uint32_t temp;
	 int i, j;
	 int n = 32;  // N must be even
	 uint32_t x[PULSEDT_BUFFLENGTH];

	for(int ii=0; ii<PULSEDT_BUFFLENGTH; ii++) {
		x[ii] = pulseData.buffer[ii];
	}
	
	 //memcpy(x,pulseData.buffer, PULSEDT_BUFFLENGTH); 
	 // the following two loops sort the array x in ascending order
	 for(i=0; i<n-1; i++) {
		 for(j=i+1; j<n; j++) {
			 if(x[j] < x[i]) {
				 // swap elements
				 temp = x[i];
				 x[i] = x[j];
				 x[j] = temp;
			 }
		 }
	 }

	sampledData.gustAvg = ((x[n/2] + x[n/2 - 1]) / 2);
}

void saveData()
{
	/*---------------------------------------------------------------------------------------*/
	MstrData.weather.speed    = (unsigned int)floatLimit(&sampledData.speed     , wxSF.windSF    , 0            , 114 , 0);
	MstrData.weather.dir      = 0xff & sampledData.dir;

	MstrData.weather.gustMax  = (unsigned int)floatLimit(&sampledData.gustMax   , wxSF.gustSF    , 0            , 30000, 0);

	MstrData.weather.temp     = (unsigned int)floatLimit(&sampledData.temp      , wxSF.tempSF    , wxSF.tempOff , 65  , -30);
	MstrData.weather.press    = (unsigned int)floatLimit(&sampledData.press     , wxSF.pressSF   , wxSF.pressOff, 1100, 900); //hPa
	MstrData.weather.humid    = (unsigned int)floatLimit(&sampledData.humid     , wxSF.humidSF   , 0            , 100 , 0);

	MstrData.weather.batteryV = (unsigned int)floatLimit(&sampledData.batteryV  , wxSF.batteryVSF, wxSF.battOff , 4.2 , 3);
	MstrData.weather.batteryP = (unsigned int)floatLimit(&sampledData.batteryP  , wxSF.batteryPSF, 0            , 100 , 0);
	Serial1.println("done Save");
}

int framRead16(int addr)
{
	int tempVar = 0;
	tempVar = fram.read8(addr);
	tempVar |= fram.read8(addr+1) << 8;
	
	return tempVar;
}

int framWrite16(int addr, int val)
{

	fram.write8(addr, val & 0xFF);
	fram.write8(addr+1, (val & 0xFF) >> 8);

}

	
void framSaveData()
{
	MstrCntrl.FRAM_Idx = framRead16(FRAM_NUM_P0INTS_Addr);
	//	MstrCntrl.FRAM_Idx != (framRead16(FRAM_NUM_P0INTS_Addr+1) << 8);
	Serial1.println("Mem pointer: " + String(MstrCntrl.FRAM_Idx));

	for (int ii = wxPackageSize-1; ii >= 0; --ii) {
		fram.write8(MstrCntrl.FRAM_Idx*FRAM_DATA_OFFSET + FRAM_CNTRL_OFFSET +ii, (MstrData.TxData[ii] >> 4) | (MstrData.TxData[ii] << 4 ));
	}
	MstrCntrl.FRAM_Idx++;
	framWrite16(FRAM_NUM_P0INTS_Addr, MstrCntrl.FRAM_Idx);
	Serial1.println(F("done Frame Save"));
}

void framReadData()
{
	//Temp data
	char format[128];
	sprintf(format, "%%.%dX", 2);
	volatile int temp;
	char tempStrFull[wxPackageSize*2+4];
	char tempStr[2] = "\0";
	strcpy(tempStrFull, "\0");
	int startVal = 0;
	
	// Grab Index from memory
	MstrCntrl.FRAM_NumPoints = framRead16(FRAM_NUM_P0INTS_Addr);
	
	Serial1.println("Num points pointer: " + String(MstrCntrl.FRAM_NumPoints,HEX));

	if( MstrCntrl.FRAM_NumPoints > 150){
		startVal = MstrCntrl.FRAM_NumPoints - 60;
	}
	
	Serial1.print("Start Val: " );
	Serial1.println(startVal );

	for (int kk = startVal; kk < MstrCntrl.FRAM_NumPoints; kk++){
		for (int ii = 0; ii <= wxPackageSize-1; ii++) {
			
			temp = fram.read8(kk*FRAM_DATA_OFFSET + FRAM_CNTRL_OFFSET + ii);
			sprintf(tempStr, format, temp);
			strcat(tempStrFull, tempStr);
		}
		strcat(tempStrFull, "\0");
		strcpy(preJSONArray[kk], tempStrFull);

		tempStr[0] = 0;
		tempStrFull[0] = 0;

	}
	
	Serial1.println(tempStrFull);
	
	// Add to code later-----------
	//MstrCntrl.FRAM_NumPoints = 0;
	//
	//fram.write8(FRAM_NUM_P0INTS_Addr, MstrCntrl.FRAM_NumPoints & 0xFF);
	//fram.write8(FRAM_MEM_POINTER_Addr, MstrCntrl.FRAM_CurrIdx & 0xFF);
	//fram.write8(FRAM_NUM_P0INTS_Addr+1, MstrCntrl.FRAM_Idx >> 8);

}

void resetMaxGust()
{
	sampledData.gustMax = 30000;	
}

void collectData()
{
	int aneErr = 4;
	int failCount = 0;
	
	//Store Time
	MstrData.weather.year   = (byte)(rtcTime.currTime.year);
	MstrData.weather.month  = (byte)(rtcTime.currTime.month);
	MstrData.weather.day    = (uint8_t)(rtcTime.currTime.day);
	MstrData.weather.hour   = (uint8_t)(rtcTime.currTime.hour);
	MstrData.weather.minute = (uint8_t)(rtcTime.currTime.min);
	MstrData.weather.second = (uint8_t)(rtcTime.currTime.sec);
	
	/*-----Get temp data------*/
	Serial1.print(F("Got temps: "));
	BME_Force();
	Serial1.println(sampledData.temp);
	
	/*-----Check battery level------*/
	failCount = 0;
	sampledData.batteryV = 0.0F;
	while((sampledData.batteryV < 0.1) && (failCount < 20)){
		getBatteryInfo();
		failCount++;
		delay(10);
	}
	Serial1.print(F("Battery data ->"));
	Serial1.println(sampledData.batteryP);
	
	/* --- Get wind --- */
	aneErr = anemometer.read(sampledData.speed, sampledData.dir);
	if (aneErr != 4 || (sampledData.speed > 100)){
		Serial1.print("Wind Error: ");
		Serial1.println(aneErr);
		pulseData.RTCFlag = true;
		delay(2010);
		aneErr = anemometer.read(sampledData.speed, sampledData.dir);
		if (aneErr != 4)
		{
			//Anemometer_Disable();
		//	delay(200);
		//	Anemometer_Enable();
		    Serial1.println(F("wind failed"));
			Serial.println(aneErr);
			sampledData.speed = 0;  //Change Me
			sampledData.dir   = 0;
		}
	}
	
	Serial1.println(sampledData.speed);
	
	/* --- Store data --- */
	MstrData.weather.LowPwrMode = MstrCntrl.LP_Mode;
	MstrData.weather.accessCode = 7;
	
	MstrData.weather.signalRSSI = sampledData.rssi;
	MstrData.weather.info = MstrCntrl.FRAM_reset_count % 16;
	
	//Serial1.println("done Collect");
}

void resetWatchDog()
{
	Serial1.println(F("----RESET WD -----"));
	digitalWrite(DONE, HIGH);
	delay(20);
	digitalWrite(DONE, LOW);
	//Set time for ISR
}


void printCurTime()
{
	Serial1.print(rtcTime.currTime.hour);
	Serial1.print(F(" Hour : "));
	Serial1.print(rtcTime.currTime.min);
	Serial1.print(F(" Min : "));
	Serial1.print(rtcTime.currTime.sec);
	Serial1.print(F(" Sec : "));
	
	Serial1.print(rtcTime.currTime.day);
	Serial1.print(F(" Day : "));
	Serial1.print(rtcTime.currTime.month);
	Serial1.print(F(" Month : "));
	Serial1.print(rtcTime.currTime.year);
	Serial1.println(F(" Year : "));

}

void LPModeCheck()
{
	if (sampledData.batteryP < LOWPOWER_LLIMIT_PCNT){
			// Double Check
			if (sampledData.batteryV < LOWPOWER_LIMIT){
			MstrCntrl.LP_Mode = 1;
			LPMCounter++;
			Serial1.println(F("-------------LP mode engaged"));
			}
	}
}

void LPModeCheckStartup()
{
	int failCount = 0;
	sampledData.batteryV = 0.0F;
	while((sampledData.batteryV < 0.1) && (failCount < 20)){
		getBatteryInfo();
		failCount++;
		delay(10);
	}
	
	
	if (sampledData.batteryP < LOWPOWER_LLIMIT_PCNT){
		// Double Check
		if (sampledData.batteryV < LOWPOWER_LIMIT){
			MstrCntrl.LP_Mode = 1;
			Serial1.println(F("-------------LP mode engaged - Startup"));
			fram.write8(FRAM_LP_MODE_Addr, 1);
			Anemometer_Disable();
			GSM_Disable();
			delay(100);
			pwr_mgmt.reset();
			enterSleep();
		}
		}else{
		fram.write8(FRAM_LP_MODE_Addr, 0);
		
	}
}
void printSampeledData()
{
	
	Serial1.println(MstrData.weather.year);
	Serial1.println(MstrData.weather.month);
	Serial1.println(MstrData.weather.day);
	Serial1.println(MstrData.weather.hour);
	Serial1.println(MstrData.weather.minute);
	Serial1.println(MstrData.weather.second);

	Serial1.println(MstrData.weather.dir);
	Serial1.print(MstrData.weather.speed);
	Serial1.print(" - ");
	Serial1.println(sampledData.speed);
	Serial1.print(MstrData.weather.gustMax);
	Serial1.print(" - ");
	Serial1.println(sampledData.gustMax);
	Serial1.println(MstrData.weather.accessCode);

	Serial1.print(MstrData.weather.temp);
	Serial1.print(" - ");
	Serial1.println(sampledData.temp);
	Serial1.print(MstrData.weather.press);
	Serial1.print(" - ");
	Serial1.println(sampledData.press);
	Serial1.print(MstrData.weather.humid);
	Serial1.print(" - ");
    Serial1.println(sampledData.humid);
	
	Serial1.print(MstrData.weather.batteryV);
	Serial1.print(" - ");
	Serial1.println(sampledData.batteryV);
	Serial1.print(MstrData.weather.batteryP);
	Serial1.print(" - ");
	Serial1.println(sampledData.batteryP);
	Serial1.println(MstrData.weather.signalRSSI);
	Serial1.println(MstrData.weather.LowPwrMode);
	Serial1.println(MstrData.weather.info);
	Serial1.println(MstrData.weather.id);
	
	
}

void WDReset()
{
	digitalWrite(DONE, HIGH);
	
}

void TC3Enable()
{
	TC3->COUNT16.CTRLA.reg |= TC_CTRLA_ENABLE;    // Enable TC3
}

void TC3Disable()
{
	TC3->COUNT16.CTRLA.reg &= ~TC_CTRLA_ENABLE;    // Disable TC3
}

void TC3Reset()
{
	TC3->COUNT16.COUNT.bit.COUNT = (uint32_t)(0);
	while (TC3->COUNT16.STATUS.reg & TC_STATUS_SYNCBUSY);
}

int gethex(char *string)
{
	int val=0;
	int go=1;
	while (go)
	{
		char c=toupper(*string++);
		if ((c>='0' && c<='9') || (c>='A' && c<='F'))
		{
			c=(c>='A') ? (c-'A'+10) : (c-'0');
			val=(val<<4)|c;
		}
		else
		{
			go=0;
		}
	}
	return val;
}

void framTimeSave()
{
	fram.write8(FRAM_TIME_Addr  ,rtcTime.currTime.sec);
	fram.write8(FRAM_TIME_Addr+1,rtcTime.currTime.min);
	fram.write8(FRAM_TIME_Addr+2,rtcTime.currTime.hour);
	fram.write8(FRAM_TIME_Addr+3,rtcTime.currTime.day);
	fram.write8(FRAM_TIME_Addr+4,rtcTime.currTime.month);
	fram.write8(FRAM_TIME_Addr+5,rtcTime.currTime.year);
	
	Serial1.println("");
	Serial1.println(F("done Frame time save"));
}

void framTimeRead()
{
	rtcTime.currTime.sec   = fram.read8(FRAM_TIME_Addr);
	rtcTime.currTime.min   = fram.read8(FRAM_TIME_Addr+1)+1;
	rtcTime.currTime.hour  = fram.read8(FRAM_TIME_Addr+2);
	rtcTime.currTime.day   = fram.read8(FRAM_TIME_Addr+3);
	rtcTime.currTime.month = fram.read8(FRAM_TIME_Addr+4);
	rtcTime.currTime.year  = fram.read8(FRAM_TIME_Addr+5);
	
	Serial1.println(F("done Frame time read"));
}

void framTimeRead2(struct tm *timeptr)
{
	timeptr->tm_sec   = fram.read8(FRAM_TIME_Addr);
	timeptr->tm_min   = fram.read8(FRAM_TIME_Addr+1)+1;
	timeptr->tm_hour  = fram.read8(FRAM_TIME_Addr+2);
	timeptr->tm_mday  = fram.read8(FRAM_TIME_Addr+3);
	timeptr->tm_mon   = fram.read8(FRAM_TIME_Addr+4);
	timeptr->tm_year  = fram.read8(FRAM_TIME_Addr+5);

	Serial1.println(F("done Frame time read"));
}

void disableCharge()
{
	pinMode(CHARGE_EN, OUTPUT);
	digitalWrite(CHARGE_EN,HIGH);	
}

void enableCharge()
{
	pinMode(CHARGE_EN, OUTPUT);
	digitalWrite(CHARGE_EN,LOW);
}

void battFollowCharge()
{
	pinMode(CHARGE_EN, INPUT_PULLDOWN);
	digitalWrite(CHARGE_EN,LOW);
}

#endif

