
//  Created on 21/01/10.


/**
  Copyright 2009, 2010 Geodesic Limited. <http://www.geodesic.com/>
 
 Spokn for iPhone and iPod Touch.
 
 This file is part of Spokn for iPhone.
 
 Spokn for iPhone is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 Spokn for iPhone is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Spokn for iPhone.  If not, see <http://www.gnu.org/licenses/>.
 */

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#include <AudioToolbox/AudioToolbox.h>
#define DEFAULT_VOLUME 0.5
#define NOT_PLAY_AUDIO_FILE
@interface SpoknAudio : NSObject<AVAudioPlayerDelegate> {
	AVAudioPlayer *playP;
	SystemSoundID soundFileObject;
}
//alert sound inter face

-(int) stopSoundUrl;
-(int) playSoundUrl;

+ (SpoknAudio*) createSoundPlaybackUrl:(NSString*)pathP play:(int)playB;
+(int) destorySoundUrl:(SpoknAudio**)spoknAudioPP;
-(int) setUrlToPlay:(NSString*)pathP;
-(void) repeatPlay:(int)valInt;
-(void) setvolume:(float)valFloat;
@end
