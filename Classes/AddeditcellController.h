//
//  SectionedTableController.h
//  SectionedTable
//
//  Created by Vinod Panicker on 30/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
/**
 Copyright 2009 John Smith, <john.smith@example.com>
 
 This file is part of FOOBAR.
 
 FOOBAR is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 FOOBAR is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with FOOBAR.  If not, see <http://www.gnu.org/licenses/>.
 */

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
- (void) handleTextFieldChanged:(id)sender;
@end


