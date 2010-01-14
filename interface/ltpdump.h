
//  Created on 15/07/09.

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

#ifndef _LTP_RTP_DUMP_
#define _LTP_RTP_DUMP_
#ifdef __cplusplus
extern "C" {
#endif 
#include "stdio.h"
	
	typedef struct RiffHeaderType
		{
			unsigned char	iRiffChunkID[4];		// First RIFF chunk - 12 bytes
			int	iRiffChunkSize;
			unsigned char	iRiffChunkFormat[4];	// "WAVE"
			
			unsigned char	iFMTChunk[4];			// Second chunk - "fmt "
			int	iFMTChunkSize;
			unsigned short	iFMTAudioFormat;
			unsigned short	iFMTNumChannels;
			int	iFMTSampleRate;
			int	iFMTByteRate;
			unsigned short	iFMTBlockAlign;
			unsigned short	iFMTBitsPerSample;
			unsigned short   extraFormat;
			unsigned short   extraFormatSP;
			
			
			unsigned char	iFactChunkID[4];		// "fact" chunk
			unsigned int	iFactChunkSize;
			unsigned int	iFactNoOfSamples;
			
			
			unsigned char	iDataChunk[4];			// The "DATA" chunk
			unsigned int	iDataChunkSize;
			//unsigned char	silientChunk[4];		
		} RiffHeaderType;
	typedef struct LtpRtpDumpType
		{
			FILE *fpPlay;
			FILE *fprecord;
			
			
			
		}LtpRtpDumpType;
	LtpRtpDumpType* CreateDumpFile(char *pathP,char *nameP,int pcmB);
	int WriteDataPlay(LtpRtpDumpType *ltpdumpP,unsigned char *dataP,int sizeInt);
	int WriteData(FILE *fp,unsigned char *dataP,int sizeDataInt);
	//return 0 if error or return actual size read
	int ReadData(FILE *fp,unsigned char *dataP,int sizeDataInt);
	int WriteDataRecord(LtpRtpDumpType *ltpdumpP,unsigned char *dataP,int sizeInt);
	//set null to object after free
	int CloseDumpFile(LtpRtpDumpType **ltpdumpP,int pcmB);
	int ConvertFileToWav(char *srcFileP,char *destFileP,int codec);
	int InitRiffHeader (RiffHeaderType* riffHeader);
#ifdef __cplusplus
}
#endif 
#endif