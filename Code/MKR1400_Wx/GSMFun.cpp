#include "GSMFun.h"
#include "arduino_secrets.h"
#include "GlobalTypes.h"

#include <TimeLib.h>

extern int hour(time_t t);
extern int minute(time_t t);
extern int second(time_t t);
extern int day(time_t t);
extern int month(time_t t);
extern int year(time_t t);

#define TINY_GSM_MODEM_UBLOX
#include <TinyGsmClient.h>
#include <ArduinoHttpClient.h>
#include <Adafruit_SleepyDog.h>
#include "Adafruit_FRAM_I2C.h"
#include <StreamDebugger.h>
#include <RTCZero.h>

#define SerialMon Serial1

// Use Hardware Serial on Mega, Leonardo, Micro
#define SerialAT Serial2



extern GSMBand band;
//extern GSMClient client;
extern GPRS gprs;
extern GSM gsmAccess;
extern serverStruct serverData;
extern nativeData       sampledData;
extern storeDataUnion   MstrData;
extern Adafruit_FRAM_I2C fram;

extern void saveData();
extern int framRead16(int addr);
extern int framWrite16(int addr, int val);
extern volatile CntrlStruct   MstrCntrl;
extern volatile RTCStruct    rtcTime;
extern uint32_t measTime_SeverTx;
extern void framTimeRead2(struct tm *timeptr);

GSMScanner scannerNetworks;
//extern char JSONArray[2+(10+wxPackageSize*2)*500-1];
extern char JSONArray[2+(10+wxPackageSize*2)*jsonBufferSize];
//extern char preJSONArray[500][(wxPackageSize+2)*2];
extern char preJSONArray[jsonBufferSize][(wxPackageSize*2+4)];
//extern char JSONDataStr[2+(10+wxPackageSize*2)*500-1 +  500*2];
extern void GSM_Disable();
extern void GSM_Enable();
extern void rtcSetGSMTime(time_t now);
extern void GPIO_dance();
extern void framReadData();
extern void rtcUpdateTime();
extern void resetWatchDog();
extern int gethex(char *string);


const char server[] = "wxdata.scottnette.com";
const char resource[] = "/ardu2SQL.php?d=12312";
const int  port = 80;

//StreamDebugger debugger(SerialAT, Serial1);
//TinyGsm modem(debugger);
TinyGsm modem(SerialAT);
TinyGsmClient client2(modem);
HttpClient http(client2, server, port);

const char apn[]  = "prodata";
const char user[] = "";
const char pass[] = "";

#define debug_GSM_EN 1

bool getRequest()
{
	// Make GET request to port 80
	Serial1.print(F("server default is:  "));
	Serial1.println(server);
	if (client2.connect(server, PORT_SERVER)){
		client2.print("GET ");
		client2.print("/getIP.php?d=123123");
		client2.println(" HTTP/1.1");
		client2.print("Host: ");
		client2.println("wxdata.scottnette.com");
		//client2.println("Connection: close");
		client2.println();
		Serial1.println("connected");
		return true;
	}
	else {
		// if you didn't get a connection to the server:
		Serial1.println(F("connection failed find"));
		return false;
	}
	
}

