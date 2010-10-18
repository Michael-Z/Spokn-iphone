
//  Created on 26/06/09.

/**
  Copyright 2009, 2010 Geodesic Limited. <http://www.geodesic.com/>
 
 Spokn for iPhone.
 
 This file is part of Spokn for iPhone.
 
 Spokn for iPhone is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, version 2 of the License.
  
 Spokn for iPhone is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Spokn for iPhone.  If not, see <http://www.gnu.org/licenses/>.
 */

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#include "ltptimer.h"
#include "LtpInterface.h"

#import "Reachability.h"
#include "playrecordpcm.h"
#import "spoknaudio.h"
#import "clicktocall.h"
@class LoginViewController;

@class DialviewController;
@class ContactDetailsViewController;
@class ContactViewController;
@class  IncommingCallViewController;

@class CalllogViewController;
@class AddEditcontactViewController;
@class Contactlookup;
@class countrylist;
#define G4_DEFINE
#include "vmsplayrecord.h"
#import "vmshowviewcontroller.h"
#import "loginviewcontroller.h"
#ifdef _TEST_MEMORY_
#import "testingview.h"
#endif
#define LOAD_VIEW 1000
#define LOAD_LOGIN_VIEW 1
#define TRYING_CALL 4000
#define INCOMMING_CALL_ACCEPTED 4005
#define INCOMMING_CALL_REJECT  4006
#define ROUTE_CHANGE 4010
#define _SIP_ 5000
#define ERR_CODE_CALL_FWD_DUPLICATE 402
#define ERR_CODE_VMS_SUCCESS 200
#define ERR_CODE_VMS_NO_CREDITS 101
#define ERR_CODE_VMS_BAD_HASH 102
#define ERR_CODE_VMS_NO_ROUTING 103
#define CALL_ALERT 5001
#define ATTEMPT_GPRS_LOGIN 5002
#define HOST_NAME_NOT_FOUND_ERROR 12
#define NO_WIFI_OR_DATA_NETWORK_REACHEBLE 10
#define _ANALYST_ 
#pragma pack(4)  
#define _CALL_THROUGH_
@class VmailViewController;
@class SpoknViewController;
@class testingview;
@class clicktocall;
typedef struct CallNumberType
{
	char number[100];
	int direction;
	int lineId;
}CallNumberType;
//
@class SpoknAppDelegate;
@interface spoknMessage:NSObject
{
	
	SpoknAppDelegate *spokndelegateP;
	int status;
	int subID;
	int lineID; 
	void *dataP;

}
@property(nonatomic,assign) SpoknAppDelegate *spokndelegateP;
@property(nonatomic,assign) int status;
@property(nonatomic,assign) int subID;
@property(nonatomic,assign) int lineID;
@property(nonatomic,assign) void* dataP;

@end



@class IncommingCallViewController;
@interface SpoknAppDelegate : NSObject <MKReverseGeocoderDelegate,MKMapViewDelegate,CLLocationManagerDelegate,UIApplicationDelegate,UITabBarControllerDelegate,UIActionSheetDelegate,clicktocallProtocol> {
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
	
	int ringStartB;
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
	void *otherDataP;
	id<VmsProtocol> VmsProtocolP;
	id<LoginProtocol> loginProtocolP;
	IncommingCallType *incommingCallList[MAXINCALL];
//
	Reachability* hostReach;
    Reachability* wifiReach;
	Boolean wifiavailable;
//	SystemSoundID endcallsoundID;
	//SystemSoundID soundIncommingCallID;
	//this store address of addressbook
	int animation;
	//SystemSoundID onlinesoundID;
	int upgradeAlerted;
	char *srvMsgCharP;
	NSString *urlSendP;
	int callOnB;
	int handSetB;
	int loginProgressStart;
	UIViewController *prvCtlP;
	CallNumberType callNumber;
	int loginGprsB;
	SpoknAudio *incommingSoundP;
	SpoknAudio *onLineSoundP;
	SpoknAudio *endSoundP;
	SpoknAudio *allSoundP;
	NSTimer *ringTimer;
	Contactlookup *contactlookupP;
	Contactlookup *intiallookupP;
	ABAddressBookRef addressRef;
	int edgevalue;
	int onoffSip;
	int onoffAnalytics;
	Boolean blueTooth;
	NSString *devicePushTokenStrP;
	int firstTimeB;

	IncommingCallViewController     *inCommingCallViewP;

	int shifttovmsTab;
	int isCallOnB;
	int setDeviceID;
	int ipadB;
	int iphoneHighResolationB;
	int prioximityB;
	int timeOutB;
	ABPeoplePickerNavigationController *globalAddressP;
	int randowVariable;
	Boolean inbackgroundModeB;
	Boolean isBackgroundSupported;
	Boolean endAppB;
#ifdef __IPHONE_4_0
	UIBackgroundTaskIdentifier bg_task;	
	//@public
	//ContactDetailsViewController     *contactDetailsviewP;
	//AddEditcontactViewController     *addeditviewP;
#endif
	Boolean loginAttemptB;
	int outCallType;//1 sip ,2 callback, 3 both 
	int actualOnlineB;
	Boolean uaLoginSuccessB;
	Boolean sipLoginAttemptStartB;
	int intrrruptB;
	Boolean dontTakeMsg;
	char userAgent[100];
	Boolean applicationLoadedB;
	Boolean stopCircularRingB;
	int onLogB;
	char numberToCall[100];
	double osversionDouble;
	countrylist *countrylispP;
	int callthroughNumber;
	#ifdef _CALL_THROUGH_
	int onlyCallThrough;
	
	#endif
	int ipadOrIpod;
	CLLocationManager *locationManager;
	MKReverseGeocoder *geoCoder;
	MKPlacemark *mPlacemark;
	
