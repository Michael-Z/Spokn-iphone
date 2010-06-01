
//  Created on 07/10/09.

/**
  Copyright 2009, 2010 Geodesic Limited. <http://www.geodesic.com/>
 
 Spokn for iPhone.
 
 This file is part of Spokn for iPhone.
 
 Spokn for iPhone is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, version 2 of the License.
  
 Spokn for iPhone is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Spokn for iPhone.  If not, see <http://www.gnu.org/licenses/>.
 */
#import <UIKit/UIKit.h>

#import "contactDetailsviewcontroller.h"
#import "pickerviewcontroller.h"
@protocol VmsProtocol

@optional
- (void)VmsStart;
- (void)VmsStop;
- (void)VmsStopRequest;
- (void)proximityChange:(BOOL)onB;

@end
typedef enum  VMSStateType
	{
		VMSStatePlay,
		VMSStateRecord,
		VMSStateForward,
		VMSStatePrevious
	}VMSStateType;
	
#define PROGRESS_VIEW
@class SpoknAppDelegate;
@class pickerviewcontroller;
@class OverlayViewController;
@interface VmShowViewController : UIViewController<UpDateViewProtocol,UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,VmsProtocol,UINavigationControllerDelegate> {
	IBOutlet UITableView *tableView;
	IBOutlet UILabel *msgLabelP;
	IBOutlet UILabel *secondLabelP;
	
	IBOutlet UIButton *sendButtonP;
	UIButton *PlayButtonP;
	IBOutlet UIButton *previewButtonP;
	IBOutlet UIView  *firstSectionviewP;
	IBOutlet UIView  *secondSectionviewP;
	IBOutlet UIView  *progressandplayviewP;
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
	#ifdef PROGRESS_VIEW
		UIProgressView *uiProgBarP;
	#else
		UISlider *sliderP;
	#endif
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
	int shiftVmailB;
	int previousPickerSz;
	Boolean contactFindB;
	Boolean contactPickB;
	UIAlertView *alertgP;
	UIActionSheet *uiActionSheetgP;
	int checkRouteB;
	
	
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
- (void)setButtonTitle:(NSString *)title forState:(UIControlState)state;
-(void)showOrHideSendButton:(BOOL)showB;
@end
