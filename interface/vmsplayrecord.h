/*
 *  vmsplayrecord.h
 *  spoknclient
 *
 *  Created by Mukesh Sharma on 17/07/09.
 *  Copyright 2009 Geodesic Ltd.. All rights reserved.
 *
 */
#ifndef _VMS_PLAY_RECORD_
	#define _VMS_PLAY_RECORD_
	#include "playrecordpcm.h"	
	#include "LtpInterface.h" 
#define VMS_PLAY_KILL 1236
#define VMS_RECORD_KILL 1237
//	#include <gsm.h>
//typedef void (*AlertNotificationVMSCallbackP)(int type,unsigned int valLong,int valSubLong, unsigned long userData,void *otherInfoP);

	typedef struct VmsPlayRecordType
		{
			unsigned long userData;
			FILE *playRecordFP;
			gsm playRecordObj;
			Boolean stopB;
			Boolean recordB;
			AQCallbackStruct *aqRecordPlayPcm; 
			AlertNotificationCallbackP alertNotifyP;
			
		}VmsPlayRecordType;	
	VmsPlayRecordType * vmsInit(unsigned long userData,AlertNotificationCallbackP alertNotiP,Boolean recordB);
	int vmsStopPlay(VmsPlayRecordType *vmsP);
		int vmsStopRecord(VmsPlayRecordType *vmsP);
int vmsStartPlay(VmsPlayRecordType *vmsP);

int vmsSetFilePlay(VmsPlayRecordType *vmsP,char *nameP,unsigned long  *noSecP);
int vmsStartRecord(VmsPlayRecordType *vmsP);
int vmsSetFileRecord(VmsPlayRecordType *vmsP,char *nameP);



	void vmsDeInit(VmsPlayRecordType **vmspP);
	//private api
	int openPlayRecordFile(VmsPlayRecordType *vmsP,char *nameP,char *modeP);
	//call back from audio engine
	int  CallBackVmsUI(void *uData,Boolean playBackB);
	int CallBackVmsSoundPCM(void *uData,sampleFrame *pcmBufferP,unsigned int *lengthP,Boolean recordB);
	
	
	
#endif
