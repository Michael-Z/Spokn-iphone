
//  Created  on 14/06/09.
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

#import "ContactCell.h"
#import "ContactCellView.h"

@implementation ContactCell

- (id)initWithCustomFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    
	#ifdef __IPHONE_3_0
		if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
	#else
			if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {	
	#endif	
	
        // Initialization code
		
		CGRect cellFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		_contactCellView = [[ContactCellView alloc] initWithFrame:cellFrame];
		
		_contactCellView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | 
										   UIViewAutoresizingFlexibleWidth | 
										   UIViewAutoresizingFlexibleTopMargin | 
										   UIViewAutoresizingFlexibleLeftMargin | 
										   UIViewAutoresizingFlexibleRightMargin | 
										   UIViewAutoresizingFlexibleBottomMargin);
		[self.contentView addSubview:_contactCellView];
    }
    return self;
}

- (void)setCellInfo:(Contact*)obj
{
	[_contactCellView setObject:obj];
}

- (Contact*)getCellInfo
{
	return [_contactCellView getObject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
	_contactCellView.selected = selected;
	[_contactCellView setNeedsLayout];
}

- (void)dealloc {
	[_contactCellView release];
    [super dealloc];
}


@end
