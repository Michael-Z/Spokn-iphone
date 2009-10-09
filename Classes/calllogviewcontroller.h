//
//  CalllogViewController.h
//  spokn
//
//  Created by Mukesh Sharma on 03/08/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LtpInterface.h"
#include "ua.h"
#import "customCell.h"

@class SpoknAppDelegate;
@interface CalllogViewController : UIViewController< UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate> {
	IBOutlet UITableView *tableView;
	SpoknAppDelegate *ownerobject;	
	UAObjectType uaObject;
	UIImage  *missImageP;
	UIImage  *inImageP;
	UIImage  *outImageP;
	CellObjectContainer *cellofcalllogP;
	UIFont *fontGloP;
	int showMisscallInt;
	UISegmentedControl *segmentedControl;
	
}
-(void)setObject:(id) object ;
-(void)setObjType:(UAObjectType)luaObj;
- (void)addRow: (int )index sectionObject:(sectionType **)sectionPP;
@end
