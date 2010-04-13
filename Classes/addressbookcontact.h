
//  Created on 11/08/09.

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
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBook/ABPerson.h>
#import <AddressBook/ABRecord.h>
#import <AddressBookUI/AddressBookUI.h>

@class SpoknAppDelegate;
@class OverlayViewController;
@interface AddressBookContact : NSObject<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate, ABPersonViewControllerDelegate> {
	NSMutableArray *peopleArray;
	UIViewController *controllerP;
	//NSMutableArray *searchArray;
	NSMutableArray *sectionArray;
	UITableView *tableView;
	UISearchBar *searchBarP;
	SpoknAppDelegate *ownerobject;
	OverlayViewController **ovControllerP;
	Boolean searchB;
	
}

+(NSString *) getName: (ABRecordRef) person;
-(void)setObject:(id) object ;
- (void)loadViewLoc;
-(void)setSearchBarAndTable:(UISearchBar *)lBarP :(UITableView *)tableP PerentObject:(UIViewController *)lcontrollerP OverlayView:(OverlayViewController **)lovController;
@end
#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface UIAddressBook : NSObject <ABPeoplePickerNavigationControllerDelegate>
{
	UIViewController* uiControllerP;
	ABPeoplePickerNavigationController *ab;
	UISegmentedControl *segmentedControl;
}
- (void) ShowPhoneContact:(UIViewController*)luiControllerP;
- (void) HidePhoneContact;

@end