bool findIP(char *server, char *serverIP, int port) {

	int buffIdx = 0;
	char idStr[] = "href=\"http://\0";
	char buff[] =  "0000000000000\0";
	bool IPFind = false;
	bool PortFind = false;

	char ipAddr[] = "wxdata.scottnette.com\0";
	char ipPort[] = "000000\0";
	bool connected = true;
	char colonFind = ':';
	char c = 'a';
	bool foundData = true;
	bool done = false;

	for (int ii = 0; ii < 5; ii++){
		if (getRequest()) break; 
		else return false;
	}
	
	
	Serial1.println(F("IP config response read"));
	// Parse response
	while (false) {
		if (client2.available() && foundData) {
			c = client2.read();		
		
		
			// Shift buffer and append right justified
			memmove(buff, &(buff[1]), strlen(&(buff[1])));
			buff[12] = c;


			// Step 5 - Done
			if (PortFind & (c == '/' )){
				memmove(&ipPort[buffIdx], "\0", 1);
				foundData = false;
				done = true;
				break;
			}

			// Step 4 - Get port
			if (PortFind) {
				ipPort[buffIdx] = c;
				buffIdx++;
			}

			// Step 3 - done with IP, get port
			if ((c == colonFind) & IPFind) {
				memmove(&ipAddr[buffIdx], "\0",1);
				//ipPort[buffIdx] = "\0";
				PortFind = true;
				IPFind = false;
				buffIdx = 0;
			}

			// Step 2 - get IP
			if (IPFind) {
				ipAddr[buffIdx] = c;
				buffIdx++;
			}
			
			// Step 1 - find http
			if (!strcmp(buff, idStr)) {
				IPFind = true;
			}
		}

		// if the server's disconnected, stop the client2:
		if (!client2.available() && !client2.connected()) {
			Serial1.println();
			Serial1.println("disconnecting.");
			connected = false;
			client2.stop();

		}
	}
	
	client2.stop();
	Serial1.println("** done IP - ");
	delay(30);
	// Save Data
	if (done){
	////	strcpy(serverData.serverIP,ipAddr);
	//	serverData.portIP = atoi(ipPort);
	//	Serial1.print(serverData.serverIP);
	//	Serial1.print(":");
	//	Serial1.println(serverData.portIP);
	//	delay(30);
		return true;
	}
	
	return false;
}


void setBand()
{
		// Set band if needed
		char bandResult[16];
		String bandName = band.getBand(); // Get and print band name
		Serial1.print("Current band:");
		Serial1.println(bandName);
		bandName.toCharArray(bandResult, 16);
		
		// Set Band if needed
		if (strcmp(bandResult, GSM_MODE_GSM850_PCS)){
			bool operationSuccess;
			operationSuccess = band.setBand(GSM_MODE_GSM850_PCS);
			if (operationSuccess) {
				Serial1.println("Success");
				} else {
				Serial1.println("Error while changing band");
				delay(100);
				operationSuccess = band.setBand(GSM_MODE_GSM850_PCS);
			}
		}
}



bool connectGPRS_tiny()
{
	
	bool connected = true;
	
	// Set band if needed
/*	char bandResult[16];
	String bandName = band.getBand(); // Get and print band name
	Serial1.print("Current band:");
	Serial1.println(bandName);
	bandName.toCharArray(bandResult, 16);
	 
	 // Set Band if needed
	if (strcmp(bandResult, GSM_MODE_GSM850_PCS)){
		bool operationSuccess;
		operationSuccess = band.setBand(GSM_MODE_GSM850_PCS);
		if (operationSuccess) {
			Serial1.println("Success");
			} else {
			Serial1.println("Error while changing band");
		}
	}
	  */

	  SerialMon.print(F("Waiting for network..."));
	  if (!modem.waitForNetwork()) {
		  modem.restart();
		  SerialMon.println(" fail");
		  return false;
	  }

	  SerialMon.print(F("Connecting to "));
	  SerialMon.println(apn);
	  if (!modem.gprsConnect(apn, user, pass)) {
		  SerialMon.println(" fail");
		  return false;
	  }
	 
	Serial1.println("stage 3");
	
	return true;

}


bool sendPost(char *PostData)
{
	Serial1.println(serverData.serverIP);
	Serial1.print("Post Req port - ");
	Serial1.println(serverData.portIP);
// Make a HTTP request:
	if (client2.connect("wxdata.scottnette.com",80)) {
		client2.print("POST ");
		client2.print(serverData.path);
		client2.println(" HTTP/1.1");
		client2.print("Host: ");
		client2.println("wxdata.scottnette.com");
	//	Serial1.print(":");
		//Serial1.println(serverData.portIP);
		
		client2.println("Content-Type: application/json");
		client2.print("Content-Length: ");
		client2.println(strlen(PostData));
			if (MstrCntrl.ServerTxDone){
				client2.println("Connection: close");
			}
		client2.println();
		client2.println(PostData);
		client2.println();
		serverData.serverConnection = true;
		return true;
	} else {
		// if you didn't get a connection to the server:
		Serial1.println("connection failed");
		return false;
	}
}

