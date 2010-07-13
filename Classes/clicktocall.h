//
//  clicktocall.h
//  spokn
//
//  Created by Rishi Saxena on 12/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "spoknAppDelegate.h"
@class SpoknAppDelegate;
@interface clicktocall : UIViewController <UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate> {

	SpoknAppDelegate * ownerobject;
	IBOutlet UITableView *tableView;
	UILabel *labelAparty;
	UILabel *labelconnectionType;
	UILabel *number;
	Boolean modalB;
	int viewResult;
	char *apartyNoCharP;
	UIActionSheet *uiActionSheetgP;
	UIView *customview;
	UILabel *text;
	NSMutableArray *sectionHeaders;
	int protocolType;
}
@property(nonatomic,assign) UITableView *tableView;
-(void)setObject:(id) object ;
-(void)modelViewB:(Boolean)lmodalB;
-(void)addCallbacknumber;
- (void)setprotocolType:(int)index;
-(char*) gecallbackNumber;

@end
