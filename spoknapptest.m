//
//  spoknapptest.m
//  spokn
//
//  Created by Mukesh Sharma on 06/12/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//
#define _MACOS_	
#define _CALLBACKLTP_
#define _strdup strdup

#import "spoknapptest.h"
#import "SpoknAppDelegate.h"

#import "Ltptimer.h"
#import "LtpInterface.h"
#import "loginviewcontroller.h"
#import "dialviewcontroller.h"
#import "contactviewcontroller.h"
#import "contactDetailsviewcontroller.h"
#import "IncommingCallViewController.h"
#include "ua.h"
#include "vmsplayrecord.h"

#import "CalllogViewController.h"
#import "vmailviewcontroller.h"
#import "spoknviewcontroller.h"


@implementation spoknapptest

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application
- (void) setUp {
	spoknDelP = [[UIApplication sharedApplication] delegate];
}

- (void) tearDown {

}

- (void) testAppDelegate {
    
    
    STAssertNotNil(spoknDelP, @"UIApplication failed to find the AppDelegate");
	printf("\n make call called");
	[spoknDelP makeCall:"919892029162"];
	//while(1);
    
}
/*- (void) testFail {
	STFail(@"Must fail to succeed.");
}
 */

- (void) testPass {
	STAssertTrue(TRUE, @"");
}
#else                           // all code under test must be linked into the Unit Test bundle

- (void) testMath {
    printf("\n testMath");
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
    
}

#endif


@end
