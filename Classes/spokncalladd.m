
//  Created on 05/02/10.

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

#import "callviewcontroller.h"
#import "spokncalladd.h"
#import "contactviewcontroller.h"
#import "spoknAppDelegate.h"
#import "alertmessages.h"

@implementation Spokncalladd
#pragma mark NAVIGATIONOBJECT
// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
	
	/*if(viewController ==self->contactP)
	{
		[contactP updateUI];
	}*/
	SEL method = @selector(updateUI:);
	
	if ([viewController respondsToSelector:method])
	{	
		[viewController performSelector:method withObject:nil];
	}	
}
- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item
{
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
-(void)objectDestory
{
	callViewCtlP = nil;
}
-(void)upDateUI
{
		#ifdef _HILIGHT_SEARCH_
		[label updateSpotlight];
	#else
	/*
	if(label.alpha>=1.0)
	{
		cycle = -1;
	}
	if(label.alpha<=0.1)
	{
		cycle = 1;
	}
	label.alpha= label.alpha + cycle*0.1;*/
	#endif

}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	#ifdef _HILIGHT_SEARCH_
	label = [[TTSearchlightLabel alloc] init] ;
	callViewCtlP.showContactCallOnDelegate = self;
	
	#else
	
		label = [[UILabel alloc] init] ;
	#endif
	
	label.text = _RETURN_TO_CALL_;
	label.font = [UIFont systemFontOfSize:25];
	label.textAlignment = UITextAlignmentCenter;
	label.contentMode = UIViewContentModeCenter;
	label.backgroundColor = [UIColor blackColor];
	label.textColor = [UIColor grayColor];
	[label sizeToFit];
	label.frame = CGRectMake(0, 0, 320, 40);
	//label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backview.png"]];
	
		[self.view addSubview:label];
	#ifdef _HILIGHT_SEARCH_
	label.spotlightColor =[UIColor whiteColor];
	[label startAnimationWithoutTimer];
	//	[label startAnimating];
	#endif
	
	
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
	
	//[contactP updateUI]; 
	
}
- (void)viewDidDisappear:(BOOL)animated;  // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
{
	[super viewDidAppear:animated];
	
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

-(void)setParent:(CallViewController *)lcallViewCtlP
{
	#ifdef _HILIGHT_SEARCH_
		callViewCtlP=lcallViewCtlP;
	#else
	callViewCtlP = nil;

	#endif
}
- (void)dealloc {
	callViewCtlP.showContactCallOnDelegate = nil;
	
	tmpCtl.delegate =nil;
	[contactP release];
	contactP = nil;
	[viewP release];
	viewP = nil;
	[tmpCtl release];
	tmpCtl = nil;
	[label release];
	label = nil;

	
	
	[super dealloc];
}
-(void) upDateCallFromTimer
{
	//- (void)updateSpotlight;
}

@end