bool readGPRSResponse()
{
	
	int buffIdx = 0;
	char idStr2[] = "Status: \0";
	char buff2[] =  "XXXXXXXX\0";
	char idStr[] =  "Command: \0";
	char buff[] =   "XXXXXXXXX\0";
	char stsVal[5] = "xxx\0";
	char cmdVal[5] = "xxx\0";
	bool CmdFind = false;
	bool StsFind = false;
	bool DoneCmd = false;
	char colonFind = ':';
	int stsVal_int = 0;
	int cmdVal_int = 0;
	int intVal_int = 0;
	int rebootVal_int = 0;
	int timeCalc = 0;
	
	Serial1.println("Reading Response");
	while (serverData.serverConnection) {
		//Serial1.println("1");
		if (client2.available()) {
			char c = client2.read();
			Serial1.print(c);
			
			if (!DoneCmd){
				// Shift buffer and append right justified
				memmove(buff, &(buff[1]), strlen(&(buff[1])));
				buff[8] = c;
				memmove(buff2, &(buff2[1]), strlen(&(buff2[1])));
				buff2[7] = c;

				// Step 3 - 
				if ((c == ',') & CmdFind) {
					memmove(&cmdVal[buffIdx], "\0",2);
					DoneCmd = true;
					CmdFind = false;
					buffIdx = 0;
					//client2.stop();
				}
				
				if ((c == ',') & StsFind) {
					memmove(&stsVal[buffIdx], "\0",2);
					StsFind = false;
					buffIdx = 0;
				}

				// Step 2 - get val
				if (CmdFind) {
					cmdVal[buffIdx] = c;
					buffIdx++;
				}
				// Step 2 - get val
				if (StsFind) {
					stsVal[buffIdx] = c;
					buffIdx++;
				}
			
				// Step 1 - find command
				if (!strcmp(buff, idStr)) {
					CmdFind = true;
				}
				// Step 1 - find sts
				if (!strcmp(buff2, idStr2)) {
					StsFind = true;
				}
			}
			if (DoneCmd && (stsVal_int != 0x84)){
				client2.stop();
			}
			
		}

		// if the server's disconnected, stop the client2:
		if (!client2.available() && !client2.connected()) {
			Serial1.println();
			Serial1.println("disconnecting.");
			serverData.serverConnection = false;
			client2.stop();
		}
	}
	stsVal_int = gethex(stsVal);
	cmdVal_int = gethex(cmdVal);
	intVal_int = (cmdVal_int & 0xFF0) >> 4;
	rebootVal_int = (cmdVal_int & 0xF);
	
	Serial1.print("Status is: ");
	Serial1.println(stsVal_int);
	Serial1.print("Command is: ");
	Serial1.println(cmdVal_int);
	Serial1.print("Int command is: ");
	Serial1.println(intVal_int);
	
	Serial1.print("Reboot command is: ");
	Serial1.println(rebootVal_int);
		
	
	if(stsVal_int != 0x84){
		Serial1.println("----------Bad Status");
		fram.write8(FRAM_DATA_ERR_CNT_Addr, fram.read8(FRAM_DATA_ERR_CNT_Addr)+1);
		
		return false;
	}
	
	if (rebootVal_int == 7){
			Watchdog.enable(1000);
		}
		
	if (sampledData.batteryP > 20){
		if((intVal_int >= 2)  && (intVal_int <= 30)  && (intVal_int != 15)){
			
			timeCalc = ((int)rtcTime.currTime.hour - MstrCntrl.sCmd_t_hours)*60 + ((int)rtcTime.currTime.min  - MstrCntrl.sCmd_t_mins);
			if (((timeCalc > 60) || (timeCalc < -60))  || (intVal_int != MstrCntrl.serverInterval)){
				MstrCntrl.serverInterval = intVal_int;
				MstrCntrl.sCmd_t_hours = rtcTime.currTime.hour;
				MstrCntrl.sCmd_t_mins =  rtcTime.currTime.min;
			}
		}
	}
	return true;
}



