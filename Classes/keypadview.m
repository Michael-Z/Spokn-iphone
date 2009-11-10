//
//  keypadview.m
//  spokn
//
//  Created by KD on 27/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "keypadview.h"


@implementation Keypadview
@synthesize objectId;
@synthesize dataStringP;
@synthesize keypadProtocolP;
-(void)setElement:(int)lelementx :(int)lelementy
{
	elementx = lelementx;
	elementy = lelementy;
	elementWidth = self.bounds.size.width/elementx;
	elementHeight = self.bounds.size.height/elementy;
	NSLog(@"\n element taken %f %f ",elementWidth,elementHeight);
		
}	

-(void)setImage:(NSString *)normalImgP :(NSString *)pressedImgP
{
	keypadImageP = [[UIImage imageNamed:normalImgP] retain];
	pressedImageP = [[UIImage imageNamed:pressedImgP] retain];
	CGRect tmpBound;
	tmpBound = self.bounds;
//	NSLog(@"\n normal %f %f ",keypadImageP.size.width,keypadImageP.size.height);
	//NSLog(@"\n pressed %f %f ",pressedImageP.size.width,pressedImageP.size.height);
	//NSLog(@"\n bound %f %f ",tmpBound.size.width,tmpBound.size.height);
	
	tmpBound.size.width = keypadImageP.size.width;
	tmpBound.size.height = keypadImageP.size.height;
	self.bounds = tmpBound;
	tmpBound = self.frame;
	tmpBound.size.width = keypadImageP.size.width;
	tmpBound.size.height = keypadImageP.size.height;

	self.frame = tmpBound;
	//self.backgroundColor = [UIColor redColor];

}
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
	touchDown = 0;
	    return self;
}
- (void)stopTimer
{
	if (_plusTimer)
	{
		[_plusTimer invalidate];
		[_plusTimer release];
		_plusTimer = NULL;
	}
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	touchDown = 1;
	int row;
	int col;
	NSString *keyStrs[] = { @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"*", @"0", @"#"};
	char keyValues[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'};
	int arrayPos;
	
	
	
	NSEnumerator *enumerator = [touches objectEnumerator];
	UITouch *touch;
	
	while ((touch = [enumerator nextObject])) 
	{
		CGPoint point = [touch locationInView:self];
		
	//	NSLog(@"\npoint x=%f y=%f\n",point.x,point.y);
		row =  point.y/self->elementHeight;
		col = point.x/self->elementWidth;

		NSLog(@"\n%f %f",point.x*4/self.bounds.size.width,point.y*4/self.bounds.size.height);
		rectchange.origin.x = col*elementWidth;
		rectchange.origin.y = row*elementHeight;
		rectchange.size.width = elementWidth;
		rectchange.size.height = elementHeight;
		arrayPos = row*elementx+col;
		printf("%d",  arrayPos);
		if(arrayPos<12)
		{	
			NSLog(@"\n%@ %c",keyStrs[arrayPos],keyValues[arrayPos]);
			NSString *curTest = keyStrs[arrayPos];
			if([curTest isEqualToString:@"0"])
			{
				_plusTimer = [[NSTimer scheduledTimerWithTimeInterval:0.2 target:self 
															 selector:@selector(handleKeyPressAndHold) 
															 userInfo:nil 
															  repeats:YES] retain];
			}	
			[keypadProtocolP keyPressedDown:keyStrs[arrayPos] keycode:keyValues[arrayPos] ];
		}	
	}
	[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self stopTimer];
	[super touchesBegan:touches withEvent:event];
	touchDown = 0;
	[self setNeedsDisplay];

	
}
- (void)handleKeyPressAndHold
{
	//[numberlebelP setText: [curText stringByAppendingString: @"+"]];
	[keypadProtocolP keyPressedDown:@"+" keycode:0 ];
	[self stopTimer];
}
- (void)drawRect:(CGRect)rect {
	/*UIFont *fntP;
	UIColor *txtColor;
	CGContextRef context = UIGraphicsGetCurrentContext(); 
	if(touchDown==0)
	{	
		CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0,1.0); 
		CGContextFillRect(context, rect);
		txtColor = [UIColor whiteColor];
	}
	else
	{
		CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0,1.0); 
		CGContextFillRect(context, rect);
		txtColor = [UIColor blackColor];
		
	}
	[txtColor set];
	fntP = [UIFont systemFontOfSize:12] ;
	[dataStringP drawInRect:rect withFont:fntP];
	//[fntP release];
	[txtColor release];
	 */
	CGRect r, b;
	
	//NSLog(@"drawRect");
	r.size = [keypadImageP  size];
	//b = CGRectMake(0.0f, 74.0f, 320.0f, 273.0f);
	b = [self bounds];
	[keypadImageP drawInRect:b];
	//	
	if (touchDown != 0)
	{
		CGRect ri;
		ri = rectchange;
			
	//	NSLog(@"\n%f %f   %f %f ",ri.origin.x,ri.origin.y,ri.size.width,ri.size.height);
		//NSLog(@"drawButton %d", _downKey);
		//CGRect ri = [self rectForKey:_downKey];
		CGImageRef cgImg = CGImageCreateWithImageInRect([ pressedImageP CGImage], ri);
		UIImage *img = [UIImage imageWithCGImage:cgImg];
		ri.origin.x += b.origin.x;
		ri.origin.y += b.origin.y;
		[img drawInRect:ri];
		CGImageRelease (cgImg);
		//CGContextRef context = UIGraphicsGetCurrentContext(); 
		//CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0,1.0); 
		//CGContextFillRect(context, ri);
			
	}
	
    // Drawing code
}


- (void)dealloc {
	[_plusTimer release];
    [dataStringP release];
	[keypadImageP release];
	[pressedImageP release];

	[super dealloc];
}


@end
