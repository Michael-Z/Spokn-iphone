//
//  spokncalladd.m
//  spokn
//
//  Created by Mukesh Sharma on 05/02/10.
//  Copyright 2010 Geodesic Ltd.. All rights reserved.
//

#import "spokncalladd.h"
#import "contactviewcontroller.h"
#import "spoknAppDelegate.h"

@implementation Spokncalladd
#pragma mark NAVIGATIONOBJECT
// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
	printf("\n problem comes");
	/*if(viewController ==self->contactP)
	{
		[contactP updateUI];
	}*/
	SEL method = @selector(updateUI:);
	
	if ([viewController respondsToSelector:method])
	{	
		printf("\n method find");
		[viewController performSelector:method withObject:nil];
	}	
}
- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item
{
	//printf("\n view poped");
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[self.parentViewController dismissModalViewControllerAnimated:YES ];
}
-(void)setObject:(id) object 
{
	ownerobject = object;
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	label = [[[UILabel alloc] init] autorelease];
	label.text = @"Touch to return to call";
	label.font = [UIFont systemFontOfSize:25];
	label.textAlignment = UITextAlignmentCenter;
	label.contentMode = UIViewContentModeCenter;
	label.backgroundColor = [UIColor grayColor];
	label.textColor = [UIColor whiteColor];
	[label sizeToFit];
	label.frame = CGRectMake(0, 0, 320, 40);
	//label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backview.png"]];
	[self.view addSubview:label];
	//[label startAnimating];
	
	
	
	//[[self navigationController] setNavigationBarHidden:NO animated:NO];
	contactP = [[ContactViewController alloc] initWithNibName:@"contact" bundle:[NSBundle mainBundle]];
	[contactP hideCallAndVmailButton:YES];
	contactP.parentView = 0;
	[contactP setObject:ownerobject];
	contactP.uaObject = GETCONTACTLIST;
	[contactP setObjType:GETCONTACTLIST];
	contactP.ltpInterfacesP =ownerobject.ltpInterfacesP;
	//navBarShow = NO;
	
	
	[contactP setReturnVariable:self :0 :0];
	
	tmpCtl = [ [ UINavigationController alloc ] initWithRootViewController: contactP ] ;
	//self.view = tmpCtl.view;
	tmpCtl.delegate =self;
	CGRect rectFrame;
	rectFrame = tmpCtl.view.frame;
	rectFrame.origin.y-=20;
	tmpCtl.view.frame = rectFrame;
	[viewP addSubview:tmpCtl.view];
	//tmpCtl.view.frame = viewP.frame;
	//[self.view addSubview:tmpCtl.view  ];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	printf("\n my view is appear");
	//[contactP updateUI]; 
	
}	
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
	tmpCtl.delegate =nil;
	[contactP release];
	[viewP release];
	[tmpCtl release];
	printf("\n call add make end");
	tmpCtl = nil;
	viewP = nil;
    [super dealloc];
}


@end