void buildJSON()
{
	char format[128];
	sprintf(format, "%%.%dX", 2);
	char tempStrFull[wxPackageSize*2+4];
	char tempStr[3];
	const char hex[] = "0123456789abcdef";
	int payloadSize = 0;
	int startIdx = 0;
	int temp = 0;

	startIdx = framRead16(FRAM_MEM_POINTER_Addr);
	Serial1.print("STart IDX :    ");
	Serial1.println(startIdx);
	
	if((MstrCntrl.FRAM_NumPoints-startIdx) >= MAX_TX_SIZE){
		payloadSize = MAX_TX_SIZE;
		MstrCntrl.FRAM_CurrIdx = startIdx+MAX_TX_SIZE;
	}else{
		payloadSize = MstrCntrl.FRAM_NumPoints - startIdx;
		MstrCntrl.FRAM_CurrIdx = startIdx + payloadSize;
	}
	
	if(MstrCntrl.FRAM_CurrIdx == MstrCntrl.FRAM_NumPoints)
		MstrCntrl.ServerTxDone = true;
	
		Serial1.print("payloadSize :    ");
		Serial1.println(payloadSize);
		
	tempStr[0]   = 0;
	JSONArray[0] = 0;
	tempStrFull[0] = 0;
	strcpy(JSONArray,"{");

	for (int kk = 0; kk< (payloadSize); kk++){
			
		//Serial1.print("int bytes - ");
	//	for (int ii = wxPackageSize-1; ii > 0; --ii) {
				for (int ii = 0; ii <= wxPackageSize-1; ii++) {
		//	Serial1.print("Mem Idx : ");
		//	Serial1.println((startIdx+kk)*FRAM_DATA_OFFSET + FRAM_CNTRL_OFFSET + ii);
			temp = fram.read8((startIdx+kk)*FRAM_DATA_OFFSET + FRAM_CNTRL_OFFSET + ii);
			//Serial1.print(temp);
			sprintf(tempStr, format, temp);
		//	Serial1.print(tempStr);
			strcat(tempStrFull, tempStr);
		}
	//	Serial1.println("");
		strcat(tempStrFull, "\0");
		Serial1.print("full:       ");
		Serial1.println(tempStrFull);
			
		strcat(JSONArray, "\"");
		sprintf(tempStr,"d%02d",kk);
		strcat(JSONArray, tempStr);
		strcat(JSONArray, "\"");
		strcat(JSONArray, ": ");
		strcat(JSONArray, "\"");
		strcat(JSONArray, tempStrFull);
		strcat(JSONArray, "\"");
			
		if (kk < (payloadSize-1)){
			strcat(JSONArray, ", ");
		}
		tempStrFull[0] = 0;
		Serial1.println("");
	}
	strcat(JSONArray, "}");
	strcat(JSONArray, "\0");
	Serial1.print("true data - ");
	Serial1.println(JSONArray);
	delay(1);
	//strcpy(JSONArray,JSONDataStr);
}


void getSignalStrength()
{
	int csq = modem.getSignalQuality();
	sampledData.rssi = csq;

	Serial1.print("Signal Strength: ");
	Serial1.print(csq);
	Serial1.println(" [0-31]");
}


