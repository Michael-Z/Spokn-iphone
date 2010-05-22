
//  Created on 27/10/09.


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
#import "AddressBookUI/AddressBookUI.h"
#import "AddressBook/AddressBook.h"
#import "contactDetailsviewcontroller.h"
#define _NAME_IN_TABLE_
@class SpoknAppDelegate;
@class GTokenField;
@class Contact;
@protocol UpDateViewProtocol

@optional
- (void)upDateScreen;
-( void)sendForwardVms:(char*)forwardP;
-(void)addContact:(UIViewController*)rootP;
-(int)getForwardNumber:(SelectedContctType*)  lcontactObjectP;
-(int)keyBoardOnOrOff:(BOOL)onB :(CGRect*) frameP viewHeight:(float)height;
-(void)showOrHideSendButton:(BOOL)showB;

@end
@class pickerviewcontroller;
@interface MyLabel : UILabel 
{
	
	id<UpDateViewProtocol> upDateProtocolP;
	
}
@property(nonatomic,readwrite,assign) id<UpDateViewProtocol> upDateProtocolP;
@end

@interface pickerviewcontroller : UIViewController <UpDateViewProtocol,UITextViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,ABPeoplePickerNavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>{
	SpoknAppDelegate *ownerobject;
	UIKeyboardType keyboardtype;
	GTokenField *txtDestNo;
	MyLabel *toLabel;
	MyLabel *toLabelStart;
	UIScrollView *_composerScrollView;
	UITableView *tbl_contacts;
	ABAddressBookRef addressBook;
	NSMutableArray *searchedContacts;
	//---------------------------------
	UAObjectType uaObject;
	NSMutableArray *searchArray;
	int count;
	//ContactListType *startListP;
	//ContactListType *endListP;
	BOOL modalB;
	id<UpDateViewProtocol> upDateProtocolP;
	NSString *allDestno;
	BOOL keyBoardOnB;
	BOOL showTableB;
	CGRect frameRect;
	CGRect prevRect;
	//NSString *detailStrP;

}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier;
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
-(void)setData:/*out parameter*/(char *)valueCharP value:(char*)fieldP placeHolder:(char*)placeHolderP/*out parameter*/returnValue:(int *)returnP;
-(void)setObject:(id) object;
-(void) SetkeyBoardType:(UIKeyboardType) type : (int) maxCharInt buttonType:(int)lbuttonType;
- (IBAction) updateSearchTable : (id) sender;
- (void) showSearchTable;
- (void) hideSearchTable;
- (void)update_txtDestNo :(NSString *)typeStrP;
-(NSString*)remSpChar:(NSString *)str;
-(void)addSelectedContact:(SelectedContctType*)  lcontactObjectP;
//-(void) delNode :(BOOL) allB;
-(void) viewLoadedModal:(BOOL)lmodalB;
-(char*) getContactNumberList;
-(IBAction)addContactPressed:(id)sender;
-(IBAction)addFromContact:(id)sender;
- (void)updateLayout;
-(int) addElement :(NSMutableArray *)searchedContactsP contactObject:(Contact*)lcontactP;
-(void)removeKeyBoard;
-(void)openKeyBoard;
@property(nonatomic,readwrite,assign) id<UpDateViewProtocol> upDateProtocolP;
@end
