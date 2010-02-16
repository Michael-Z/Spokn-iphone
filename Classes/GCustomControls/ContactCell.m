//
//  ContactCell.m
//  munduSMS
//
//  Created by Vinay Chavan on 14/06/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

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
