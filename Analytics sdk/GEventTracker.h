//
//  EventTracker.h
//  GoogleAnalyticsWrapper
//
//  Created by Ninad Vartak on 17/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GANTracker.h"
@class SpoknAppDelegate;
@interface GEventTracker : NSObject <GANTrackerDelegate> {
	//Encapsulates the error occured while tracking the event
	NSError *error;
	int showTrakerB;
}
@property(nonatomic,readwrite) int showTrakerB;
//Returns singleton instance of EventTracker
+ (GEventTracker *)sharedInstance;

//Starts Google Analytics event tracker
//- (void)startEventTracker;

//Tracks event with specified details
- (void)trackEvent:(NSString *)category action:(NSString *)action label:(NSString *)label;

//Stops Google Analytics event tracker
- (void)stopEventTracker;
- (void)startEventTracker;
+(void) releaseSharedInstance;
@end
