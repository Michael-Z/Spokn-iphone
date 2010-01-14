
//  Created on 17/07/09.

/**
 Copyright 2009,2010 Geodesic, <http://www.geodesic.com/>
 
 Spokn SIP-VoIP for iPhone and iPod Touch.
 
 This file is part of Spokn iphone.
 
 Spokn iphone is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 Spokn iphone is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Spokn iphone.  If not, see <http://www.gnu.org/licenses/>.
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
