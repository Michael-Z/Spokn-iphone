//
//  VmsRecordPlayViewController.m
//  spokn
//
//  Created by Mukesh Sharma on 28/07/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//
#import "SpoknAppDelegate.h"
#import "vmsrecordplayviewcontroller.h"


@implementation VmsRecordPlayViewController
-(void)setObject:(id) object 
{
	ownerobject = object;
}

-(IBAction)stopVm:(id)sender
{
	[ownerobject vmsStop:recordB];
}
-(IBAction)sendVm:(id)sender
{
	if(stopB)
	{	
		if(numberCharP)
		{	
			[ownerobject vmsSend:numberCharP];
			free(numberCharP);
			numberCharP = 0;
		}	
	}
	else
	{
		[ownerobject vmsStop:recordB];
	}

}
- (void) handleTimer: (id) timer
{
    //printf("\n time");
	if(amt<maxtime)
	{	
		amt += 1;
		[uiProgBarP setProgress: (amt / maxtime)];
	//	if (amt > maxtime) { [timer invalidate];}
	}
	else
	{
		if(recordB)
		{
			[ownerobject vmsStop:recordB];

		}
	}
	
}
- (void) cancelRecord {
	[self stopVm:nil];
}
-(int)  vmsRecordStart:(int) max :(char*)noCharP
{
	numberCharP = noCharP;
	amt = 0.0;
	maxtime = max*2;
	//printf("\n recordst");
	recordB = true;
	stopB = false;
	[uiProgBarP setProgress:0.0];
     timerP = [NSTimer scheduledTimerWithTimeInterval: 0.5
												target: self
											  selector: @selector(handleTimer:)
											  userInfo: nil
											   repeats: YES];
	//[uiProgBarP setProgress:0.0];
	//[stopButtonP setTitle:@"Stop" forState:UIControlStateNormal]; 
	//[timerP retain];
	self.navigationItem.leftBarButtonItem 
	= [ [ [ UIBarButtonItem alloc ]
		 initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
		 target: self
		 action: @selector(cancelRecord) ] autorelease ];	
	firstViewB = true;
	self->sendButtonP.hidden = NO;
	self->stopRecordButtonP.hidden = NO;
	self->stopPlayButtonP.hidden = YES;
	//[self.view sendSubviewToBack:stopSendBP];
	return 0;

}
-(int) vmsPlayStart:(int)max;
{
	amt = 0.0;
	maxtime = max*2;
	recordB = false;
	stopB = false;
	//printf("\n playstmine");
//	[stopButtonP setTitle:@"Stop" forState:UIControlStateNormal]; 
	//[self.view sendSubviewToBack:stopSendBP];
	[uiProgBarP setProgress:0.0];
	timerP = [NSTimer scheduledTimerWithTimeInterval: 0.5
											  target: self
											selector: @selector(handleTimer:)
											userInfo: nil
											 repeats: YES];
	self.navigationItem.leftBarButtonItem 
	= [ [ [ UIBarButtonItem alloc ]
		 initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
		 target: self
		 action: @selector(cancelRecord) ] autorelease ];	
	firstViewB = true;
	self->sendButtonP.hidden = YES;
	self->stopRecordButtonP.hidden = YES;
	self->stopPlayButtonP.hidden = NO;
	//[timerP retain];
	return 0;
	
}
-(int) vmsUIStop
{
	[timerP invalidate];
	stopB = true;
	//[timerP invalidate];
	

	//[timerP release];
	////printf("\n release");
	if(recordB)
	{
		[ self sendVm:nil];
		//return false;
	}
	return false;
		
}
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.tabBarItem = [UITabBarItem alloc];
	//[self.tabBarItem initWithTitle:@"Recording" image:nil tag:3];
	[uiProgBarP setProgress:0.0];
	
	//self.incomingStatusLabelP.text =textProP;
	//[incomingStatusLabelP performSelectorOnMainThread : @ selector(setText: ) withObject:textProP waitUntilDone:YES];
	
	
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	//printf("\n viewloaded");
	if(firstViewB)
	{	
		[ownerobject VmsStreamStart: recordB];
		firstViewB = false;
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
