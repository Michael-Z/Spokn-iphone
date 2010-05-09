
//  Created on 10/07/09.

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
#import "IncommingCallViewController.h"
#include "LtpInterface.h"
#import "SpoknAppDelegate.h"
#include "ua.h"
#import "alertmessages.h"

@implementation IncommingCallViewController
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

-(id)initVariable
{
	
	statusStrP =nil;
	nameStrP = nil;
	return self;
}
- (void) viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	

}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	acceptPressedB = NO;
	buttonPressedB = NO;
    [super viewDidLoad];
	
	[UIApplication sharedApplication] .statusBarStyle = UIBarStyleBlackOpaque;
	//self.tabBarItem = [UITabBarItem alloc];
	//[self.tabBarItem initWithTitle:@"IncommingCall" image:nil tag:2];
	nameLabelP.backgroundColor = [UIColor clearColor];
	statusLabelP.backgroundColor = [UIColor clearColor];
	[nameLabelP setText:nameStrP];
	[statusLabelP setText:statusStrP];
	/*[self.view setBackgroundColor:[[[UIColor alloc] 
									initWithPatternImage:[UIImage imageNamed:@"spokncall.png"]]
								   autorelease]];	*/
	[self.view setBackgroundColor:[[[UIColor alloc] 
									initWithPatternImage:[UIImage imageNamed:_CALL_WATERMARK_PNG_]]
								   autorelease]];
	//self.incomingStatusLabelP.text =textProP;
	//[incomingStatusLabelP performSelectorOnMainThread : @ selector(setText: ) withObject:textProP waitUntilDone:YES];
	UIImage *buttonBackground;
	UIImage *buttonBackgroundPressed;
	
	buttonBackground = [UIImage imageNamed:_ANSWER_NORMAL_PNG_];
	buttonBackgroundPressed = [UIImage imageNamed:_ANSWER_PRESSED_PNG_];
	[CustomButton setImages:ansP image:buttonBackground imagePressed:buttonBackgroundPressed change:NO];
	[buttonBackground release];
	[buttonBackgroundPressed release];
	ansP.backgroundColor =  [UIColor clearColor];
	buttonBackground = [UIImage imageNamed:_DECLINE_NORMAL_PNG_];
	buttonBackgroundPressed = [UIImage imageNamed:_DECLINE_PRESSED_PNG_];
	[CustomButton setImages:declineP image:buttonBackground imagePressed:buttonBackgroundPressed change:NO];
	[buttonBackground release];
	[buttonBackgroundPressed release];
	declineP.backgroundColor =  [UIColor clearColor];
	[self->topViewP setBackgroundColor:[[[UIColor alloc] 
										 initWithPatternImage:[UIImage imageNamed:_SCREEN_BORDERS_PNG_]]
										autorelease]];	
	[self->bottomViewP setBackgroundColor:[[[UIColor alloc] 
											initWithPatternImage:[UIImage imageNamed:_SCREEN_BORDERS_PNG_]]
										   autorelease]];	
	

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
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[UIApplication sharedApplication] .statusBarStyle = UIStatusBarStyleDefault;
	[self->nameStrP release];
	[self->statusStrP release];
    [super dealloc];
}
-(IBAction)Accept:(id)sender
{
	if(buttonPressedB)
		return;
	acceptPressedB = 1;
	//[ownerobject.tabBarController dismissModalViewControllerAnimated:NO];
	buttonPressedB =YES;
//	[UIApplication sharedApplication] .statusBarStyle = prvStyle;
	[self retain];
	[self->ownerobject AcceptCall:self->ltpInDataP :[self parentViewController]];
	[self autorelease];
	
}
-(IBAction)Reject:(id)sender
{
	if(buttonPressedB)
		return;
	buttonPressedB =YES;	
	//[UIApplication sharedApplication] .statusBarStyle = prvStyle;
	[self retain];
	[self->ownerobject RejectCall:self->ltpInDataP :[self parentViewController]];
	[self autorelease];
	

}
-(void)directAccept:(int)ldirectB
{
	directB = ldirectB;
}
-(void)setObject:(id) object 
{
	
	self->ownerobject = object;
}
-(void)setIncommingData:(IncommingCallType *)lltpInDataP
{
//	NSString *nsp;
	
	struct AddressBook *addressP;
	self->ltpInDataP = lltpInDataP;
	char type [40];
	if(self->ltpInDataP==0)
	{
		return;
	}
	addressP = getContactAndTypeCall(self->ltpInDataP->userIdChar,type);
	if(addressP)
	{
		nameStrP = [[ NSString alloc ] initWithUTF8String:addressP->title];
		statusStrP = [[ NSString alloc ] initWithUTF8String:type];
		
	}
	else
	{	
		nameStrP = [[ NSString alloc ] initWithUTF8String:self->ltpInDataP->userIdChar];
		statusStrP = [[ NSString alloc ] initWithUTF8String:"Unknown"];

		
	}
		
}
@end
