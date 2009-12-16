//
//  LoginViewController.h
//  spoknclient
//
//  Created by Mukesh Sharma on 01/07/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ltptimer.h"
#import "LtpInterface.h"
@protocol LoginProtocol

@optional
-(void) startloginIndicator;
-(void) stoploginIndicator;
@end

@class SpoknAppDelegate;
@interface LoginViewController : UIViewController<UITextFieldDelegate,LoginProtocol> {
	IBOutlet UITextField*usernameFieldP;
	IBOutlet UITextField *passwordFieldP;
	IBOutlet UIButton *spoknButtonP;
	//LtpTimer *ltpTimerP;
	SpoknAppDelegate * ownerobject;
	LtpInterfaceType *ltpInterfacesP;
	UIActivityIndicatorView *loginactivityIndicator;
	
	
}


@property(readwrite,assign) LtpInterfaceType *ltpInterfacesP;

-(void)setObject:(id) object ;
-(IBAction)loginLtp:(id)sender;
-(IBAction)openUrl:(id)sender;
-(IBAction)forgotPassword:(id)sender;
-(IBAction)cancelPressed:(id)sender;

@end
