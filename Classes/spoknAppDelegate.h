//
//  SpoknAppDelegate.h
//  spoknclient
//
//  Created by Mukesh Sharma on 26/06/09.
//  Copyright Geodesic Ltd. 2009. All rights reserved.
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

#import <UIKit/UIKit.h>
#include "ltptimer.h"
#include "LtpInterface.h"
#import "Reachability.h"
#include "playrecordpcm.h"

@class LoginViewController;

@class DialviewController;
@class ContactDetailsViewController;
@class ContactViewController;
@class  IncommingCallViewController;

@class CalllogViewController;
@class AddEditcontactViewController;
#include "vmsplayrecord.h"
#import "vmshowviewcontroller.h"
#import "loginviewcontroller.h"
#ifdef _TEST_MEMORY_
#import "testingview.h"
#endif
#define LOAD_VIEW 1000
#define LOAD_LOGIN_VIEW 1
#define TRYING_CALL 4000
#define _SIP_ 5000
#define ERR_CODE_CALL_FWD_DUPLICATE 402
#define ERR_CODE_VMS_SUCCESS 200
#define ERR_CODE_VMS_NO_CREDITS 101
#define ERR_CODE_VMS_BAD_HASH 102
#define ERR_CODE_VMS_NO_ROUTING 103
#define CALL_ALERT 5001

@class VmailViewController;
@class SpoknViewController;
@class testingview;
typedef struct CallNumberType
{
	char number[100];
	int direction;
	int lineId;
}CallNumberType;
//
@interface SpoknAppDelegate : NSObject <UIApplicationDelegate,UITabBarControllerDelegate> {
  //  @public
	UIWindow *window;
	

	LtpTimer    *ltpTimerP;
	DialviewController    *dialviewP;
	ContactViewController     *contactviewP;
	VmailViewController     *vmsviewP;
	CalllogViewController     *callviewP;
	//VmsRecordPlayViewController *vmsRPViewP;
	SpoknViewController			*spoknViewControllerP;
//	UINavigationController *dialNavigationController;
	UINavigationController *vmsNavigationController;
	UINavigationController *calllogNavigationController;
	UINavigationController *contactNavigationController;
	UINavigationController *spoknViewNavigationController;
#ifdef _TEST_MEMORY_
	UINavigationController *testNavigationController;
	testingview *testP;
	
#endif
	
	NSTimer *ringTimer;
	NSTimer *nsTimerP;
	UITabBarController *tabBarController;
	LtpInterfaceType *ltpInterfacesP;
	VmsPlayRecordType *vmsP;
	Boolean onLineB;
	Boolean onLineCounter;
	float balance;
//	@public
	int status;
	int subID;
	int lineID;
	id<VmsProtocol> VmsProtocolP;
	id<LoginProtocol> loginProtocolP;
	IncommingCallType *incommingCallList[MAXINCALL];
//
	Reachability* hostReach;
    Reachability* wifiReach;
	Boolean wifiavailable;
	SystemSoundID endcallsoundID;
	SystemSoundID soundIncommingCallID;
	//this store address of addressbook
	int animation;
	SystemSoundID onlinesoundID;
	int upgradeAlerted;
	char *srvMsgCharP;
	NSString *urlSendP;
	int callOnB;
	int handSetB;
	int loginProgressStart;
	UIViewController *prvCtlP;
	CallNumberType callNumber;
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
-(void)SendDTMF:(char *)dtmfVapP;

-(void)updateSpoknView:(id)object;
/*
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, assign) IBOutlet DialviewController *dialviewP;
@property (nonatomic, assign) IBOutlet ContactViewController *contactviewP;
@property (nonatomic, assign) IBOutlet VmailViewController *vmsviewP;
@property (nonatomic, assign) IBOutlet VmsRecordPlayViewController *vmsRPViewP;
@property (nonatomic, assign) IBOutlet CalllogViewController *callviewP;

*/

@property (nonatomic, assign) int callOnB;
@property (nonatomic, assign) int handSetB;
@property (nonatomic,assign)  int loginProgressStart; 
@property (nonatomic, assign) LtpInterfaceType *ltpInterfacesP;
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
-(int) vmsRecordStart:(char*)namecharP;
-(int) vmsSend:(char*)numberP :(char*)fileNameCharP;
-(void)popLoginView;
-(int)VmsStreamStart:(Boolean)recordB;
-(void)setVmsDelegate :(id)deligateP;
-(int)getFileSize:(char*)fileNameP :(unsigned long *)noSecP;
-(int) vmsShowRecordScreen : (char*)noCharP;
-(int)showContactScreen:(id) navObject returnnumber:(SelectedContctType *)lselectedContactP  result:(int *) resultP;

-(int) vmsForward:(char*)numberP :(char*)fileNameCharP;
- (void) updateReachabilityStatus: (Reachability*) curReach;
-(void) startCheckNetwork;
-(void) stopCheckNetwork;
-(void)vmsDeinitRecordPlay:(id)object;
-(void)newBadgeArrived:(id)object;
-(void) sendMessage:(id)object;
+(BOOL) emailValidate : (NSString *)email;
-(void) createRing;
-(void) destroyRing;
-(int) stopRing;
-(void)startRing;
-(void)cancelLoginView;
-(void) playonlineTone;
-(void) playcallendTone;
-(void)logOut:(Boolean) clearAllB;
-(void)setLoginDelegate :(id)deligateP;
-(void)refreshallViews;

-(char*) getNameAndTypeFromNumber:(char*)pnumberP :(char*)typeP :(Boolean*)pfindBP ;
@end
void alertNotiFication(int type,unsigned int valLong,int valSubLong, unsigned long userData,void *otherinfoP);
void MyAudioSessionPropertyListener(
									void *                  inClientData,
									AudioSessionPropertyID	inID,
									UInt32                  inDataSize,
									const void *            inData);
