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
@implementation LoginViewController

@synthesize ltpInterfacesP;


 

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
	//usernameFieldP.text = @"dhpatil1";
	//passwordFieldP.text = @"deepak123";

	//self.tabBarItem = [UITabBarItem alloc];
	//[self.tabBarItem initWithTitle:@"Login" image:nil tag:1];
	//ltpTimerP = [[LtpTimer alloc] init];
	//ltpTimerP.ltpInterfacesP =  startLtp();
	//setLtpServer("64.49.236.88");
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	[usernameFieldP release];
	[passwordFieldP release];
    [super dealloc];
}
-(IBAction)loginLtp:(id)sender
{
	char *userNamecharP;
	char *passwordcharP;
	
	//dataP = [pathP cStringUsingEncoding:1];
	userNamecharP = (char*)[[usernameFieldP text] cStringUsingEncoding:1];
	passwordcharP = (char*)[[passwordFieldP text] cStringUsingEncoding:1];
	if(userNamecharP && passwordcharP)
	{	
		setLtpUserName(ltpInterfacesP,userNamecharP);
		setLtpPassword(ltpInterfacesP,passwordcharP);
		DoLtpLogin(ltpInterfacesP);
		
		[self->ownerobject changeView];
		[self->ownerobject popLoginView];
	}	
	
	
}
-(IBAction)cancelLtp:(id)sender
{
	//[self->ownerobject popLoginView];

}
-(void)setObject:(id) object 
{
	self->ownerobject = object;
}


@end
