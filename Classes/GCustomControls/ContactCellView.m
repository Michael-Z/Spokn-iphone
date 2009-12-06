//
//  ContactCellView.m
//  munduSMS
//
//  Created by Vinay Chavan on 14/06/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import "ContactCellView.h"
#import "Contact.h"

@implementation ContactCellView

@synthesize selected;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		_contact = nil;
		self.backgroundColor = [UIColor colorWithRed:0.925 green:0.925 blue:0.925 alpha:1];
    }
    return self;
}

- (void)setObject:(Contact*)objct
{
	if( _contact )
	{
		[_contact release], _contact = nil;
	}
	_contact = [objct retain];
	
	[self setNeedsDisplay];
}
- (Contact*)getObject
{
	return _contact;
}

- (void)drawRect:(CGRect)rect {
	// Drawing code
#define LEFT_COLUMN_OFFSET 10
#define LEFT_COLUMN_WIDTH 130
	
#define MSG_LEFT_COLUMN_WIDTH 225
	
#define RIGHT_COLUMN_OFFSET 270
	
#define UPPER_ROW_TOP 2
#define LOWER_ROW_TOP 18
	
#define NAME_FONT_SIZE 15
#define MIN_NAME_FONT_SIZE 12
	
#define DETAIL_FONT_SIZE 15
#define MIN_DETAIL_FONT_SIZE 12
	
#define NUMBER_FONT_SIZE 15
#define MIN_NUMBER_FONT_SIZE 15
	
	UIColor *nameTextColor, *detailTextColor, *numberTextColor;
	if( selected )
	{
		nameTextColor = [[UIColor whiteColor] autorelease];
		detailTextColor = [[UIColor whiteColor] autorelease];
		numberTextColor = [[UIColor whiteColor] autorelease];
	}else
	{
		nameTextColor = [[UIColor blackColor] autorelease];
		detailTextColor = [[UIColor grayColor] autorelease];
		numberTextColor = [[UIColor grayColor] autorelease];
		
	}
	UIFont *nameFont = [UIFont boldSystemFontOfSize:NAME_FONT_SIZE];
	UIFont *detailFont = [UIFont boldSystemFontOfSize:DETAIL_FONT_SIZE];
	UIFont *numberFont = [UIFont systemFontOfSize:NUMBER_FONT_SIZE];
	
	
	CGRect contentRect = self.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGPoint point;
	
	
	// Set the color for the main text items
	[nameTextColor set];
	point = CGPointMake(boundsX + LEFT_COLUMN_OFFSET, UPPER_ROW_TOP);
	[_contact.Name drawAtPoint:point 
	 forWidth:LEFT_COLUMN_WIDTH 
	 withFont:nameFont minFontSize:MIN_NAME_FONT_SIZE 
	 actualFontSize:NULL 
	 lineBreakMode:UILineBreakModeTailTruncation 
	 baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
	
	[detailTextColor set];
	point = CGPointMake(boundsX + LEFT_COLUMN_OFFSET, LOWER_ROW_TOP);
	[_contact.Detail drawAtPoint:point 
	 forWidth:LEFT_COLUMN_WIDTH 
	 withFont:detailFont minFontSize:MIN_DETAIL_FONT_SIZE 
	 actualFontSize:NULL 
	 lineBreakMode:UILineBreakModeTailTruncation 
	 baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
	
	
	[numberTextColor set];
	point = CGPointMake(boundsX + LEFT_COLUMN_OFFSET + 80, LOWER_ROW_TOP);
	[_contact.Number drawAtPoint:point 
	 forWidth:MSG_LEFT_COLUMN_WIDTH 
	 withFont:numberFont minFontSize:MIN_NUMBER_FONT_SIZE 
	 actualFontSize:NULL 
	 lineBreakMode:UILineBreakModeTailTruncation 
	 baselineAdjustment:UIBaselineAdjustmentAlignBaselines];	
}


- (void)dealloc {
	if(_contact != nil)
	{
		[_contact release];
		_contact = nil;
	}
	
    [super dealloc];
}


@end
