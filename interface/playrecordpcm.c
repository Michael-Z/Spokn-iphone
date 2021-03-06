
//  Created   on 23/06/09.

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


#include "playrecordpcm.h"
#include "LtpInterface.h"
#import <AudioToolbox/AudioToolbox.h>
int onOrBlueTooth(int onBluetoothB)
{
	AudioSessionPropertyID blueToothStatus;
	UInt32 allowBluetoothInput = onBluetoothB;
	OSStatus err;
	/*#if kAudioSessionProperty_OverrideCategoryEnableBluetoothInput
	 blueTooth = kAudioSessionProperty_OverrideCategoryEnableBluetoothInput;
	 
	 #else
	 */
	blueToothStatus = 'cblu';
	
	//#endif
	int majorver =0,minor1ver=0,minor2ver=0;
	GetOsVersion(&majorver,&minor1ver,&minor2ver);
	if(majorver>=3 && minor1ver>0 )
	{	
		err = AudioSessionSetProperty(blueToothStatus, sizeof(allowBluetoothInput), &allowBluetoothInput);
		return 0;
		//HeadSetIsOn();
	}
	return 1;




}
int RouteAudio(void *uData,int optionInt)
{
	switch(optionInt)
	{
	
		case 1://bluetooth
			SetSpeakerOnOrOffNew(0,0);
			onOrBlueTooth(1);//off
			break;
		case 2: //iphone
			onOrBlueTooth(0);//off
			SetSpeakerOnOrOffNew(0,0);
			break;
		case 3://speaker
			SetSpeakerOnOrOffNew(0,1);
			break;
	
		case 4:
			onOrBlueTooth(1);
			if(HeadSetIsOn()==0)
			{
				SetSpeakerOnOrOffNew(0,1);
			}
			else
			{
				SetSpeakerOnOrOffNew(0,0);
			}
			
			break;
	
	}
	return 0;
}
int SetSpeakerOnOrOffNew(void *uData,Boolean onB)
{
		UInt32 route;
	
	
	route = onB ? kAudioSessionOverrideAudioRoute_Speaker : 
	 kAudioSessionOverrideAudioRoute_None;
	 AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, 
	 sizeof(route), &route);
	return 0;
	
}
int SetSpeakerOnOrOff(void *uData,Boolean onB)
{
//	UInt32 route;
	
	
	/*route = onB ? kAudioSessionOverrideAudioRoute_Speaker : 
	kAudioSessionOverrideAudioRoute_None;
	AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, 
							 sizeof(route), &route);*/
	return 0;
	
}	
int removePcmData(void *libData)
{
	int i;
	AQCallbackStruct *aqcP;
	if(libData==NULL)
		return 1;
	aqcP = (AQCallbackStruct*)libData;
	for(i=0;i<MAXArray;++i)
	{
		if(aqcP->pcmBuffArray[i].pcmBufferP)
		{	
			free(aqcP->pcmBuffArray[i].pcmBufferP);
		}
		aqcP->pcmBuffArray[i].pcmBufferP = 0;
		aqcP->pcmBuffArray[i].bufferLength = 0;
	}
	aqcP->frontCount = 0;
	aqcP->rearCount = 0; 
	return 0;
	
}
int AddPcmData(void *libData,sampleFrame *dataPtr,int length,Boolean playB)
{
	AQCallbackStruct *aqcP;
	int sz = MINSIZE;
	//int i;
	
	if(libData==NULL)
		return 1;
	//use some memory protection logic
	aqcP = (AQCallbackStruct*)libData;
	if(aqcP->stopB)
	{
		return 1;
	}
	if(aqcP->rearCount==MAXArray)
	{
		aqcP->rearCount = 0; 
		//return 2;
	}
	/*
	if(length<MINSIZE || aqcP->buffsizeInt>0)
	{
		memmove(aqcP->buffPcm+aqcP->buffsizeInt,dataPtr,length*2);//mul by 2 for byte
		aqcP->buffsizeInt =aqcP->buffsizeInt +length;
		if(aqcP->buffsizeInt<MINSIZE)
		{
			return 0;
		}
		dataPtr = aqcP->buffPcm;
		length = aqcP->buffsizeInt;
		
		aqcP->buffsizeInt = 0;
		
		
	}*/
	
	#ifdef _MAKE_NEW_MEMORY_ALWAYS_
		aqcP->pcmBuffArray[aqcP->rearCount].pcmBufferP = (sampleFrame*)malloc(length*sizeof(sampleFrame));
		
	#else
		if(sz<length*sizeof(sampleFrame))
		{
			sz = length*sizeof(sampleFrame)+4;//extra
			if(aqcP->pcmBuffArray[aqcP->rearCount].pcmBufferP)
			{
				free(aqcP->pcmBuffArray[aqcP->rearCount].pcmBufferP);
				aqcP->pcmBuffArray[aqcP->rearCount].pcmBufferP = 0;
			}
			
		}
		if(aqcP->pcmBuffArray[aqcP->rearCount].pcmBufferP==0)
		{
			aqcP->pcmBuffArray[aqcP->rearCount].pcmBufferP = (sampleFrame*)malloc(sz);
		}
	#endif
	aqcP->pcmBuffArray[aqcP->rearCount].bufferLength = length*sizeof(sampleFrame);
	memmove(aqcP->pcmBuffArray[aqcP->rearCount].pcmBufferP ,dataPtr,aqcP->pcmBuffArray[aqcP->rearCount].bufferLength);
	aqcP->rearCount++;
	if(aqcP->playStartedB==false && aqcP->rearCount>AUDIO_BUFFERS)
	{
		
		aqcP->frontCount = 0;
		PlayBuffStart(aqcP);
		
		
		AudioQueueStart( aqcP->queue,0);
	}
	return 0;
	
}
int  PlayBuffStart(AQCallbackStruct *aqcP)
{
	int i;
	if(aqcP==0)
	{
		return 1;
	}
	aqcP->playStartedB=true;
	for(i=0;i<AUDIO_BUFFERS;++i)
	{	
		AQBufferCallback(aqcP, aqcP->queue, aqcP->mBuffers[i]);
	}	
	return 0;
	
}

