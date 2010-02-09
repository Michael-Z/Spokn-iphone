
//  Created by Mukesh Sharma on 29/09/09.

/**
 Copyright 2009,2010 Geodesic, <http://www.geodesic.com/>
 
 Spokn SIP-VoIP for iPhone and iPod Touch.
 
 This file is part of Spokn iphone.
 
 Spokn iphone is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 Spokn iphone is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Spokn iphone.  If not, see <http://www.gnu.org/licenses/>.
 */

#import <UIKit/UIKit.h>
#import "keypadview.h"
#import "contactDetailsviewcontroller.h"
@class SpoknAppDelegate;
@protocol ShowContactCallOnDelegate

@optional
- (void)upDateUI;
-(void)objectDestory; 


@end

@interface CallViewController : UIViewController<KeypadProtocol,UIActionSheetDelegate> {
	IBOutlet UILabel *callnoLabelP;
	//IBOutlet UILabel *timeLabelP;
	//IBOutlet UILabel *dtmfLabelP;
	IBOutlet UIView  *viewMenuP;
	IBOutlet UILabel *callTypeLabelP;
	IBOutlet Keypadview  *viewKeypadP;
	IBOutlet UIButton  *endCallButtonP;
	IBOutlet UIButton  *hideKeypadButtonP;
	IBOutlet UIButton  *endCallKeypadButtonP;
	IBOutlet UIView    *topViewP;
	IBOutlet UIView    *bottomViewP;
	SpoknAppDelegate *ownerobject;
	NSTimer *calltimerP;//this timer for call duration
	Boolean onLineB;
	long timecallduration;
	int hour,min,sec;
	NSString *labelStrP;
	NSString *labeltypeStrP;
	Boolean navBarShow;
	Boolean  actualDismissB;
	Boolean loadedB;
	Boolean delTextB;
	id<ShowContactCallOnDelegate> showContactCallOnDelegate;
	//Boolean needTOStartTimerB;
	int sendCallRequestB; 

}
-(void)setObject:(id) object ;
-(void)setLabel:(NSString *)strP :(NSString *)strtypeP;
-(IBAction)mutePressed:(id)sender;
-(IBAction)speakerPressed:(id)sender;
-(IBAction)keypadPressed:(id)sender;
-(IBAction)endCallPressed:(id)sender;
-(IBAction)endCallPressedKey:(id)sender;
-(void) startTimer;
-(int)  stopTimer;
-(IBAction)HoldPressed:(id)sender;
-(IBAction)addContactPressed:(id)sender;
- (void) handleCallEndTimer: (id) timer;
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
@property (readwrite,assign) id<ShowContactCallOnDelegate> showContactCallOnDelegate;

@end
