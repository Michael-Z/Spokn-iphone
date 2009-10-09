//
//  SectionedTableController.h
//  SectionedTable
//
//  Created by Vinod Panicker on 30/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LtpInterface.h"
#include "ua.h"
@class SpoknAppDelegate;
@class AddressBookContact;
@class UIAddressBook;
@class ContactDetailsViewController;
@interface AddeditcellController : UITableViewController<UITextFieldDelegate> {
	
	UITextField* txtField;
	UILabel *headLabelP;
	SpoknAppDelegate *ownerobject;
	//struct AddressBook *addressDataP;
	Boolean editable;
	NSString *StringP;
	NSString *typeP;
	int contactID;
	int *returnP;
	char *rvalueCharP;
	
}
-(void)setData:/*out parameter*/(char *)valueCharP value:(char*)fieldP /*out parameter*/returnValue:(int *)returnP;
-(IBAction)cancelPressed;
-(IBAction)savePressed;
-(void)setObject:(id) object;
@end

