//
//  contact.h
//  spoknclient
//
//  Created by Mukesh Sharma on 05/07/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ltptimer.h"
#import "LtpInterface.h"
#include "ua.h"
#include "vmsplayrecord.h"
#import "contactDetailsviewcontroller.h"
#import <AddressBookUI/AddressBookUI.h>
#define MAXSEC 28
#define ALPHA @"!ABCDEFGHIJKLMNOPQRSTUVWXYZ#"
#define ALPHA_ARRAY [NSArray arrayWithObjects: @"{search}" , @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R",@"S",@"T", @"U", @"V", @"W", @"X", @"Y",@"Z",@"#" , nil] 

@class SpoknAppDelegate;

@class AddressBookContact;
@class UIAddressBook;
@class OverlayViewController;
//@class ABPeoplePickerNavigationController;
#define _NEW_ADDRESS_BOOK_
#define _NO_SEARCH_MOVE_

@interface ContactViewController : UIViewController<ABPeoplePickerNavigationControllerDelegate , UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>  {
	IBOutlet UITableView *tableView;
	//IBOutlet UITableView *addressBookTableView;
	IBOutlet AddressBookContact *addressBookTableDelegate;
	//UIAddressBook *addressBookUIP;
	UISegmentedControl *segmentedControl;

	//NSMutableArray *fileList;
	SpoknAppDelegate *ownerobject;
	LtpInterfaceType *ltpInterfacesP;
	UAObjectType uaObject;
	NSMutableArray *sectionArray;
	NSMutableArray *searchArray;
	UISearchBar *searchbar;
	OverlayViewController *ovController;
	int *returnPtr;
	//char *numberCharP;
	SelectedContctType *selectedContactP;
	int parentView;//this variable distinguish between different parent view
	id rootControllerObject;
	long contactID;
	int resultInt;
	int firstSection;	
	CGRect gframe;
	Boolean searchStartB;
	//NSArray *sectionNSArrayP;
	#ifdef _NEW_ADDRESS_BOOK_
		ABPeoplePickerNavigationController *addressBookP;
	#endif

}
@property(readwrite,assign) LtpInterfaceType *ltpInterfacesP;

@property (readwrite,assign) UAObjectType uaObject;
@property(readwrite,assign) int parentView;
-(void)setObject:(id) object ;
- (void) reload;
- (void) startEditing;
- (void) stopEditing;
-(void)setObjType:(UAObjectType)luaObj;
- (int) reloadLocal:(NSString *)searchStrP : (int*) firstSectionP ;
- (void) doneSearching_Clicked:(id)sender;
-(void) setReturnVariable:(id) rootObject :(SelectedContctType *)lselectedContactP : (int *)valP;
-(int)  showContactDetailScreen: (struct AddressBook * )addressP :(ViewTypeEnum) viewEnum contactBook:(ABRecordRef)contactRefP;
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
-(void)cancelSearch;
@end
