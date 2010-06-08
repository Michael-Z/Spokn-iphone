
//  Created on 17/11/09.

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


#import "GEventTracker.h"
#import "SpoknAppDelegate.h"

//Tracked events will be dispatched to the Google Analytics server after specified no of seconds
#define DISPATCH_INTERVAL 20

//Specifies if application mode is developer or user. Events will not be tracked for developer mode
// Comment following line when not in developer mode
//#define DEVELOPER_MODE

id sharedEventTracker;


#ifndef GOOGLE_ID
#define GOOGLE_ID @"XXX"
#endif 

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
		[[GANTracker sharedTracker] startTrackerWithAccountID:GOOGLE_ID dispatchPeriod:DISPATCH_INTERVAL delegate:self];
	}
}
- (void)trackEvent:(NSString *)category action:(NSString *)action label:(NSString *)label {
#ifdef DEVELOPER_MODE
	return;
#endif
	if(self.showTrakerB)
	{
		BOOL result;
		result = [[GANTracker sharedTracker] trackEvent:category action:action label:label value:-1 withError:&error];
		/*if(result) {
			NSLog(@"Tracked event ==> Category: %@, Action: %@, Label: %@", category, action, label);
		}*/
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
//	NSLog(@"Events dispatched: %i , Events Failed: %i", eventsDispatched, eventsFailedDispatch);
}

@end
