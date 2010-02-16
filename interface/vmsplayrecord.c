
// Created on 17/07/09.

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

#include "vmsplayrecord.h"
#include "LtpInterface.h" 
int  CallBackVmsUI(void *uData,Boolean playBackB)
{
	int alertcode;
	VmsPlayRecordType *vmsObjP;
	vmsObjP = (VmsPlayRecordType *)uData;
	if(playBackB)
	{
		alertcode = VMS_PLAY_KILL;
	}
	else
	{
		alertcode = VMS_RECORD_KILL;
	}
	if(vmsObjP)
	{	
		if(vmsObjP->alertNotifyP)
		{
			vmsObjP->alertNotifyP(alertcode,0,0,vmsObjP->userData,0);
		}
	}
	return 0;
	
}
int CallBackVmsSoundPCM(void * userData,sampleFrame *pcmBufferP,unsigned int *lengthP,Boolean recordB)
{
	VmsPlayRecordType *vmsObjP;
	sampleFrame *tempP=0;
	sampleFrame *pcmP=0;
	//sampleFrame *pcmLoopP = 0;
	//int j;
	char audioBuff[150];
	int index = 0;
	int i;
	int nsamples;
	nsamples = *lengthP;
	vmsObjP = (VmsPlayRecordType *)userData;
	if(vmsObjP)
	{
		if(vmsObjP->stopB)
		{
			StopAudio(vmsObjP->aqRecordPlayPcm,false);
			return 1;
		}
		 pcmP = pcmBufferP;
		if(recordB)
		{
			
			if(*lengthP<640)
			 {
				 tempP = malloc(640*sizeof(sampleFrame)+4);//extra 4 byte
				 memset(tempP,0,640*sizeof(sampleFrame));
				 memmove(tempP,pcmBufferP,*lengthP*sizeof(sampleFrame));
				 pcmP = tempP;
				 nsamples = 640;
			 
			 
			 }
			 else
			 {
			 
				  pcmP = pcmBufferP;
			 
			 }
			for ( i = 0; i < nsamples; i+= 160){
				gsm_encode(vmsObjP->playRecordObj,(short*) pcmP + i, (gsm_byte *)(audioBuff + index));
				index += 33;
			}
			fwrite(audioBuff,1,index,vmsObjP->playRecordFP);
			 if(tempP)
			 {
				 free(tempP);
			 }
			
		
		}
		else
		{
			memset(audioBuff,0,33*4);
			nsamples = fread(audioBuff,1,33*4,vmsObjP->playRecordFP);
			if(nsamples<33*4)
			{
				vmsObjP->stopB = true;
			}
			index = 0;
			for ( i = 0; i < nsamples; i+= 33){
				gsm_decode(vmsObjP->playRecordObj,(gsm_byte *)(audioBuff + i),(short*) pcmP + index );
				
				index += 160;
			}
			
			*lengthP = index;
			
		
		}
	
	
	
	
	}

	return 0;
}
VmsPlayRecordType * vmsInit(unsigned long userData,AlertNotificationCallbackP alertNotiP,Boolean recordB)
{
	VmsPlayRecordType *vmsObjP;
	vmsObjP =(VmsPlayRecordType*) malloc(sizeof(VmsPlayRecordType));
	memset(vmsObjP,0,sizeof(VmsPlayRecordType));
	vmsObjP->recordB = recordB;
	vmsObjP->alertNotifyP = alertNotiP;
	vmsObjP->userData = userData;
	return vmsObjP;

}

int openPlayRecordFile(VmsPlayRecordType *vmsP,char *nameP,char *modeP)
{
	if(vmsP==0)
	{
		return 1;
	}
	vmsP->playRecordFP = fopen(nameP,modeP);
	if(vmsP->playRecordFP==0)
	{
		
		return -1;
	}
	return 0;
	

}
int vmsSetFilePlay(VmsPlayRecordType *vmsP,char *nameP,unsigned long *noSecP)
{
	long sz;
	if(openPlayRecordFile(vmsP,nameP,"rb")==0)
	{
		
		*noSecP = 20;
		fseek(vmsP->playRecordFP,0,SEEK_END);
		sz = ftell(vmsP->playRecordFP);
		*noSecP = sz/(1650);
		fseek(vmsP->playRecordFP,0,SEEK_SET);
		if(*noSecP==0)
		{	
			return 1;
		
		}	
		return 0;
	}
	return 1;
	
	
		
}
int vmsStartPlay(VmsPlayRecordType *vmsP)
{
	vmsP->playRecordObj = gsm_create();
	SetAudioTypeLocal(0,1);// play back
	SetSpeakerOnOrOff(0, 1);
	vmsP->aqRecordPlayPcm = InitAudio(vmsP, CallBackVmsUI, CallBackVmsSoundPCM);//playback
	if(CreateSoundThread(true,vmsP->aqRecordPlayPcm,false,0))
	{
		DeInitAudio( vmsP->aqRecordPlayPcm,false);
		vmsP->aqRecordPlayPcm = 0;
		return 1;
	}
	else
	{	
		//vmsP->aqRecordPlayPcm->playStartedB = true;
		PlayBuffStart(vmsP->aqRecordPlayPcm);
		PlayAudio(vmsP->aqRecordPlayPcm);
		return 0;
		
		
	}	
	
	
}
int vmsStopPlay(VmsPlayRecordType *vmsP)
{
	if(vmsP==0)
	{
		return 1;
	}
	return StopAudio(vmsP->aqRecordPlayPcm,false);	
	
}
int vmsSetFileRecord(VmsPlayRecordType *vmsP,char *nameP)
{
	if(openPlayRecordFile(vmsP,nameP,"wb")==0)
	{
		return 0;
	}
	return 1;
}

int vmsStartRecord(VmsPlayRecordType *vmsP)
{
		vmsP->playRecordObj = gsm_create();
		SetAudioTypeLocal(0,2);//record 
		vmsP->aqRecordPlayPcm = InitAudio(vmsP, CallBackVmsUI, CallBackVmsSoundPCM);//playback
		if(CreateSoundThread(false,vmsP->aqRecordPlayPcm,false,0))
		{
			DeInitAudio( vmsP->aqRecordPlayPcm,false);
			vmsP->aqRecordPlayPcm = 0;
			return 1;
			
		}
		else
		{	
			PlayAudio(vmsP->aqRecordPlayPcm);
			return 0;
		}	
	
	
}

int vmsStopRecord(VmsPlayRecordType *vmsP)
{
	return vmsStopPlay(vmsP);//both having same fp
	
}
void vmsDeInit(VmsPlayRecordType **vmspP)
{
	if(vmspP)
	{
		if(*vmspP)
		{
			if((*vmspP)->playRecordObj)
			{	
				gsm_destroy((*vmspP)->playRecordObj);
			}
			DeInitAudio( (*vmspP)->aqRecordPlayPcm,false);
			if((*vmspP)->playRecordFP)
			{	
				fclose((*vmspP)->playRecordFP);
				(*vmspP)->playRecordFP = 0;
				
			}
			
			free(*vmspP);
			*vmspP = 0;
		
		}
	}
}
