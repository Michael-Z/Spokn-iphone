//
//  AddEditcontactViewController.h
//  spokn
//
//  Created by Mukesh Sharma on 04/08/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LtpInterface.h"
#include "ua.h"
@class SpoknAppDelegate;
@interface AddEditcontactViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UILabel *nameLabelP;
	IBOutlet UITextField *nameFieldP;
	IBOutlet UILabel *mobileLabelP;
	IBOutlet UITextField *mobileFieldP;
	IBOutlet UILabel *businessLabelP;
	IBOutlet UITextField *businessFieldP;
	IBOutlet UILabel *homeLabelP;
	IBOutlet UITextField *homeFieldP;
	IBOutlet UILabel *emailLabelP;
	IBOutlet UITextField *emailFieldP;
	IBOutlet UILabel *spoknIdLabelP;
	IBOutlet UITextField *spoknIdFieldP;

	SpoknAppDelegate *ownerobject;
	LtpInterfaceType *ltpInterfacesP;
	int contactID;

	

}
@property(readwrite,assign) LtpInterfaceType *ltpInterfacesP;
-(void)setObject:(id) object ;
-(void)setContactDetail:(struct AddressBook *)addrP;
-(IBAction)doneClicked;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@end
