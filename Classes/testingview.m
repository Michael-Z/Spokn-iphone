
//  Created on 21/10/09.


/**
  Copyright 2009, 2010 Geodesic Limited. <http://www.geodesic.com/>
 
 Spokn for iPhone and iPod Touch.
 
 This file is part of Spokn for iPhone.
 
 Spokn for iPhone is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 Spokn for iPhone is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Spokn for iPhone.  If not, see <http://www.gnu.org/licenses/>.
 */

//#ifdef _TEST_MEMORY_
	#import "testingview.h"
	#import "SpoknAppDelegate.h"

	#import "Ltptimer.h"
	#import "LtpInterface.h"
	#import "loginviewcontroller.h"
	#import "dialviewcontroller.h"
	#import "contactviewcontroller.h"
	#import "contactDetailsviewcontroller.h"
	#import "IncommingCallViewController.h"
	#include "ua.h"
	#include "vmsplayrecord.h"

	#import "CalllogViewController.h"
	#import "vmailviewcontroller.h"
	#import "spoknviewcontroller.h"


	@implementation testingview
	-(IBAction)ContactButton:(id)sender
	{
		
		ContactViewController *contactviewP;
		contactviewP = [[ContactViewController alloc] initWithNibName:@"contact" bundle:[NSBundle mainBundle]];
		[ [self navigationController] pushViewController:contactviewP animated: YES ];
		[contactviewP release];
	
	
	}

	-(IBAction)CalllogtButton:(id)sender
	{
		CalllogViewController *callviewP;
		callviewP = [[CalllogViewController alloc] initWithNibName:@"calllog" bundle:[NSBundle mainBundle]];
		[callviewP hideLeftbutton:true];
		[ [self navigationController] pushViewController:callviewP animated: YES ];
		[callviewP release];

	}
	-(IBAction)vmsButton:(id)sender
	{
	
		VmailViewController *vmsviewP;
		vmsviewP = [[VmailViewController alloc] initWithNibName:@"vmailview" bundle:[NSBundle mainBundle]];
		[ [self navigationController] pushViewController:vmsviewP animated: YES ];
		[vmsviewP release];
	}
	-(IBAction)phoneButton:(id)sender
	{
		DialviewController *dialviewP;
		dialviewP = [[DialviewController alloc] initWithNibName:@"dialview" bundle:[NSBundle mainBundle]];
		[ [self navigationController] pushViewController:dialviewP animated: YES ];
		[dialviewP release];
	
	
	}
	-(IBAction)spokn:(id)sender
	{
		SpoknViewController *spoknViewControllerP;
		spoknViewControllerP = [[SpoknViewController alloc] initWithNibName:@"spoknviewcontroller" bundle:[NSBundle mainBundle]];
		[ [self navigationController] pushViewController:spoknViewControllerP animated: YES ];
		[spoknViewControllerP release];


	}



 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
	- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
		if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
			// Custom initialization
			self.title = @"testing";
			}
		return self;
	}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
		[super dealloc];
	}



@end
//#endif
