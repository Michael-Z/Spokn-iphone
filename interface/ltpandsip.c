/*
 *  ltpandsip.c
 *  spokn
 *
 *  Created by Mukesh Sharma on 27/10/09.
 *  Copyright 2009 Geodesic Ltd.. All rights reserved.
 *
 */

#include "ltpandsip.h"
#ifdef _LTP_
#include "ltpmobile.c"
#else
#include "sipwrapper.c"
#endif
#ifdef _CALLBACKLTP_
LtpCallBackPtr gltpCallBackP;
#endif
#ifdef _CALLBACKLTP_

void SetLtpCallBack(struct ltpStack *ps,LtpCallBackPtr ltpCallbackPtr)
{
	if(ltpCallbackPtr)
	{	
		if(ps->ltpCallbackPtr==0)
		{
			ps->ltpCallbackPtr = (LtpCallBackPtr)malloc(sizeof(LtpCallBackType));
			
		}
		gltpCallBackP = ps->ltpCallbackPtr;
		
		*ps->ltpCallbackPtr = *ltpCallbackPtr;
	}	
}
void ResetLtpCallback(struct ltpStack *ps)
{
	if(ps->ltpCallbackPtr)
	{
		free(ps->ltpCallbackPtr);
		ps->ltpCallbackPtr = 0;
		gltpCallBackP = 0;
	}
}
unsigned int32 lookupDNS(char *host)
{
	
	if(gltpCallBackP)
	{
		if(gltpCallBackP->alertCallBackPtr)
			return gltpCallBackP->lookDnsCallBackPtr(gltpCallBackP->uData,host);
	}
	return 0;
	
}
void alert(int lineid, int alertcode, void *data)
{
	if(gltpCallBackP)
	{
		if(gltpCallBackP->alertCallBackPtr)
			return gltpCallBackP->alertCallBackPtr(gltpCallBackP->uData,lineid,alertcode,data);
	}
}

int netWrite(void *msg, int length, unsigned int32 address, unsigned short16 port)
{
	if(gltpCallBackP)
	{
		if(gltpCallBackP->netWriteCallBackPtr)
			return gltpCallBackP->netWriteCallBackPtr(gltpCallBackP->uData,msg,length,address,port);
	}
	return 0;
}

void outputSound(struct ltpStack *ps, struct Call *pc, short *pcm, int length)
{
	if(gltpCallBackP)
	{
		if(gltpCallBackP->outputSoundCallBackPtr)
			return gltpCallBackP->outputSoundCallBackPtr(gltpCallBackP->uData,ps,pc,pcm,length);
	}
}
int openSound(int isFullDuplex)
{
	if(gltpCallBackP)
	{
		if(gltpCallBackP->openSoundCallBackPtr)
			return	 gltpCallBackP->openSoundCallBackPtr(gltpCallBackP->uData,isFullDuplex);
	}
	return 0;
}
void closeSound()
{
	if(gltpCallBackP)
	{
		if(gltpCallBackP->closeSoundCallBackPtr)
			gltpCallBackP->closeSoundCallBackPtr(gltpCallBackP->uData);
	}
	return ;
}
#endif
