
//  Created on 27/09/09.

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

#import <UIKit/UIKit.h>

@protocol KeypadProtocol

@optional
- (void)keyPressedDown:(NSString *)stringkey keycode:(int)keyVal;
- (void)keyPressedUp:(NSString *)stringkey keycode:(int)keyVal;

@end

@interface Keypadview : UIView {
	int objectId;
	int ydiff;
	int xdiff;
	NSString *dataStringP;
	UIImage *keypadImageP;
	UIImage *pressedImageP;
	int touchDown;
	int elementx;
	int elementy;
	float elementWidth;
	float elementHeight;
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
