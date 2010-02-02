
//  Created by Mukesh Sharma on 01/07/09.

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

#import "Ltptimer.h"
#import "LtpInterface.h"
#include "ua.h"
#import "keypadview.h"
@class SpoknAppDelegate;
@class CallViewController;
@interface DialviewController : UIViewController<UITextFieldDelegate, KeypadProtocol> {
//	@public
	//IBOutlet UITextField*statusFieldP;
	IBOutlet UILabel *statusLabel1P;
	IBOutlet UILabel *statusLabel2P;
	//IBOutlet UILabel *ltpNameLabelP;
	//IBOutlet UITextField *numberFieldP;
	IBOutlet UILabel *numberlebelP;
	IBOutlet UILabel *mainstatusLabelP;
	IBOutlet UIButton *hangUpButtonP;
	IBOutlet UIButton *callButtonP;
	IBOutlet Keypadview *keypadmain;
	
	SpoknAppDelegate *ownerobject;
	LtpInterfaceType *ltpInterfacesP;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	//UISegmentedControl *segmentedControl;
	int status;
	int subStatus;
	int currentView;
	
	NSTimer *calltimerP;//this timer for call duration
	Boolean onLineB;
	long timecallduration;
	int hour,min,sec;
	CallViewController *callViewControllerP;
	NSString *callingstringP;
	NSString *callingstringtypeP;
	char lastTypeNo[40];
	int _downKey;
	UIAlertView *alert;
	NSTimer *_deleteTimer;
	int invalidUserB;
}


@property(readwrite,assign) LtpInterfaceType *ltpInterfacesP;
@property(readwrite,assign) int currentView;


-(void)setObject:(id) object ;
-(IBAction)callLtp:(id)sender;
-(IBAction)hangLtp:(id)sender;
-(IBAction)backkeyPressed:(id)sender;
-(IBAction)backkeyReleased:(id)sender;
- (IBAction)dismissKeyboard: (id)sender;
- (IBAction)valueChanged: (id)sender;
-(void)setStatusText:(NSString *)strP :(NSString *)strtypeP :(int)status :(int)subStatus;
//- (void)controlPressed:(id) sender;
-(void)setViewButton:(int)viewButton;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
- (void)playSoundForKey:(int)key;
- (void)stopTimer;
- (void)deleteRepeat;
@end
