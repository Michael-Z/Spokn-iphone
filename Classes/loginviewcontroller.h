
//  Created on 01/07/09.

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
#import "Ltptimer.h"
#import "LtpInterface.h"
@protocol LoginProtocol

@optional
-(void) startloginIndicator;
-(void) stoploginIndicator;
-(void) cleartextField;
@end

@class SpoknAppDelegate;
@interface LoginViewController : UIViewController<UITextFieldDelegate,LoginProtocol> {
	IBOutlet UITextField*usernameFieldP;
	IBOutlet UITextField *passwordFieldP;
	IBOutlet UIButton *spoknButtonP;
	IBOutlet UIButton *mainViewButton;
	IBOutlet UIButton *lineViewButton;
	IBOutlet UILabel *loginstatusLabel;
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
