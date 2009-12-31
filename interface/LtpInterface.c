/*
 *  LtpInterface.c
 *  spoknclient
 *
 *  Created by Mukesh Sharma on 28/06/09.
 *  Copyright 2009 Geodesic Ltd.. All rights reserved.
 *
 */

#include "LtpInterface.h"
#include "string.h"
#include "netlayer.h"
#include "time.h"
#include "stdlib.h"
#include "unistd.h"
#include "ltpmobile.h"
#include "ua.h"
#include "ltpandsip.h"
#include "sipwrapper.h"
//#include <types.h>
pthread_mutexattr_t    attr;
pthread_mutex_t         mutex;


//#define _SNDLOOPBACK_
//#import <Foundation/Foundation.h>

//LtpInterfaceType *ltpInterfaceObjectP;

unsigned int lookupDNSInterface(void *uData,char *host)
{
	
	return lookupDNSLocal(host);	
}
void readSocketData(LtpInterfaceType *localLtpInterfaceObjectP)
{
		int length;
	while((length = netRead(localLtpInterfaceObjectP->socketID, localLtpInterfaceObjectP->ltpReceType.bufferUChar, localLtpInterfaceObjectP->ltpReceType.bufferLength, &localLtpInterfaceObjectP->ltpReceType.address, &localLtpInterfaceObjectP->ltpReceType.port))>0)
	{
		mutexLockInterface();
		#ifdef _LTP_
		//////printf("\n length recv %d",length);
			ltpOnPacket(localLtpInterfaceObjectP->ltpObjectP, (char *)localLtpInterfaceObjectP->ltpReceType.bufferUChar, length, localLtpInterfaceObjectP->ltpReceType.address, localLtpInterfaceObjectP->ltpReceType.port);
		//////printf("\n end length");
		#endif
		mutexUnLockInterface();
	}	
	

}
int DoPolling(LtpInterfaceType *localLtpInterfaceObjectP)
{

	if(localLtpInterfaceObjectP==0)
	{
		return 1;//error
	}
	mutexLockInterface();
	//////printf("\n start");

	if(localLtpInterfaceObjectP->pthreadstopB)
	{
		mutexUnLockInterface();
		return 1;
	}
	ltpTick(localLtpInterfaceObjectP->ltpObjectP,time(NULL));
	mutexUnLockInterface();
	readSocketData(localLtpInterfaceObjectP);
		//////printf("\n end");
	
	return 0;
}

void alertInterface(void *udata,int lineid, int alertcode, void *data)
{
	////printf("\n%d %d ",lineid,alertcode);
	void *ldata = data;
	int subid = 0;
	LtpInterfaceType *ltpInterfaceP;
	ltpInterfaceP = (LtpInterfaceType *)udata;
	switch(alertcode)
	{
		case ALERT_CONNECTED:
		
			/*
			if (ltpInterfaceObjectP->ltpObjectP->call[0].inTalk)
				openSoundInterface(0);
			else
				openSoundInterface(1);
			break;
		case ALERT_DISCONNECTED:
			closeSound();
			break;*/
			break;
		case ALERT_DISCONNECTED:
			if (ltpInterfaceP->ltpObjectP->call[lineid].timeStop)
				cdrAdd(ltpInterfaceP->ltpObjectP->call[lineid].remoteUserid, (time_t) ltpInterfaceP->ltpObjectP->call[lineid].timeStart, 
					  ltpInterfaceP->ltpObjectP->call[lineid].timeStop - ltpInterfaceP->ltpObjectP->call[lineid].timeStart, ltpInterfaceP->ltpObjectP->call[lineid].kindOfCall,ltpInterfaceP->addressUId ,ltpInterfaceP->recordID );
			else
				cdrAdd(ltpInterfaceP->ltpObjectP->call[lineid].remoteUserid, (time_t) ltpInterfaceP->ltpObjectP->call[lineid].timeStart, 
					   0, ltpInterfaceP->ltpObjectP->call[lineid].kindOfCall,ltpInterfaceP->addressUId ,ltpInterfaceP->recordID);
			ltpInterfaceP->addressUId  = 0;
			ltpInterfaceP->recordID = 0;
			break;
		case ALERT_OFFLINE:
				subid = ltpInterfaceP->ltpObjectP->loginStatus;
			
			break;
		case ALERT_INCOMING_CALL:
			{
				IncommingCallType *incommingCallP;
				incommingCallP = (IncommingCallType *)malloc(sizeof(IncommingCallType));
				incommingCallP->lineid = lineid;
				strcpy(incommingCallP->userIdChar,ltpInterfaceP->ltpObjectP->call[lineid].remoteUserid);
				ldata = incommingCallP;//change data variable 

				
			}
			break;
	
	}
	
	
	if(ltpInterfaceP)
	{	
		if(ltpInterfaceP->alertNotifyP)
		{
			ltpInterfaceP->alertNotifyP(alertcode,lineid,subid,ltpInterfaceP->userData,ldata);
		}
	}	
}

