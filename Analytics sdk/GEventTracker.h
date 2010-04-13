
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
