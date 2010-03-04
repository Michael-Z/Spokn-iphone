
//  Created on 21/01/10.


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

#import "spoknaudio.h"
#import <AVFoundation/AVFoundation.h>


@implementation SpoknAudio


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{

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
			[localspoknAudioP stopSoundUrl];
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
