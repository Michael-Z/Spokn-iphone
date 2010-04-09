
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

#import "GTokenField.h"
#import "GTokenFieldCell.h"

@implementation  UIView(FindSuperview)
- (UIView*)findRootViewOfClass:(Class)cls {
	if ([self isKindOfClass:cls]) {
		return self;
	} else if (self.superview) {
		return [self.superview findRootViewOfClass:cls];
	} else {
		return nil;
	}
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

static NSString* kEmpty = @" ";
static NSString* kSelected = @"`";

static CGFloat kCellPaddingY = 3;
static CGFloat kPaddingX = 8;
static CGFloat kSpacingY = 6;
static CGFloat kPaddingRatio = 1.75;
static CGFloat kClearButtonSize = 38;
static CGFloat kMinCursorWidth = 50;

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation GTokenField

@synthesize cellViews = _cellViews, selectedCell = _selectedCell, lineCount = _lineCount;
@synthesize commaSeparatedNumber;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		_cellViews = [[NSMutableArray alloc] init];
		_selectedCell = nil;
		_lineCount = 1;
		_cursorOrigin = CGPointZero;
		
		self.text = kEmpty;
		self.delegate = self;
		self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
		self.clearButtonMode = UITextFieldViewModeNever;
		self.returnKeyType = UIReturnKeyDone;
		self.enablesReturnKeyAutomatically = NO;
		
		[self addTarget:self action:@selector(textFieldDidEndEditing) forControlEvents:UIControlEventEditingDidEnd];
	}
	return self;
}

- (void)dealloc {
	[_cellViews release];
	[super dealloc];
}

//////////////////////////////////////////////////////////////////////////////////////////////////

- (CGFloat)layoutCells {
//	[UIView beginAnimations:@"myAnimation" context:nil];
//	[UIView setAnimationDuration:0.2];
	
	CGSize fontSize = [@"M" sizeWithFont:self.font];
	CGFloat lineIncrement = fontSize.height + kCellPaddingY*2 + kSpacingY;
	CGFloat marginY = floor(fontSize.height/kPaddingRatio);
	CGFloat marginLeft = self.leftView ? kPaddingX + self.leftView.frame.size.width + kPaddingX/2 : kPaddingX;
	CGFloat marginRight = kPaddingX + (self.rightView ? kClearButtonSize : 0);
	
	_cursorOrigin.x = 35;
	_cursorOrigin.y = marginY;
	_lineCount = 1;
	
	if (self.frame.size.width) {
		for (GTokenFieldCell* cell in _cellViews) {
			[cell sizeToFit];
			
			CGFloat lineWidth = _cursorOrigin.x + cell.frame.size.width + marginRight;
			if (lineWidth >= self.frame.size.width) {
				_cursorOrigin.x = marginLeft;
				_cursorOrigin.y += lineIncrement;
				++_lineCount;
			}
			
			cell.frame = CGRectMake(_cursorOrigin.x, _cursorOrigin.y-kCellPaddingY,	cell.frame.size.width, cell.frame.size.height);
			_cursorOrigin.x += cell.frame.size.width + kPaddingX;
		}
		
		CGFloat remainingWidth = self.frame.size.width - (_cursorOrigin.x + marginRight);
		if (remainingWidth < kMinCursorWidth) {
			_cursorOrigin.x = marginLeft;
			_cursorOrigin.y += lineIncrement;
			++_lineCount;
		}
	}
	
	
//	[UIView commitAnimations];
	
	return _cursorOrigin.y + fontSize.height + marginY;
}

- (void)updateHeight {

	CGFloat previousHeight = self.frame.size.height;
	CGFloat newHeight = [self layoutCells];
	if (previousHeight && newHeight != previousHeight) {
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, newHeight);
		//self.height = newHeight;
		[self setNeedsDisplay];
		
		SEL sel = @selector(textFieldDidResize:);
		if ([self.delegate respondsToSelector:sel]) {
			[self.delegate performSelector:sel withObject:self];
		}
	}

//	if( self.frame.size.height > 166)
		[self scrollToEditingLine:YES];
//	else
//		[self scrollToVisibleLine:YES];
}

