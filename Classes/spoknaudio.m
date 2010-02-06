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


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	printf("\n finish %d",flag);

}
+ (SpoknAudio*) createSoundPlaybackUrl:(NSString*)pathP play:(int)playB
{
	#ifdef NOT_PLAY_AUDIO_FILE
		return nil;
	#endif
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: pathP];
	if(fileURL==nil)
	{
		return 0;
	}
	SpoknAudio *spoknAudioP = [[SpoknAudio alloc] init];
	spoknAudioP->playP = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
	spoknAudioP->playP.delegate = self;
	spoknAudioP->playP.volume = DEFAULT_VOLUME;

	if(playB)
	{
		[spoknAudioP->playP play];
		
	//	printf("\n play retain count %d",[spoknAudioP->playP retainCount]);
	}
		[fileURL release];
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
	[fileURL release];
	return 0;
}
-(int) stopSoundUrl
{
	if(playP==0) return 1;
	if(playP.isPlaying)
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
		//	printf("\n before stop retain count %d",[localspoknAudioP->playP retainCount]);
			[localspoknAudioP stopSoundUrl];
			//printf("\n stop retain count %d",[localspoknAudioP->playP retainCount]);
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
	[self stopSoundUrl];
	[self->playP release];
	self->playP = nil;
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
