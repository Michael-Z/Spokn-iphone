//
//  callviewcontroller.h
//  spokn
//
//  Created by Mukesh Sharma on 29/09/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "keypadview.h"
@class SpoknAppDelegate;

@interface CallViewController : UIViewController<KeypadProtocol> {
	IBOutlet UILabel *callnoLabelP;
	IBOutlet UILabel *timeLabelP;
	IBOutlet UILabel *dtmfLabelP;
	IBOutlet UIView  *viewMenuP;
	IBOutlet Keypadview  *viewKeypadP;
	IBOutlet UIButton  *endCallButtonP;
	IBOutlet UIButton  *hideKeypadButtonP;
	IBOutlet UIButton  *endCallKeypadButtonP;
	SpoknAppDelegate *ownerobject;
	NSTimer *calltimerP;//this timer for call duration
	Boolean onLineB;
	long timecallduration;
	int hour,min,sec;
	NSString *labelStrP;
	UIButton *_buttons[6];
	

}
-(void)setObject:(id) object ;
-(void)setLabel:(NSString *)strP;
-(IBAction)mutePressed:(id)sender;
-(IBAction)speakerPressed:(id)sender;
-(IBAction)keypadPressed:(id)sender;
-(IBAction)endCallPressed:(id)sender;
-(IBAction)endCallPressedKey:(id)sender;
-(void) startTimer;
-(int)  stopTimer;
-(IBAction)HoldPressed:(id)sender;

@end
