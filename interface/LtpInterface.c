
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
#include "sipandltpwrapper.h"
//#include <types.h>
pthread_mutexattr_t    attr;
pthread_mutex_t         mutex;
//int gsizeBuffer;
void setHold(struct ltpStack *ps,int enableB);
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
			
			ltpOnPacket(localLtpInterfaceObjectP->ltpObjectP, (char *)localLtpInterfaceObjectP->ltpReceType.bufferUChar, length, localLtpInterfaceObjectP->ltpReceType.address, localLtpInterfaceObjectP->ltpReceType.port);
		
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
	;

	if(localLtpInterfaceObjectP->pthreadstopB)
	{
		mutexUnLockInterface();
		return 1;
	}
	ltpTick(localLtpInterfaceObjectP->ltpObjectP,time(NULL));
	mutexUnLockInterface();
	readSocketData(localLtpInterfaceObjectP);
		
	return 0;
}

void alertInterface(void *udata,int lineid, int alertcode, void *data)
{
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
		case ALERT_CALL_NOT_START:	
		case ALERT_DISCONNECTED:
			if (ltpInterfaceP->ltpObjectP->call[lineid].timeStop)
				cdrAdd(ltpInterfaceP->ltpObjectP->call[lineid].remoteUserid, (time_t) ltpInterfaceP->ltpObjectP->call[lineid].timeStart, 
					  ltpInterfaceP->ltpObjectP->call[lineid].timeStop - ltpInterfaceP->ltpObjectP->call[lineid].timeStart, ltpInterfaceP->ltpObjectP->call[lineid].kindOfCall,ltpInterfaceP->recordUId ,ltpInterfaceP->recordID );
			else
				cdrAdd(ltpInterfaceP->ltpObjectP->call[lineid].remoteUserid, (time_t) ltpInterfaceP->ltpObjectP->call[lineid].timeStart, 
					   0, ltpInterfaceP->ltpObjectP->call[lineid].kindOfCall,ltpInterfaceP->recordUId ,ltpInterfaceP->recordID);
			ltpInterfaceP->recordUId  = 0;
			ltpInterfaceP->recordID = 0;
			subid = 0;					
			if((ltpInterfaceP->ltpObjectP->call[lineid].kindOfCall&CALLTYPE_IN) && (ltpInterfaceP->ltpObjectP->call[lineid].kindOfCall&CALLTYPE_MISSED))
			{
				subid = 1;
			}
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


#ifdef _SNDLOOPBACK_
	AddPcmData(ltpInterfaceP->playbackP,(unsigned short*)pcmBufferP,*lengthP,true);
#else
	#ifdef _LTP_
	if(ltPInterfaceP->holdB==true || ltPInterfaceP->muteB==true)
	{
		ltpSoundInput(ltPInterfaceP->ltpObjectP,(short*)ltPInterfaceP->blankData,160,true);
	}
	else
	{	
		ltpSoundInput(ltPInterfaceP->ltpObjectP,(short*)pcmBufferP,*lengthP,true);
	}	
#endif
	/*if(length<640)
	{
			memset(temp,0,640*sizeof(sampleFrame));
		memmove(temp,pcmBufferP,length*sizeof(sampleFrame));
		ltpSoundInput(ltPInterfaceP->ltpObjectP,(short*)temp,640,true);

				
	}
	else
	{
				ltpSoundInput(ltPInterfaceP->ltpObjectP,(short*)pcmBufferP,length,true);
		
		
		
	}
	*/
#endif	

	return 0;
	
}
int netWriteInterface(void *udata,void *msg, int length, unsigned int32 address, unsigned short16 port)
{
	LtpInterfaceType *ltpInterfaceP;
	ltpInterfaceP = (LtpInterfaceType *)udata;
	
	return netWriteLocal(ltpInterfaceP->socketID, msg, length, address, port);
}

