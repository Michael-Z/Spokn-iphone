
//  Created on 09/10/09.

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

#import "WebViewController.h"
#import "ua.h"
#import "alertmessages.h"

@implementation WebViewController
@synthesize accountswebView;
-(id) init
{
	[super init];
	modalB = NO;
	return self;

}
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		modalB = NO;
	}
    return self;
}


-(void)setObject:(id) object 
{
	self->ownerobject = object;


}
-(void)modelViewB:(Boolean)lmodalB
{
	modalB = lmodalB;

}
-(void)setData:(NSString*)urlP web:(Boolean)lwebB :(NSString*)title
{
	nowebB = !lwebB;
	urlToLoadP = [[NSString alloc] initWithString:urlP];
	if([title length]>0)
	{
		[self setTitle:title];
	}	
	//[urlToLoadP retain];
}

-(IBAction)donePressed
{
	
	//[txtField resignFirstResponder];
	
	[self  dismissModalViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	if(modalB)
	{
				self.navigationItem.rightBarButtonItem = [ [ [ UIBarButtonItem alloc ]
												   initWithBarButtonSystemItem: UIBarButtonSystemItemDone
												   target: self
												   action: @selector(donePressed) ] autorelease ];
		
	
	}
	
	 accountswebView.delegate = self;
	 //uiActionSheetP = [[UIActionSheet alloc] initWithTitle:@"Loading..." delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	// uiActionSheetP.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//	 [uiActionSheetP showInView:[self navigationController].view]; 
	
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[spinner setCenter:CGPointMake(160, 250)];
	[[self navigationController].view addSubview:spinner];
	if(nowebB==NO)
	{	
		
		
	
		//Create a URL object.
		NSURL *url = [NSURL URLWithString:urlToLoadP];
	
		//URL Requst Object
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	//	[self setTitle:@"Account history"];

		//Load the request in the UIWebView.
		[accountswebView loadRequest:requestObj];
		accountswebView.dataDetectorTypes = UIDataDetectorTypeNone;
		[urlToLoadP release];
		urlToLoadP = nil;
	}
	else
	{
		//NSString *urlAddress = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"pdf"];
	
		NSURL *url = [NSURL fileURLWithPath:urlToLoadP];
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
		[accountswebView loadRequest:requestObj];
		[urlToLoadP release];
	
		urlToLoadP = nil;
	//	[self setTitle:@"About"];
	}
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {    
	[spinner stopAnimating];
//[uiActionSheetP dismissWithClickedButtonIndex:0 animated:YES ];

}

- (void)webViewDidStartLoad:(UIWebView *)webView {     
	if(nowebB==NO)
	{	
		[spinner startAnimating];
	}	
	//webView.detectsPhoneNumbers = NO;
//	[uiActionSheetP showInView:[self navigationController].view]; 
}
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {

	
	NSURL *url = request.URL;
	NSString *urlString = url.absoluteString;
	NSString *search = @"tel:";
	NSRange range = [urlString rangeOfString : search];

	
	//NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		
	if (range.location != NSNotFound) 
	{
		NSString * urlnumberP;
		urlnumberP = [urlString substringFromIndex:range.length];
		char *numbercharP;
		numbercharP = (char*)[urlnumberP cStringUsingEncoding:NSUTF8StringEncoding];
		if(numbercharP==NULL || strlen(numbercharP)==0)
		{
			
			UIAlertView	*alert = [ [ UIAlertView alloc ] initWithTitle: _TITLE_ 
															   message: [ NSString stringWithString:_CALLING_FAILED_ ]
															  delegate: self
													 cancelButtonTitle: nil
													 otherButtonTitles: _OK_, nil];
			[ alert show ];
			[alert release];
			
		}
		[ownerobject makeCall:numbercharP];
	}
	return YES;
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
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
	//[urlnumberP release];
	//[uiActionSheetP release];
	[spinner stopAnimating];
	[spinner release];
	[accountswebView release];
    [super dealloc];
}


@end
