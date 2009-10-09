//
//  LtpTimer.h
//  spoknclient
//
//  Created by Mukesh Sharma on 28/06/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "LtpInterface.h"

@interface LtpTimer : NSObject {
	@private
	NSTimer *timerP;
	LtpInterfaceType *ltpInterfacesP;
}

@property(readwrite,assign) LtpInterfaceType *ltpInterfacesP;
-(int) startTimer;
-(int)stopTimer;

@end
