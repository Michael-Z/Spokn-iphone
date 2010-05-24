
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

#import <UIKit/UIKit.h>
#import "TTSearchlightLabel.h"
//#import "TTDefaultStyleSheet.h"
@class ContactViewController;
@class SpoknAppDelegate;
@class CallViewController;
@protocol AddCallProtocol


@optional
-(void)handupCall:(int)llineID;
- (void)makeCall:(char*)numberP;
-(int)totalCallActive;
-(NSString*)getStringByIndex:(int)index;
-(void) selectedCall:(int)index;
-(void) objectDestroy;

@end
@protocol ShowContactCallOnDelegate

@optional
- (void)upDateUI;
-(void)objectDestory; 
-(void)setParentObject:(id)parentP;


@end

//#import "callviewcontroller.h"

#define _HILIGHT_SEARCH_
@protocol ShowContactCallOnDelegate;
@interface Spokncalladd : UIViewController<UINavigationControllerDelegate,ShowContactCallOnDelegate,AddCallProtocol,UITabBarControllerDelegate> {
	
	IBOutlet UIView *viewP;
	SpoknAppDelegate      *ownerobject;
	ContactViewController *contactP;
	UINavigationController *tmpCtl;
	CallViewController *callViewCtlP;
	int addCallB;
	UITabBarController *tabBarControllerP;
#ifdef _HILIGHT_SEARCH_
	TTSearchlightLabel* label;
#else
	int cycle;
	UILabel *label;
#endif
	
		//
}
@property(nonatomic,assign) int addCallB;
-(void)setObject:(id) object ;
-(void)setParent:(CallViewController *)lcallViewCtlP;
@end
