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
#import "VmailViewController.h"
#import "calllogviewcontroller.h"
#import "contactviewcontroller.h"
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
	NSString *placeHolderP;
	int contactID;
	int *returnP;
	char *rvalueCharP;
	Boolean shiftRootB;
	UIKeyboardType keyboardtype;
	int fieldRangeInt;
	id navRootObject;
	int buttonType;
		
}
-(void)setData:/*out parameter*/(char *)valueCharP value:(char*)fieldP placeHolder:(char*)placeHolderP/*out parameter*/returnValue:(int *)returnP;
-(IBAction)cancelPressed;
-(IBAction)savePressed;
-(void)setObject:(id) object;
-(void) shiftToRoot:(id)lnavRootObject :(Boolean ) rootB;
-(void) SetkeyBoardType:(UIKeyboardType) type : (int) maxCharInt buttonType:(int)lbuttonType;

@end


