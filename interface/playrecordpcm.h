
// Created on 23/06/09.
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

#ifndef _PLAYPCM_H_
#define _PLAYPCM_H_
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/stat.h>
#include <AudioToolbox/AudioQueue.h>
#include <AudioToolbox/AudioServices.h>
#define MAXArray 20
#define INTERRUPT_ALERT 4234
#define BYTES_PER_SAMPLE 2 
#define SAMPLE_RATE 8000
#define NOCHANNNEL   1
#define NOBYTE		(NOCHANNNEL*2)
typedef unsigned short sampleFrame;
//#define _MAKE_NEW_MEMORY_ALWAYS_
#define FRAME_COUNT 735
#define AUDIO_BUFFERS 3
#define MINSIZE 2000
typedef struct PcmBufferType
	{
		sampleFrame *pcmBufferP;
		long bufferLength;
	}PcmBufferType;

typedef int (*CallBackSoundP)(void *uData,sampleFrame *pcmBufferP,unsigned int *lengthP,Boolean recordB);
typedef int (* CallBackUIP)(void *uData,Boolean stopB);
typedef struct AQCallbackStruct {
    AudioQueueRef queue;
    UInt32 frameCount;
    AudioQueueBufferRef mBuffers[AUDIO_BUFFERS];
    AudioStreamBasicDescription mDataFormat;
    UInt32 playPtr;
    UInt32 sampleLen;
    sampleFrame *pcmBuffer;
	Boolean stopB;
	unsigned short *dataPtr;
	Boolean playStartedB;
	PcmBufferType pcmBuffArray[MAXArray];
	int frontCount;
	int rearCount;
	void *uData;
	CallBackUIP CallBackUIP;
	CallBackSoundP callBackSoundP;
//	unsigned short buffPcm[MINSIZE*4];
	int buffsizeInt;
	Boolean playBackB;
} AQCallbackStruct;

void *loadpcm(const char *filename, unsigned long *len);
int playbuffer(AQCallbackStruct *aqcP,void *pcm, unsigned long len);
void AQBufferCallback(void *in, AudioQueueRef inQ, AudioQueueBufferRef outQB);

void* InitAudio(void *udata,CallBackUIP callBackP,CallBackSoundP callBackSoundP);
void DeInitAudio(void *libData,Boolean deinitAQueueB );
int PlayAudio(void *uData);
int StopAudio(void *uData,Boolean inImmediateB);
int AddPcmData(void *UData,sampleFrame *dataPtr,int length,Boolean playB);

int playFile(void *uData,char *fileName);
int  PlayBuffStart(AQCallbackStruct *aqcP);
void AudioQueuePropertyListenerFunction(  
										void *                  inUserData,
										AudioQueueRef           inAQ,
										AudioQueuePropertyID    inID);
int CreateSoundThread(int OutB,AQCallbackStruct *aqcP,Boolean sampleDataB,int buffsize);
void AudioInputCallback(
						void *                          inUserData,
						AudioQueueRef                   inAQ,
						AudioQueueBufferRef             inBuffer,
						const AudioTimeStamp *          inStartTime,
						UInt32                          inNumberPacketDescriptions,
						const AudioStreamPacketDescription *inPacketDescs);
void AudioInputCallbackLocal(
							 void *                          inUserData,
							 AudioQueueRef                   inAQ,
							 AudioQueueBufferRef             inBuffer,
							 const AudioTimeStamp *          inStartTime,
							 UInt32                          inNumberPacketDescriptions,
							 const AudioStreamPacketDescription *inPacketDescs);
void AQBufferCallbackLocal(
						   void *in,
						   AudioQueueRef inQ,
						   AudioQueueBufferRef outQB);
void AudioSessionInterruptionListenerClient(
										   void *                  inClientData,
										   UInt32                  inInterruptionState);
void SetAudioTypeLocal(void *uData,int type);
int SetSpeakerOnOrOff(void *uData,Boolean onB);
void SetAudioSessionPropertyListener( void *uDataP,AudioSessionPropertyListener        inProc);
int SetSpeakerOnOrOffNew(void *uData,Boolean onB);
int RouteAudio(void *uData,int optionInt);
int onOrBlueTooth(int onBluetoothB);
int GetOsVersion(int *majorP,int *minor1P,int *minor2P);
int HeadSetIsOn();
int pauseAudio(void *uData);

#endif

