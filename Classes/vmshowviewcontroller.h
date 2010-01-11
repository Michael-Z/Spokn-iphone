//
//  vmshowviewcontroller.h
//  spokn
//
//  Created by Mukesh Sharma on 07/10/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "contactDetailsviewcontroller.h"
#import "pickerviewcontroller.h"
@protocol VmsProtocol

@optional
- (void)VmsStart;
- (void)VmsStop;
- (void)VmsStopRequest;

@end
typedef enum  VMSStateType
	{
		VMSStatePlay,
		VMSStateRecord,
		VMSStateForward
	}VMSStateType;
	
//#define PROGRESS_VIEW
@class SpoknAppDelegate;
@class pickerviewcontroller;
@class OverlayViewController;
@interface VmShowViewController : UIViewController<UpDateViewProtocol,UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,VmsProtocol,UINavigationControllerDelegate> {
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
	VMSStateType vmstateType;//play record forward
	Boolean loadedB;
	SpoknAppDelegate *ownerobject;
	struct VMail* vmailP;
	SectionContactType sectionArray[MAX_SECTION];
	int sectionCount;
	int maxTime;
	int maxTimeLoc;
	int maxtimeDouble;
	float amt;
	int tablesz;
	NSTimer        *nsTimerP;
	char *fileNameCharP;
	int *returnValLongP;
	int openForwardNo;
	SelectedContctType      forwardContact;
	UISlider *sliderP;
	UIImage *knob;
	int returnValueInt;
	UIButton *deleteButton;
	SelectedContctType *selectP;
	pickerviewcontroller     *pickerviewcontrollerviewP;
	OverlayViewController *ovController;
	int recordVmsB;
	Boolean modalB;
	Boolean previewPressedB;
	int recordingStartB;
	int doNothing;
	//(SelectedContctType *)lselectedContactP
	
	
}
- (void)VmsStart;
- (void)VmsStop;
-(void)setFileName:(char*)lfileNameCharP :(int*) lreturnValLongP;
-(void)setvmsDetail:(char*)lnoCharP :(char*)lnameCharP :(char*)ltypeCharP :(VMSStateType)lVMSStateType :(int)lmaxTime :(struct VMail*) vmailP;

-(IBAction)sendPressed:(id)sender;
-(IBAction)playPressed:(id)sender;
-(IBAction)previewPressed:(id)sender;
- (void)addRow: (int)lsection:(int )row sectionObject:(sectionType **)sectionPP;
-(void)setObject:(id) object ;
-(void)makeView;
-(IBAction)stopButtonPressed:(id)sender;
-(void)loadOtherView;
-(void) loadContactDetails :(char*) numberCharP;
-(void)showForwardOrReplyScreen:(VMSStateType) lvmsState :(SelectedContctType *)selectedContactP;
- (void) doneSearching_Clicked:(id)sender;
-(IBAction)cancelClicked;
-(void)VmsStopRequest;
@end
