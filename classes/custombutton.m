//
//  CustomButton.m
//  spokn
//
//  Created by Mukesh Sharma on 12/10/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//
/**
 Copyright 2009 John Smith, <john.smith@example.com>
 
 This file is part of FOOBAR.
 
 FOOBAR is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 FOOBAR is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with FOOBAR.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "CustomButton.h"


@implementation CustomButton


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
//	[super drawRect:rect];
	
	CGRect rect1;
	rect1 = rect;
	rect1.origin.x-=2;
	rect1.origin.y-=2;
	rect1.size.width+=4;
	rect1.size.height+=4;
//	[self CGContextAddRoundRect : rect1 :5.0];
	
}

-(void) CGContextAddRoundRect :(CGRect)rect :(float)radius

{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[[UIColor whiteColor] set];
	CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + radius);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height - radius);
	CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, 
					radius, M_PI / 4, M_PI / 2, 1);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius, 
							rect.origin.y + rect.size.height);
	CGContextAddArc(context, rect.origin.x + rect.size.width - radius, 
					rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + radius);
	CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, 
					radius, 0.0f, -M_PI / 2, 1);
	CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y);
	CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + radius, radius, 
					-M_PI / 2, M_PI, 1);
	//printf("\n draw");
}

- (void)dealloc {
    [super dealloc];
}
+(void)setImages:	(UIButton *)buttonObjectP
image:(UIImage *)image
imagePressed:(UIImage *)imagePressed

{	
	buttonObjectP.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	buttonObjectP.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[buttonObjectP setBackgroundImage:newImage forState:UIControlStateNormal];
	//retain for 2.2.1
	[image retain];
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[buttonObjectP setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	//retain for 2.2.1
	[imagePressed retain];
	   // in case the parent view draws with a custom color or gradient, use a transparent color
	buttonObjectP.backgroundColor = [[UIColor clearColor] autorelease ];
	
	//return button;
}


@end