int CallBackSoundPCM(void *uData,sampleFrame *pcmBufferP,unsigned int *lengthP,Boolean recordB)
{
	LtpInterfaceType *ltPInterfaceP;
	ltPInterfaceP = (LtpInterfaceType *)uData;
//	static sampleFrame temp[642];
	//////printf("\nltp st");
	//ltpSoundInput(ltPInterfaceP->ltpObjectP,(short*)pcmBufferP,length,true);
#ifdef _SNDLOOPBACK_
	AddPcmData(ltpInterfaceP->playbackP,(unsigned short*)pcmBufferP,*lengthP,true);
#else
	#ifdef _LTP_
	ltpSoundInput(ltPInterfaceP->ltpObjectP,(short*)pcmBufferP,*lengthP,true);
#endif
	/*if(length<640)
	{
		////printf("\nlength=%d",length);
		memset(temp,0,640*sizeof(sampleFrame));
		memmove(temp,pcmBufferP,length*sizeof(sampleFrame));
		ltpSoundInput(ltPInterfaceP->ltpObjectP,(short*)temp,640,true);

				
	}
	else
	{
		////printf("\nspeex full length");
		ltpSoundInput(ltPInterfaceP->ltpObjectP,(short*)pcmBufferP,length,true);
		
		
		
	}
	*/
#endif	
	//////printf("\nltp end");
	return 0;
	
}
int netWriteInterface(void *udata,void *msg, int length, unsigned int32 address, unsigned short16 port)
{
	LtpInterfaceType *ltpInterfaceP;
	ltpInterfaceP = (LtpInterfaceType *)udata;
	//////printf("\n%d",length);
	return netWriteLocal(ltpInterfaceP->socketID, msg, length, address, port);
}

void outputSoundInterface(void *udata,struct ltpStack *ps, struct Call *pc, short *pcm, int length)
{
	//////printf("\npcm length %d",length);
	LtpInterfaceType *ltpInterfaceP;
	ltpInterfaceP = (LtpInterfaceType *)udata;
	AddPcmData(ltpInterfaceP->playbackP,(unsigned short*)pcm,length,true);
}
int openSoundInterface(void *udata,int isFullDuplex)
{
	LtpInterfaceType *ltpInterfaceP;
	ltpInterfaceP = (LtpInterfaceType *)udata;

	DeInitAudio( ltpInterfaceP->playbackP,false);
	DeInitAudio( ltpInterfaceP->recordP,false);
	ltpInterfaceP->playbackP = 0;
	ltpInterfaceP->recordP = 0;
	SetAudioTypeLocal(ltpInterfaceP,0);//record as well as play back
	ltpInterfaceP->playbackP = InitAudio(ltpInterfaceP, CallBackUI, 0);//playback
	if(CreateSoundThread(true,ltpInterfaceP->playbackP,false,0))
	{
		DeInitAudio( ltpInterfaceP->playbackP,false);
		ltpInterfaceP->playbackP = 0;

	}
	
	ltpInterfaceP->recordP = InitAudio(ltpInterfaceP, CallBackUI, CallBackSoundPCM);
	
	if(CreateSoundThread(false,ltpInterfaceP->recordP,false,ltpInterfaceP->ltpObjectP->soundBlockSize*2))
	{
		  DeInitAudio( ltpInterfaceP->recordP,false);
		  ltpInterfaceP->recordP = 0;
			  
		  
	}  
	PlayAudio(ltpInterfaceP->recordP);
	//sleep(10);
	PlayAudio(ltpInterfaceP->playbackP);
	//PlayAudio(ltpInterfaceObjectP->recordP);
	
	return 0;
}
void closeSoundInterface(void *udata)
{
	LtpInterfaceType *ltpInterfaceP;
	ltpInterfaceP = (LtpInterfaceType *)udata;

	StopAudio(ltpInterfaceP->recordP,false);
	
	StopAudio(ltpInterfaceP->playbackP,false);
		return ;
}
int  CallBackUI(void *uData,Boolean playBackB)
{
	int alertcode;
	LtpInterfaceType *ltPInterfaceP;
	ltPInterfaceP = (LtpInterfaceType *)uData;
	if(playBackB)
	{
		alertcode = PLAY_KILL;
	}
	else
	{
		alertcode = RECORD_KILL;
	}
	if(ltPInterfaceP)
	{	
		if(ltPInterfaceP->alertNotifyP)
		{
			ltPInterfaceP->alertNotifyP(alertcode,0,0,ltPInterfaceP->userData,0);
		}
	}
	return 0;
	
}
unsigned long ticks()
{
	return time(NULL);
}

