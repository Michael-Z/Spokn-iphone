//
//  IncommingCallViewController.h
//  spoknclient
//
//  Created by Mukesh Sharma on 10/07/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "LtpInterface.h"
@class SpoknAppDelegate;
IncommingCallType *ownerobject;
@interface IncommingCallViewController : UIViewController {
	IBOutlet UILabel *incomingStatusLabelP;
	SpoknAppDelegate *ownerobject;
	IncommingCallType *ltpInDataP;

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
