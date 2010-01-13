//
//  LtpTimer.m
//  spoknclient
//
//  Created by Mukesh Sharma on 28/06/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//
/**
 Copyright 2009 John Smith, <john.smith@example.com>
 
 This file is part of FOOBAR.
 
 FOOBAR is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 FOOBAR is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with FOOBAR.  If not, see <http://www.gnu.org/licenses/>.
 */

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
