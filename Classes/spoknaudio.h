//
//  spoknaudio.h
//  spokn
//
//  Created by Mukesh Sharma on 21/01/10.
//  Copyright 2010 Geodesic Ltd.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define DEFAULT_VOLUME 1.0
@interface SpoknAudio : NSObject {
	AVAudioPlayer *playP;

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