void SetAudioSessionPropertyListener( void *uDataP,AudioSessionPropertyListener        inProc)
{
	void *uglobalDataP;
	AudioSessionPropertyListener        inProcglobal;

//if(inProc)
	{
		inProcglobal = inProc;
	}
	//if(uDataP)
	{
		uglobalDataP = uDataP;
	}
	int majorver =0,minor1ver=0,minor2ver=0;
	GetOsVersion(&majorver,&minor1ver,&minor2ver);
	if(majorver>=3 && minor1ver>0 )
	{	
		AudioSessionAddPropertyListener(    kAudioSessionProperty_AudioRouteChange,
                                    inProcglobal,
                                   uglobalDataP); 
	
				
	}
		//AudioSessionAddPropertyListener(    kAudioSessionProperty_ServerDied,
     //                               inProcglobal,
          //                          uglobalDataP); 
	
	
}
void MyAudioSessionPropertyListener(
									void *                  inClientData,
									AudioSessionPropertyID	inID,
									UInt32                  inDataSize,
									const void *            inData);
void SetAudioTypeLocal(void *uData,int type)
{
	UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;//kAudioSessionCategory_MediaPlayback
	switch(type)
	{
		case 1://play back
			//sessionCategory = kAudioSessionCategory_MediaPlayback;
			sessionCategory = kAudioSessionCategory_PlayAndRecord;
			AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
			onOrBlueTooth(1);
			if(HeadSetIsOn()==0)
			{
				SetSpeakerOnOrOffNew(0,1);
			}
			else
			{
				SetSpeakerOnOrOffNew(0,0);
			}
			AudioSessionSetActive(true);
			return;
			break;
		case 2:// record
			sessionCategory = kAudioSessionCategory_RecordAudio;
			
			break;
		case 3:
			sessionCategory = kAudioSessionCategory_MediaPlayback;
			break;
		case 0: //play and record
			sessionCategory = kAudioSessionCategory_PlayAndRecord;
			break;
			
			
			
	}
	//this is added for iphone 3.0
	if(uData)
	{	
		//OSStatus propertySetError = 0;
		//UInt32 allowMixing = false;

		
		AudioSessionInitialize(0,0,AudioSessionInterruptionListenerClient,uData);
		AudioSessionSetActive(true);		
		/*propertySetError = AudioSessionSetProperty (
													kAudioSessionProperty_OverrideCategoryMixWithOthers,  // 1
													sizeof (allowMixing),                                 // 2
													&allowMixing                                          // 3
													);*/
		//kAudioSessionProperty_OverrideCategoryMixWithOthers
	}
/*	- (NSInteger) getMajorOSVersion {
		NSString *versionString = [[UIDevice currentDevice] systemVersion];
		return [[[versionString componentsSeparateByString:@"."] objectAtIndex:0] intValue];
	}
	*/
	
	AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);		//AudioQueueAddPropertyListener(aqcP->queue,kAudioQueueProperty_IsRunning,AudioQueuePropertyListenerFunction,aqcP);
