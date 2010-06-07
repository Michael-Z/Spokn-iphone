
//  Created on 29/09/09.

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
#import "keypadview.h"
#import "contactDetailsviewcontroller.h"
#import "spokncalladd.h"
#import "callmanagement.h"

@class ConferenceViewController;
@class SpoknAppDelegate;
@interface CallViewController : UIViewController<KeypadProtocol,UIActionSheetDelegate,UITableViewDataSource, UITableViewDelegate,AddCallProtocol> {
	IBOutlet UITableView *tableView;
	IBOutlet UILabel *callnoLabelP;
	IBOutlet UILabel *callTypeLabelP;
	IBOutlet UIView  *viewMenuP;
	IBOutlet UIView    *bottomViewP;
	IBOutlet Keypadview  *viewKeypadP;
	IBOutlet UIButton  *endCallButtonP;
	IBOutlet UIButton  *hideKeypadButtonP;
	IBOutlet UIButton  *endCallKeypadButtonP;
	IBOutlet UIButton  *speakerButtonP;
	IBOutlet UIView    *topViewP;
	IBOutlet UIView  *blueToothViewP;
	IBOutlet UIButton  *hideSourcesbuttonP;
	IBOutlet UIButton  *audiobuttonP;
	IBOutlet UIButton  *speakerinbluetoothbuttonP;
	IBOutlet UIButton  *bluetoothbuttonP;
	IBOutlet UIButton  *holdButtonP;
	IBOutlet UIButton  *addcallButtonP;

	
	UILabel    *name1LabelP;
	UILabel    *name2LabelP;
	UILabel    *type2LabelP;
	UILabel    *type1LabelP;
	UIImageView   *uiImageP;
	SpoknAppDelegate *ownerobject;
	NSTimer *calltimerP;//this timer for call duration
	Boolean onLineB;
	NSString *labelStrP;
	NSString *labeltypeStrP;
	Boolean navBarShow;
	Boolean  actualDismissB;
	Boolean loadedB;
	Boolean delTextB;
	Boolean refreshViewB;
	id<ShowContactCallOnDelegate> showContactCallOnDelegate;
	//Boolean needTOStartTimerB;
	id<ShowContactCallOnDelegate> parentObjectDelegate;
	Boolean sendCallRequestB; 
	Boolean failedCallB;
	Boolean endCalledPressed;
	Boolean firstTimeB;
	Boolean selectedModeB;
	UIActionSheet *uiActionSheetgP;
	int speakerOnB;
	int holdOnB;

	id<AddCallProtocol> addcallDelegate;
	CallManagement *callManagmentP;
	ConferenceViewController *spoknconfP;
		//IBOutlet UIButton *testP;
	int muteOnB;
	//IBOutlet UIButton *testP;

	int gchildWillDie;
}
-(void)setObject:(id) object ;
-(void)setParentObject:(id) object ;
-(void)setLabel:(NSString *)strP :(NSString *)strtypeP;
-(IBAction)mutePressed:(id)sender;
-(IBAction)speakerPressed:(id)sender;
-(IBAction)hidesourcesrPressed:(id)sender;
-(IBAction)keypadPressed:(id)sender;
-(IBAction)endCallPressed:(id)sender;
-(IBAction)endCallPressedKey:(id)sender;
-(void) startTimer:(int) lineID;
-(int)  stopTimer:(int) lineID;
-(IBAction)HoldPressed:(id)sender;
-(IBAction)addContactPressed:(id)sender;
- (void) handleCallEndTimer: (id) timer;
-(IBAction)blueToothViewAudio:(id)sender;
-(IBAction)blueToothViewiphone:(id)sender;
-(IBAction)blueToothViewspeaker:(id)sender;
-(void)routeChange:(int)reason;
-(void)setselectedButtonImage:(int) button;
-(void)setSpeakerButtonImage;
-(void)setSelectedOrUnselectedImage:(UIButton*)selectedButtonP :(UIImage*)imageP;
-(void) changeSelectedImage;
-(void)sendLtpHang:(int)lineID;
-(void)removeCallview;
-(void)makeCall:(char*)numberP;
-(IBAction)callAdded:(id)sender;

-(void) updatescreen:(int )time;
@property (readwrite,assign) id<ShowContactCallOnDelegate> showContactCallOnDelegate;
@property(readwrite,assign) id<AddCallProtocol> addcallDelegate;
-(void)updateTableSubView:(Boolean)hideB;
-(void) objectDestroy;
-(int)isCallOn;
-(int)AddIncommingCall :(int)llineID :(NSString*)labelStrP :(NSString*)typeStrP;
-(void) removeTempId;
-(void) addTempId;
-(void) dismisscontroller:(int)parentB;
-(int)childWillDie;
@end