void outputSoundInterface(void *udata,struct ltpStack *ps, struct Call *pc, short *pcm, int length)
{
	
	LtpInterfaceType *ltpInterfaceP;
	ltpInterfaceP = (LtpInterfaceType *)udata;
	if(ltpInterfaceP->holdB==false) 
	{	
		AddPcmData(ltpInterfaceP->playbackP,(unsigned short*)pcm,length,true);
	}	
}
int openSoundInterface(void *udata,int isFullDuplex)
{
	LtpInterfaceType *ltpInterfaceP;
	ltpInterfaceP = (LtpInterfaceType *)udata;
	if(ltpInterfaceP->ltpObjectP->sipOnB || ltpInterfaceP->playbackP ||ltpInterfaceP->stopAutioQueueImidateB==true)
	{
		return 0;
	}
	ltpInterfaceP->holdB = false;
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
	if(ltpInterfaceP->ltpObjectP->sipOnB)
	{
		return ;
	}
	/*if(ltpInterfaceP->stopAutioQueueImidateB)
	{
		removeAudioQueueListener(ltpInterfaceP->recordP);
		removeAudioQueueListener(ltpInterfaceP->playbackP);
	}*/
	StopAudio(ltpInterfaceP->recordP,ltpInterfaceP->stopAutioQueueImidateB);
	
	StopAudio(ltpInterfaceP->playbackP,ltpInterfaceP->stopAutioQueueImidateB);
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
		
		if(gP->connectionActiveByte==0 || gP->firstTimeLoginB==true)
		{
			sleep(2);
			continue;
		}
		else
		{
		
			
			if(gP->connectionActiveByte==1)
			{	
				restartSocket(&gP->socketID);
				
				ltpLogin(gP->ltpObjectP,CMD_LOGIN);
				gP->connectionActiveByte = 2;
			}
			
			
			/*
			
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
					
					if(gP->ltpObjectP->call[gP->ltpObjectP->activeLine].ltpState = CALL_IDLE)
					{	
						profileResync();
					}	
				}
				
			}*/
			if(DoPolling(gP)!=0)
			{	
				//sleep(1);
				gP->pthreadstopB = false;
				break;
				
			}
			
		
		
		
		}
		
				
	}
	return NULL;
	
}
extern char* GetPathFunction();
void setLogFile(LtpInterfaceType *ltpInterfaceP,int onB)
{
	char *pathP=0,*filePathP=0;
	if(ltpInterfaceP==0)
		return ;
	if(onB)
	{
		pathP = GetPathFunction();
		filePathP = malloc(400);
		sprintf(filePathP,"%s/%s",pathP,"logtext.txt");
		setLog(ltpInterfaceP->ltpObjectP, true,filePathP );
		free(pathP);
		free(filePathP);
		
	}
	else {
		setLog(ltpInterfaceP->ltpObjectP, false,0 );
	}

	
		
	

}
LtpInterfaceType *	  startLtp(Boolean sipOnB,AlertNotificationCallbackP  alertNotiCallbackP,unsigned long userData,int randomVariable)
{
	LtpCallBackType localLtpCallBackType;
	LtpInterfaceType *ltpInterfaceP;
	int er = 0;
	ltpInterfaceP = malloc(sizeof(LtpInterfaceType));
	memset(ltpInterfaceP,0,sizeof(LtpInterfaceType));
	ltpInterfaceP->firstTimeLoginB = true;
	ltpInterfaceP->socketID = -1;
	ltpInterfaceP->ltpObjectP = 0;
	ltpInterfaceP->ltpReceType.bufferLength = MAXDATA;
	ltpInterfaceP->userData = userData;
	ltpInterfaceP->alertNotifyP =  alertNotiCallbackP;
	ltpInterfaceP->checkPortAgainB = 1;
	if(sipOnB==false)
	{
		er = restartSocket(&ltpInterfaceP->socketID);
	}
	if(er ==0)
	{	
	#ifndef SUPPORT_SPEEX
		ltpInterfaceP->ltpObjectP = ltpInitNew(sipOnB,MAX_CALL_ALLOWED, LTP_CODEC_GSM, 4);
	#else		
		ltpInterfaceP->ltpObjectP = ltpInitNew(sipOnB,MAX_CALL_ALLOWED, LTP_CODEC_SPEEX, 4);
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
		if(sipOnB==false)
		{	
			pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
			pthread_mutex_init(&mutex, &attr);
			ltpInterfaceP->pthreadstopB = false;
			#ifdef _OWN_THREAD_
				pthread_create(&ltpInterfaceP->pthObj, 0,PollThread,ltpInterfaceP);
			#endif
		}	
	#endif	
		sip_set_randomVariable(ltpInterfaceP->ltpObjectP,randomVariable);
		SetAudioTypeLocal((void*)userData,3);
		
		//setVpnCallback();
		return ltpInterfaceP;
	}
	return NULL;
}

