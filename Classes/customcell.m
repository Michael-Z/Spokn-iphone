//
//  customcell.m
//  spokn
//
//  Created by Mukesh Sharma on 25/08/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import "customcell.h"


@implementation displayData
@synthesize percent;
@synthesize left;
@synthesize top;
@synthesize width;
@synthesize height;
@synthesize dataP;
@synthesize colorP;

@synthesize row;
@synthesize uiImageP;
@synthesize fountCount;
@synthesize fntSz;
@synthesize fntNameP;
@synthesize textAlignmentType;
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
	return self;
	
}
-(void)dealloc
{
	
	
	[fntNameP release];
	[dataP release];
	
	[colorP release];
	dataP = nil;
	
	colorP = nil;
	if(uiImageP)
	{
	
		[uiImageP release];
	}
	[super dealloc];
	
	
}

@end
@implementation SpoknUITableViewCell
@synthesize  spoknSubCellP;
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		
		CGRect cellFrame = CGRectMake(5.0, 5.0, self.contentView.bounds.size.width-8.0, self.contentView.bounds.size.height-8.0);
		spoknSubCellP = [[SpoknSubCell alloc] initWithFrame:cellFrame];
		
		spoknSubCellP.autoresizingMask = (UIViewAutoresizingFlexibleHeight | 
										  UIViewAutoresizingFlexibleWidth | 
										  UIViewAutoresizingFlexibleTopMargin | 
										  //UIViewAutoresizingFlexibleLeftMargin | 
										  //UIViewAutoresizingFlexibleRightMargin | 
										  UIViewAutoresizingFlexibleBottomMargin);
		[self.contentView addSubview:spoknSubCellP];
		spoknSubCellP.font = self.font;
		
	}
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
	spoknSubCellP.selectedVar = selected;
	
	[spoknSubCellP setNeedsDisplay];
}
-(void)dealloc
{
	////printf("\nSpoknUITableViewCell release  %d ",[spoknSubCellP retainCount] );

	[spoknSubCellP release];
	[super dealloc];
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
		
		
		self.backgroundColor = [UIColor whiteColor];
		
		//savedImage = [UIImage imageNamed:@"Status-saved.png"];	
    }
    return self;
}
-(void)dealloc
{
	
	//	self.contentView.remove
		[super dealloc];
}
- (void)drawRect:(CGRect)rect
{
	displayData *displayDataP = nil;
	int stX;
	int stY;
	int width;
	int height;
	stX = rect.origin.x;
	stY = rect.origin.y;
	UIColor *txtColor;
	UIFont                *fontlP;
	//////////////printf("\n drawing...");
	/*	if (self.editing)
	 {
	 return;
	 }
	 */
	
	if(self.dataArrayP)
	{
		int count = [dataArrayP count];
		int prvRow = 0;
		for(int i = 0;i<count;++i)
		{
			displayDataP = [dataArrayP objectAtIndex:i];
			if(displayDataP)
			{
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
						//////printf("\nheight%d",height);
						stY = rect.origin.y+height;
					}
					rec.origin.x = stX + displayDataP.left + 1;
					rec.origin.y = stY+ displayDataP.top + 5;
					width = (rect.size.width/100)*displayDataP.width;
					height = (rect.size.height/100)*displayDataP.height;
					rec.size.width = width;
					rec.size.height = height;
					//if(displayDataP.height==100)
					{
						rec.origin.y += height/4;
					}
					//#define ORANGE [UIColor colorWithRed:1.0f green:0.522f blue:0.03f alpha:1.0f]
						//self.textColor = ORANGE;
					if(selectedVar)
					{
						txtColor = [UIColor whiteColor];
						////////////printf("selected");
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
						fontlP =   [UIFont systemFontOfSize:displayDataP.fntSz] ;// displayDataP.fontP;
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
						rec.origin.y = stY+ displayDataP.top + 5;
						rec1 = rec;
						rec1.size.width = displayDataP.uiImageP.size.width;
						rec1.size.height = displayDataP.uiImageP.size.height;
						[displayDataP.uiImageP drawInRect:rec1 ];	
						rec.origin.y += height/4;
						//[displayDataP.uiImageP drawInRect:rec1 blendMode: kCGBlendModeNormal alpha: 1.0];
						rec.origin.x+= displayDataP.uiImageP.size.width +2;
						
					}
				//	- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(UILineBreakMode)lineBreakMode alignment:(UITextAlignment)alignment;

					[displayDataP.dataP drawInRect:rec withFont:fontlP lineBreakMode:UILineBreakModeTailTruncation alignment:displayDataP.textAlignmentType];
					//[displayDataP.dataP drawInRect:rec withFont:fontlP];
					stX+=width;
					//stY+=height;
					[txtColor release];
				//	[fontlP release];
					
					
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
	index = 0;
	elementP = [[NSMutableArray alloc] init];
	return self;
}
-(void)dealloc
{
	//[elementP release];
	//printf("\n dealloc called");
	while(elementP.count)
	{
		
		id iD;
	//	printf("\n element count %d",elementP.count);
		//NSMutableArray *tmpObj;
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
	////printf("\nobject count st %d",objectArrayP.count);
	//[objectArrayP addObject:objid];
	////printf("\nobject count end %d",objectArrayP.count);
	
}
-(void)addObject:(id)objid
{
	////printf("\nobject count st %d",objectArrayP.count);
	[objectArrayP addObject:objid];
	////printf("\nobject count end %d",objectArrayP.count);

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
		
	////printf("\n remove all call %d",objectArrayP.count );
	while(objectArrayP.count)
	{
		
		id iD;
		////printf("\n count %d",objectArrayP.count);
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
		////printf("\nremoved");
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
