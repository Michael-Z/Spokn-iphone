//
//  confrenceviewcontroller.h
//  spokn
//
//  Created by Mukesh Sharma on 03/05/10.
//  Copyright 2010 Geodesic Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma pack(4)  
@class CallViewController ;
@class SpoknAppDelegate;

//#define FRAMEX 60
#define SPACE_DEL 15
#define SPACE_NO_DEL 5
@protocol AddCallProtocol;
typedef struct callRowOrder
{
	int order;
	int selected;
}callRowOrder;
@interface ConferenceViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView *tableView;
	SpoknAppDelegate *ownerObject;
	id<AddCallProtocol> addCallP;
	int showB;
	int firstB;
	callRowOrder callRow[10];
	
	
}
-(void)reload;
-(void)setObject:(id)ownerObjP;
-(void)setDelegate:(CallViewController *)lcallViewCtlP;
-(void)showPrivate:(int)lshowB;
-(void)giveOrder;
-(void)sortByOrder;
@end
