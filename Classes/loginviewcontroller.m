
//  Created on 01/07/09.

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
#import "LoginViewController.h"

#import "Ltptimer.h"
#import "LtpInterface.h"
#import "SpoknAppDelegate.h"
#include "ua.h"
#include "alertmessages.h"
@implementation LoginViewController

@synthesize ltpInterfacesP;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	
	
	
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

		[self loginLtp:nil];
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	
	if(textField==usernameFieldP)
	{	
		NSString *usernameString = [usernameFieldP.text stringByReplacingCharactersInRange:range withString:string];
		return !([usernameString length] > USERNAME_RANGE);
	}
	else
	{	
		NSString *passwordString = [passwordFieldP.text stringByReplacingCharactersInRange:range withString:string];
		return !([passwordString length] > PASSWORD_RANGE );
	}
	
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSString *uNameStringP;
	NSString *passwordStringP;
	char *unameP;
	char *passwordP;

	loginstatusLabel.textColor = [[UIColor grayColor] autorelease];
	
	if(ltpInterfacesP)
	{	
		unameP = getLtpUserName(ltpInterfacesP);
		passwordP = getLtpPassword(ltpInterfacesP);
		uNameStringP = [[NSString alloc] initWithUTF8String:unameP];
		passwordStringP = [[NSString alloc] initWithUTF8String:passwordP];
		usernameFieldP.text = uNameStringP;
		passwordFieldP.text = passwordStringP;
		free(unameP);
		free(passwordP);
		[uNameStringP release];
		[passwordStringP release];
	}
	usernameFieldP.delegate = self;
	passwordFieldP.delegate = self;
	[usernameFieldP becomeFirstResponder];
	/*[passwordFieldP becomeFirstResponder];
	passwordFieldP.delegate = self;

	[usernameFieldP becomeFirstResponder];
	usernameFieldP.delegate = self;
	[usernameFieldP resignFirstResponder];
	[passwordFieldP resignFirstResponder];*/
	
	//usernameFieldP.text = @"dhpatil1";
	//passwordFieldP.text = @"deepak123";

	//self.tabBarItem = [UITabBarItem alloc];
	//[self.tabBarItem initWithTitle:@"Login" image:nil tag:1];
	//ltpTimerP = [[LtpTimer alloc] init];
	//ltpTimerP.ltpInterfacesP =  startLtp();
	//setLtpServer("64.49.236.88");
	[ownerobject setLoginDelegate:self];
	loginactivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[loginactivityIndicator setCenter:CGPointMake(80.0f, 140.0f)];
	[self.view addSubview:loginactivityIndicator];
	loginstatusLabel.hidden = YES;


}

-(void) cleartextField
{
	passwordFieldP.text = @"";
}

-(void) startloginIndicator
{
	[loginactivityIndicator startAnimating];
	loginstatusLabel.hidden = NO;
	lineViewButton.hidden = YES;
	usernameFieldP.hidden = YES;
	passwordFieldP.hidden = YES;
}

-(void) stoploginIndicator
{
	[loginactivityIndicator stopAnimating];	
	loginstatusLabel.hidden = YES;
	lineViewButton.hidden = NO;
	usernameFieldP.hidden = NO;
	passwordFieldP.hidden = NO;
}
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
		
}


- (void)dealloc {
	[loginactivityIndicator release];
	[ownerobject setLoginDelegate:nil];
	[super dealloc];
	
}
-(IBAction)loginLtp:(id)sender
{
	char *userNamecharP;
	char *passwordcharP;
	UIAlertView *alert;
	NSString *userNameStrP;
	NSString *passwordStrP;
	if([usernameFieldP.text length]==0)
	{
		alert = [ [ UIAlertView alloc ] initWithTitle: _EMPTY_USERNAME_ 
											  message: [ NSString stringWithString:_EMPTY_USERNAME_MESSAGE_ ]
											 delegate: self
									cancelButtonTitle: nil
									otherButtonTitles: _OK_, nil
				 ];
		
		[ alert show ];
		[alert release];
		return;
	}
	else
	{
		if([passwordFieldP.text length]==0)
		{
			alert = [ [ UIAlertView alloc ] initWithTitle: _EMPTY_PASSWORD_ 
												  message: [ NSString stringWithString:_EMPTY_PASSWORD_MESSAGE_ ]
												 delegate: self
										cancelButtonTitle: nil
										otherButtonTitles: _OK_, nil
					 ];
			
			[ alert show ];
			[alert release];
			return;
		}
		
	}
	userNameStrP = [usernameFieldP.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if([userNameStrP length]==0)
	{
		alert = [ [ UIAlertView alloc ] initWithTitle: _SIGN_IN_FAILED_ 
											  message: [ NSString stringWithString:_USERNAME_NO_WHITESPACE_ ]
											 delegate: self
									cancelButtonTitle: nil
									otherButtonTitles: _OK_, nil
				 ];
		
		[ alert show ];
		[alert release];
		return;
		
	}
	passwordStrP = [passwordFieldP.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if([passwordStrP length]==0)
	{
		alert = [ [ UIAlertView alloc ] initWithTitle: _SIGN_IN_FAILED_ 
											  message: [ NSString stringWithString:_PASSWORD_NO_WHITESPACE_ ]
											 delegate: self
									cancelButtonTitle: nil
									otherButtonTitles: _OK_, nil
				 ];
		
		[ alert show ];
		[alert release];
		return;
		
	}
	//dataP = [pathP cStringUsingEncoding:1];
	userNamecharP = (char*)[userNameStrP cStringUsingEncoding:NSUTF8StringEncoding];
	passwordcharP = (char*)[passwordStrP cStringUsingEncoding:NSUTF8StringEncoding];
	if(userNamecharP && passwordcharP)
	{	
		char *uNameCharP;
		uNameCharP = getLtpUserName(ltpInterfacesP);
		if(uNameCharP)
		{
			if(strcmp(uNameCharP,userNamecharP)!=0)
			{
				profileClear();
			}
			free(uNameCharP);
		}
		setLtpUserName(ltpInterfacesP,userNamecharP);
		setLtpPassword(ltpInterfacesP,passwordcharP);
		usernameFieldP.selected = FALSE;
		passwordFieldP.selected = FALSE;
		DoLtpLogin(ltpInterfacesP);

		//[self->ownerobject changeView];
		//[self->ownerobject popLoginView];
	}	
	
	
}
-(IBAction)openUrl:(id)sender
{
	//[self->ownerobject popLoginView];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:_URL_SIGNUP_]];


}
-(IBAction)forgotPassword:(id)sender
{
	
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:_URL_FORGOT_PASS_]];
	/*NSString *srtrP; 
	 srtrP = [[NSString alloc] initWithString:@"http://www.spokn.com/services/wm/forgot-password"];
	 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:srtrP]];
	 [srtrP release];*/
}
-(IBAction)cancelPressed:(id)sender
{
	[self->ownerobject cancelLoginView];
}
-(void)setObject:(id) object 
{
	self->ownerobject = object;
}


@end
