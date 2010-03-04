
//  Created on 27/05/09.
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

#import "GTokenFieldCell.h"

#define G_ROUNDED -1
#define RD(_RADIUS) (_RADIUS == G_ROUNDED ? round(fh/2) : _RADIUS)
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:1]

#define _topLeftRadius -1
#define _topRightRadius -1
#define _bottomLeftRadius -1
#define _bottomRightRadius -1

///////////////////////////////////////////////////////////////////////////////////////////////////

static CGFloat kPaddingX = 8;
static CGFloat kPaddingY = 3;
static CGFloat kMaxWidth = 250;
static const NSInteger kDefaultLightSource = 125;

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation GTokenFieldCell
@synthesize object = _object, selected = _selected;
@synthesize color1 = _color1, color2 = _color2, color3 = _color3, color4 = _color4;
@synthesize _number;
- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		_object = nil;
		_selected = NO;
		_number = nil;
		_labelView = [[UILabel alloc] initWithFrame:CGRectZero];
		_labelView.opaque = NO;
		_labelView.backgroundColor = [[UIColor clearColor] autorelease];
		_labelView.textColor = [[UIColor blackColor] autorelease];
		_labelView.highlightedTextColor = [[UIColor whiteColor] autorelease];
		_labelView.lineBreakMode = UILineBreakModeTailTruncation;
		[self addSubview:_labelView];
		
		self.backgroundColor = [[UIColor clearColor] autorelease];
	}
	return self;
}

- (void)dealloc {
	[_number release ];
	[_object release];
	[_labelView release];
	[_color1 release];
	[_color2 release];
	[_color3 release];
	[_color4 release];
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)layoutSubviews {
	_labelView.frame = CGRectMake(kPaddingX, 
								  kPaddingY,
								  self.bounds.size.width-kPaddingX*2, 
								  self.bounds.size.height-kPaddingY*2);
}

- (CGSize)sizeThatFits:(CGSize)size {
	CGSize labelSize = [_labelView.text sizeWithFont:_labelView.font];
	CGFloat width = labelSize.width + kPaddingX*2;
	
	CGSize size1 = CGSizeMake(width > kMaxWidth ? kMaxWidth : width, labelSize.height + kPaddingY*2);
	return size1;
}

