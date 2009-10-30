//
//  testingview.m
//  spokn
//
//  Created by Mukesh Sharma on 21/10/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//
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
