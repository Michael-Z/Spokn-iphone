//
//  LoginViewController.m
//  spoknclient
//
//  Created by Mukesh Sharma on 01/07/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import "LoginViewController.h"

#import "Ltptimer.h"
#import "LtpInterface.h"
#import "SpoknAppDelegate.h"
#include "ua.h"
@implementation LoginViewController

@synthesize ltpInterfacesP;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	[usernameFieldP resignFirstResponder];
	[passwordFieldP resignFirstResponder];
	
	
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

	//printf("\n return pressed");
	//[super textFieldShouldReturn:textField];
	[usernameFieldP resignFirstResponder];
	[passwordFieldP resignFirstResponder];
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
	
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	//printf("\nmemory leak");
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
		
}


- (void)dealloc {
	//printf("\ndalloc");
	//[usernameFieldP release];
	//[passwordFieldP release];
    [super dealloc];
}
-(IBAction)loginLtp:(id)sender
{
	char *userNamecharP;
	char *passwordcharP;
	UIAlertView *alert;
	if([usernameFieldP.text length]==0)
	{
		alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn." 
											  message: [ NSString stringWithString:@"user name can not be empty" ]
											 delegate: self
									cancelButtonTitle: nil
									otherButtonTitles: @"OK", nil
				 ];
		
		[ alert show ];
		[alert release];
		return;
	}
	else
	{
		if([passwordFieldP.text length]==0)
		{
			alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn." 
												  message: [ NSString stringWithString:@"password can not be empty" ]
												 delegate: self
										cancelButtonTitle: nil
										otherButtonTitles: @"OK", nil
					 ];
			
			[ alert show ];
			[alert release];
			return;
		}
		
	}
	
	//dataP = [pathP cStringUsingEncoding:1];
	userNamecharP = (char*)[[usernameFieldP text] cStringUsingEncoding:1];
	passwordcharP = (char*)[[passwordFieldP text] cStringUsingEncoding:1];
	if(userNamecharP && passwordcharP)
	{	
		setLtpUserName(ltpInterfacesP,userNamecharP);
		setLtpPassword(ltpInterfacesP,passwordcharP);
		DoLtpLogin(ltpInterfacesP);
		
		//[self->ownerobject changeView];
		[self->ownerobject popLoginView];
	}	
	
	
}
-(IBAction)openUrl:(id)sender
{
	//[self->ownerobject popLoginView];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.spokn.com/cgi-bin/signup.cgi"]];


}
-(void)setObject:(id) object 
{
	self->ownerobject = object;
}


@end
