/*
 *  playpcm.h
 *  AVMeter
 *
 *  Created by Mukesh Sharma on 23/06/09.
 *  Copyright 2009 Geodesic Ltd.. All rights reserved.
 *
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
#endif