void  setLtpUserName(LtpInterfaceType *ltpInterfaceP,char *unameCharP)
{
	strcpy(ltpInterfaceP->ltpObjectP->ltpUserid,unameCharP);
}
char* getLtpUserName(LtpInterfaceType *ltpInterfaceP)
{
	return strdup(ltpInterfaceP->ltpObjectP->ltpUserid);
}
void  setLtpPassword(LtpInterfaceType *ltpInterfaceP,char *passwordCharP)
{
	strcpy(ltpInterfaceP->ltpObjectP->ltpPassword,passwordCharP);
}
char* getLtpPassword(LtpInterfaceType *ltpInterfaceP)
{
	return strdup(ltpInterfaceP->ltpObjectP->ltpPassword);
}
void  setLtpServer(LtpInterfaceType *ltpInterfaceP,char*serverCharP)
{
	strcpy(ltpInterfaceP->ltpObjectP->ltpServerName,serverCharP);

	
}
void *PollThread(void *PollThreadP)
{
	#ifndef _LTP_
	return NULL;
	#endif
	
	LtpInterfaceType *gP = (LtpInterfaceType*) PollThreadP;
	
	while(1)
	{
		
		if(gP->pthreadstopB==true) 
		{
			gP->pthreadstopB = false;
			break;
		}
		
		if(gP->connectionActiveByte==0)
		{
			sleep(1);
			continue;
		}
		else
		{
		
			
			if(gP->connectionActiveByte==1)
			{	
				restartSocket(&gP->socketID);
				////printf("\nloggedin %s %s",ltpInterfaceP->ltpObjectP->ltpUserid,ltpInterfaceP->ltpObjectP->ltpPassword);
				ltpLogin(gP->ltpObjectP,CMD_LOGIN);
				gP->connectionActiveByte = 2;
			}
			
			
			
			
			if(gP->currentTime==0)
			{
				gP->currentTime = time(NULL);
			}
			else
			{
				long diff;
				diff = time(NULL) - gP->currentTime;
				if(diff>MAXTIME_RESYNC)
				{
					gP->currentTime = time(NULL);
					//printf("\n resync Called");
					if(gP->ltpObjectP->call[gP->ltpObjectP->activeLine].ltpState = CALL_IDLE)
					{	
						profileResync();
					}	
				}
				
			}
			if(DoPolling(gP)!=0)
			{	
				//sleep(1);
				break;
				
			}
			
		
		
		
		}
		
				
	}
	return NULL;
	
}
LtpInterfaceType *	  startLtp(AlertNotificationCallbackP  alertNotiCallbackP,unsigned long userData)
{
	LtpCallBackType localLtpCallBackType;
	LtpInterfaceType *ltpInterfaceP;
	ltpInterfaceP = malloc(sizeof(LtpInterfaceType));
	memset(ltpInterfaceP,0,sizeof(LtpInterfaceType));
	ltpInterfaceP->socketID = -1;
	ltpInterfaceP->ltpObjectP = 0;
	ltpInterfaceP->ltpReceType.bufferLength = MAXDATA;
	
	ltpInterfaceP->userData = userData;
	ltpInterfaceP->alertNotifyP =  alertNotiCallbackP;
	if(restartSocket(&ltpInterfaceP->socketID)==0)
	{	
	#ifndef SUPPORT_SPEEX
		ltpInterfaceP->ltpObjectP = ltpInit(2, LTP_CODEC_GSM, 4);
	#else		
		ltpInterfaceP->ltpObjectP = ltpInit(2, LTP_CODEC_SPEEX, 4);
	#endif
		if(ltpInterfaceP->ltpObjectP==0)
		{
			free(ltpInterfaceP);
			return NULL;
		}
		ltpInterfaceP->ltpObjectP->nextCallSession = 0xffff & ticks();
		ltpInterfaceP->ltpObjectP->nextMsgID = 0xffff & ticks();
		ltpInterfaceP->ltpObjectP->forceProxy = 0;
		strcpy(ltpInterfaceP->ltpObjectP->userAgent, USERAGENT);
		ltpInterfaceP->ltpObjectP->ltpPresence = NOTIFY_ONLINE;
	
		#ifdef _CALLBACKLTP_
	
	
			localLtpCallBackType.lookDnsCallBackPtr = lookupDNSInterface;
		localLtpCallBackType.uData = ltpInterfaceP;
			localLtpCallBackType.alertCallBackPtr   = alertInterface;
			localLtpCallBackType.netWriteCallBackPtr = netWriteInterface;
			localLtpCallBackType.outputSoundCallBackPtr = outputSoundInterface;
			localLtpCallBackType.openSoundCallBackPtr = openSoundInterface;
			localLtpCallBackType.closeSoundCallBackPtr = closeSoundInterface;
			SetLtpCallBack(ltpInterfaceP->ltpObjectP,&localLtpCallBackType);
		
		#endif
	#ifdef _LTP_	
		pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
		pthread_mutex_init(&mutex, &attr);
		ltpInterfaceP->pthreadstopB = false;
		#ifdef _OWN_THREAD_
			pthread_create(&ltpInterfaceP->pthObj, 0,PollThread,ltpInterfaceP);
		#endif
	#endif	
		printf("\n my udata %d",userData);
		SetAudioTypeLocal(userData,0);
		return ltpInterfaceP;
	}
	return NULL;
}
int	  endLtp(LtpInterfaceType *ltpInterfaceP)
{
	DeInitAudio( ltpInterfaceP->playbackP,false);
	DeInitAudio( ltpInterfaceP->recordP,false);
	ltpInterfaceP->playbackP = 0;
	ltpInterfaceP->recordP = 0;
	#ifdef _LTP_		
		#ifdef _OWN_THREAD_
	
		ltpInterfaceP->pthreadstopB = true;
		while(ltpInterfaceP->pthreadstopB)
		{
			sleep(1);
		}
		//pthread_cancel(ltpInterfaceP->pthObj);
		//pthread_exit(ltpInterfaceP->pthObj);
		ltpInterfaceP->pthObj = 0;
		#endif
	#endif
	free(ltpInterfaceP->ltpObjectP);
	ltpInterfaceP->ltpObjectP  = 0;
	/* destroys the mutex */
	ltpInterfaceP->pthreadstopB = true;
		pthread_mutex_destroy(&mutex);
		return 0;
}
int   DoLtpLogin(LtpInterfaceType *ltpInterfaceP)
{
	
	printf("\nloggedin %s %s",ltpInterfaceP->ltpObjectP->ltpUserid,ltpInterfaceP->ltpObjectP->ltpPassword);

	if(ltpInterfaceP->ltpObjectP==0)
	{
		return -1;
	}
	if(strlen(ltpInterfaceP->ltpObjectP->ltpUserid)==0 || strlen(ltpInterfaceP->ltpObjectP->ltpPassword)==0)
	{
		return -2;
	}
	if(ltpInterfaceP->connectionActiveByte)
	{	
		char errorstr[50];
		//printf("\n mukesh start ");
		#ifdef _LTP_
		restartSocket(&ltpInterfaceP->socketID);
		#else
		if(ltpInterfaceP->pjsipStartB==false)
		{	
			//printf("\n start login ltp");
			if (!spokn_pj_init(errorstr)){
				//printf ("PJ not initiallized: %s\n",errorstr);
				return 1;
			
			}
			//ltpInterfaceP->pjsipStartB==true;
		}	
		
		#endif
		////printf("\nloggedin %s %s",ltpInterfaceP->ltpObjectP->ltpUserid,ltpInterfaceP->ltpObjectP->ltpPassword);
		ltpLogin(ltpInterfaceP->ltpObjectP,CMD_LOGIN);
		ltpInterfaceP->alertNotifyP(START_LOGIN,0,0,ltpInterfaceP->userData,0);
	}
	else
	{
		ltpInterfaceP->alertNotifyP(START_LOGIN,0,1,ltpInterfaceP->userData,0);
	}
	
	return 0;

}
int logOut(LtpInterfaceType *ltpInterfaceP,Boolean clearAllB)
{
	if(ltpInterfaceP)
	{	
		ltpLogin(ltpInterfaceP->ltpObjectP,CMD_LOGOUT);
		if(clearAllB)
		{	
			profileClear();
			cdrRemoveAll();
			setLtpUserName(ltpInterfaceP,"");
			setLtpPassword(ltpInterfaceP,"");
		}	
		return 0;
	}	
	return 1;
	
}
Boolean callLtpInterface(LtpInterfaceType *ltpInterfaceP,char *numberCharP)
{
#ifdef _SNDLOOPBACK_
	openSoundInterface(true);
#else
	ltpRing(ltpInterfaceP->ltpObjectP, numberCharP, CMD_RING);
#endif
	return true;
}
Boolean hangLtpInterface(LtpInterfaceType *ltpInterfaceP)
{

#ifdef _SNDLOOPBACK_

	closeSoundInterface(ltpInterfaceP);
#else
	ltpHangup(ltpInterfaceP->ltpObjectP, 0);

#endif
	return true;
}
void RemoveSoundThread(LtpInterfaceType *ltpInterfaceP,Boolean playBackB)
{
	if(playBackB)
	{	
		DeInitAudio( ltpInterfaceP->playbackP,false);
		ltpInterfaceP->playbackP = 0;
	}
	else
	{	
		DeInitAudio( ltpInterfaceP->recordP,false);
		ltpInterfaceP->recordP = 0;
	}
}
void mutexLockInterface()
{
	pthread_mutex_lock(&mutex);

}
void mutexUnLockInterface()
{
	pthread_mutex_unlock(&mutex);

}
void AcceptInterface(LtpInterfaceType *ltpInterfaceP,int lineID)
{
	ltpAnswer(ltpInterfaceP->ltpObjectP, lineID);
}
void RejectInterface(LtpInterfaceType *ltpInterfaceP,int lineID)
{
#ifdef _LTP_
	ltpRefuse(ltpInterfaceP->ltpObjectP, lineID,0);
#else
	ltpHangup(ltpInterfaceP->ltpObjectP,lineID);
#endif
}
void SendDTMF(LtpInterfaceType *ltpInterfaceP,int lineid, char *dtmfMsgP)
{
	ltpMessageDTMF(ltpInterfaceP->ltpObjectP,  lineid,dtmfMsgP );

}
int SetConnection( LtpInterfaceType *ltpInterfaceP,int activeByte)
{
	ltpInterfaceP->connectionActiveByte = activeByte;
	if(activeByte==2)//mean send login packet
	{
		return DoLtpLogin(ltpInterfaceP);
	}
	return 0;
	
}
int  SetAddressBookDetails(LtpInterfaceType *ltpInterfaceP,int addressUId,int recordID)
{
	if(ltpInterfaceP)
	{
		ltpInterfaceP->addressUId = addressUId;
		ltpInterfaceP->recordID = recordID;
		return 0;
		
	}
	return 1;
}
int getAddressUid(LtpInterfaceType *ltpInterfaceP)
{
	if(ltpInterfaceP==0) return 0;
	return ltpInterfaceP->addressUId;
}
int setHoldInterface(LtpInterfaceType *ltpInterfaceP,int holdB)
{
	return setHold(ltpInterfaceP->ltpObjectP,holdB);
}
int setMuteInterface(LtpInterfaceType *ltpInterfaceP,int muteB)
{
	return setMute(muteB);
}