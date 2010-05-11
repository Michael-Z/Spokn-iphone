//
//  confrenceviewcontroller.h
//  spokn
//
//  Created by Mukesh Sharma on 03/05/10.
//  Copyright 2010 Geodesic Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CallViewController ;
@class SpoknAppDelegate;
@protocol AddCallProtocol;
@interface ConferenceViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView *tableView;
	SpoknAppDelegate *ownerObject;
	id<AddCallProtocol> addCallP;
	int showB;
}
-(void)reload;
-(void)setObject:(id)ownerObjP;
-(void)setDelegate:(CallViewController *)lcallViewCtlP;
-(void)showPrivate:(int)lshowB;
@end
