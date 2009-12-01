//
//  IncommingCallViewController.m
//  spoknclient
//
//  Created by Mukesh Sharma on 10/07/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import "IncommingCallViewController.h"
#include "LtpInterface.h"
#import "SpoknAppDelegate.h"

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
	
	textProP = [[NSMutableString alloc] init];
	return self;
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.tabBarItem = [UITabBarItem alloc];
	//[self.tabBarItem initWithTitle:@"IncommingCall" image:nil tag:2];
	incomingStatusLabelP.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lcd_top_simple.png"]];
	[incomingStatusLabelP setText:textProP];
	[self.view setBackgroundColor:[[[UIColor alloc] 
							   initWithPatternImage:[UIImage defaultDesktopImage]]
							  autorelease]];
	
	//self.incomingStatusLabelP.text =textProP;
	//[incomingStatusLabelP performSelectorOnMainThread : @ selector(setText: ) withObject:textProP waitUntilDone:YES];


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
	[self->textProP release];
    [super dealloc];
}
-(IBAction)Accept:(id)sender
{
	[self->ownerobject AcceptCall:self->ltpInDataP];	
}
-(IBAction)Reject:(id)sender
{
	[self->ownerobject RejectCall:self->ltpInDataP];
}
-(void)setObject:(id) object 
{
	self->ownerobject = object;
}
-(void)setIncommingData:(IncommingCallType *)lltpInDataP
{
	NSString *nsp;
	
	self->ltpInDataP = lltpInDataP;
	if(self->ltpInDataP==0)
	{
		return;
	}
	//printf("\n %s",self->ltpInDataP->userIdChar);
	nsp = [[NSString alloc] initWithUTF8String:self->ltpInDataP->userIdChar ];
	[self->textProP setString:@"Incoming call from \n"];
	[self->textProP appendString:nsp];
	NSLog(self->textProP);
	[nsp release];
	
}
@end
