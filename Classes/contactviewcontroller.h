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
#define MAXSEC 27
#define ALPHA @"!ABCDEFGHIJKLMNOPQRSTUVWXYZ"
#define ALPHA_ARRAY [NSArray arrayWithObjects: @"", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R",@"S",@"T", @"U", @"V", @"W", @"X", @"Y",@"Z" , nil] 

@class SpoknAppDelegate;

@class AddressBookContact;
@class UIAddressBook;
@class OverlayViewController;
@interface ContactViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>  {
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
	IBOutlet UISearchBar *searchbar;
	OverlayViewController *ovController;
		
	

}
@property(readwrite,assign) LtpInterfaceType *ltpInterfacesP;

@property (readwrite,assign) UAObjectType uaObject;
-(void)setObject:(id) object ;
- (void) reload;
- (void) startEditing;
- (void) stopEditing;
-(void)setObjType:(UAObjectType)luaObj;
- (int) reloadLocal:(NSString *)searchStrP;
- (void) doneSearching_Clicked:(id)sender;
@end
