//
//  spoknaudio.m
//  spokn
//
//  Created by Mukesh Sharma on 21/01/10.
//  Copyright 2010 Geodesic Ltd.. All rights reserved.
//

#import "spoknaudio.h"
#import <AVFoundation/AVFoundation.h>


@implementation SpoknAudio

+ (SpoknAudio*) createSoundPlaybackUrl:(NSString*)pathP play:(int)playB
{
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: pathP];
	if(fileURL==nil)
	{
		return 0;
	}
	SpoknAudio *spoknAudioP = [[SpoknAudio alloc] init];
	spoknAudioP->playP = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
	if(playB)
	{
		[spoknAudioP->playP play];
	}
	spoknAudioP->playP.volume = DEFAULT_VOLUME;
	return spoknAudioP;
}
-(int) setUrlToPlay:(NSString*)pathP
{
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: pathP];
	if(fileURL==nil)
	{
		return 1;
	}
	self->playP = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
	if(self->playP==nil)
		return 1;
	self->playP.volume = DEFAULT_VOLUME;
	return 0;
}
-(int) stopSoundUrl
{
	if(playP==0) return 1;
	[playP stop];
	return 0;
}
-(int) playSoundUrl
{
	if(playP==0) return 1;
	[playP play];
	return 0;
}
+(int) destorySoundUrl:(SpoknAudio**)spoknAudioPP
{
	if(spoknAudioPP)
	{
		SpoknAudio *localspoknAudioP;
		localspoknAudioP = *spoknAudioPP;
		if(localspoknAudioP)
		{	
			[localspoknAudioP->playP stop];
			[localspoknAudioP->playP release];
			localspoknAudioP->playP = nil;
			[localspoknAudioP release];
		}	
		*spoknAudioPP = 0;
		return 0;
		
	}
	return 1;
}
- (void)dealloc {
	[self->playP stop];
	[self->playP release];
    [super dealloc];
	
}
-(void)setvolume:(float)valFloat
{
	self->playP.volume = valFloat;
}
-(void) repeatPlay:(int)valInt
{
	self->playP.numberOfLoops = valInt;
}

@end
