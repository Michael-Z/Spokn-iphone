
//  Created on 27/09/09.

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

#import <UIKit/UIKit.h>

@protocol KeypadProtocol

@optional
- (void)keyPressedDown:(NSString *)stringkey keycode:(int)keyVal;
- (void)keyPressedUp:(NSString *)stringkey keycode:(int)keyVal;

@end

@interface Keypadview : UIView {
	int objectId;
	NSString *dataStringP;
	UIImage *keypadImageP;
	UIImage *pressedImageP;
	int touchDown;
	int elementx;
	int elementy;
	int elementWidth;
	int elementHeight;
	CGRect rectchange;
	id<KeypadProtocol> keypadProtocolP;
	NSTimer *_plusTimer;

}
-(void)setElement:(int)lelementx :(int)lelementy;
-(void)setImage:(NSString *)normalImgP : (NSString *)pressedImgP;
- (void)handleKeyPressAndHold;
- (void)stopTimer;
@property(nonatomic,readwrite,assign) id<KeypadProtocol> keypadProtocolP;
@property(nonatomic,readwrite,copy) NSString *dataStringP;
@property(nonatomic,readwrite,assign) int objectId;		
@end