int startOpenVpn(LtpInterfaceType *ltpInterfaceP,char *myPath,char *rscpathCharP)
{
	#ifdef _OPEN_VPN_
		char *newFolder; 
		FILE *fp;

		//myPath = GetPathFunction(0);
		newFolder = malloc(strlen(myPath)+100);
		sprintf(newFolder,"%s/Spokn",myPath);
		CreateDirectoryFunction(0, newFolder);
		
		sprintf(newFolder,"%s/Spokn/dev",myPath);
		CreateDirectoryFunction(0, newFolder);
		sprintf(newFolder,"%s/Spokn/dev/tun0",myPath);
		fp = fopen(newFolder,"wb");
		if(fp)
		{
			fclose(fp);
		}
		else {
			return 0;
		}
		
		
		sprintf(newFolder,"%s/Spokn/net",myPath);
		CreateDirectoryFunction(0, newFolder);
		sprintf(newFolder,"%s/Spokn",myPath);
		setDevPath(newFolder);
		setVpnCallback(ltpInterfaceP->ltpObjectP,newFolder,rscpathCharP);
		return 1;
	
	#else
	return 0;
	#endif
		
	
}
				 
int  showErrorOnTimeOut(LtpInterfaceType *ltpInterfaceP)
{
	/*if(ltpInterfaceP->valChange==0)
	{
		ltpInterfaceP->valChange = 1;
		ltpInterfaceP->ltpObjectP->stunB = !ltpInterfaceP->ltpObjectP->stunB;
		//ltpInterfaceP->ltpObjectP->timeOut = MAXTIMEOUT*2;
		return 0;//attempt relogin
	}*/
	return 1;
}
void setStunSettingIngetface(LtpInterfaceType *ltpInterfaceP, int stunB)
{
	ltpInterfaceP->ltpObjectP->stunB = 1;
	//ltpInterfaceP->ltpObjectP->stunB = stunB;
}
int  getStunSettingInterface(LtpInterfaceType *ltpInterfaceP)
{
	return ltpInterfaceP->ltpObjectP->stunB;
}
void HangupAllCall(LtpInterfaceType *ltpInterfaceP)
{
	ltpInterfaceP->stopAutioQueueImidateB = true;
	ltpHangup(ltpInterfaceP->ltpObjectP,-1);//
	
}
int	  endLtp(LtpInterfaceType *ltpInterfaceP)
{
	
	//
	Boolean clearProfileB = false;
	applicationEnd();

	DeInitAudio( ltpInterfaceP->playbackP,false);
	DeInitAudio( ltpInterfaceP->recordP,false);
	ltpInterfaceP->playbackP = 0;
	ltpInterfaceP->recordP = 0;
	#ifdef _LTP_	
	
		if(ltpInterfaceP->ltpObjectP->sipOnB==false)
		{
			
		
			#ifdef _OWN_THREAD_
	
			ltpInterfaceP->pthreadstopB = true;
			while(ltpInterfaceP->pthreadstopB)
			{
				sleep(1);
			}
			//pthread_cancel(ltpInterfaceP->pthObj);
			//pthread_exit(ltpInterfaceP->pthObj);
			ltpInterfaceP->pthObj = 0;
		}	
		#endif
	#endif
	if(ltpInterfaceP->ltpObjectP->sipOnB)
	{
		sip_pj_DeInit(ltpInterfaceP->ltpObjectP);
		ltpInterfaceP->pjsipStartB = false;
	}
	if (ltpInterfaceP->ltpObjectP->ltpUserid[0]==0)
	{
		clearProfileB = true;
	}
	if(terminateThread()==0)
	{	
		free(ltpInterfaceP->ltpObjectP);
	}	
		ltpInterfaceP->ltpObjectP  = 0;
	
		/* destroys the mutex */
	ltpInterfaceP->pthreadstopB = true;
		pthread_mutex_destroy(&mutex);
	free(ltpInterfaceP);
	if(clearProfileB)
	{
		profileClear();
	}
	return 0;
}
void *createThread(void *spoknP)
{
	char errorstring[50];
	int er;
	LtpInterfaceType *ltpInterfaceP;
	ltpInterfaceP = (LtpInterfaceType *)spoknP;
	ltpInterfaceP->pjsipThreadStartB = 1;
	errorstring[0] = 0;
	er = sip_spokn_pj_config(ltpInterfaceP->ltpObjectP,ltpInterfaceP->userAgent,errorstring);
	if(er==0)
	{
		ltpInterfaceP->checkPortAgainB = 1;
		ltpInterfaceP->pjsipThreadStartB =0;
		ltpInterfaceP->alertNotifyP(ATTEMPT_LOGIN,0,0,ltpInterfaceP->userData,0);

	}
	else	
	{
		ltpInterfaceP->alertNotifyP(ATTEMPT_LOGIN_ERROR,er,0,ltpInterfaceP->userData,strdup(errorstring));
		
	}
	ltpInterfaceP->pjsipThreadStartB =0;
	return 0;
	
}
void startThreadLogin(LtpInterfaceType *ltpInterfaceP)
{
	pthread_t pt;
	if(sip_spokn_pj_Create(ltpInterfaceP->ltpObjectP))
	{	
		pthread_create(&pt, 0,createThread,ltpInterfaceP);
	}
	else {
		ltpInterfaceP->alertNotifyP(ATTEMPT_LOGIN_ERROR,0,0,ltpInterfaceP->userData,strdup("sip library can not create."));
		ltpInterfaceP->LogoutSendB = 0;
	}

}
void ResetPortChecking(LtpInterfaceType *ltpInterfaceP)
{
	ltpInterfaceP->LogoutSendB = 0;
	
	ltpInterfaceP->pjsipThreadStartB =0;
	ltpInterfaceP->checkPortAgainB = 1;
	
}

