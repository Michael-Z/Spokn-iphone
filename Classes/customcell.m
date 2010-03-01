
//  Created by Mukesh Sharma on 25/08/09.

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

#import "customcell.h"


@implementation displayData
@synthesize noChangeDimentationB;
@synthesize percent;
@synthesize left;
@synthesize top;
@synthesize width;
@synthesize height;
@synthesize dataP;
@synthesize colorP;
@synthesize boldB;
@synthesize row;
@synthesize uiImageP;
@synthesize fountCount;
@synthesize fntSz;
@synthesize fntNameP;
@synthesize textAlignmentType;
@synthesize showOnEditB;
-(id)init
{
	self = [super init];
	left = 0;
	top = 0;
	width = 0;
	height = 0;
	row    = 0;
	percent = true;
	dataP = nil;
	colorP = nil;
	uiImageP = nil;
	fountCount = 0;
	textAlignmentType = UITextAlignmentLeft;
	boldB = NO;
	showOnEditB = false;
	noChangeDimentationB = NO;
	return self;
	
}
-(void)dealloc
{
	
	
	[fntNameP release];
	fntNameP = nil;
	[dataP release];
	dataP = nil;
	[colorP release];

	
	colorP = nil;
	if(uiImageP)
	{
		[uiImageP release];
		
		
		uiImageP = nil;
		
	}
	[super dealloc];
	
	
}

@end
@implementation SpoknUITableViewCell
@synthesize  spoknSubCellP;
-(void) tablecellsetEdit:(int)leditB :(int)needsdisplayB 
{
	[spoknSubCellP subcellsetEdit:leditB];
	if(needsdisplayB)
	{
		[spoknSubCellP setNeedsDisplay];
	}	
}
- (id)initWithCustomFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
   
	
	#ifdef __IPHONE_3_0
		if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
	#else
		if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {	
	#endif		
        // Initialization code
		
		CGRect cellFrame = CGRectMake(5.0, 5.0, self.contentView.bounds.size.width-8.0, self.contentView.bounds.size.height-8.0);
		spoknSubCellP = [[SpoknSubCell alloc] initWithFrame:cellFrame];
		
		/*spoknSubCellP.autoresizingMask = (UIViewAutoresizingFlexibleHeight | 
										  UIViewAutoresizingFlexibleWidth | 
										  UIViewAutoresizingFlexibleTopMargin | 
										  //UIViewAutoresizingFlexibleLeftMargin | 
										  //UIViewAutoresizingFlexibleRightMargin | 
										  UIViewAutoresizingFlexibleBottomMargin);*/
		spoknSubCellP.autoresizingMask = UIViewAutoresizingNone;
		[self.contentView addSubview:spoknSubCellP];
		//[spoknSubCellP release];
		//spoknSubCellP.font = self.font;
		
	}
    return self;
}
-(void) resizeFrame
{
	CGRect cellFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
	//spoknSubCellP = [[SpoknSubCell alloc] initWithFrame:cellFrame];
	
	spoknSubCellP.frame = cellFrame;
}
-(void) setAutoResize:(BOOL)onB
{
	if(onB)
	{
		spoknSubCellP.autoresizingMask = (UIViewAutoresizingFlexibleHeight | 
										 UIViewAutoresizingFlexibleWidth | 
										 UIViewAutoresizingFlexibleTopMargin | 
										 //UIViewAutoresizingFlexibleLeftMargin | 
										 //UIViewAutoresizingFlexibleRightMargin | 
										 UIViewAutoresizingFlexibleBottomMargin);	
	}
	else
	{
		spoknSubCellP.autoresizingMask = UIViewAutoresizingNone;
	}

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
	//spoknSubCellP.selectedVar = selected;
	
	//[spoknSubCellP setNeedsDisplay];
}
-(void)dealloc
{
	
	[spoknSubCellP release];
	[super dealloc];

}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	[super setHighlighted:highlighted animated:animated];
	spoknSubCellP.selectedVar = highlighted;
	
}
- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	//spoknSubCellP.selectedVar = self.highlighted;
}
@end
@implementation SpoknSubCell
@synthesize font;
@synthesize selectedVar;
@synthesize userData;
@synthesize ownerDrawB;
@synthesize rowHeight;
@synthesize dataArrayP;
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		rectCell = frame;
		self.backgroundColor = [[UIColor whiteColor] autorelease];
		self->editCellB = false;
	
    }
    return self;
}
-(void)dealloc
{
		//	self.contentView.remove
		[super dealloc];
}
-(void)subcellsetEdit:(int)leditB
{
	editCellB = leditB ;
	
}
- (void)drawRect:(CGRect)rect
{
	displayData *displayDataP = nil;
	int stX;
	int stY;
	int width;
	int height;
	//rect = rectCell;
	stX = rect.origin.x;
	stY = rect.origin.y;
	UIColor *txtColor;
	UIFont                *fontlP;
	
	
	
	if(self.dataArrayP)
	{
		int count = [dataArrayP count];
		int prvRow = 0;
		for(int i = 0;i<count;++i)
		{
			displayDataP = [dataArrayP objectAtIndex:i];
			if(displayDataP)
			{
				//added for edit cell
				
				if(self->editCellB && !displayDataP.showOnEditB)
				{
					continue;
				}
				if(displayDataP.percent)
				{
					CGRect rec;
					if(prvRow< displayDataP.row)
					{
						prvRow = displayDataP.row;
						stX = displayDataP.left;//rect.origin.x;
						if(displayDataP.left)
						stX = displayDataP.left;//rect.origin.x;
						height = (rect.size.height/100)*displayDataP.height;
						
						stY = rect.origin.y+height;
					}
					rec.origin.x = stX + displayDataP.left + 1;
					rec.origin.y = stY+ displayDataP.top + 1;
					width = (rect.size.width/100)*displayDataP.width;
					height = (rect.size.height/100)*displayDataP.height;
					rec.size.width = width;
					rec.size.height = height;
					if(displayDataP.noChangeDimentationB==NO)
					{
						rec.origin.y += height/4;
					}
					//#define ORANGE [UIColor colorWithRed:1.0f green:0.522f blue:0.03f alpha:1.0f]
						//self.textColor = ORANGE;
					if(selectedVar)
					{
						txtColor = [UIColor whiteColor];
						
					}
					else
					{	
						if(displayDataP.colorP==nil)
						{	
							txtColor = [UIColor blackColor];
						}
						else
						{
							txtColor = displayDataP.colorP;
							[txtColor retain];
							
						}
					}
					
					if(displayDataP.fntSz)
					{
						if(displayDataP.boldB)
						{
							fontlP =   [UIFont boldSystemFontOfSize:displayDataP.fntSz] ;// displayDataP.fontP;
							
						}
						else
						{	
							fontlP =   [UIFont systemFontOfSize:displayDataP.fntSz] ;// displayDataP.fontP;
						}
					}
					else
					{	
						
						fontlP = self.font;
						
						//[fontlP retain];
					}
					[txtColor set];
					if(displayDataP.uiImageP)
					{
						
						CGRect rec1;
						// CGFloat y;
						
						rec1 = rec;
						rec1.origin.y = stY+ displayDataP.top + 8;
						rec1.size.width = displayDataP.uiImageP.size.width;
						rec1.size.height = displayDataP.uiImageP.size.height;
						[displayDataP.uiImageP drawInRect:rec1 ];	
						//rec.origin.y += height/4;
						//[displayDataP.uiImageP drawInRect:rec1 blendMode: kCGBlendModeNormal alpha: 1.0];
						rec.origin.x+= displayDataP.uiImageP.size.width +4;
						
					}
				//	- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(UILineBreakMode)lineBreakMode alignment:(UITextAlignment)alignment;

					[displayDataP.dataP drawInRect:rec withFont:fontlP lineBreakMode:UILineBreakModeTailTruncation alignment:displayDataP.textAlignmentType];
					//[displayDataP.dataP drawInRect:rec withFont:fontlP];
					stX+=width;
					//stY+=height;
					[txtColor release];
				
					
					
				}
				
			}
		}
		
	}
}