void readGPRSResponseTime()
{
	bool connected = true;
	char ID[] = "Date:\0";
	char IDBuff[] = "XXXXX\0";
	char DateBuff[] = "XXX, XX XXX XXXX XX:XX:XX \0";
	byte idx = 0;
	bool IDFound = 0;
	
	DateBuff[25] = 0;
	while (connected) 
	{
		if (client2.available()) 
		{
			char c = client2.read();
			//Serial1.print(c);
			// Shift buffer and append right justified
			memmove(IDBuff, &(IDBuff[1]), strlen(&(IDBuff[1])));
			IDBuff[4] = c;
			
			if (c == 'G')
			{
				IDFound = 0;
			}
			
			if (IDFound)
			{
				memmove(DateBuff, &(DateBuff[1]), strlen(&(DateBuff[1])));
				DateBuff[25] = c;
			}
		}
		
		if (!strcmp(ID,IDBuff)){
			IDFound = 1;
		}

		// if the server's disconnected, stop the client:
		if (!client2.available() && !client2.connected())
		{
			Serial1.println();
			Serial1.println("disconnecting.");
			connected = false;
			client2.stop();
		}
	}
	
	Serial1.println("-------");
	Serial1.println(DateBuff);
	
	char *monthArray[12] = {"Jan\0", "Feb\0", "Mar\0", "Apr\0", "May\0", "Jun\0", "Jul\0", "Aug\0", "Sep\0", "Oct\0", "Nov\0", "Dec\0"};
	char tmpDay[] = "XXX\0";

	
	
	int httpMonth = 0;
	int httpDay = 0;
	int httpYear = 0;
	int httpHour = 0;
	int httpMin = 0;
	int httpSec = 0;
	
	char strMonth[] = "XXX\0";
	char strDay[] = "XX\0";
	char strYear[] = "XXXX\0";
	char strHour[] = "XX\0";
	char strMin[] = "XX\0";
	char strSec[] = "XX\0";
	
	strMonth[0] = DateBuff[8];
	strMonth[1] = DateBuff[9];
	strMonth[2] = DateBuff[10];
	
	strDay[0] = DateBuff[5];
	strDay[1] = DateBuff[6];
		
	strYear[0] = DateBuff[12];
	strYear[1] = DateBuff[13];
	strYear[2] = DateBuff[14];
	strYear[3] = DateBuff[15];
			
	strHour[0] = DateBuff[17];
	strHour[1] = DateBuff[18];
				
	strMin[0] = DateBuff[20];
	strMin[1] = DateBuff[21];
					
	strSec[0] = DateBuff[23];
	strSec[1] = DateBuff[24];
	
/*	Serial1.println(strMonth);
	Serial1.println(strDay);
	Serial1.println(strYear);
	Serial1.println(strHour);
	Serial1.println(strMin);
	Serial1.println(strSec);
*/
						
	
	for (int ii = 0; ii< 12; ii++)
	{
		if (!strcmp(monthArray[ii],strMonth))
		{
			httpMonth = ii +1;
			break;
		}
	} 

	httpDay = atoi(strDay);
	httpYear = atoi(strYear);
	httpHour = atoi(strHour);
	httpMin = atoi(strMin);
	httpSec = atoi(strSec);
	
	/*
	Serial1.println(httpMonth);
	Serial1.println(httpDay);
	Serial1.println(httpYear);
	Serial1.println(httpHour);
	Serial1.println(httpMin);
	Serial1.println(httpSec);
	*/
	if (httpHour - 7 < 0)
	{
		httpHour = httpHour + 24 -7;
		httpDay  = httpDay -1;
	}
	else
	{
		httpHour = httpHour -7;
	}


	char CCLKStr[] = "04/01/01,00:00:34+00";
	
	sprintf(CCLKStr, "AT+CCLK=\"%.2d/%.2d/%.2d,%.2d:%.2d:%.2d+00\"",httpYear-2000, httpMonth,httpDay,httpHour,httpMin, httpSec);
	Serial1.print("Sending this: ");
	Serial1.println(CCLKStr);

	String response;
	MODEM.send(CCLKStr);
	MODEM.waitForResponse(100, &response);
	Serial1.println(response.c_str());
	delay(100);
}



void HTTPGETTime()
{
	if (client2.connect("wxdata.scottnette.com",80)) {
		client2.print("GET  ");
		client2.print("/getIP.php?d=123123");
		client2.println(" HTTP/1.1");
		client2.print("Host: ");
		client2.println("wxdata.scottnette.com");
		client2.println("Connection: close");
		client2.println();
	}

	 readGPRSResponseTime();
}


bool setFromGSMTime()
{
	time_t nowT;
	time_t lastT;
	struct tm readtime;
	
	HTTPGETTime();
	nowT = gsmAccess.getLocalTime();
			
	framTimeRead2(&readtime);
	readtime.tm_year += 2018;
	lastT = mktime(&readtime);
	
	Serial1.println(nowT);
	Serial1.println(lastT);
		
	if ((nowT < lastT)){
		Serial1.println("failed time");
		delay(100);
		//rtcSetGSMTime(nowT);
		return false;
	}	
	else{
		Serial1.println("success time");
		rtcSetGSMTime(nowT);
	}
	return true;

}

