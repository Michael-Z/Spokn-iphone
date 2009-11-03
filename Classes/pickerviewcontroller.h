//
//  pickerviewcontroller.h
//  spokn
//
//  Created by Kaustubh Deshpande on 27/10/09.
//  Copyright 2009 Geodesic Ltd. All rights reserved.
//

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
/*typedef struct ContactListType
	{
		SelectedContctType  contactObject;	
		struct ContactListType *prevP;
		struct ContactListType *nextP;
	}ContactListType;*/
/*
@interface BarBG : UIView {
	UIColor* _color1;
	UIColor* _color2;
}
@property(nonatomic,retain) UIColor* color1;
@property(nonatomic,retain) UIColor* color2;
@end
*/
@protocol UpDateViewProtocol

@optional
- (void)upDateScreen;
-( void)sendForwardVms:(char*)forwardP;
-(void)addContact:(UIViewController*)rootP;
-(int)getForwardNumber:(SelectedContctType*)  lcontactObjectP;
-(int)keyBoardOnOrOff:(BOOL)onB :(CGRect*) frameP;

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
	//NSString *detailStrP;

}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier;
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
-(void)setData:/*out parameter*/(char *)valueCharP value:(char*)fieldP placeHolder:(char*)placeHolderP/*out parameter*/returnValue:(int *)returnP;
-(IBAction)cancelPressed;
-(IBAction)savePressed;
-(void)setObject:(id) object;
-(void) SetkeyBoardType:(UIKeyboardType) type : (int) maxCharInt buttonType:(int)lbuttonType;
- (IBAction) updateSearchTable : (id) sender;
- (void) showSearchTable;
- (void) hideSearchTable;
- (void)update_txtDestNo :(NSString *)typeStrP;
-(NSString*)remSpChar:(NSString *)str;
-(void)addSelectedContact:(SelectedContctType*)  lcontactObjectP;
-(void) delNode :(BOOL) allB;
-(void) viewLoadedModal:(BOOL)lmodalB;
-(char*) getContactNumberList;
-(IBAction)addContactPressed:(id)sender;
-(IBAction)addFromContact:(id)sender;
- (void)updateLayout;
-(int) addElement :(NSMutableArray *)searchedContactsP contactObject:(Contact*)lcontactP;
-(void)removeKeyBoard;
@property(nonatomic,readwrite,assign) id<UpDateViewProtocol> upDateProtocolP;
@end
