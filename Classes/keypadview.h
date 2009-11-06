//
//  keypadview.h
//  spokn
//
//  Created by KD on 27/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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

}
-(void)setElement:(int)lelementx :(int)lelementy;
-(void)setImage:(NSString *)normalImgP : (NSString *)pressedImgP;
@property(nonatomic,readwrite,assign) id<KeypadProtocol> keypadProtocolP;
@property(nonatomic,readwrite,copy) NSString *dataStringP;
@property(nonatomic,readwrite,assign) int objectId;		
@end
