
//  Created on 10/07/09.

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
#include "LtpInterface.h"
#import "custombutton.h"
#pragma pack(4)  
@class SpoknAppDelegate;

//IncommingCallType *ownerobject;
@interface IncommingCallViewController : UIViewController {
	IBOutlet UILabel *nameLabelP;
	IBOutlet UILabel *statusLabelP;
	SpoknAppDelegate *ownerobject;
	IncommingCallType *ltpInDataP;
	IBOutlet CustomButton *ansP;//ans button
	IBOutlet CustomButton *declineP;//ans button
	IBOutlet UIView *topViewP;
	IBOutlet UIView *bottomViewP;
	
	//NSString *textProP;
	NSString *statusStrP;
	NSString *nameStrP;
	int buttonPressedB;
	int acceptPressedB;
	int directB;
	Boolean dontResetStyle;
	//UIBarStyle prvStyle;
	
}




-(IBAction)Accept:(id)sender;
-(IBAction)Reject:(id)sender;
-(void)setObject:(id) object ;
-(id)initVariable;
-(void)setIncommingData:(IncommingCallType *)lltpInDataP;
-(void)directAccept:(int)ldirectB;

-(int)incommingViewDestroy:(int)lineID;
@end
