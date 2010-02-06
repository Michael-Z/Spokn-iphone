//
//  spokncalladd.h
//  spokn
//
//  Created by Mukesh Sharma on 05/02/10.
//  Copyright 2010 Geodesic Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTSearchlightLabel.h"
//#import "TTDefaultStyleSheet.h"
@class ContactViewController;
@class SpoknAppDelegate;
@class CallViewController;
#define _HILIGHT_SEARCH_
@protocol ShowContactCallOnDelegate;
@interface Spokncalladd : UIViewController<UINavigationControllerDelegate,ShowContactCallOnDelegate> {
	
	IBOutlet UIView *viewP;
	SpoknAppDelegate      *ownerobject;
	ContactViewController *contactP;
	UINavigationController *tmpCtl;
	CallViewController *callViewCtlP;
#ifdef _HILIGHT_SEARCH_
	TTSearchlightLabel* label;
#else
	int cycle;
	UILabel *label;
#endif
	
		//
}
-(void)setObject:(id) object ;
-(void)setParent:(CallViewController *)lcallViewCtlP;
@end
