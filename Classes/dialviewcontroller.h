//
//  DialviewController.h
//  spoknclient
//
//  Created by Mukesh Sharma on 01/07/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Ltptimer.h"
#import "LtpInterface.h"
#include "ua.h"
@class SpoknAppDelegate;
@interface DialviewController : UIViewController<UITextFieldDelegate> {
//	@public
	//IBOutlet UITextField*statusFieldP;
	IBOutlet UILabel *statusLabelP;
	IBOutlet UILabel *balanceLabelP;
	IBOutlet UILabel *ltpNameLabelP;
	IBOutlet UITextField *numberFieldP;
	IBOutlet UIButton *hangUpButtonP;
	
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
	
}


@property(readwrite,assign) LtpInterfaceType *ltpInterfacesP;
@property(readwrite,assign) int currentView;


-(void)setObject:(id) object ;
-(IBAction)callLtp:(id)sender;
-(IBAction)hangLtp:(id)sender;
- (IBAction)dismissKeyboard: (id)sender;
- (IBAction)valueChanged: (id)sender;
-(void)setStatusText:(NSString *)strP :(int)status :(int)subStatus;
//- (void)controlPressed:(id) sender;
-(void)setViewButton:(int)viewButton;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text

@end