bool sendToServer(bool findIPFlag)
{
	volatile bool status =  false;
	volatile bool statusIP =  false;
	bool globalStatus = false;
	bool gsmTxCount = false;
	bool gsmTxStatus = false;
	bool sendDataFlag = false;
	int errorCount = 0;
	int postErrorCount = 0;
	volatile int  currPoint = 0;
	bool timeStatus = false;
	int timeStatusCount = 0;
	
	globalStatus = false;
	
	#if debug_GSM_EN
		if (digitalRead(GSM_RESETN)){
			GSM_Enable();
			delay(9000);
		}
			
		//framReadData();
		MstrCntrl.FRAM_NumPoints = framRead16(FRAM_NUM_P0INTS_Addr);
		currPoint = framRead16(FRAM_MEM_POINTER_Addr);
		
		if(MstrCntrl.FRAM_NumPoints > 0  ) sendDataFlag = true;
		else MstrCntrl.ServerTxDone = true;
		
		Serial1.print("num points pointer: ");
		Serial1.println(MstrCntrl.FRAM_NumPoints);
		
		if ((currPoint >= MstrCntrl.FRAM_NumPoints) && sendDataFlag){
			sendDataFlag = false;
			MstrCntrl.ServerTxDone = true;
			framWrite16(FRAM_MEM_POINTER_Addr, 0);
			Serial1.println("reset pointer");
		}
		Serial1.print(" pointer:   ");
		Serial1.println(currPoint);
		
		
		if (MstrCntrl.FRAM_NumPoints >= 92 ) resetWatchDog();
		
	//	buildJSON();
		//delay(10000000);
	
		enum StateDef {ConnectingState = 0, findIPState = 1, updateTimeSignalState = 3, sendPostState = 4, readState = 5, eraseData = 6, connFail = 7};
		enum StateDef State = ConnectingState;
		setBand();
		while (errorCount <= 2){
			switch(State){
				case ConnectingState:
					status = connectGPRS_tiny();
					if (status && findIPFlag) State = findIPState;
					else if (status) State = updateTimeSignalState;
					else errorCount++;
					break;

				case findIPState:
					//if (!statusIP) statusIP = findIP(serverData.server, serverData.serverIP, PORT_IP);
					statusIP = true;
					if (statusIP) State = updateTimeSignalState;
					else State = connFail;
					break;
				
				case updateTimeSignalState:
					getSignalStrength();
					timeStatus = setFromGSMTime();
					if (timeStatus){
						if (sendDataFlag) State = sendPostState;
						else State = eraseData;
						break;
					}
					else {
						timeStatusCount++;
						if (timeStatusCount >3)
							State = connFail;
						
						break;						
					}
				
				case sendPostState:
					Serial1.println("Build Jason---------------");
					buildJSON();
					delay(50);
					status = sendPost(JSONArray);
					delay(50);
					if (status)	State = readState;
					else {
						status = sendPost(JSONArray);
					}
					if (status)	State = readState;
					else State = connFail;
					break;
				
				case readState:
				    delay(200);
					gsmTxStatus = readGPRSResponse();
					if (gsmTxStatus){
						framWrite16(FRAM_MEM_POINTER_Addr, MstrCntrl.FRAM_CurrIdx);
						if(MstrCntrl.ServerTxDone)	State = eraseData;
						else State = sendPostState;
					}
					else State = connFail;
					break;
				
				case eraseData:
					modem.gprsDisconnect();
					GPIO_dance();
					GPIO_dance();
					GPIO_dance();
					framWrite16(FRAM_NUM_P0INTS_Addr, 0);
					framWrite16(FRAM_MEM_POINTER_Addr, 0);
					errorCount = 99;//Done
					globalStatus = true;
					MstrCntrl.ServerTxDone = false;
					break;
					
				case connFail:
					client2.stop();
					modem.gprsDisconnect();
					GSM_Disable();
					delay(250);
					GSM_Enable();
					delay(250);
					State = ConnectingState;
					if (fram.read8(FRAM_ERR_CNT_Addr) < 5){
						fram.write8(FRAM_ERR_CNT_Addr, fram.read8(FRAM_ERR_CNT_Addr)+1);
					}
					
					break;
				
				default:
					State = ConnectingState;
					break;
			}
		}
	#else
		GPIO_dance();
		GPIO_dance();
		GPIO_dance();
		globalStatus = true;
		framWrite16(FRAM_NUM_P0INTS_Addr, 0);
		framWrite16(FRAM_MEM_POINTER_Addr, 0);
	#endif
	
				
	GSM_Disable();
				
	// Reset global array
	JSONArray[0] = 0;
				
	// Set new time
	rtcUpdateTime();
	if(globalStatus){
		measTime_SeverTx = (rtcTime.currTime.min + MstrCntrl.serverInterval) % 60;
		Serial1.println("DoneServer TX");
		return true;
	}
	else{
		measTime_SeverTx = (rtcTime.currTime.min + fram.read8(FRAM_ERR_CNT_Addr)) % 60;
		return false;
	}
}