- (CGGradientRef)newGradientWithColors:(UIColor**)colors count:(int)count {
	CGFloat* components = malloc(sizeof(CGFloat)*4*count);
	for (int i = 0; i < count; ++i) {
		UIColor* color = colors[i];
		size_t n = CGColorGetNumberOfComponents(color.CGColor);
		const CGFloat* rgba = CGColorGetComponents(color.CGColor);
		if (n == 2) {
			components[i*4] = rgba[0];
			components[i*4+1] = rgba[0];
			components[i*4+2] = rgba[0];
			components[i*4+3] = rgba[1];
		} else if (n == 4) {
			components[i*4] = rgba[0];
			components[i*4+1] = rgba[1];
			components[i*4+2] = rgba[2];
			components[i*4+3] = rgba[3];
		}
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef space = CGBitmapContextGetColorSpace(context);
	CGGradientRef gradient = CGGradientCreateWithColorComponents(space, components, nil, count);
	free(components);
	return gradient;
}

- (void)fillGradient:(CGContextRef)ctx inRect:(CGRect)rect {
	// give round shape
	CGContextSaveGState(ctx);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
	CGContextBeginPath(context);
	
	CGFloat fw = rect.size.width;
	CGFloat fh = rect.size.height;
	
	CGContextMoveToPoint(context, fw, floor(fh/2));
	CGContextAddArcToPoint(context, fw, fh, floor(fw/2), fh, RD(-1));
	CGContextAddArcToPoint(context, 0, fh, 0, floor(fh/2), RD(-1));
	CGContextAddArcToPoint(context, 0, 0, floor(fw/2), 0, RD(-1));
	CGContextAddArcToPoint(context, fw, 0, fw, floor(fh/2), RD(-1));
	
	CGContextClosePath(context);
	CGContextRestoreGState(context);
	CGContextClip(ctx);
	
	// fill gradient
	UIColor* colors[] = {_color1, _color2};
	CGGradientRef gradient = [self newGradientWithColors:colors count:2];
	CGContextDrawLinearGradient(ctx, gradient, CGPointMake(rect.origin.x, rect.origin.y),
								CGPointMake(rect.origin.x, rect.origin.y+rect.size.height), kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(gradient);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addTopEdgeToPath:(CGRect)rect lightSource:(NSInteger)lightSource {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGFloat fw = rect.size.width;
	CGFloat fh = rect.size.height;
	
	if (lightSource >= 0 && lightSource <= 90) {
		CGContextMoveToPoint(context, RD(_topLeftRadius), 0);
	} else {
		CGContextMoveToPoint(context, 0, RD(_topLeftRadius));
		CGContextAddArcToPoint(context, 0, 0, RD(_topLeftRadius), 0, RD(_topLeftRadius));
	}
	CGContextAddArcToPoint(context, fw, 0, fw, RD(_topRightRadius), RD(_topRightRadius));
	CGContextAddLineToPoint(context, fw, RD(_topRightRadius));
}

- (void)addRightEdgeToPath:(CGRect)rect lightSource:(NSInteger)lightSource {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGFloat fw = rect.size.width;
	CGFloat fh = rect.size.height;
	
	CGContextMoveToPoint(context, fw, RD(_topRightRadius));
	CGContextAddArcToPoint(context, fw, fh, fw-RD(_bottomRightRadius), fh, RD(_bottomRightRadius));
	CGContextAddLineToPoint(context, fw-RD(_bottomRightRadius), fh);
}

- (void)addBottomEdgeToPath:(CGRect)rect lightSource:(NSInteger)lightSource {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGFloat fw = rect.size.width;
	CGFloat fh = rect.size.height;
	
	CGContextMoveToPoint(context, fw-RD(_bottomRightRadius), fh);
	CGContextAddLineToPoint(context, RD(_bottomLeftRadius), fh);
	CGContextAddArcToPoint(context, 0, fh, 0, fh-RD(_bottomLeftRadius), RD(_bottomLeftRadius));
}

- (void)addLeftEdgeToPath:(CGRect)rect lightSource:(NSInteger)lightSource {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGFloat fh = rect.size.height;
	
	CGContextMoveToPoint(context, 0, fh-RD(_bottomLeftRadius));
	CGContextAddLineToPoint(context, 0, RD(_topLeftRadius));
	
	if (lightSource >= 0 && lightSource <= 90) {
		CGContextAddArcToPoint(context, 0, 0, RD(_topLeftRadius), 0, RD(_topLeftRadius));
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)drawBorder:(CGContextRef)ctx inRect:(CGRect)rect {
	CGContextSetLineWidth(ctx, 2.0);
	CGRect strokeRect = CGRectInset(rect, 1/2, 1/2);

	[_color3 setStroke];
	[self addTopEdgeToPath:strokeRect lightSource:kDefaultLightSource];
	CGContextStrokePath(ctx);

	[_color3 setStroke];
	[self addLeftEdgeToPath:strokeRect lightSource:kDefaultLightSource];
	CGContextStrokePath(ctx);

	[_color4 setStroke];
	[self addBottomEdgeToPath:strokeRect lightSource:kDefaultLightSource];
	CGContextStrokePath(ctx);
	
	[_color4 setStroke];
	[self addRightEdgeToPath:strokeRect lightSource:kDefaultLightSource];
	CGContextStrokePath(ctx);
}


- (void)drawRect:(CGRect)rect {
	if( self.selected )
	{
		self.color1 = RGBCOLOR(79, 144, 255);
		self.color2 = RGBCOLOR(49, 90, 255);
		self.color3 = RGBCOLOR(53, 94, 255);
		self.color4 = RGBCOLOR(53, 94, 255);
	}
	else
	{
		self.color1 = RGBCOLOR(221, 231, 248);
		self.color2 = RGBCOLOR(188, 206, 241);
		self.color3 = RGBCOLOR(161, 187, 283);
		self.color4 = RGBCOLOR(118, 130, 214);
	}
	CGContextRef ctx = UIGraphicsGetCurrentContext();

	[self fillGradient:ctx inRect:rect];

	[self drawBorder:ctx inRect:rect];
	
	CGContextRestoreGState(ctx);	
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString*)label {
	return _labelView.text;
}

- (void)setLabel:(NSString*)label {
	_labelView.text = label;
}

- (UIFont*)font {
	return _labelView.font;
}

- (void)setFont:(UIFont*)font {
	_labelView.font = font;
}

- (void)setSelected:(BOOL)selected {
	_selected = selected;
	
	_labelView.highlighted = selected;
	[self setNeedsDisplay];
}

@end

