//
//  GEventTracker.m
//  GoogleAnalyticsWrapper
//
//  Created by Ninad Vartak on 17/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GEventTracker.h"
#import "SpoknAppDelegate.h"

//Tracked events will be dispatched to the Google Analytics server after specified no of seconds
#define DISPATCH_INTERVAL 10

//Specifies if application mode is developer or user. Events will not be tracked for developer mode
// Comment following line when not in developer mode
//#define DEVELOPER_MODE

id sharedEventTracker;




@implementation GEventTracker
@synthesize showTrakerB;
+(void) releaseSharedInstance
{
	[sharedEventTracker release];
	sharedEventTracker = nil;

}
+ (GEventTracker *)sharedInstance 
{
	
	@synchronized(self) 
	{
		if(sharedEventTracker == nil)
		{
			sharedEventTracker = [[GEventTracker alloc] init];
			//[sharedEventTracker startEventTracker];
			
		}
	}
	return sharedEventTracker;
}

- (void)startEventTracker {
#ifdef DEVELOPER_MODE
	return;
#endif
	if(self.showTrakerB)
	{	
		[[GANTracker sharedTracker] startTrackerWithAccountID:@ "UA-10360983-1" dispatchPeriod:DISPATCH_INTERVAL delegate:self];
	}
}
- (void)trackEvent:(NSString *)category action:(NSString *)action label:(NSString *)label {
#ifdef DEVELOPER_MODE
	return;
#endif
	if(self.showTrakerB)
	{
		if([[GANTracker sharedTracker] trackEvent:category action:action label:label value:-1 withError:&error]) {
		NSLog(@"Tracked event ==> Category: %@, Action: %@, Label: %@", category, action, label);
		}
	}
}

- (void)stopEventTracker {
#ifdef DEVELOPER_MODE
	return;
#endif
	if(self.showTrakerB)
	{
		[[GANTracker sharedTracker] stopTracker];
	}	
}
#pragma mark GANTrackerDelegate methods

- (void)trackerDispatchDidComplete:(GANTracker *)tracker
                  eventsDispatched:(NSUInteger)eventsDispatched
              eventsFailedDispatch:(NSUInteger)eventsFailedDispatch
{
	NSLog(@"Events dispatched: %i , Events Failed: %i", eventsDispatched, eventsFailedDispatch);
}

@end