@end
@implementation sectionData
-(id)init
{
	self = [super init];
	recordid = 0;
	return self;
}
-(void)dealloc
{

	[super dealloc];
}

@end

@implementation sectionType
-(id)init
{
	self = [super init];
	freeUDataB = false;
	index = 0;
	uniqueID = 0;
	elementP = [[NSMutableArray alloc] init];
	return self;
}
-(void)dealloc
{
	if(freeUDataB)
	{
		if(userData)
		{	
			free(userData);
		}	
		userData = 0;
	}
	while(elementP.count)
	{
		
		id iD;
		iD = [elementP objectAtIndex:0];
		[iD release];
		
	
		[elementP removeObjectAtIndex:0];
	}
	
	[elementP release];
	
	[super dealloc];
	
}

@end
@implementation CellObjectContainer

@synthesize type;
-(id)getObjectAtIndex:(int)index
{
	if(objectArrayP)
	{
		if(objectArrayP.count>index)
		{
			return [objectArrayP objectAtIndex:index];
		}
	}
	return nil;
	
}
-(void)removeObjectAtIndex:(int)index
{
	if(objectArrayP)
	{
		if(objectArrayP.count>index)
		{
			id iD = [objectArrayP objectAtIndex:index];
			if(type==arrayObject)
			{
				NSMutableArray *tmpObj;
				tmpObj = iD;
				if(tmpObj)
					while(tmpObj.count)
					{
						iD = [tmpObj objectAtIndex:0];
						[iD release];
						[tmpObj removeObjectAtIndex:0];
					}	
				
				[tmpObj release];
			}
			else
			{	
				[iD release];
			}
			[objectArrayP removeObjectAtIndex:index];
		}
	}
	
	
}
-(void)addObjectAtIndex:(id)objid :(int)index
{
	[objectArrayP replaceObjectAtIndex:index withObject:objid];
		
}
-(void)addObject:(id)objid
{
	[objectArrayP addObject:objid];
	
}
-(id)init
{
	[super init];
	type = idObject;
	objectArrayP = [[NSMutableArray alloc] init];
	return self;
}
-(void)removeAll
{
		
	while(objectArrayP.count)
	{
		
		id iD;
		NSMutableArray *tmpObj;
		iD = [objectArrayP objectAtIndex:0];
		if(type==arrayObject)
		{
			tmpObj = iD;
			if(tmpObj)
			while(tmpObj.count)
			{
				iD = [tmpObj objectAtIndex:0];
				[iD release];
				[tmpObj removeObjectAtIndex:0];
			}	

			[tmpObj release];
		}
		else
		{	
			[iD release];
		}
		[objectArrayP removeObjectAtIndex:0];
	}
	[objectArrayP release];
}
-(void)dealloc
{
	[self removeAll];
	[super dealloc];

	
		
}
@end