#define _BLUETOOTH_SUPPORT
#ifdef _BLUETOOTH_SUPPORT
	if(sessionCategory == kAudioSessionCategory_PlayAndRecord || sessionCategory == kAudioSessionCategory_RecordAudio )
	{
		onOrBlueTooth(1);
	}
#endif
	
	//SetAudioSessionPropertyListener(0,0)
}
void* InitAudio( void *udata,CallBackUIP callBackP,CallBackSoundP callBackSoundP)
{
	AQCallbackStruct *aqcP;
	//UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;//kAudioSessionCategory_MediaPlayback
	
	//UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;//kAudioSessionCategory_MediaPlayback
	//AudioSessionSetActive(true);
	aqcP = (AQCallbackStruct*)malloc(sizeof(AQCallbackStruct));
	memset(aqcP,0,sizeof(AQCallbackStruct));
	aqcP->uData = udata;
	aqcP->CallBackUIP = callBackP;
	aqcP->callBackSoundP = callBackSoundP;
	aqcP->stopB = false;
	
	
	return aqcP;
}
void DeInitAudio(void *libData,Boolean deinitAQueueB )
{
	AQCallbackStruct *aqcP;
	
	if(libData==NULL)
		return ;
	aqcP = (AQCallbackStruct*)libData;
	if(deinitAQueueB)
	{	
		AudioQueueDispose(aqcP->queue, true);
	}
	if(aqcP->dataPtr)
	{
		free(aqcP->dataPtr);
	}
	removePcmData(aqcP);
	free(libData);
}
int PlayAudio(void *uData)
{
	int err;
	AQCallbackStruct *aqcP;
	if(uData==NULL)
		return 1;
	aqcP = (AQCallbackStruct*)uData;
	err = AudioQueueStart(aqcP->queue, NULL);
	return err;
	
	
}
int pauseAudio(void *uData)
{
	if(uData==NULL)
		return 1 ;
	AQCallbackStruct *aqcP;
	///int err;
	//UInt32		isRunning;
	aqcP = (AQCallbackStruct*)uData;
	AudioQueuePause(aqcP->queue);
	return 0;
	

}
int StopAudio(void *uData,Boolean inImmediateB)
{
	if(uData==NULL)
		return 1 ;
	AQCallbackStruct *aqcP;
	int err;
	UInt32		isRunning;
	aqcP = (AQCallbackStruct*)uData;
	aqcP->stopB = true;
	//AudioQueuePause (aqcP->queue);
	//AudioQueueFlush(aqcP->queue);
	UInt32		propertySize = sizeof (UInt32);
	
	OSStatus	result;
	result =	AudioQueueGetProperty (
									   aqcP->queue,
									   kAudioQueueProperty_IsRunning,
									   &isRunning,
									   &propertySize
									   );
		
	
	err = AudioQueueStop(aqcP->queue, inImmediateB);
	if(isRunning==false)
	{
		aqcP->stopB = true;
		if(aqcP->CallBackUIP)
		{	
			aqcP->CallBackUIP(aqcP->uData,aqcP->playBackB);
		}	
	}
	
	return err;
	
	
}

