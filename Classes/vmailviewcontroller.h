//
//  VmailViewController.h
//  spokn
//
//  Created by Mukesh Sharma on 03/08/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LtpInterface.h"
#include "ua.h"
#include "vmsplayrecord.h"
#import "customCell.h"
@class SpoknAppDelegate;
@interface VmailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate> {
	IBOutlet UITableView *tableView;
	SpoknAppDelegate *ownerobject;	
	UAObjectType uaObject;
	LtpInterfaceType *ltpInterfacesP;
	CellObjectContainer *cellofvmsP;
	UIImage  *activeImageP;
	UIImage  *dileverImageP;
	UIImage  *failedImageP;
	UIImage  *vnewImageP;
	UIImage  *readImageP;
	UIProgressView *uiProgressP;
	UIActionSheet  *uiActionSheetP;
	NSTimer        *nsTimerP;
	float maxtime;
	float amt;
	int showFailInt;
	UISegmentedControl *segmentedControl;
	int viewPlayResult;


}
-(void)setObject:(id) object ;
-(void)setObjType:(UAObjectType)luaObj;
- (void)addRow: (int )index sectionObject:(sectionType **)sectionPP;
-(void)stopvmsPlay;
-(void)startVmsProgress:(char*)fileNameCharP :(int) max :(struct VMail *)vmailP;
@property(readwrite,assign) LtpInterfaceType *ltpInterfacesP;
@end
