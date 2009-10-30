//
//  WebViewController.m
//  spokn
//
//  Created by Mukesh Sharma on 09/10/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import "WebViewController.h"
#import "ua.h"

@implementation WebViewController
@synthesize accountswebView;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

-(void)setObject:(id) object 
{
	self->ownerobject = object;
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSString *urlAddress;
	char * tempurl;
	tempurl = getAccountPage();
	urlAddress = [[NSString alloc] initWithUTF8String:tempurl];
	free(tempurl);
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[self setTitle:@"Account history"];
	//Load the request in the UIWebView.
	[accountswebView loadRequest:requestObj];
	
	[urlAddress release];
	
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

	[accountswebView release];
    [super dealloc];
}


@end
