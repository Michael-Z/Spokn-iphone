//
//  ContactDetailsViewController.h
//  spoknclientContactDetails

//  Created by Mukesh Sharma on 01/07/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ltptimer.h"
#import "LtpInterface.h"
#include "ua.h"
#define MAX_COUNT 7
@class SpoknAppDelegate;
@interface ContactDetailsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UILabel *userNameP;
	IBOutlet UITableView *tableView;

	int tablesz;
	char *element[MAX_COUNT]; 
	struct AddressBook *addressDataP;
	SpoknAppDelegate *ownerobject;
}

-(void)setObject:(id) object ;
-(void)setAddressBook:( struct AddressBook *)laddressDataP;

@end
