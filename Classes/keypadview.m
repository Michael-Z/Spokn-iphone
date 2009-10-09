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
		
}	

-(void)setImage:(NSString *)normalImgP :(NSString *)pressedImgP
{
	keypadImageP = [[UIImage imageNamed:normalImgP] retain];
	pressedImageP = [[UIImage imageNamed:pressedImgP] retain];

}
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
	touchDown = 0;
	    return self;
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

		NSLog(@"\n%f %f",point.x*4/self.bounds.size.width,point.y*4/self.bounds.size.height);
		rectchange.origin.x = col*elementWidth;
		rectchange.origin.y = row*elementHeight;
		rectchange.size.width = elementWidth;
		rectchange.size.height = elementHeight;
		arrayPos = row*elementx+col;
		[keypadProtocolP keyPressedDown:keyStrs[arrayPos] keycode:keyValues[arrayPos] ];
	}
	[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	touchDown = 0;
	[self setNeedsDisplay];

	
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
			
		NSLog(@"\n%f %f   %f %f ",ri.origin.x,ri.origin.y,ri.size.width,ri.size.height);
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
    [dataStringP release];
	[keypadImageP release];
	[pressedImageP release];

	[super dealloc];
}


@end
