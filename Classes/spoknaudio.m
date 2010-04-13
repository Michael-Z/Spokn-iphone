
//  Created on 21/01/10.


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
#import "spoknaudio.h"
#import <AVFoundation/AVFoundation.h>


@implementation SpoknAudio


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{

}
-(SpoknAudio*)init
{
	self = [super init];
	self->soundFileObject = 0;
	self->playP = nil;
	return self;
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
	#ifdef _PLAY_SYSTEM_SOUND_
		
	#else
		spoknAudioP->playP = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
		spoknAudioP->playP.delegate = self;
		spoknAudioP->playP.volume = DEFAULT_VOLUME;
	
		if(playB)
		{
			[spoknAudioP->playP play];
			
		}
	
	#endif
	[fileURL release];
	return spoknAudioP;
}
-(int)setUrlToPlayFromSystemSound:(CFURLRef )soundFileURLRef
{
	
	#ifdef _PLAY_SYSTEM_SOUND_
	if(soundFileURLRef)
	{	
		return 	AudioServicesCreateSystemSoundID (
										  soundFileURLRef,
										  &soundFileObject
										  );
	}
	#endif	
	return 1;
	
}
-(int) setUrlToPlay:(NSString*)pathP
{

	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: pathP];
	if(fileURL==nil)
	{
		return 1;
	}
	#ifdef _PLAY_SYSTEM_SOUND_
			
	#else
		self->playP = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
		if(self->playP==nil)
			return 1;
		self->playP.volume = DEFAULT_VOLUME;
	#endif	
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
	
#ifdef _PLAY_SYSTEM_SOUND_
	if(soundFileObject)
	{
		AudioServicesPlaySystemSound (self->soundFileObject);
	}
#else
	if(playP==0) return 1;
	[playP play];
#endif	
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
	if(self->soundFileObject)
	{	
		AudioServicesDisposeSystemSoundID (self->soundFileObject);
		self->soundFileObject = 0;
	}	
	[self stopSoundUrl];
	[self->playP release];
	self->playP = nil;
    [super dealloc];
	
}
-(void)setvolume:(float)valFloat
{
	if(self->playP)
	self->playP.volume = valFloat;
}
-(void) repeatPlay:(int)valInt
{
	if(self->playP)
	self->playP.numberOfLoops = valInt;
}

@end