int SendLoginPacket(LtpInterfaceType *ltpInterfaceP)
{
	char errorstring[50];
	
	if(ltpInterfaceP->pjsipThreadStartB)
	{
		return 1;
	}
	if(ltpInterfaceP->checkPortAgainB)
	{
		ltpInterfaceP->checkPortAgainB = 0;
		ltpInterfaceP->pjsipThreadStartB = 1;
		sip_IsPortOpen(ltpInterfaceP->ltpObjectP,errorstring,false);
		return 1;
	}
	if(ltpInterfaceP->LogoutSendB) 
	{
		//sip_pj_DeInit(ltpInterfaceP->ltpObjectP);
		ltpInterfaceP->LogoutSendB = 0;
	}
	else {
		ltpLogin(ltpInterfaceP->ltpObjectP,CMD_LOGIN);
		return 0;
	}

	return 1;


}
int DoLtpSipLoginInterface(LtpInterfaceType *ltpInterfaceP)
{
	ltpInterfaceP->firstTimeLoginB = false;
	if(ltpInterfaceP->ltpObjectP->sipOnB==false)
	{	
		restartSocket(&ltpInterfaceP->socketID);
		ltpLogin(ltpInterfaceP->ltpObjectP,CMD_LOGIN);
	}
	else
	{	
		if(ltpInterfaceP->pjsipStartB==false)
		{	
			
			startThreadLogin(ltpInterfaceP);	
			
			/*if (!sip_spokn_pj_init(ltpInterfaceP->ltpObjectP,errorstr)){
			 
			 
			 return 1;
			 
			 }*/
			ltpInterfaceP->pjsipStartB=true;
		}	
		else {
			SendLoginPacket(ltpInterfaceP);
		}
		
		
	}
	return 0;
	

}
int   DoLtpLogin(LtpInterfaceType *ltpInterfaceP)
{
	

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
		//char errorstr[50];
		if(ltpInterfaceP->LogoutSendB)
		{
			ltpInterfaceP->LogoutSendB = 0;
			return 0;
		}
		 #ifndef _UA_LOGIN_FIRST_
			DoLtpSipLoginInterface(ltpInterfaceP);
		#else
		if(ltpInterfaceP->firstTimeLoginB==false)
		{
			DoLtpSipLoginInterface(ltpInterfaceP);
		}	
		#endif
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
		ltpInterfaceP->checkPortAgainB = 1;
		if(ltpInterfaceP->pjsipThreadStartB==false || ltpInterfaceP->ltpObjectP->sipOnB==false)
		{	
			ltpLogin(ltpInterfaceP->ltpObjectP,CMD_LOGOUT);
			
		}	
		else {
			ltpInterfaceP->LogoutSendB = 1;
		}

		if(clearAllB)
		{	sip_destroy_transation(ltpInterfaceP->ltpObjectP);
			loggedOut();
			profileClear();
			cdrRemoveAll();
			resetMissCallCount();
			setLtpUserName(ltpInterfaceP,"");
			setLtpPassword(ltpInterfaceP,"");
			ltpInterfaceP->firstTimeLoginB = true;
		}
		else
		{
			if(ltpInterfaceP->ltpObjectP)
			{	
				if (ltpInterfaceP->ltpObjectP->ltpUserid[0])
					profileSave();
			}	
		}
		return 0;
	}	
	return 1;
	
}
int callLtpInterface(LtpInterfaceType *ltpInterfaceP,char *numberCharP)
{
#ifdef _SNDLOOPBACK_
	openSoundInterface(true);
#else
	return ltpRing(ltpInterfaceP->ltpObjectP, numberCharP, CMD_RING);
#endif
	return 0;
}
Boolean hangLtpInterface(LtpInterfaceType *ltpInterfaceP,int llineId)
{

#ifdef _SNDLOOPBACK_

	closeSoundInterface(ltpInterfaceP);
#else
	ltpHangup(ltpInterfaceP->ltpObjectP, llineId);

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
		ltpInterfaceP->recordUId = addressUId;
		ltpInterfaceP->recordID = recordID;
		return 0;
		
	}
	return 1;
}
int getAddressUid(LtpInterfaceType *ltpInterfaceP)
{
	if(ltpInterfaceP==0) return 0;
	return ltpInterfaceP->recordUId;
}
int setHoldInterface(LtpInterfaceType *ltpInterfaceP,int holdB)
{
	int er = 0;
	if(ltpInterfaceP->ltpObjectP->sipOnB==false) //ltp interface
	{
		if(holdB)
		{	
			
			//er = pauseAudio(ltpInterfaceP->recordP);
			er =  pauseAudio(ltpInterfaceP->playbackP);
			if(er==0)
			{
				ltpInterfaceP->holdB = true;
			}
		}
		else
		{
			ltpInterfaceP->holdB = false;
			//PlayAudio(ltpInterfaceP->recordP);
			return 	PlayAudio(ltpInterfaceP->playbackP);
		}
		return 0;
	}
	else
	{	
		setHold(ltpInterfaceP->ltpObjectP,holdB);
	}
	
	
	return 0;
}
int setMuteInterface(LtpInterfaceType *ltpInterfaceP,int muteB)
{
	if(ltpInterfaceP->ltpObjectP->sipOnB==false) //ltp interface
	{
		ltpInterfaceP->muteB = muteB;
		/*if(muteB)
		{	
			return	pauseAudio(ltpInterfaceP->recordP);
		}
		else
		{
			return 	PlayAudio(ltpInterfaceP->recordP);
		}*/
		return 0;
	}
	
	setMute(ltpInterfaceP->ltpObjectP,muteB);
	return 0;
}
void startConferenceInterface(LtpInterfaceType *ltpInterfaceP)
{
	return startConference(ltpInterfaceP->ltpObjectP);
}

