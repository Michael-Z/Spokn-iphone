//
//  VmsRecordPlayViewController.h
//  spokn
//
//  Created by Mukesh Sharma on 28/07/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SpoknAppDelegate;
@interface VmsRecordPlayViewController : UIViewController {
	IBOutlet UIProgressView *uiProgBarP;
	IBOutlet UIButton *sendButtonP;
	IBOutlet UIButton *stopPlayButtonP;
	IBOutlet UIButton *stopRecordButtonP;
	float amt;
	float maxtime;
	NSTimer *timerP;
	SpoknAppDelegate * ownerobject;
	Boolean recordB;
	Boolean stopB;
	Boolean firstViewB;
	char *numberCharP;

}
-(int) vmsRecordStart:(int)max :(char*)noCharP;
-(int) vmsPlayStart:(int)max;
-(int) vmsUIStop;

- (void) handleTimer: (id) timer;
-(void)setObject:(id) object ;

-(IBAction)stopVm:(id)sender;
-(IBAction)sendVm:(id)sender;
@end