	NSString *presentCountry;
	NSString *presentCountryCode;

	
}
-(void)LoadInCommingView:(id)objid:(UIViewController*)perentControllerP;
-(void) setLtpInfo:(int)ltpstatus :(int)subid :(int)llineID :(void*)dataVoidP; 
-(void) showText:(NSString *)testStringP;
-(void)changeView;
-(IBAction)loginLtp:(id)sender;
-(IBAction)cancelLtp:(id)sender;
-(void)AcceptCall:(IncommingCallType*) inComP :(UIViewController*)perentControllerP;
-(void)RejectCall:(IncommingCallType *)inComP:(UIViewController*)perentControllerP;
-(void)LoadContactView:(id)object;
-(void)SendDTMF:(char *)dtmfVapP;
-(void)updateSpoknView:(id)object;
-(void)startRutine;
- (void) ProximityChange:(NSNotification *)notification	;
-(void)onCharging:(NSNotification *)notification;	
- (BOOL) checkForIpad ;
-(void)registerUnregisterOriantation:(BOOL)registerB;
//#define _TEST_CALL_
#ifdef _TEST_CALL_
- (void) handleStartCall: (id) timer;
- (void) handleEndCall: (id) timer;
-(void)startCall;
-(void)endCall;
- (BOOL) checkForHighResolution;
-(void) setPjsipBufferSize;


#endif
-(void) setoutCallTypeProtocol:(int)type;
-(void)	applicationInit:(id)application;
/*
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, assign) IBOutlet DialviewController *dialviewP;
@property (nonatomic, assign) IBOutlet ContactViewController *contactviewP;
@property (nonatomic, assign) IBOutlet VmailViewController *vmsviewP;
@property (nonatomic, assign) IBOutlet VmsRecordPlayViewController *vmsRPViewP;
@property (nonatomic, assign) IBOutlet CalllogViewController *callviewP;

*/
#ifdef _CALL_THROUGH_
 
@property (nonatomic, assign) int onlyCallThrough;
#endif


@property(nonatomic,assign) ABPeoplePickerNavigationController *globalAddressP;
@property (nonatomic, assign) Boolean blueTooth;
@property (nonatomic, assign) ABAddressBookRef addressRef;
@property (nonatomic, assign) int callOnB;
@property (nonatomic, assign) int handSetB;
@property (nonatomic,assign)  int loginProgressStart; 
@property (nonatomic, assign) LtpInterfaceType *ltpInterfacesP;
@property (nonatomic, assign) IBOutlet UINavigationController *vmsNavigationController;
@property (nonatomic, assign) IBOutlet UINavigationController *calllogNavigationController;
@property (nonatomic, assign) IBOutlet UINavigationController *contactNavigationController;
@property (nonatomic, assign) Boolean onLineB;
@property (nonatomic, assign) int firstTimeB;
@property (nonatomic, assign) UITabBarController *tabBarController;
@property (nonatomic,assign) DialviewController    *dialviewP; 
@property(nonatomic,assign)Boolean inbackgroundModeB;
@property(nonatomic,assign)int onLogB;
@property(nonatomic,assign)int onoffSip;
@property(nonatomic,assign)double osversionDouble;
@property (nonatomic, retain) CLLocationManager *locationManager;  

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

-(int)showContactScreen:(id) navObject returnnumber:(SelectedContctType *)lselectedContactP  result:(int *) resultP;
-(void) enableEdge ;
-(void) enableSip;
-(void) enableAnalytics;
-(int) vmsForward:(char*)numberP :(char*)fileNameCharP;
- (void) updateReachabilityStatus: (Reachability*) curReach;
-(void) startCheckNetwork;
-(void) stopCheckNetwork;
-(void)vmsDeinitRecordPlay:(id)object;
-(void)newBadgeArrived:(id)object;
-(void) sendMessage:(id)object;
+(BOOL) emailValidate : (NSString *)emailid;
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
-(void)makeIndexingFromAddressBook;
-(char*) getNameAndTypeFromNumber:(char*)pnumberP :(char*)typeP :(Boolean*)pfindBP ;
-(int)playUrlPath:(NSString*)pathP;
-(int) vmsShowRecordOrForwardScreen : (char*)noCharP VMSState:(VMSStateType)state filename:(char*)fileNameCharP duration:(int) maxtime vmail:(struct VMail*) lvmailP;
-(int) profileResynFromApp;
-(void)setDeviceInforation:(NSString *)deviceTokenP;
-(void)sendMessageFromOtherThread:(spoknMessage*)spoknMsgP;
-(void) setIncommingCallDelegate:(id)incommingP;
-(int)getIncommingLineID;

-(void)onOrientationChangeApp:(NSNotification *)notification;
-(void)checkChangesInSetting;
-(void)retianThisObject:(id)retainObject;
- (BOOL) checkForHighResolution;	
-(void) startTakingEvent;
-(int)sendLogFile:(NSString **)stringP;
-(void) enableLog;
-(Boolean)makeSipCallOrCallBack:(char *)noCharP callType:(int) loutCallType;
-(void)setcallthroughData:(id)objectP;
- (void)stopUpdatingCoreLocation:(NSString *)state;
#ifdef G4_DEFINE	
#ifdef __IPHONE_4_0	
- (void)sendIncommingPushNotification:(NSString*)msgStringP;
#endif
#endif
@end
int blueToothIsOn();
int GetOsVersion(int *majorP,int *minor1P,int *minor2P);
void * ThreadForContactLookup(void *udata);

int alertNotiFication(int type,unsigned int valLong,int valSubLong, unsigned long userData,void *otherinfoP);

void MyAudioSessionPropertyListener(
									void *                  inClientData,
									AudioSessionPropertyID	inID,
									UInt32                  inDataSize,
									const void *            inData);
