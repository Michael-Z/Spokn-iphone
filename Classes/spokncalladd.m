
//  Created on 05/02/10.

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

#import "callviewcontroller.h"
#import "spokncalladd.h"
#import "contactviewcontroller.h"
#import "spoknAppDelegate.h"
#import "alertmessages.h"
#import "dialviewcontroller.h"
#import "calllogviewcontroller.h"

@implementation Spokncalladd
@synthesize addCallB;
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



 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		addCallB = 0;
	
	}
  
	
	return self;
}
-(void)makeCall:(char*)numberP
{

	[callViewCtlP makeCall:numberP];
	/*if([callViewCtlP childWillDie])
	{	
		
		[self dismissModalViewControllerAnimated:YES ];
	
	}*/
	[self dismissModalViewControllerAnimated:YES ];
	
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	NSEnumerator *enumerator = [touches objectEnumerator];
	UITouch *touch;
	CGPoint point ;
	
		
	while ((touch = [enumerator nextObject])) 
	{
		 point = [touch locationInView:self.view];
		break;	
	}
	
	if(point.y<40)
	{	
		/*if([callViewCtlP childWillDie])
		{	
			
			[self dismissModalViewControllerAnimated:YES ];
			
		}		
		*/
		[self dismissModalViewControllerAnimated:YES ];
	}	
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
	label.font = [UIFont systemFontOfSize:15];
	label.textAlignment = UITextAlignmentCenter;
	label.contentMode = UIViewContentModeCenter;
	label.backgroundColor = [UIColor blackColor];
	label.textColor = [UIColor grayColor];
	//[label sizeToFit];
	label.frame = CGRectMake(0, 0, 320, 30);
	//label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backview.png"]];
	
		[self.view addSubview:label];
	#ifdef _HILIGHT_SEARCH_
	label.spotlightColor =[UIColor whiteColor];
	[label startAnimationWithoutTimer];
	//	[label startAnimating];
	#endif
	
	
	//[[self navigationController] setNavigationBarHidden:NO animated:NO];
	if(self.addCallB==false)
	{	
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
		[viewP addSubview:tmpCtl.view];
		CGRect rectFrame;
		rectFrame = tmpCtl.view.frame;
		rectFrame.origin.y-=20;
		tmpCtl.view.frame = rectFrame;
		
	}	
	else {
		
		NSMutableArray *viewControllers;
		viewControllers = [[NSMutableArray alloc] init];
		
		
		contactP = [[ContactViewController alloc] initWithNibName:@"contact" bundle:[NSBundle mainBundle]];
		contactP.addcallDelegate = self;
		[contactP hideCallAndVmailButton:YES];
		contactP.parentView = 0;
		[contactP setObject:ownerobject];
		contactP.uaObject = GETCONTACTLIST;
		[contactP setObjType:GETCONTACTLIST];
		contactP.ltpInterfacesP =ownerobject.ltpInterfacesP;
		tmpCtl = [ [ UINavigationController alloc ] initWithRootViewController: contactP ] ;
		tmpCtl.delegate =self;
		[contactP release];
		contactP = nil;
		DialviewController* dialviewP = [[DialviewController alloc] initWithNibName:@"dialview" bundle:[NSBundle mainBundle]];
		dialviewP.addcallDelegate = self;
		[dialviewP setObject:ownerobject];
		CalllogViewController *callviewP = [[CalllogViewController alloc] initWithNibName:@"calllog" bundle:[NSBundle mainBundle]];
		UINavigationController* calllogNavigationController = [ [ UINavigationController alloc ] initWithRootViewController: callviewP ];
		[callviewP release];	
		[callviewP setObject:ownerobject];
		callviewP.addcallDelegate = self;
		//[viewControllers addObject:loginViewP];
		[viewControllers addObject:tmpCtl];
		//[tmpCtl release];
		//tmpCtl = nil;
		[viewControllers addObject:calllogNavigationController];
		[calllogNavigationController release];
		[viewControllers addObject:dialviewP];
		[dialviewP release];
	//	[ownerobject.contactNavigationController release];
		
	//	[viewControllers addObject:ownerobject.calllogNavigationController];
		//[ownerobject.calllogNavigationController release];
		
		
		// [viewControllers addObject:ownerobject.dialviewP];
		//[ownerobject.dialviewP release];
		
		tabBarControllerP = [ [ UITabBarController alloc ] init ];
		
		tabBarControllerP.viewControllers = viewControllers;
		[viewControllers release];
		
		
		
		
		
		//self.view = tmpCtl.view;
	//	tmpCtl.delegate =self;
		
		[viewP addSubview:tabBarControllerP.view];
		CGRect rectFrame;
		rectFrame = tabBarControllerP.view.frame;
		rectFrame.size.height-=45;
		//rectFrame.origin.y-=20;
		tabBarControllerP.view.frame = rectFrame;
	//	[ [UIApplication sharedApplication] setStatusBarHidden:YES];
	}

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
- (void) removeController: (id) timer
{
	[timer invalidate];
	timer = nil;
	[self dismissModalViewControllerAnimated:YES];
	
	
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if([callViewCtlP childWillDie]==0)
	{
		removeControllerB = 0;
		[NSTimer scheduledTimerWithTimeInterval: 0.1
										 target: self
									   selector: @selector(removeController:)
									   userInfo: nil
										repeats: NO];
		
				
	}
	//[contactP updateUI]; 
	
}
- (void)viewDidDisappear:(BOOL)animated;  // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
{
	[super viewDidDisappear:animated];
	
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
	[tabBarControllerP release];
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
-(void)removeController
{
	removeControllerB = true;
}
@end
