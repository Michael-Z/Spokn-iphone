
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
