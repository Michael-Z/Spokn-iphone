
//  Created on 25/08/09.

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

#import <Foundation/Foundation.h>
/*
 CGRect myImageRect = CGRectMake(0.0f, 0.0f, 320.0f, 109.0f);
 UIImageView *myImage = [[UIImageView alloc] initWithFrame:myImageRect];
 [myImage setImage:[UIImage imageNamed:@"myImage.png"]];
 myImage.opaque = YES; // explicitly opaque for performance
 [self.view addSubview:myImage];
 [myImage release];
 */

@interface displayData:NSObject
{
	int left;
	int top;
	int width;
	int height;
	int row;
	int noChangeDimentationB;
	//UIFont *fontP;
	int fntSz;
	BOOL boldB;
	NSString  *fntNameP;
	UIColor *colorP;
	Boolean percent;//data given as persent
	NSString *dataP;
	UIImage  *uiImageP;
	UITextAlignment textAlignmentType;
//	@public
	int fountCount;
	BOOL showOnEditB;
	
	
}
@property (readwrite,assign) int noChangeDimentationB;
@property (readwrite,assign) BOOL boldB;
@property (readwrite,assign) UITextAlignment textAlignmentType;
@property (readwrite,assign) Boolean percent;
@property (readwrite,assign) int left;
@property (readwrite,assign) int top;
@property (readwrite,assign) int width;
@property (readwrite,assign) int height;
@property (readwrite,assign) int row;
@property (readwrite,assign) int fountCount;
@property (readwrite,copy) NSString *dataP;
@property (readwrite,copy) NSString *fntNameP;
@property (readwrite,retain) UIColor *colorP;
@property (readwrite,retain) UIImage  *uiImageP;
@property (readwrite,assign) int fntSz;
@property (readwrite,assign) BOOL showOnEditB;
-(id)init;


@end

@interface SpoknSubCell : UIView {
@private
	UIFont         *font;  
	void *userData;
	Boolean selectedVar;
	//@public
	Boolean ownerDrawB;
	int rowHeight;
	NSMutableArray *dataArrayP;  
	CGRect rectCell;
	int	editCellB;	
	
}
- (void)drawRect:(CGRect)rect;
-(void) subcellsetEdit:(int)editB;
@property (readwrite,assign) void *userData;
@property (readwrite,assign) Boolean ownerDrawB;
@property (readwrite,assign) int rowHeight;
@property (readwrite,assign) NSMutableArray *dataArrayP;  
@property (readwrite,assign) Boolean selectedVar;
@property(readwrite,assign)  UIFont         *font;  

@end

@class SpoknUITableViewCell;
@protocol SpoknUITableViewCellDelegate
- (void)spoknUITableViewCell:(SpoknUITableViewCell *)spoknUITableViewCell willHighlight:(BOOL)highlighted;
- (NSString*)spoknUITableviewCellCopy;
@end

@interface SpoknUITableViewCell : UITableViewCell
{
	id<SpoknUITableViewCellDelegate> delegate;
	SpoknSubCell *spoknSubCellP;
	CGPoint holdPoint;
}

@property (assign, nonatomic) id<SpoknUITableViewCellDelegate> delegate;
-(void) resizeFrame;
-(void) setAutoResize:(BOOL)onB;
-(void) tablecellsetEdit:(int)leditB :(int)needsdisplayB;
@property (readwrite,assign) SpoknSubCell *spoknSubCellP;
- (id)initWithCustomFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;
@end

#define _NEW_TABEL_
@interface sectionData:NSObject
{
@public
	//struct AddressBook *addP;
	long recordid;
}
@end
@interface sectionType:NSObject
{
@public
	int freeUDataB;
	int index;
	int uniqueID;
	void *userData;
	NSMutableArray *elementP;
}
@end
typedef enum TypeOfObject
	{
		idObject,//general object
		arrayObject
	}TypeOfObject;
@interface CellObjectContainer :NSObject
{
	NSMutableArray *objectArrayP;
	TypeOfObject type;
}
@property (readwrite,assign) TypeOfObject type;
-(id)getObjectAtIndex:(int)index;
-(void)removeObjectAtIndex:(int)index;
-(void)addObjectAtIndex:(id)objid :(int)index;
-(void)addObject:(id)objid;
-(void)removeAll;
@end



