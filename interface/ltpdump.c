/*
 *  ltpdump.c
 *  spoknclient
 *
 *  Created by Mukesh Sharma on 15/07/09.
 *  Copyright 2009 Geodesic Ltd.. All rights reserved.
 *
 */

#include "ltpdump.h"
#include "string.h"
LtpRtpDumpType* CreateDumpFile(char *pathP,char *nameP,int pcmB)
{
	LtpRtpDumpType *ltprtpDumpP; 
	RiffHeaderType refTypeP;
	char *stP;
	ltprtpDumpP = malloc(sizeof(LtpRtpDumpType));
	
	InitRiffHeader(&refTypeP);
	
	stP = (char*)malloc(strlen(pathP)+strlen(nameP)+100);
	sprintf(stP,"%s\\play_%s",pathP,nameP);
	ltprtpDumpP->fpPlay = fopen(stP,"wb+");
	sprintf(stP,"%s\\record_%s",pathP,nameP);
	ltprtpDumpP->fprecord = fopen(stP,"wb+");
	free(stP);
	if(pcmB)
	{
		//write riff header
		WriteData(ltprtpDumpP->fprecord ,&refTypeP,sizeof(RiffHeaderType));
		WriteData(ltprtpDumpP->fpPlay ,&refTypeP,sizeof(RiffHeaderType));
	}
	return ltprtpDumpP;
	
	
	
}
int WriteDataPlay(LtpRtpDumpType *ltprtpDumpP,unsigned char *dataP,int sizeInt)
{
	if(ltprtpDumpP==0)
	{
		return 0;
	}
	return WriteData(ltprtpDumpP->fpPlay,dataP,sizeInt);
}
int WriteData(FILE *fp,unsigned char *dataP,int sizeDataInt)
{
	return fwrite(dataP,1,sizeDataInt,fp);
	
}
//return 0 if error or return actual size read
int ReadData(FILE *fp,unsigned char *dataP,int sizeDataInt)
{
	return fread(dataP,1,sizeDataInt,fp);
	
}
int WriteDataRecord(LtpRtpDumpType *ltprtpDumpP,unsigned char *dataP,int sizeInt)
{
	if(ltprtpDumpP==0)
	{
		return 0;
	}
	return WriteData(ltprtpDumpP->fprecord,dataP,sizeInt);
	
}
//set null to object after free
int CloseDumpFile(LtpRtpDumpType **ltprtpDumpP,int pcmB)
{
	LtpRtpDumpType *tmpLtp; 
	if(ltprtpDumpP==0)
	{
		return 1;
	}
	if(*ltprtpDumpP==0)
	{
		return 1;
	}
	tmpLtp = *ltprtpDumpP;
	if(pcmB)//now update riff header
	{
		RiffHeaderType refTypeP;
		long length;
		InitRiffHeader(&refTypeP);
		
		length = ftell(tmpLtp->fpPlay);
		UpdateRiffHeader(&refTypeP,1,8000,length);
		fseek(tmpLtp->fpPlay,0,SEEK_SET);
		
		WriteData(tmpLtp->fpPlay ,&refTypeP,sizeof(RiffHeaderType));
		fseek(tmpLtp->fpPlay,0,SEEK_SET);
		memset(&refTypeP,0,sizeof(RiffHeaderType));
		fread(&refTypeP,1,sizeof(RiffHeaderType),tmpLtp->fpPlay);
		InitRiffHeader(&refTypeP);
		
		length = ftell(tmpLtp->fprecord);
		UpdateRiffHeader(&refTypeP,1,8000,length);
		fseek(tmpLtp->fprecord,0,SEEK_SET);
		WriteData(tmpLtp->fprecord ,&refTypeP,sizeof(RiffHeaderType));
		fseek(tmpLtp->fprecord,0,SEEK_SET);
		memset(&refTypeP,0,sizeof(RiffHeaderType));
		fread(&refTypeP,1,sizeof(RiffHeaderType),tmpLtp->fpPlay);
		
		
		
	}
	fclose(tmpLtp->fpPlay);
	fclose(tmpLtp->fprecord);
	
	free(tmpLtp);
	*ltprtpDumpP = 0;
	return 0;
	
}
int ConvertFileToWav(char *srcFileP,char *destFileP,int codec)
{
	
}
int InitRiffHeader (RiffHeaderType* riffHeader)
{
	/*
	 *	RIFF Chunk ID 			= "RIFF"
	 *  RIFF Chunk Size			= to be modified
	 *  RIFF Chunk Format 		= "WAVE"
	 */
	memset(riffHeader,0,sizeof(RiffHeaderType));
	riffHeader->iRiffChunkID[0] = 'R';		// First RIFF chunk - 12 bytes
	riffHeader->iRiffChunkID[1] = 'I';
	riffHeader->iRiffChunkID[2] = 'F';
	riffHeader->iRiffChunkID[3] = 'F';
	riffHeader->iRiffChunkSize = 0;
	riffHeader->iRiffChunkFormat[0] = 'W';	// "WAVE"
	riffHeader->iRiffChunkFormat[1] = 'A';
	riffHeader->iRiffChunkFormat[2] = 'V';
	riffHeader->iRiffChunkFormat[3] = 'E';
	
	/*
	 *	fmt  Chunk ID 			= "fmt "
	 *  fmt  Chunk Size			= 20
	 *  fmt  Audio Format 		= 0x31 - GSM 06.10
	 *  fmt  Number of channels = 1 - Mono
	 *  fmt  Sample Rate 		= 8kHz sampling rate
	 *  fmt  Byte Rate			= 1625
	 *  fmt  Block Align		= 65
	 *  fmt  Bits Per Sample	= 2
	 */
	riffHeader->iFMTChunk[0] = 'f';		// Second chunk - "fmt "
	riffHeader->iFMTChunk[1] = 'm';
	riffHeader->iFMTChunk[2] = 't';
	riffHeader->iFMTChunk[3] = ' ';
	riffHeader->iFMTChunkSize = (16L);
	riffHeader->iFMTAudioFormat = (1);	// Needs to be modified later
	riffHeader->iFMTNumChannels = 0;	// Needs to be modified later
	riffHeader->iFMTSampleRate = 0;		// Needs to be modified later
	riffHeader->iFMTByteRate = 0;		// Needs to be modified later
	riffHeader->iFMTBlockAlign = 0;		// Needs to be modified later
	riffHeader->iFMTBitsPerSample = (16);
	
	
	/*
	 *	Fact Chunk ID 			= "data"
	 *  Fact Chunk Size			= to be modified
	 *	Fact No of Samples		= to be modified
	 */
	/*
	 riffHeader->iFactChunkID[0] = 'F';			// The "DATA" chunk
	 riffHeader->iFactChunkID[1] = 'A';
	 riffHeader->iFactChunkID[2] = 'C';
	 riffHeader->iFactChunkID[3] = 'T';
	 riffHeader->iFactChunkSize = ByteSwap32(4L);;
	 riffHeader->iFactNoOfSamples = 0; 	// Needs to be modified later
	 */
	/*
	 *	DATA Chunk ID 			= "data"
	 *  DATA Chunk Size			= to be modified
	 */
	riffHeader->iDataChunk[0] = 'd';			// The "DATA" chunk
	riffHeader->iDataChunk[1] = 'a';
	riffHeader->iDataChunk[2] = 't';
	riffHeader->iDataChunk[3] = 'a';
	riffHeader->iDataChunkSize = 0;
	
	return 0;
}


int UpdateRiffHeader (RiffHeaderType* riffHeader,int nochanel,int sampleRate,long sizeFile)
{
	long 				tempLong=0;
	
	//Lock the SoundType Handle
	
	
	riffHeader->iFMTNumChannels = nochanel;
	riffHeader->iFMTSampleRate = sampleRate;
	tempLong = sampleRate * (long) nochanel* 2; // (16 / 8);
	riffHeader->iFMTByteRate = (tempLong);
	tempLong = nochanel * 2 /* bits per sample 16/8*/ ;
	riffHeader->iFMTBlockAlign = tempLong;
	riffHeader->iRiffChunkSize = sizeFile+ sizeof (RiffHeaderType)-8;
	riffHeader->iDataChunkSize =sizeFile;
	
	
	return (0);
}
