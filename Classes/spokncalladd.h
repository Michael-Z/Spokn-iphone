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
@interface Spokncalladd : UIViewController<UINavigationControllerDelegate> {
	UILabel *label;
	IBOutlet UIView *viewP;
	SpoknAppDelegate      *ownerobject;
	ContactViewController *contactP;
	UINavigationController *tmpCtl;
	//TTSearchlightLabel* label;
}
-(void)setObject:(id) object ;
@end
