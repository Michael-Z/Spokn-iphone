//
//  GTokenField.h
//  GTokenFieldTest
//
//  Created by Vinay Chavan on 27/05/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

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
@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@protocol GTokenFieldDelegate

- (void)tokenField:(GTokenField*)tokenField didAddCellAtIndex:(NSInteger)index;

- (void)tokenField:(GTokenField*)tokenField didRemoveCellAtIndex:(NSInteger)index;

- (void)tokenFieldDidResize:(GTokenField*)tokenField;

- (NSString*) labelForObject:(id)object;
-(NSString *)GetNameAtIndex:(int)index;

@end