- (CGFloat)marginY {
	CGSize fontSize = [@"M" sizeWithFont:self.font];
	return floor(fontSize.height/kPaddingRatio);
}

- (CGFloat)topOfLine:(int)lineNumber {
	if (lineNumber == 0) {
		return 0;
	} else {
		CGFloat lineHeight = [@"M" sizeWithFont:self.font].height;
		CGFloat lineSpacing = kCellPaddingY*2 + kSpacingY;
		CGFloat marginY = floor(lineHeight/kPaddingRatio);
		CGFloat lineTop = marginY + (lineHeight + lineSpacing) *lineNumber;
		return lineTop - lineSpacing; 
	}
}

- (CGFloat)centerOfLine:(int)lineNumber {
	CGFloat lineTop = [self topOfLine:lineNumber];
	CGFloat lineHeight = [@"M" sizeWithFont:self.font].height + kCellPaddingY*2 + kSpacingY;
	return lineTop + floor(lineHeight/2);
}

- (CGFloat)heightWithLines:(int)lines {
	CGFloat lineHeight = [@"M" sizeWithFont:self.font].height;
	CGFloat lineSpacing = kCellPaddingY*2 + kSpacingY;
	CGFloat marginY = floor(lineHeight/kPaddingRatio);
	return marginY + lineHeight*lines + lineSpacing*(lines ? lines-1 : 0) + marginY;
}

- (void)selectNoCell {
	self.selectedCell = nil;
}

- (void)selectLastCell {
	self.selectedCell = [_cellViews objectAtIndex:_cellViews.count-1];
}

- (NSString*)labelForObject:(id)object {
	GTokenFieldCell *cell = object;
	return [NSString stringWithFormat:@"%@", cell.label];
}
- (NSString*)numberForObject:(id)object {
	GTokenFieldCell *cell = object;
	return [NSString stringWithFormat:@"%@", cell._number];
}
//////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)layoutSubviews {
	[self layoutCells];
	[super layoutSubviews];
}

