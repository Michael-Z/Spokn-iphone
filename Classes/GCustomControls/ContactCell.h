//
//  ContactCell.h
//  munduSMS
//
//  Created by Vinay Chavan on 14/06/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Contact;
@class ContactCellView;

@interface ContactCell : UITableViewCell {
	ContactCellView *_contactCellView;
}

- (void)setCellInfo:(Contact*)obj;
- (Contact*)getCellInfo;
- (id)initWithCustomFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;
@end
