//
//  spoknviewcontroller.h
//  spokn
//
//  Created by Mukesh Sharma on 02/10/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//
#define MAXVIEW 5
#define MAXSECTION 3
#import <UIKit/UIKit.h>
/*typedef struct SubViewDetails
	{
		int sectionInt;
		UIView *viewForrowP;
	}SubViewDetails;
 */
@class SpoknAppDelegate;
@interface SpoknViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
	
	SpoknAppDelegate *ownerobject;
	//SubViewDetails subViewDetails[MAXVIEW];
	IBOutlet UITableView *tableView;
	IBOutlet UIButton *buttonCtlP;
	NSMutableArray *listOfItems;
	UILabel *labelBalance;
	UILabel *labelStatus;
	UILabel *labelForword;
	UILabel *labelSpoknNo;
	UISwitch *switchView;
	int viewResult;
	char *forwardNoCharP;
	

}
-(IBAction)buyCredit:(id)sender;
-(void)setObject:(id) object ;
-(void)setDetails:(char *)titleCharP :(int )statusInt :(float) balance :(char *)forwardNoCharP :(char *)spoknCharP;
- (IBAction)switchChange:(UISwitch*)sender;

@end