int playFile(void *uData,char *fileName)
{
	unsigned long len;
    int err;
	int ret,i=0;
	if(uData==NULL)
		return 1;
	AQCallbackStruct *aqcP;
	
	aqcP = (AQCallbackStruct*)uData;
	
	aqcP->dataPtr = loadpcm(fileName, &len);
    if (!aqcP->dataPtr) {
        fprintf(stderr, "%s: %s\n", fileName, strerror(errno));
        return 2;
    }
	aqcP->frameCount = SAMPLE_RATE/60;
    aqcP->sampleLen = len / BYTES_PER_SAMPLE;
    aqcP->playPtr = 0;
    //aqcP->pcmBuffer = pcmbuffer;
	aqcP->stopB = false;
	err = CreateSoundThread(true,aqcP,false,0);
	err = AudioQueueStart(aqcP->queue, NULL);
	while(len>0)
	{
		AddPcmData(uData,aqcP->dataPtr+i,2000,true);
		i=i+2000;
		if(i>len)
			break;
	}
    //ret = playbuffer(aqcP,aqcP->dataPtr, len);
	// free(pcmbuffer);
	return ret;
	
	
}


void *loadpcm(const char *filename, unsigned long *len) {
    FILE *file;
    static struct stat s;
    void *pcm;
	//s.st_size = 2000;
    if (stat(filename, &s))
        return NULL;
    *len = s.st_size;
    pcm = (void *) malloc(s.st_size);
    if (!pcm)
        return NULL;
    file = fopen(filename, "rb");
    if (!file) {
        free(pcm);
        return NULL;
    }
	fread(pcm,60, 1, file);
    fread(pcm, s.st_size-60, 1, file);
    fclose(file);
    return pcm;
}
void AudioInputCallback(
						void *                          inUserData,
						AudioQueueRef                   inAQ,
						AudioQueueBufferRef             inBuffer,
						const AudioTimeStamp *          inStartTime,
						UInt32                          inNumberPacketDescriptions,
						const AudioStreamPacketDescription *inPacketDescs)
{
	
	//mutexLockInterface();
	
	AudioInputCallbackLocal(inUserData,inAQ,inBuffer,inStartTime,inNumberPacketDescriptions,inPacketDescs);
	//mutexUnLockInterface();
}
void AudioInputCallbackLocal(
							 void *                          inUserData,
							 AudioQueueRef                   inAQ,
							 AudioQueueBufferRef             inBuffer,
							 const AudioTimeStamp *          inStartTime,
							 UInt32                          inNumberPacketDescriptions,
							 const AudioStreamPacketDescription *inPacketDescs)
{
	
	AQCallbackStruct *aqcP;
	unsigned int   sz;
	
	aqcP = (AQCallbackStruct *) inUserData;
	if(aqcP)
	{	
		if(aqcP->stopB)
		{
			return;
		}
		if(aqcP->callBackSoundP)
		{
			sz = inBuffer->mAudioDataByteSize>>1;
			
			aqcP->callBackSoundP(aqcP->uData,inBuffer->mAudioData,&sz,true);
		}
	}	
	AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
	
}
extern void alertNotiFication(int type,unsigned int lineID,int valSubLong, unsigned long userData,void *otherinfoP);
void AudioSessionInterruptionListenerClient(
										   void *                  inClientData,
										   UInt32                  inInterruptionState)
{
	
	
	if(inClientData)
	{
		alertNotiFication(INTERRUPT_ALERT,0,inInterruptionState,(unsigned long )inClientData,0);
		
	}
}
void removeAudioQueueListener(AQCallbackStruct *aqcP)
{
	AudioQueueRemovePropertyListener(aqcP->queue,kAudioQueueProperty_IsRunning,AudioQueuePropertyListenerFunction,aqcP);
	

}
int CreateSoundThread(int OutB,AQCallbackStruct *aqcP,Boolean sampleDataB,int samplesize)
{
	UInt32 err;
	int i,bufferSize;
	
	if(sampleDataB==0)
	{	
		aqcP->mDataFormat.mSampleRate = SAMPLE_RATE;
		aqcP->mDataFormat.mFormatID = kAudioFormatLinearPCM;
		aqcP->mDataFormat.mFormatFlags =
		kLinearPCMFormatFlagIsSignedInteger
		| kAudioFormatFlagIsPacked;
		aqcP->mDataFormat.mBytesPerPacket = NOBYTE;
		aqcP->mDataFormat.mFramesPerPacket = 1;
		aqcP->mDataFormat.mBytesPerFrame = NOBYTE;
		aqcP->mDataFormat.mChannelsPerFrame = NOCHANNNEL;
		aqcP->mDataFormat.mBitsPerChannel = 16;
		aqcP->frameCount = 3200;
		//aqcP->frameCount = SAMPLE_RATE/60;
		//aqcP->sampleLen = len / BYTES_PER_SAMPLE;
	}	
	if(OutB)
	{	
		err = AudioQueueNewOutput(&aqcP->mDataFormat,
								  AQBufferCallback,
								  aqcP,
								  NULL,
								  kCFRunLoopDefaultMode,
								  0,
								  &aqcP->queue);
		bufferSize = aqcP->frameCount * aqcP->mDataFormat.mBytesPerFrame;
		if(samplesize)
		{
			bufferSize = samplesize;
		}
		aqcP->playBackB = true;
		
		
	}
	else
	{
		err = AudioQueueNewInput(&aqcP->mDataFormat,
								 AudioInputCallback,
								 aqcP,
								 NULL,
								 kCFRunLoopDefaultMode,
								 0,
								 &aqcP->queue);
		
		bufferSize = 640*2;
		if(samplesize)
		{
			bufferSize = samplesize;
		}
		aqcP->playBackB = false;
	}
	for (i=0; i<AUDIO_BUFFERS; i++) {
		err = AudioQueueAllocateBuffer(aqcP->queue, bufferSize,
									   &aqcP->mBuffers[i]);
		if(err)
		{
			return err;
		}
		if(OutB==false)
		{	
			AudioQueueEnqueueBuffer( aqcP->queue, aqcP->mBuffers[i], 0, NULL);
		}	
	}
	AudioQueueAddPropertyListener(aqcP->queue,kAudioQueueProperty_IsRunning,AudioQueuePropertyListenerFunction,aqcP);
	
	if (err)
        return err;
	return 0;
	
}
int playbuffer(AQCallbackStruct *aqcP ,void *pcmbuffer, unsigned long len) {
	UInt32 err;//, bufferSize;
	//    int i;
	
	/* aqcP->mDataFormat.mSampleRate = SAMPLE_RATE;
	 aqcP->mDataFormat.mFormatID = kAudioFormatLinearPCM;
	 aqcP->mDataFormat.mFormatFlags =
	 kLinearPCMFormatFlagIsSignedInteger
	 | kAudioFormatFlagIsPacked;
	 aqcP->mDataFormat.mBytesPerPacket = NOBYTE;
	 aqcP->mDataFormat.mFramesPerPacket = 1;
	 aqcP->mDataFormat.mBytesPerFrame = NOBYTE;
	 aqcP->mDataFormat.mChannelsPerFrame = NOCHANNNEL;
	 aqcP->mDataFormat.mBitsPerChannel = 16;*/
	
    aqcP->frameCount = SAMPLE_RATE/60;
    aqcP->sampleLen = len / BYTES_PER_SAMPLE;
    aqcP->playPtr = 0;
    aqcP->pcmBuffer = pcmbuffer;
	aqcP->stopB = false;
	err = CreateSoundThread(true,aqcP,false,0);
	if (err)
		return err;
	
	/*  err = AudioQueueNewOutput(&aqcP->mDataFormat,
	 AQBufferCallback,
	 aqcP,
	 NULL,
	 kCFRunLoopCommonModes,
	 0,
	 &aqcP->queue);
	 if (err)
	 return err;
	 */
    //aqcP->frameCount = FRAME_COUNT;
	
	// bufferSize = aqcP->frameCount * aqcP->mDataFormat.mBytesPerFrame;
	// for (i=0; i<AUDIO_BUFFERS; i++) {
	//err = AudioQueueAllocateBuffer(aqcP->queue, bufferSize,
	//							   &aqcP->mBuffers[i]);
	//  if (err)
	//      return err;
	//  AQBufferCallback(aqcP, aqcP->queue, aqcP->mBuffers[i]);
	// }
	
	//AudioQueueAddPropertyListener(aqcP->queue,kAudioQueueProperty_IsRunning,AudioQueuePropertyListenerFunction,aqcP);
    err = AudioQueueStart(aqcP->queue, NULL);
    if (err)
        return err;
	//sleep(10);
	// while(aqcP->playPtr < aqcP->sampleLen) { select(NULL, NULL, NULL, NULL, 1.0); }
	//AudioQueueStop(aqc, true);
	//	AudioQueueDispose(aqcP->queue, true);
	
	//sleep(10);
    return 0;
}
void AudioQueuePropertyListenerFunction(  
										void *                  inUserData,
										AudioQueueRef           inAQ,
										AudioQueuePropertyID    inID)
{
	
	
	UInt32		isRunning;
	UInt32		propertySize = sizeof (UInt32);
	
	OSStatus	result;
	
	AQCallbackStruct *aqcP;
	aqcP = (AQCallbackStruct *) inUserData;
	
	if(inID==kAudioQueueProperty_IsRunning)
	{	  
		result =	AudioQueueGetProperty (
										   inAQ,
										   kAudioQueueProperty_IsRunning,
										   &isRunning,
										   &propertySize
										   );
		
		if (result == noErr) {
			
			if(!isRunning)
			{
				aqcP->stopB = true;
				if(aqcP->CallBackUIP)
				{	
					aqcP->CallBackUIP(aqcP->uData,aqcP->playBackB);
				}	
				//AudioQueueDispose(inAQ, true);
				
				
			}
		}
	}
	
}