void switchReinviteInterface(LtpInterfaceType *ltpInterfaceP ,int llineid)
{
	return switchReinvite(ltpInterfaceP->ltpObjectP,llineid);
}
void UnconferenceInterface(LtpInterfaceType *ltpInterfaceP)
{
	return Unconference(ltpInterfaceP->ltpObjectP);
	
}
void shiftToConferenceCallInterface(LtpInterfaceType *ltpInterfaceP,int oldLineId)
{
	return shiftToConferenceCall(ltpInterfaceP->ltpObjectP,oldLineId);
}
void setPrivateCallInterface(LtpInterfaceType *ltpInterfaceP,int lineid)
{
	return setPrivateCall(ltpInterfaceP->ltpObjectP,lineid);
}
void setUserAgent(LtpInterfaceType *ltpInterfaceP,char*userAgentP)
{
	strcpy(ltpInterfaceP->userAgent,userAgentP);
}
void setCallbackCdr(LtpInterfaceType *ltpInterfaceP,char*userP,time_t time)
{
	if(strlen(userP)>0)
	{	
		
		cdrAdd(userP, (time_t) time, 0, CALLTYPE_OUT,0 ,0 );
	}
}
/*void set_sizeof_buffer(int size)
{
	gsizeBuffer = size;
}
int get_sizeof_buffer()
{
	return gsizeBuffer;

}*/