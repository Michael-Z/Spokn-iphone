//
//  SpoknAppDelegate.h
//  spoknclient
//
//  Created by Mukesh Sharma on 26/06/09.
//  Copyright Geodesic Ltd. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "ltptimer.h"
#include "LtpInterface.h"
@class LoginViewController;

@class DialviewController;
@class ContactDetailsViewController;
@class ContactViewController;
@class  IncommingCallViewController;
@class VmsRecordPlayViewController;
@class CalllogViewController;
@class AddEditcontactViewController;
#include "vmsplayrecord.h"

#define LOAD_VIEW 1000
#define LOAD_LOGIN_VIEW 1
#define TRYING_CALL 4000

@class VmailViewController;


@interface SpoknAppDelegate : NSObject <UIApplicationDelegate> {
  //  @public
	UIWindow *window;
	

	LtpTimer    *ltpTimerP;
	DialviewController    *dialviewP;
	ContactViewController     *contactviewP;
	VmailViewController     *vmsviewP;
	CalllogViewController     *callviewP;
	VmsRecordPlayViewController *vmsRPViewP;
	UINavigationController *dialNavigationController;
	UINavigationController *vmsNavigationController;
	UINavigationController *calllogNavigationController;
	UINavigationController *contactNavigationController;

	NSMutableArray *viewControllers;
	UITabBarController *tabBarController;
	LtpInterfaceType *ltpInterfacesP;
	VmsPlayRecordType *vmsP;
	Boolean onLineB;
//	@public
	int status;
	int subID;
	int lineID;
	IncommingCallType *incommingCallList[MAXINCALL];
//
	
	@public
	//ContactDetailsViewController     *contactDetailsviewP;
	//AddEditcontactViewController     *addeditviewP;


}
-(void)LoadInCommingView:(id)objid;
-(void) setLtpInfo:(int)ltpstatus :(int)subid :(int)llineID :(void*)dataVoidP; 
-(void) showText:(NSString *)testStringP;
-(void)changeView;
-(IBAction)loginLtp:(id)sender;
-(IBAction)cancelLtp:(id)sender;
-(void)AcceptCall:(IncommingCallType *)inComP;
-(void)RejectCall:(IncommingCallType *)inComP;
-(void)LoadContactView:(id)object;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet DialviewController *dialviewP;
@property (nonatomic, retain) IBOutlet ContactViewController *contactviewP;
@property (nonatomic, retain) IBOutlet VmailViewController *vmsviewP;
@property (nonatomic, retain) IBOutlet VmsRecordPlayViewController *vmsRPViewP;
@property (nonatomic, retain) IBOutlet CalllogViewController *callviewP;

@property (nonatomic, assign) IBOutlet UINavigationController *dialNavigationController;
@property (nonatomic, assign) IBOutlet UINavigationController *vmsNavigationController;
@property (nonatomic, assign) IBOutlet UINavigationController *calllogNavigationController;
@property (nonatomic, assign) IBOutlet UINavigationController *contactNavigationController;
@property (nonatomic, assign) Boolean onLineB;
@property (nonatomic, assign) UITabBarController *tabBarController;
//@property (nonatomic, retain) IBOutlet spoknviewcontroller *viewController;
//add delegate
-(void)tabBarController:(UITabBarController*)tabBarController didSelectViewController:(UIViewController*)viewController;
-(void)tabBarController:(UITabBarController*)tabBarController didEndCustomizingViewController:(NSArray*)viewcontrollers
changed:(BOOL)changed;
-(Boolean)makeCall:(char *)noCharP;
-(Boolean)endCall:(int)lineid;
-(int) vmsPlayStart:(char *)fileName :(unsigned long *)fileszP;
-(int) vmsStop:(Boolean)recordB;
-(int) vmsRecordStart:(char*)numberP;
-(int) vmsSend:(char*)numberP;
-(void)popLoginView;
-(int)VmsStreamStart:(Boolean)recordB;
@end
void alertNotiFication(int type,unsigned int valLong,int valSubLong, unsigned long userData,void *otherinfoP);
