
//  Created on 10/07/09.

/**
 Copyright 2009,2010 Geodesic, <http://www.geodesic.com/>
 
 Spokn SIP-VoIP for iPhone and iPod Touch.
 
 This file is part of Spokn iphone.
 
 Spokn iphone is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 Spokn iphone is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Spokn iphone.  If not, see <http://www.gnu.org/licenses/>.
 */

#import <UIKit/UIKit.h>
#include "LtpInterface.h"
#import "custombutton.h"
@class SpoknAppDelegate;

//IncommingCallType *ownerobject;
@interface IncommingCallViewController : UIViewController {
	IBOutlet UILabel *incomingStatusLabelP;
	SpoknAppDelegate *ownerobject;
	IncommingCallType *ltpInDataP;
	IBOutlet CustomButton *ansP;//ans button
	IBOutlet CustomButton *declineP;//ans button
	LtpInterfaceType *ltpInterfacesP;
	//NSString *textProP;
	NSMutableString *textProP;
	
}


@property(readwrite,assign) LtpInterfaceType *ltpInterfacesP;

-(IBAction)Accept:(id)sender;
-(IBAction)Reject:(id)sender;
-(void)setObject:(id) object ;
-(id)initVariable;
-(void)setIncommingData:(IncommingCallType *)lltpInDataP;
@end
