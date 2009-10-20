//
//  addressBookContact.h
//  spokn
//
//  Created by Mukesh Sharma on 11/08/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

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