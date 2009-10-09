//
//  vmshowviewcontroller.h
//  spokn
//
//  Created by Mukesh Sharma on 07/10/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "contactDetailsviewcontroller.h"
@protocol VmsProtocol

@optional
- (void)VmsStart;
- (void)VmsStop;

@end

@class SpoknAppDelegate;
@interface VmShowViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,VmsProtocol> {
	IBOutlet UITableView *tableView;
	IBOutlet UILabel *msgLabelP;
	IBOutlet UILabel *secondLabelP;
	UIProgressView *uiProgBarP;
	IBOutlet UIButton *sendButtonP;
	IBOutlet UIButton *PlayButtonP;
	IBOutlet UIButton *previewButtonP;
	IBOutlet UIView  *firstSectionviewP;
	IBOutlet UIView  *secondSectionviewP;
	char *nameCharP;
	char *noCharP;
	char *typeCharP;
	Boolean playB;
	Boolean loadedB;
	SpoknAppDelegate *ownerobject;
	struct VMail* vmailP;
	SectionContactType sectionArray[4];
	int sectionCount;
	int maxTime;
	int maxTimeLoc;
	int maxtimeDouble;
	float amt;
	int tablesz;
	NSTimer        *nsTimerP;
	char *fileNameCharP;
	int *returnValLongP;
	
	
	
	
}
- (void)VmsStart;
- (void)VmsStop;
-(void)setFileName:(char*)lfileNameCharP :(int*) lreturnValLongP;
-(void)setvmsDetail:(char*)lnoCharP :(char*)lnameCharP :(char*)ltypeCharP :(Boolean)lplayB :(int)lmaxTime :(struct VMail*) vmailP;

-(IBAction)sendPressed:(id)sender;
-(IBAction)playPressed:(id)sender;
-(IBAction)previewPressed:(id)sender;
- (void)addRow: (int)lsection:(int )row sectionObject:(sectionType **)sectionPP;
-(void)setObject:(id) object ;
-(void)makeView;
-(IBAction)stopButtonPressed:(id)sender;
-(void)loadOtherView;
@end
