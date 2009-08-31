//
//  spoknalert.m
//  spokn
//
//  Created by Mukesh Sharma on 14/08/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import "spoknalert.h"


@implementation SpoknAlert

@synthesize buttonClickedIndex;

- (void)dealloc {
    [super dealloc];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
	buttonClickedIndex = buttonIndex;
}

@end
