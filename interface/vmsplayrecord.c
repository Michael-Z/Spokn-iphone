/*
 *  vmsplayrecord.c
 *  spoknclient
 *
 *  Created by Mukesh Sharma on 17/07/09.
 *  Copyright 2009 Geodesic Ltd.. All rights reserved.
 *
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
			// ////printf("\nspeex full length");
			// ltpSoundInput(ltPInterfaceP->ltpObjectP,(short*)pcmBufferP,length,true);
			 
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
				/*pcmLoopP =  pcmP + index ;
				for(j=0;j<160;++j)
				{
					*pcmLoopP = *pcmLoopP*8;
					pcmLoopP++;
					////printf("pcminc ");
				}*/
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
	////printf(nameP);
	if(openPlayRecordFile(vmsP,nameP,"rb")==0)
	{
		
		*noSecP = 20;
		fseek(vmsP->playRecordFP,0,SEEK_END);
		sz = ftell(vmsP->playRecordFP);
		*noSecP = sz/(1650);
		fseek(vmsP->playRecordFP,0,SEEK_SET);
		if(*noSecP==0)
		{	
			//printf("\n file size %ld ",sz);
			return 1;
		
		}	
		return 0;
	}
	return 1;
	
	
		
}
int vmsStartPlay(VmsPlayRecordType *vmsP)
{
	vmsP->playRecordObj = gsm_create();
	SetAudioTypeLocal(vmsP,0);// play back
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
		SetAudioTypeLocal(vmsP,0);//record 
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
