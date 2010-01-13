//
//  vmshowviewcontroller.h
//  spokn
//
//  Created by Mukesh Sharma on 07/10/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//
/**
 Copyright 2009 John Smith, <john.smith@example.com>
 
 This file is part of FOOBAR.
 
 FOOBAR is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 FOOBAR is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with FOOBAR.  If not, see <http://www.gnu.org/licenses/>.
 */

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
		VMSStateForward,
		VMSStatePrevious
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
	int audioStartB;
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
