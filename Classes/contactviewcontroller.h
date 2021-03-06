
//  Created on 05/07/09.

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
@protocol AddCallProtocol;
@interface ContactViewController : UIViewController<ABPeoplePickerNavigationControllerDelegate , UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>  {
	IBOutlet UITableView *tableView;
	IBOutlet UIView *noResultViewP;
	IBOutlet UILabel*noResultLabelP;
	//IBOutlet UIView *viewP;
	//IBOutlet UITableView *addressBookTableView;
	IBOutlet AddressBookContact *addressBookTableDelegate;
	//UIAddressBook *addressBookUIP;
	UISegmentedControl *segmentedControl;
	UIView *tempview;
	//NSMutableArray *fileList;
	SpoknAppDelegate *ownerobject;
	
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
	CGRect tableframe;
	Boolean searchStartB;
	UIView *mainViewP;
	int loadedNewViewB;
	int refreshB;
	int viewDidLodadedB;
	int noserchResultShowB;
	Boolean hideCallAndVmailButtonB;
	Boolean viewOnB;
	id<AddCallProtocol> addcallDelegate;
	//NSArray *sectionNSArrayP;
	#ifdef _NEW_ADDRESS_BOOK_
		ABPeoplePickerNavigationController *addressBookP;
	#endif
	Boolean contactTabControllerB;

}
@property(readwrite,assign) id<AddCallProtocol> addcallDelegate;

@property(readwrite,assign) Boolean  contactTabControllerB;

@property (readwrite,assign) UAObjectType uaObject;
@property(readwrite,assign) int parentView;
-(void)setObject:(id) object ;
-(void)hideCallAndVmailButton:(Boolean)showB;
- (void) reload;
- (void) startEditing;
- (void) stopEditing;
-(void)setObjType:(UAObjectType)luaObj;
- (int) reloadLocal:(NSString *)searchStrP : (int*) firstSectionP ;
- (void) doneSearching_Clicked:(id)sender;
-(void) setReturnVariable:(id) rootObject :(SelectedContctType *)lselectedContactP : (int *)valP;
-(int)  showContactDetailScreen: (struct AddressBook * )addressP :(ViewTypeEnum) viewEnum contactBook:(ABRecordRef)contactRefP;
- (BOOL)searchBarStartEditing:(UISearchBar *)searchBar;
-(void)cancelSearch;
- (void) doRefresh ;
- (void) removeSelectionFromAddressBook;
- (void)controlPressed:(id) sender ;
- (void)updateUI:(id) objectP;
-(Boolean)searchStringFroName:(NSString*)nameStrP key:(NSString*)keyStrP;
+(int) getNameAndType:(ABAddressBookRef) laddressRef :(ABRecordID) recordID :(char*)lnumberCharP :(char **) nameStringP :(char**)typeP;
+(int) addDetailsFromAddressBook :(ContactDetailsViewController     *)ContactControllerDetailsviewP :(ViewTypeEnum) viewEnum contactBook:(ABRecordRef)person;
@end