- (CGSize)sizeThatFits:(CGSize)size {
	[self layoutIfNeeded];
	CGFloat height = [self heightWithLines:_lineCount];
	return CGSizeMake(size.width, height);
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	UITouch* touch = [touches anyObject];
	if (touch.view == self) {
		self.selectedCell = nil;
		self.text = kEmpty;
	} else {
		if ([touch.view isKindOfClass:[GTokenFieldCell class]]) {
			self.selectedCell = (GTokenFieldCell*)touch.view;
		}
	}
	[super touchesEnded:touches withEvent:event];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UITextField

- (void)setFont:(UIFont*)font {
	[super setFont:font];
}

- (UIFont*)font {
	return super.font;
}

- (void)setText:(NSString*)text {
	[self updateHeight];
	[super setText:text];
}

- (NSString*) text {
	return super.text; 
}

- (NSString*) commaSeparatedText {
	NSString* commaSeparatedTextString = [[NSString alloc] init];
	int i, count = [_cellViews count];
	
	for( i = 0; i < count; i++)
	{
		commaSeparatedTextString = [[[commaSeparatedTextString autorelease] stringByAppendingString:[self labelForObject:[_cellViews objectAtIndex:i]]] retain];
		if( i != count - 1 )
		{
			commaSeparatedTextString = [[[commaSeparatedTextString autorelease] stringByAppendingString:@","] retain];
		}
	}
	
	[commaSeparatedTextString autorelease];
	return commaSeparatedTextString;
}
-(int) totalObject
{
	return [_cellViews count];
}
-(NSString *)GetNameAtIndex:(int)index
{
	int  count = [_cellViews count];
	if(index<count)
	{
		NSString* returnString = [[NSString alloc] init];
		returnString = [[NSString alloc] initWithString:[self labelForObject:[_cellViews objectAtIndex:index]]];
		[returnString autorelease];
		return returnString;
		
		
		
	
	}
	return nil;
}
- (NSString*) commaSeparatedNumber {
	NSString* commaSeparatedTextString = [[NSString alloc] init];
	int i, count = [_cellViews count];
	
	for( i = 0; i < count; i++)
	{
		commaSeparatedTextString = [[[commaSeparatedTextString autorelease] stringByAppendingString:[self numberForObject:[_cellViews objectAtIndex:i]]] retain];
		if( i != count - 1 )
		{
			commaSeparatedTextString = [[[commaSeparatedTextString autorelease] stringByAppendingString:@","] retain];
		}
	}
	
	[commaSeparatedTextString autorelease];
	return commaSeparatedTextString;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
	if( [self.text isEqualToString:kSelected] ) {
		return CGRectMake(-10, -10, 0, 0);
	}
	else {
		CGRect frame = CGRectOffset(bounds, _cursorOrigin.x, _cursorOrigin.y);
		frame.size.width -= (_cursorOrigin.x + kPaddingX + (self.rightView ? kClearButtonSize : 0));
		return frame;
	}
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
	return [self textRectForBounds:bounds];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
	return [self textRectForBounds:bounds];
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
	if (self.leftView) {
		return CGRectMake(bounds.origin.x+kPaddingX, self.marginY, self.leftView.frame.size.width, self.leftView.frame.size.height);
	} else {
		return bounds;
	}
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
	if (self.rightView) {
		return CGRectMake(bounds.size.width - kClearButtonSize, bounds.size.height - kClearButtonSize, kClearButtonSize, kClearButtonSize);
	} else {
		return bounds;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// GSearchTextField
//
- (BOOL)hasText {
	return self.text.length && ![self.text isEqualToString:kEmpty] && ![self.text isEqualToString:kSelected];
}
//
//- (void)showSearchResults:(BOOL)show {
//	[super showSearchResults:show];
//	if (show) {
//		[self scrollToEditingLine:YES];
//	} else {
//		[self scrollToVisibleLine:YES];
//	}
//}
//
//- (CGRect)rectForSearchResults:(BOOL)withKeyboard {
//	UIView* superview = self.superviewForSearchResults;
//	CGFloat y = superview.screenY;
//	CGFloat visibleHeight = [self heightWithLines:1];
//	CGFloat keyboardHeight = withKeyboard ? KEYBOARD_HEIGHT : 0;
//	CGFloat tableHeight = self.window.frame.size.height - (y + visibleHeight + keyboardHeight);
//	
//	return CGRectMake(0, self.bottom-1, superview.frame.size.width, tableHeight+1);
//}
//
-(void)setTableOn:(int)onB
{
	tableonB = onB;
}
- (BOOL)shouldUpdate:(BOOL)emptyText {
	if (emptyText && !self.hasText && !self.selectedCell && self.cells.count) {
		//backspace select last cell
		
		self.text = kEmpty;
		[self selectLastCell];
		[self scrollToVisibleLine:YES];
		[self scrollToEditingLine:YES];
		return NO;
	} else if (emptyText && self.selectedCell) {
		//remove last cell
		[self removeSelectedCell];
		return NO;
	} else {
		//normal text
		if(tableonB)
		{	
			[self scrollToEditingLine:YES];
		//	tableonB = NO:
			
		}	
		return YES;
	}
}
//
///////////////////////////////////////////////////////////////////////////////////////////////////
// UITableViewDelegate

//- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
//	[_tableView deselectRowAtIndexPath:indexPath animated:NO];
//	
//	id object = [_dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
//	[self addCellWithObject:object];
//}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIControlEvents

- (void)textFieldDidEndEditing {
	if (_selectedCell) {
		[self selectNoCell];
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (NSArray*)cells {
	NSMutableArray* cells = [NSMutableArray array];
	for (GTokenFieldCell* cellView in _cellViews) {
		[cells addObject:cellView.object ? cellView.object : [NSNull null]];
	}
	return cells;
}

- (void)addCellWithObject:(id)object {
	GTokenFieldCell* cell = [[[GTokenFieldCell alloc] initWithFrame:CGRectZero] autorelease];

	// for improving animation effect
	cell.frame = CGRectMake(_cursorOrigin.x, _cursorOrigin.y-kCellPaddingY,	cell.frame.size.width, cell.frame.size.height);
	
	NSString* label = [self labelForObject:object];
	cell.object = object;
	cell.label = label;
	cell.font = self.font;
	[_cellViews addObject:cell];
	[self addSubview:cell];
	
	// Reset text so the cursor moves to be at the end of the cellViews
	self.text = kEmpty;

	SEL sel = @selector(textField:didAddCellAtIndex:);
	if ([self.delegate respondsToSelector:sel]) {
		[self.delegate performSelector:sel withObject:self withObject:(id)_cellViews.count-1];
	}
}

- (void)addCellWithString:(NSString*)string type:(NSString*)lnumberStrP {
	//check if its present
	for( int i=0; i<[_cellViews count]; i++)
	{
		GTokenFieldCell *cell = [_cellViews objectAtIndex:i];
		if( [string isEqualToString:cell.label] && [lnumberStrP isEqualToString:cell._number] )
			return;
	}
	
	
	GTokenFieldCell* cell = [[[GTokenFieldCell alloc] initWithFrame:CGRectZero] autorelease];
	
	// for improving animation effect
	cell.frame = CGRectMake(_cursorOrigin.x, _cursorOrigin.y-kCellPaddingY,	cell.frame.size.width, cell.frame.size.height);
	
	NSString* label = [NSString stringWithString:string];
	cell.object = [NSString stringWithString:string];
	cell.label = label;
	cell._number = lnumberStrP;
	cell.font = self.font;
	[_cellViews addObject:cell];
	[self addSubview:cell];
	
	// Reset text so the cursor moves to be at the end of the cellViews
	self.text = kEmpty;
		
	SEL sel = @selector(textField:didAddCellAtIndex:);
	if ([self.delegate respondsToSelector:sel]) {
		[self.delegate performSelector:sel withObject:self withObject:(id)_cellViews.count-1];
	}	
}

- (void)removeCellWithObject:(id)object {
	for (int i = 0; i < _cellViews.count; ++i) {
		GTokenFieldCell* cell = [_cellViews objectAtIndex:i];
		if (cell.object == object) {
			[_cellViews removeObjectAtIndex:i];
			[cell removeFromSuperview];
			
			SEL sel = @selector(textField:didRemoveCellAtIndex:);
			if ([self.delegate respondsToSelector:sel]) {
				[self.delegate performSelector:sel withObject:self withObject:(id)i];
			}
			break;
		}
	}
	
	// Reset text so the cursor oves to be at the end of the cellViews
	self.text = self.text;
}

- (void)removeAllCells {
	while (_cellViews.count) {
		GTokenFieldCell* cell = [_cellViews objectAtIndex:0];
		[cell removeFromSuperview];
		[_cellViews removeObjectAtIndex:0];
		[self updateHeight];
	}
	
	[self selectNoCell];
}

- (void)setSelectedCell:(GTokenFieldCell*)cell {
	if (_selectedCell) {
		_selectedCell.selected = NO;
	}
	
	_selectedCell = cell;
	
	if (_selectedCell) {
		_selectedCell.selected = YES;
		[self setText:kSelected];
	} else if (self.cells.count) {
		self.text = kEmpty;
	}
}

- (void)removeSelectedCell {
	if (_selectedCell) {
		[self removeCellWithObject:_selectedCell.object];
		_selectedCell = nil;
		
		if (_cellViews.count) {
			self.text = kEmpty;
		} else {
			self.text = @" ";
		}
	}
}

- (void)scrollToVisibleLine:(BOOL)animated {
	if (self.editing) {
		UIScrollView* scrollView = (UIScrollView*)[self findRootViewOfClass:[UIScrollView class]];
		if (scrollView) {
			[scrollView setContentOffset:CGPointMake(0, self.frame.origin.y) animated:animated];
		}
	}
}

- (void)scrollToEditingLine:(BOOL)animated {
	UIScrollView* scrollView = (UIScrollView*)[self findRootViewOfClass:[UIScrollView class]];
	if (scrollView) 
	{
		//CGFloat offset = _lineCount == 1 ? 0 : [self topOfLine:_lineCount-1];
		//[scrollView setContentOffset:CGPointMake(0, self.frame.origin.y + offset) animated:animated];
		[scrollView setContentOffset:CGPointMake(0, self.frame.size.height - 42) animated:YES];
	}
}
@end
