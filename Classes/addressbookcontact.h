//
//  addressBookContact.h
//  spokn
//
//  Created by Mukesh Sharma on 11/08/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
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