
//  Created by Mukesh Sharma on 09/10/09.

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

#import "WebViewController.h"
#import "ua.h"
#import "alertmessages.h"

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
	
	
	 accountswebView.delegate = self;
	 //uiActionSheetP = [[UIActionSheet alloc] initWithTitle:@"Loading..." delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	// uiActionSheetP.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//	 [uiActionSheetP showInView:[self navigationController].view]; 
	
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[spinner setCenter:CGPointMake(160, 250)];
	[[self navigationController].view addSubview:spinner];
	
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
- (void)webViewDidFinishLoad:(UIWebView *)webView {    
	[spinner stopAnimating];
//[uiActionSheetP dismissWithClickedButtonIndex:0 animated:YES ];

}

- (void)webViewDidStartLoad:(UIWebView *)webView {     
	[spinner startAnimating];
	//webView.detectsPhoneNumbers = NO;
//	[uiActionSheetP showInView:[self navigationController].view]; 
}
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {

	
	NSURL *url = request.URL;
	NSString *urlString = url.absoluteString;
	NSString *search = @"tel:";
	NSRange range = [urlString rangeOfString : search];

	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		
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
