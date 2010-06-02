
// Created on 28/06/09.

/**
  Copyright 2009, 2010 Geodesic Limited. <http://www.geodesic.com/>
 
 Spokn for iPhone.
 
 This file is part of Spokn for iPhone.
 
 Spokn for iPhone is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, version 2 of the License.
  
 Spokn for iPhone is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Spokn for iPhone.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef _LTP_INTERFACE_H_
	#define _LTP_INTERFACE_H_
	#define PLAY_KILL 1234
	#define RECORD_KILL 1235

	#include "ltpmobile.h"
	#include "playrecordpcm.h"
	//#define USERAGENT  "desktop-windows-d2-1.0"
	#define USERAGENT "spokn-iphone-1.0.0"
	#define ALERT_OFFLINE_WRONG_ID 1000
	#define START_LOGIN        6000 
	#define ATTEMPT_LOGIN      6010  
	#define MAXDATA 2000
	#define MAXINCALL 15 
	#define MAXTIME_RESYNC 180 //this is in sec 
	#define NO_WIFI_AVAILABLE 1001 
	#define END_CALL_PRESSED 2150
	#define MAX_CALL_ALLOWED  4 
	#define _OWN_THREAD_
	
  #include <pthread.h>
typedef int (*AlertNotificationCallbackP)(int type,unsigned int valLong,int valSubLong, unsigned long userData,void *otherInfoP);
typedef struct LtpReceiveDataType
		{
		
			unsigned char bufferUChar[MAXDATA];
			int bufferLength;
			unsigned long address;
			unsigned short port;
			
		}LtpReceiveDataType;
typedef struct IncommingCallType
	{
		int lineid;
		char userIdChar[MAX_USERID];
	}IncommingCallType;
		typedef struct LtpInterfaceType
		{
			int socketID;
			unsigned long userData;
			LtpReceiveDataType ltpReceType;
			struct ltpStack *ltpObjectP;
			AlertNotificationCallbackP alertNotifyP;
			//two objects of recording and playback
			AQCallbackStruct *playbackP;
			AQCallbackStruct *recordP;
			int pthreadstopB;
			long currentTime;
			int connectionActiveByte;
			pthread_t pthObj;
			Boolean pjsipStartB;
			int recordUId;
			int recordID;	
			int holdB;
			int muteB;
			int valChange;
			int pjsipThreadStartB;
			int LogoutSendB;
			short int blankData[160];//blank data
			
		}LtpInterfaceType;
	void  setLtpUserName(LtpInterfaceType *ltpInterfaceP,char *unameCharP);
	char* getLtpUserName(LtpInterfaceType *ltpInterfaceP);
	void  setLtpPassword(LtpInterfaceType *ltpInterfaceP,char *passwordCharP);
	char* getLtpPassword();
    void  setLtpServer(LtpInterfaceType *ltpInterfaceP,char*serverCharP);
LtpInterfaceType *	  startLtp(Boolean sipOnB,AlertNotificationCallbackP  alertNotiCallbackP,unsigned long userData);
	int DoPolling(LtpInterfaceType *localLtpInterfaceObjectP);
	int   DoLtpLogin(LtpInterfaceType *ltpInterfaceP);
	int   endLtp(LtpInterfaceType *ltpInterfaceP);
	unsigned long ticks();
	unsigned int lookupDNSInterface(void *udata,char *host);
	void alertInterface(void *udata,int lineid, int alertcode, void *data);
	void closeSoundInterface(void *udata);
	int openSoundInterface(void *uData,int isFullDuplex);
	void outputSoundInterface(void *udata,struct ltpStack *ps, struct Call *pc, short *pcm, int length);
	int netWriteInterface(void *udata,void *msg, int length, unsigned int32 address, unsigned short16 port);
	int CallBackSoundPCM(void *uData,sampleFrame *pcmBufferP,unsigned int *lengthP,Boolean recordB);
	int callLtpInterface(LtpInterfaceType *ltpInterfaceP,char *numberCharP);
Boolean hangLtpInterface(LtpInterfaceType *ltpInterfaceP,int llineId);
	int  CallBackUI(void *uData,Boolean palyBackB);
	void RemoveSoundThread(LtpInterfaceType *ltpInterfaceP,Boolean playBackB);
	int logOut(LtpInterfaceType *ltpInterfaceP,Boolean clearAllB);
	void mutexLockInterface();
	void mutexUnLockInterface();
	void *PollThread(void *PollThreadP);
	void AcceptInterface(LtpInterfaceType *ltpInterfaceP,int lineID);
	void RejectInterface(LtpInterfaceType *ltpInterfaceP,int lineID);
    void SendDTMF(LtpInterfaceType *ltpInterfaceP,int lineid, char *dtmfMsgP);
	void readSocketData(LtpInterfaceType *localLtpInterfaceObjectP);
	int SetConnection( LtpInterfaceType *ltpInterfaceP,int activeB);
	int SetAddressBookDetails(LtpInterfaceType *ltpInterfaceP,int addressUId,int recordID);
	int getAddressUid(LtpInterfaceType *ltpInterfaceP);
	int setHoldInterface(LtpInterfaceType *ltpInterfaceP,int holdB);
	int setMuteInterface(LtpInterfaceType *ltpInterfaceP,int muteB);
	void startConferenceInterface(LtpInterfaceType *ltpInterfaceP);
	void switchReinviteInterface(LtpInterfaceType *ltpInterfaceP ,int llineid);
	void UnconferenceInterface(LtpInterfaceType *ltpInterfaceP); 
	void shiftToConferenceCallInterface(LtpInterfaceType *ltpInterfaceP,int oldLineId);
	void setPrivateCallInterface(LtpInterfaceType *ltpInterfaceP,int lineid);
	int  showErrorOnTimeOut(LtpInterfaceType *ltpInterfaceP);
void setStunSettingIngetface(LtpInterfaceType *ltpInterfaceP, int stunB);
	int  getStunSettingInterface(LtpInterfaceType *ltpInterfaceP);
int SendLoginPacket(LtpInterfaceType *ltpInterfaceP);
#endif