void AQBufferCallback(
					  void *in,
					  AudioQueueRef inQ,
					  AudioQueueBufferRef outQB)
{
	
	
	//	mutexLockInterface();
	AQBufferCallbackLocal(in,inQ,outQB);
	//mutexUnLockInterface();
}

void AQBufferCallbackLocal(
						   void *in,
						   AudioQueueRef inQ,
						   AudioQueueBufferRef outQB)
{
    AQCallbackStruct *aqcP;
    sampleFrame *coreAudioBuffer;
	unsigned int sz;
	// short sample;
	// int i;
	
    aqcP = (AQCallbackStruct *) in;
    coreAudioBuffer = (sampleFrame*) outQB->mAudioData;
	if(aqcP==0)
		return;
	if(aqcP->stopB)
	{
		outQB->mAudioDataByteSize = 1200 ;
		memset(coreAudioBuffer,0,1200);
		AudioQueueEnqueueBuffer(inQ, outQB, 0, NULL);
		return;
	}
	
	if(aqcP->callBackSoundP)
	{
		if(aqcP->playStartedB==false)
		{
			outQB->mAudioDataByteSize = 1200 ;
			memset(coreAudioBuffer,0,1200);
			AudioQueueEnqueueBuffer(inQ, outQB, 0, NULL);
			return;
		}
		sz = outQB->mAudioDataByteSize/2;
		if(aqcP->callBackSoundP(aqcP->uData,coreAudioBuffer,&sz,false))
		{
			aqcP->stopB = true;
			aqcP->playStartedB = false;
			
			
		}
		outQB->mAudioDataByteSize = sz*2;
		AudioQueueEnqueueBuffer(inQ, outQB, 0, NULL);
		return;
	}
	if(aqcP->frontCount==MAXArray)
	{
		aqcP->frontCount = 0;
	}
	if(aqcP->frontCount==aqcP->rearCount && aqcP->playStartedB==true)
	{
		aqcP->frontCount = 0;
		aqcP->rearCount = 0;
		//aqcP->playStartedB=false;
		outQB->mAudioDataByteSize = 1200 ;
		memset(coreAudioBuffer,0,1200);
		AudioQueueEnqueueBuffer(inQ, outQB, 0, NULL);
		
		return;
	}
	if(aqcP->playStartedB==false)
	{
		outQB->mAudioDataByteSize = 1200 ;
		memset(coreAudioBuffer,0,1200);
		AudioQueueEnqueueBuffer(inQ, outQB, 0, NULL);
		return;
	}
	outQB->mAudioDataByteSize = aqcP->pcmBuffArray[aqcP->frontCount].bufferLength ;
	if(outQB->mAudioDataByteSize==0)
	{
		
	}
	memmove(coreAudioBuffer,aqcP->pcmBuffArray[aqcP->frontCount].pcmBufferP ,aqcP->pcmBuffArray[aqcP->frontCount].bufferLength);
	#ifdef _MAKE_NEW_MEMORY_ALWAYS_
		free(aqcP->pcmBuffArray[aqcP->frontCount].pcmBufferP)	;
		aqcP->pcmBuffArray[aqcP->frontCount].pcmBufferP = 0;
	#endif
		aqcP->pcmBuffArray[aqcP->frontCount].bufferLength = 0;
	
	aqcP->frontCount++;
	AudioQueueEnqueueBuffer(inQ, outQB, 0, NULL);
    
}

