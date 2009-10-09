/*
 *  LtpInterface.h
 *  spoknclient
 *
 *  Created by Mukesh Sharma on 28/06/09.
 *  Copyright 2009 Geodesic Ltd.. All rights reserved.
 *
 */

#ifndef _LTP_INTERFACE_H_
	#define _LTP_INTERFACE_H_
	#define PLAY_KILL 1234
	#define RECORD_KILL 1235

	#include "ltpmobile.h"
	#include "playrecordpcm.h"
	//#define USERAGENT  "desktop-windows-d2-1.0"
	#define USERAGENT "spokn-win-0.1.17"
	#define ALERT_OFFLINE_WRONG_ID 1000
	#define START_LOGIN        6000 
	#define MAXDATA 2000
	#define MAXINCALL 15 
	#define _OWN_THREAD_
  #include <pthread.h>
typedef void (*AlertNotificationCallbackP)(int type,unsigned int valLong,int valSubLong, unsigned long userData,void *otherInfoP);
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
			pthread_t pthObj;
			
			
		}LtpInterfaceType;
	void  setLtpUserName(LtpInterfaceType *ltpInterfaceP,char *unameCharP);
	char* getLtpUserName(LtpInterfaceType *ltpInterfaceP);
	void  setLtpPassword(LtpInterfaceType *ltpInterfaceP,char *passwordCharP);
	char* getLtpPassword();
    void  setLtpServer(LtpInterfaceType *ltpInterfaceP,char*serverCharP);
	LtpInterfaceType *	  startLtp(AlertNotificationCallbackP  alertNotiCallbackP,unsigned long userData);	
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
	Boolean callLtpInterface(LtpInterfaceType *ltpInterfaceP,char *numberCharP);
	Boolean hangLtpInterface(LtpInterfaceType *ltpInterfaceP);
	int  CallBackUI(void *uData,Boolean palyBackB);
	void RemoveSoundThread(LtpInterfaceType *ltpInterfaceP,Boolean playBackB);
	int logOut(LtpInterfaceType *ltpInterfaceP);
	void mutexLockInterface();
	void mutexUnLockInterface();
	void *PollThread(void *PollThreadP);
	void AcceptInterface(LtpInterfaceType *ltpInterfaceP,int lineID);
	void RejectInterface(LtpInterfaceType *ltpInterfaceP,int lineID);
    void SendDTMF(LtpInterfaceType *ltpInterfaceP,int lineid, char *dtmfMsgP);
void readSocketData(LtpInterfaceType *localLtpInterfaceObjectP);

#endif