//
//  ContactCellView.h
//  munduSMS
//
//  Created by Vinay Chavan on 14/06/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Contact;

@interface ContactCellView : UIView {
	Contact *_contact;
	BOOL selected;
}

@property (nonatomic, assign) BOOL selected;

- (void)setObject:(Contact*)objct;
- (Contact*)getObject;
@end
