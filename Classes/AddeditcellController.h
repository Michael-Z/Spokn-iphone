
//  Created on 30/09/09.

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
	UILabel *footerLabelP;
	SpoknAppDelegate *ownerobject;
	//struct AddressBook *addressDataP;
	Boolean editable;
	NSString *StringP;
	NSString *typeP;
	NSString *titleStrP;
	NSString *placeHolderP;
	NSString *exampleStrP;
	int contactID;
	int *returnP;
	char *rvalueCharP;
	Boolean shiftRootB;
	UIKeyboardType keyboardtype;
	int fieldRangeInt;
	id navRootObject;
	int buttonType;
	int onlyOneB;
	int activeAditButtonB;
	int hidefooterB;
	int autoCapitalOn;
		
}
-(void)setData:/*out parameter*/(char *)lvalueCharP value:(char*)fieldP placeHolder:(char*)lplaceHolderP title:(char*)titleP/*out parameter*/returnValue:(int *)lreturnP;
-(IBAction)cancelPressed;
-(IBAction)savePressed;
-(void)setObject:(id) object;
-(void) shiftToRoot:(id)lnavRootObject :(Boolean ) rootB;
-(void) SetkeyBoardType:(UIKeyboardType) type : (int) maxCharInt buttonType:(int)lbuttonType;
- (void) handleTextFieldChanged:(id)sender;
- (void)updateUI:(id) objectP;
-(void)hideFooter;
@end


