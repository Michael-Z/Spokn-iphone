//
//  LtpTimer.m
//  spoknclient
//
//  Created by Mukesh Sharma on 28/06/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import "LtpTimer.h"


@implementation LtpTimer
@synthesize ltpInterfacesP;
-(id)init
{
	self = [super init];
	return self;
}
-(int) startTimer
{
	timerP = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkTimer:) userInfo:nil
											 repeats:YES ] retain ];	
	return 0;
}
-(int)stopTimer
{
	[timerP release];
	return 0;
}
-(void)checkTimer:(NSTimer*)aTimer
{
	DoPolling(self.ltpInterfacesP);
	
}

@end
