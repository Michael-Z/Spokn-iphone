
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

#import "keypadview.h"


@implementation Keypadview
@synthesize objectId;
@synthesize dataStringP;
@synthesize keypadProtocolP;
-(void)setElement:(int)lelementx :(int)lelementy
{
	int rem;
	elementx = lelementx;
	elementy = lelementy;
	xdiff = 0;
	ydiff = 0;
	elementWidth = (self.bounds.size.width/elementx);
	elementHeight = (self.bounds.size.height/elementy);
	rem= (int)(self.bounds.size.width)%elementx;
	if(rem)
	{
		xdiff=2;
	}
	
	/*
	rem= (int)(self.bounds.size.height)%elementy;
	if(rem)
	{
		//ydiff=1;
	}
	*/
		
}	

-(void)setImage:(NSString *)normalImgP :(NSString *)pressedImgP
{
	keypadImageP = [[UIImage imageNamed:normalImgP] retain];
	pressedImageP = [[UIImage imageNamed:pressedImgP] retain];
	CGRect tmpBound;
	tmpBound = self.bounds;
	tmpBound.origin.x += (tmpBound.size.width-keypadImageP.size.width)/2;
	tmpBound.origin.y += (tmpBound.size.height-keypadImageP.size.height)/2;
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
		
		row =  point.y/self->elementHeight;
		col = point.x/self->elementWidth;

		rectchange.origin.x = col*elementWidth ;
		rectchange.origin.y = row*elementHeight;
		if(col==1)
		{	
			rectchange.size.width = elementWidth - xdiff;
		}
		else
		{
			rectchange.size.width = elementWidth;
		}
		rectchange.size.height = elementHeight-ydiff;
		arrayPos = row*elementx+col;
		
		if(arrayPos<12)
		{	
			NSString *curTest = keyStrs[arrayPos];
			if([curTest isEqualToString:@"0"])
			{
				_plusTimer = [[NSTimer scheduledTimerWithTimeInterval:0.5 target:self 
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
	
	r.size = [keypadImageP  size];
	//b = CGRectMake(0.0f, 74.0f, 320.0f, 273.0f);
	b = [self bounds];
	[keypadImageP drawInRect:b];
	//	
	if (touchDown != 0)
	{
		CGRect ri;
		ri = rectchange;
			
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
