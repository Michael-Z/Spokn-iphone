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
	
	
	 accountswebView.delegate = self;
	 uiActionSheetP = [[UIActionSheet alloc] initWithTitle:@"Loading..." delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	 uiActionSheetP.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
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
	NSLog(@"Web View started loading...");
	[spinner stopAnimating];
	[uiActionSheetP dismissWithClickedButtonIndex:0 animated:YES ];

}

- (void)webViewDidStartLoad:(UIWebView *)webView {     
	[spinner startAnimating];
	[uiActionSheetP showInView:[self navigationController].view]; 
}
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {

	urlnumberP = [NSString alloc];
	NSURL *url = request.URL;
	NSString *urlString = url.absoluteString;
	NSString *search = @"tel:";
	NSRange range = [urlString rangeOfString : search];
	if (range.location != NSNotFound) 
	{
		urlnumberP = [urlString substringFromIndex:range.length];
		char *numbercharP;
		numbercharP = (char*)[urlnumberP cStringUsingEncoding:NSUTF8StringEncoding];
		if(numbercharP==NULL || strlen(numbercharP)==0)
		{
			
			UIAlertView	*alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
															   message: [ NSString stringWithString:@"Error" ]
															  delegate: self
													 cancelButtonTitle: nil
													 otherButtonTitles: @"OK", nil];
			[ alert show ];
			[alert release];
			
		}
		[ownerobject makeCall:numbercharP];
	}
	return YES;
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
	[uiActionSheetP release];
	[spinner release];
	[accountswebView release];
    [super dealloc];
}


@end
