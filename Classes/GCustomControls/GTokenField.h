
//  Created  on 27/05/09.
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

#import <UIKit/UIKit.h>
#import "GTokenFieldCell.h"
@interface UIView (FindSuperview)

- (UIView*)findRootViewOfClass:(Class)cls;


@end

@class GTokenFieldCell;

@interface GTokenField : UITextField <UITextFieldDelegate>{
	NSMutableArray* _cellViews;
	GTokenFieldCell* _selectedCell;
	int _lineCount;
	CGPoint _cursorOrigin;
	int tableonB;
}

@property(nonatomic,copy)NSString* text;
@property(nonatomic, readonly)NSString* commaSeparatedText;
@property(nonatomic,retain) UIFont* font;
@property(nonatomic,readonly) NSArray* cellViews;
@property(nonatomic,readonly) NSArray* cells;
@property(nonatomic,assign) GTokenFieldCell* selectedCell;
@property(nonatomic,readonly) int lineCount;
@property(nonatomic, readonly)NSString* commaSeparatedNumber;

- (void)addCellWithObject:(id)object;

- (void)addCellWithString:(NSString*)string type:(NSString*)lnumberStrP;

- (void)removeCellWithObject:(id)object;

- (void)removeAllCells;

- (void)removeSelectedCell;

- (void)scrollToVisibleLine:(BOOL)animated;

- (void)scrollToEditingLine:(BOOL)animated;

- (BOOL)shouldUpdate:(BOOL)emptyText;
- (NSString*)numberForObject:(id)object;
-(int) totalObject;
-(NSString *)GetNameAtIndex:(int)index;
-(void)setTableOn:(int)onB;
@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@protocol GTokenFieldDelegate

- (void)tokenField:(GTokenField*)tokenField didAddCellAtIndex:(NSInteger)index;

- (void)tokenField:(GTokenField*)tokenField didRemoveCellAtIndex:(NSInteger)index;

- (void)tokenFieldDidResize:(GTokenField*)tokenField;

- (NSString*) labelForObject:(id)object;
-(NSString *)GetNameAtIndex:(int)index;

@end