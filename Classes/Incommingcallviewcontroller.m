
//  Created on 10/07/09.

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
#import "IncommingCallViewController.h"
#include "LtpInterface.h"
#import "SpoknAppDelegate.h"
#include "ua.h"

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
	struct AddressBook *addressP;
	self->ltpInDataP = lltpInDataP;
	if(self->ltpInDataP==0)
	{
		return;
	}
	//printf("\n %s",self->ltpInDataP->userIdChar);
	addressP = getContactAndTypeCall(self->ltpInDataP->userIdChar,0);
	if(addressP)
	{
		nsp = [[NSString alloc] initWithUTF8String:addressP->title] ;
		
	}
	else
	{	
		nsp = [[NSString alloc] initWithUTF8String:self->ltpInDataP->userIdChar ];
	}
	[self->textProP setString:@"Incoming call\n"];
	[self->textProP appendString:nsp];
	NSLog(self->textProP);
	[nsp release];
	
}
@end
