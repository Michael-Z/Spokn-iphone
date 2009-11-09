//
//  SpoknAppDelegate.m
//  spoknclient
//
//  Created by Mukesh Sharma on 26/06/09.
//  Copyright Geodesic Ltd. 2009. All rights reserved.
//

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
//#import "testingview.h"
//#import "NSFileManager.h"
@implementation SpoknAppDelegate
/*
@synthesize window;
@synthesize dialviewP;

@synthesize contactviewP;

@synthesize vmsviewP;
@synthesize callviewP;
@synthesize vmsRPViewP;
*/
//@synthesize dialNavigationController;
@synthesize vmsNavigationController;
@synthesize calllogNavigationController;
@synthesize contactNavigationController;
@synthesize onLineB;
@synthesize tabBarController;
- (void) handleTimer: (id) timer
{
	
	printf("\n resync called");
	profileResync();
	
}

+(BOOL) emailValidate : (NSString *)email
{
	
	
	//Quick return if @ Or . not in the string
	if([email rangeOfString:@"@"].location==NSNotFound || [email rangeOfString:@"."].location==NSNotFound)
		return NO;
	
	//Break email address into its components
	NSString *accountName=[email substringToIndex: [email rangeOfString:@"@"].location];
	email=[email substringFromIndex:[email rangeOfString:@"@"].location+1];
	
	//’.’ not present in substring
	if([email rangeOfString:@"."].location==NSNotFound)
		return NO;
	NSString *domainName=[email substringToIndex:[email rangeOfString:@"."].location];
	NSString *subDomain=[email substringFromIndex:[email rangeOfString:@"."].location+1];
	
	//username, domainname and subdomain name should not contain the following charters below
	//filter for user name
	NSString *unWantedInUName = @" ~!@#$^&*()={}[]|;’:\”<>,?/`";
	//filter for domain
	NSString *unWantedInDomain = @" ~!@#$%^&*()={}[]|;’:\”<>,+?/`";
	//filter for subdomain 
	NSString *unWantedInSub = @" `~!@#$%^&*()={}[]:\”;’<>,?/1234567890";
	
	//subdomain should not be less that 2 and not greater 6
	if(!(subDomain.length>=2 && subDomain.length<=6)) return NO;
	
	if([accountName isEqualToString:@""] || [accountName rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInUName]].location!=NSNotFound || [domainName isEqualToString:@""] || [domainName rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInDomain]].location!=NSNotFound || [subDomain isEqualToString:@""] || [subDomain rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInSub]].location!=NSNotFound)
		return NO;
	
	return YES;
}
-(void) showText:(NSString *)testStringP
{
	[dialviewP setStatusText:testStringP :0 :0];
}

//@synthesize viewNavigationController;
-(void)alertAction:(NSNotification*)note
{
	switch(self->status)
	{
		case ALERT_CONNECTED:
			[dialviewP setStatusText: @"ringing" :ALERT_CONNECTED :0];
			//openSoundInterface(ltpInterfacesP,1);
			[[UIApplication sharedApplication] setProximitySensingEnabled:YES];
			#ifndef _LTP_
				[nsTimerP invalidate];
				nsTimerP = nil;
			#endif
			break;	
		case ALERT_DISCONNECTED:
			[dialviewP setStatusText: @"end call" :ALERT_DISCONNECTED :0 ];

			//closeSoundInterface(ltpInterfacesP);
			
			[[UIApplication sharedApplication] setProximitySensingEnabled:NO];
			//reload log
			[self LoadContactView:callviewP];
			#ifndef _LTP_
				[nsTimerP invalidate];
			
				nsTimerP = [NSTimer scheduledTimerWithTimeInterval: MAXTIME_RESYNC
						
														target: self
						
													  selector: @selector(handleTimer:)
						
													  userInfo: nil
						
													   repeats: YES];
			 #endif
			//[self performSelectorOnMainThread : @ selector(LoadContactView: ) withObject:callviewP waitUntilDone:YES];
			break;
		case START_LOGIN:
				if(self->subID==1)//mean no connectivity
				{
					printf("\n start network request send");
					[self startCheckNetwork];
				}
				[dialviewP setStatusText: @"connecting..." :START_LOGIN :0 ];
			break;
		case ALERT_ONLINE://login
			
			#ifndef _LTP_
			[nsTimerP invalidate];
			
			nsTimerP = [NSTimer scheduledTimerWithTimeInterval: MAXTIME_RESYNC
						
														target: self
						
													  selector: @selector(handleTimer:)
						
													  userInfo: nil
						
													   repeats: YES];
			#endif
			#ifdef _LOG_DATA_
			//printf("\nonline");
			#endif
			self->onLineB = true;
			[dialviewP setStatusText: @"online" :ALERT_ONLINE :0 ];
			
			//[self performSelectorOnMainThread : @ selector(updateSpoknView: ) withObject:nil waitUntilDone:YES];
			[self updateSpoknView:0];
			//[self performSelectorOnMainThread : @ selector(popLoginView: ) withObject:nil waitUntilDone:YES];

			profileResync();
			cdrEmpty();
			cdrLoad();
			//[self performSelectorOnMainThread : @ selector(LoadContactView: ) withObject:callviewP waitUntilDone:YES];
			[self LoadContactView:callviewP];
			break;
		case ALERT_OFFLINE:
			
			self->onLineB = false;
			//logOut(ltpInterfacesP,false);
			//[self performSelectorOnMainThread : @ selector(updateSpoknView: ) withObject:nil waitUntilDone:YES];
			[self updateSpoknView:0];
				switch(self->subID)
				{
					case LOGIN_STATUS_OFFLINE:
						
							[dialviewP setStatusText: @"Offline" :ALERT_OFFLINE :self->subID ];
						break;
					case LOGIN_STATUS_FAILED:
							
							[dialviewP setStatusText: @"Authentication failed" :ALERT_OFFLINE :self->subID ];
						break;
					case LOGIN_STATUS_NO_ACCESS:
							[dialviewP setStatusText: @"no access" :ALERT_OFFLINE :self->subID ];
						printf("\n no access to network");
						break;
					default:
							[dialviewP setStatusText: @"Offline" :ALERT_OFFLINE :self->subID ];
				}
			
			break;
		case VMS_PLAY_KILL:
			//remove object from memory
			[self vmsDeinitRecordPlay:nil];			
			//[self performSelectorOnMainThread : @ selector(vmsDeinitRecordPlay: ) withObject:nil waitUntilDone:YES];
			break;
		case VMS_RECORD_KILL:	
			//vmsDeInit(&vmsP);
			
			////printf("\n delete record object");
			//[self performSelectorOnMainThread : @ selector(vmsDeinitRecordPlay: ) withObject:nil waitUntilDone:YES];
			[self vmsDeinitRecordPlay:nil];
			break;
		case PLAY_KILL:
			RemoveSoundThread(ltpInterfacesP,true);
			break;
		case RECORD_KILL:
			RemoveSoundThread(ltpInterfacesP,false);
			break;	
		case ALERT_INCOMING_CALL:
			//[self performSelectorOnMainThread : @ selector(LoadInCommingView: ) withObject:nil waitUntilDone:YES];
			[self LoadInCommingView:0];	
			//[ navigationNavigationController pushViewNavigationController: inCommingCallViewP animated: YES ];
			//[statusLabelP performSelectorOnMainThread : @ selector(setText: ) withObject:strP waitUntilDone:YES];
			break;
		case ALERT_NEWVMAIL:
	//put badge on vmail
		
		//	[self performSelectorOnMainThread : @ selector(newBadgeArrived: ) withObject:vmsNavigationController waitUntilDone:YES];
			[self newBadgeArrived:vmsNavigationController];	
			break;
			case UA_ALERT:
			switch(self->subID)
			{
				case REFRESH_CONTACT:
					[self LoadContactView:contactviewP];
					//[self performSelectorOnMainThread : @ selector(LoadContactView: ) withObject:contactviewP waitUntilDone:YES];
					//refresh cradit
					//balance = getBalance();
					[dialviewP setStatusText: nil :UA_ALERT :REFRESH_CONTACT ];
					[self updateSpoknView:0];
					//[self performSelectorOnMainThread : @ selector(updateSpoknView: ) withObject:nil waitUntilDone:YES];
					

					
					break;
				
				case REFRESH_VMAIL:
					
					//[self performSelectorOnMainThread : @ selector(LoadContactView: ) withObject:vmsviewP waitUntilDone:YES];
					[self LoadContactView:vmsviewP];
					break;
				
				case REFRESH_CALLLOG:
					//[self performSelectorOnMainThread : @ selector(LoadContactView: ) withObject:callviewP waitUntilDone:YES];
					[self LoadContactView:callviewP];
					break;
					
				
					
			}
			break;
		case LOAD_VIEW:
			switch(self->subID)
			{
				case LOAD_LOGIN_VIEW:
				{
					LoginViewController     *loginViewP;	
					loginViewP = [[LoginViewController alloc] initWithNibName:@"loginview" bundle:[NSBundle mainBundle]];
					loginViewP.ltpInterfacesP  = ltpInterfacesP;
					[loginViewP setObject:self];
					[tabBarController presentModalViewController:loginViewP animated:YES];
					//[ [self dialNavigationController] pushViewController:loginViewP animated: YES ];
					
					//NSLog(@"retainCount:%d", [addeditviewP retainCount]);
					if([loginViewP retainCount]>1)
						[loginViewP release];
					
					
					//[ navigationController pushViewController: loginViewP animated: YES ];
					
					
				}
				break;
					
			}		
			
	}
	
}
-(void)vmsDeinitRecordPlay:(id)object
{
	vmsDeInit(&vmsP);
	[VmsProtocolP VmsStop];
		
			
	
}
-(void)SendDTMF:(char*)dtmfP
{
		SendDTMF(ltpInterfacesP,0,dtmfP);
}

-(void)newBadgeArrived:(id)object
{
	
	NSString *stringStrP;
	UINavigationController *controllerP;
	controllerP = object;
	char s1[30];
	
	sprintf(s1,"%d",newVMailCount());
	stringStrP = [[NSString alloc] initWithUTF8String:s1 ];
	controllerP.tabBarItem.badgeValue= stringStrP;

	[stringStrP release];
	
	
	
	}
-(void)updateSpoknView:(id)object
{
	char *forwardCharP;
	int result=0;
	forwardCharP = getForwardNo(&result);
	if(wifiavailable)
	{	
		[spoknViewControllerP setDetails:getTitle() :self->onLineB :self->subID :getBalance() :forwardCharP :getDidNo() forwardOn:result ];
	}
	else
	{
		if(self->onLineB)
		{	
			[spoknViewControllerP setDetails:getTitle() :self->onLineB :NO_WIFI_AVAILABLE :getBalance() :forwardCharP :getDidNo() forwardOn:result ];
		}
		else
		{
			[spoknViewControllerP setDetails:getTitle() :self->onLineB :self->subID :getBalance() :forwardCharP :getDidNo() forwardOn:result ];
			
		}
	}
}
-(void)LoadContactView:(id)object
{
	[object reload];
}
-(void)LoadInCommingView:(id)object
{
	IncommingCallViewController     *inCommingCallViewP;	
	//printf("\nview added");
	inCommingCallViewP = [[IncommingCallViewController alloc] initWithNibName:@"incommingcall" bundle:[NSBundle mainBundle]];
	[inCommingCallViewP initVariable];
	inCommingCallViewP.ltpInterfacesP = ltpInterfacesP;
	[inCommingCallViewP setIncommingData:self->incommingCallList[self->lineID]];
	[inCommingCallViewP setObject:self];
	
	//[ dialNavigationController pushViewController: inCommingCallViewP animated: YES ];
	
		//NSLog(@"retainCount:%d", [addeditviewP retainCount]);
	[tabBarController presentModalViewController:inCommingCallViewP animated:YES];
	if([inCommingCallViewP retainCount]>1)
		[inCommingCallViewP release];
	

	//tabBarController.selectedViewController = dialNavigationController;
	
//	[ dialNavigationController pushViewController: inCommingCallViewP animated: YES ];
	[self changeView];
}
-(void) sendMessage:(id)object
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"ALERTNOTIFICATION" object:(id)object userInfo:nil];
}
void alertNotiFication(int type,unsigned int lineID,int valSubLong, unsigned long userData,void *otherinfoP)
{
	SpoknAppDelegate *spoknDelP;
	spoknDelP = (SpoknAppDelegate *)userData;
	[spoknDelP setLtpInfo:type :valSubLong :lineID :otherinfoP];
	[spoknDelP performSelectorOnMainThread : @ selector(sendMessage: ) withObject:spoknDelP waitUntilDone:YES];
	
	//NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	//[nc postNotificationName:@"ALERTNOTIFICATION" object:(id)spoknDelP userInfo:nil];

}
-(void) setLtpInfo:(int)ltpstatus :(int)subid :(int)llineID :(void*)dataVoidP
{
	self->status = ltpstatus;
	self->subID = subid;
	self->lineID = llineID;
	
	if(ltpstatus==ALERT_INCOMING_CALL)
	{
		self->incommingCallList[llineID] = dataVoidP;//this is ltp incomming call structure
	}
	
}
char * GetPathFunction(void *uData)
{
	NSString *nsP;
	char * returnCharP;
	const char *dataP;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	nsP = [paths objectAtIndex:0];
	dataP = [nsP cStringUsingEncoding:NSUTF8StringEncoding];
	returnCharP = malloc(strlen(dataP)+10);
	strcpy(returnCharP,dataP);
	
	
	
	return returnCharP;
}
void CreateDirectoryFunction(void *uData,char *pathCharP)
{
	NSFileManager *defaultManager;
    defaultManager = [NSFileManager defaultManager];
	//char *fullPathDir ;
	NSString *nsP;
	nsP = [[NSString alloc] initWithUTF8String:pathCharP];
    [defaultManager createDirectoryAtPath:nsP attributes:nil];
	//printf("\n %s\n",pathCharP);
	
	[nsP release];
}
- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
	//CGRect screenBounds = [ [ UIScreen mainScreen ] bounds ];
	
	//self.window = [ [ [ UIWindow alloc ] initWithFrame: screenBounds ] autorelease ];
	//viewController = [ [ spoknviewcontroller alloc ] init ];
	
	//[ window addSubview: viewController.view ];
	//[ window addSubview: viewController->usernameP ];
	//[ window addSubview: viewController->passwordP ];
	wifiavailable = NO;
	char *userNameCharP;
	char *passwordCharP;
	NSMutableArray *viewControllers;
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	dialviewP = [[DialviewController alloc] initWithNibName:@"dialview" bundle:[NSBundle mainBundle]];
	


	contactviewP = [[ContactViewController alloc] initWithNibName:@"contact" bundle:[NSBundle mainBundle]];
	vmsviewP = [[VmailViewController alloc] initWithNibName:@"vmailview" bundle:[NSBundle mainBundle]];
	callviewP = [[CalllogViewController alloc] initWithNibName:@"calllog" bundle:[NSBundle mainBundle]];
	
	

	
	spoknViewControllerP = [[SpoknViewController alloc] initWithNibName:@"spoknviewcontroller" bundle:[NSBundle mainBundle]];	
	vmsP = 0;
	//dialNavigationController = [ [ UINavigationController alloc ] initWithRootViewController: dialviewP ];
	contactNavigationController = [ [ UINavigationController alloc ] initWithRootViewController: contactviewP ];
	[contactviewP release];
	vmsNavigationController = [ [ UINavigationController alloc ] initWithRootViewController: vmsviewP ];
	[vmsviewP release];
	calllogNavigationController = [ [ UINavigationController alloc ] initWithRootViewController: callviewP ];
	[callviewP release];
	
	
	spoknViewNavigationController = [ [ UINavigationController alloc ] initWithRootViewController: spoknViewControllerP ];
	[spoknViewControllerP release];
	[spoknViewControllerP setObject:self];
	[dialviewP setObject:self];
	[contactviewP setObject:self];
	contactviewP.uaObject = GETCONTACTLIST;
	[contactviewP setObjType:GETCONTACTLIST];
	
	
	
	//vmsviewP.uaObject = GETVMAILLIST;
	[vmsviewP setObjType:GETVMAILLIST];

	[vmsviewP setObject:self];
	//callviewP.uaObject = GETCALLLOGLIST;
	[callviewP setObject:self];
	[callviewP setObjType:GETCALLLOGLIST];
	
	//now inin variable of incomming class
		

	
	#ifdef _TEST_MEMORY_
		testP = [[testingview alloc] initWithNibName:@"testingview" bundle:[NSBundle mainBundle]];
		testNavigationController = [ [ UINavigationController alloc ] initWithRootViewController: testP ];
		[testP release];				
	#endif
	
	viewControllers = [[NSMutableArray alloc] init];
	//[viewControllers addObject:loginViewP];
	[viewControllers addObject:contactNavigationController];
	[contactNavigationController release];
	
	[viewControllers addObject:calllogNavigationController];
	[calllogNavigationController release];


	[viewControllers addObject:dialviewP];
	[dialviewP release];
	
	[viewControllers addObject:vmsNavigationController];
	[vmsNavigationController release];
	
	[viewControllers addObject:spoknViewNavigationController];
	[spoknViewNavigationController release];
	
	#ifdef _TEST_MEMORY_
	[viewControllers addObject:testNavigationController];
	[testNavigationController release];

	#endif
	tabBarController = [ [ UITabBarController alloc ] init ];
	printf("\n tab retain count %d",[tabBarController retainCount]);
	tabBarController.viewControllers = viewControllers;
	[viewControllers release];
	
	printf("\n dialviewP retain count %d",[dialviewP retainCount]);

	printf("\n tab retain count %d",[tabBarController retainCount]);
	
	tabBarController.delegate = self; 	
	[window addSubview:tabBarController.view];
	printf("\n \n add tab retain count %d",[tabBarController retainCount]);
		ltpTimerP = nil;	
	#ifndef _OWN_THREAD_
		ltpTimerP = [[LtpTimer alloc] init];
	#endif	
	if(ltpTimerP)
	{	
		ltpInterfacesP =  ltpTimerP.ltpInterfacesP =  startLtp(alertNotiFication,(unsigned long)self);
	}
	else
	{
		ltpInterfacesP = startLtp(alertNotiFication,(unsigned long)self);
	}
	setLtpServer(ltpInterfacesP,"64.49.236.88");
	//setLtpServer(ltpInterfacesP,"64.49.244.225");

	//start ua 
	UACallBackType uaCallback = {0};
	uaCallback.uData = self;
	uaCallback.pathFunPtr = GetPathFunction;
	uaCallback.creatorDirectoryFunPtr = CreateDirectoryFunction;
	uaCallback.alertNotifyP = alertNotiFication;
	
	UACallBackInit(&uaCallback,ltpInterfacesP->ltpObjectP);
	uaInit();
	SetDeviceDetail("Spokn","2.0","Macos","3.0","iphone","1789023");
	//dialviewP.ltpTimerP  = ltpTimerP;
	
	dialviewP.ltpInterfacesP  = ltpInterfacesP;
	
	contactviewP.ltpInterfacesP = ltpInterfacesP;
	vmsviewP.ltpInterfacesP = ltpInterfacesP;
	//callviewP.ltpInterfacesP = ltpInterfacesP;
    [ window makeKeyAndVisible ];
	//tabBarController.selectedViewController = dialviewP;
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(alertAction:) name:@"ALERTNOTIFICATION" object:nil];
	//NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	//[nc postNotificationName:@"DEQUEUEAUDIO" object:idP userInfo:nil];
	cdrLoad();
	/*
	NSString *idValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"id_prefrence"];
	NSString *passValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"pass_prefrence"];
	char *idValueCharP;
	char *idPasswordCharP;
	idValueCharP =(char*) [idValue cStringUsingEncoding:1];
	idPasswordCharP = (char*)[passValue cStringUsingEncoding:1];
	
	userNameCharP = getLtpUserName(ltpInterfacesP);
	if(idValueCharP)
	{	
		if(strlen(userNameCharP)==0 || (strlen(idValueCharP)>0 && strcmp(userNameCharP,idValueCharP)!=0 ) )
		{
			printf("\n%s %s",idValueCharP,idPasswordCharP);
			setLtpUserName(ltpInterfacesP, idValueCharP);
			setLtpPassword(ltpInterfacesP, idPasswordCharP);
			
		}
	}	
	free(userNameCharP);
	[idValue release];
	[passValue release];*/
	//setLtpUserName(ltpInterfacesP, "");
	//setLtpPassword(ltpInterfacesP, "");
	//NSString *ltpValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"protocol_prefrence"];
	//[self startCheckNetwork];	
	
	if(DoLtpLogin(ltpInterfacesP))//mean error ask dial to load login view
	{
		alertNotiFication(LOAD_VIEW,0,LOAD_LOGIN_VIEW,(unsigned long)self,0);
	}
	
	//[self startCheckNetwork];	
	/*
	[self LoadContactView:contactviewP];
	[self LoadContactView:vmsviewP];
	[self LoadContactView:callviewP];
	*/	

	printf("\n tab retain count %d",[tabBarController retainCount]);
	printf("\n after %d %d",[callviewP retainCount],[dialviewP retainCount]	);
	//tabBarController.selectedViewController = vmsNavigationController;
	[vmsviewP.tabBarItem initWithTitle:@"VMS" image:[UIImage imageNamed:@"TB-VMS.png"] tag:4];
	tabBarController.selectedViewController = spoknViewNavigationController;
	

		
}
-(void)logOut
{
	logOut(ltpInterfacesP,true);
}
- (void)applicationWillTerminate:(UIApplication *)application
{
	#ifndef _LTP_
		[nsTimerP invalidate];
		nsTimerP = nil;
	#endif
	//[super applicationWillTerminate:application];
	[ltpTimerP stopTimer ];
	//logOut(ltpInterfacesP);
	logOut(ltpInterfacesP,false);
	endLtp(ltpInterfacesP);
	[self stopCheckNetwork];
	printf("\n  count %d tab %d",[dialviewP retainCount],[tabBarController retainCount]);
	[tabBarController release];
	
	//[contactNavigationController release];
	//[vmsNavigationController release];
	//[calllogNavigationController release];
	//[dialviewP release];
	
	
	
	

	

}
- (void)dealloc {
 //   [viewController release];
	
	//[navigationController.tabBarItem release];
		[window release];
	  [super dealloc];
}
-(IBAction)loginLtp:(id)sender
{
	 /*char *userNamecharP;
	 char *passwordcharP;
	
	//dataP = [pathP cStringUsingEncoding:1];
	userNamecharP = (char*)[[usernameFieldP text] cStringUsingEncoding:1];
	passwordcharP = (char*)[[passwordFieldP text] cStringUsingEncoding:1];
	if(userNamecharP && passwordcharP)
	{	
		setLtpUserName(userNamecharP);
		setLtpPassword(passwordcharP);
		DoLtpLogin();
		[ltpTimerP startTimer];
	}	
	
	*/
}
-(IBAction)cancelLtp:(id)sender
{
}
-(void)popLoginView
{
//	[dialNavigationController popToRootViewControllerAnimated:TRUE];
	[tabBarController dismissModalViewControllerAnimated:YES];
	[ spoknViewControllerP startProgress];//start animation
	//[self changeView];


}
-(void)changeView
{
	//[ navigationController pushViewController: dialviewP animated: YES ];
	//[navigationController setViewControllers: dialviewP animated: YES ];
	//tabBarController.selectedViewController = dialviewP;
//	tabBarController.selectedViewController = dialviewP;
	//tabBarController.selectedViewController = dialNavigationController;
}
//call by incomming method
-(void)AcceptCall:(IncommingCallType*) inComP
{
	
	self->incommingCallList[inComP->lineid] = 0;
	
	
	
	dialviewP.currentView = 1;//mean show hang button
	[tabBarController dismissModalViewControllerAnimated:NO];

	//[ dialNavigationController popToViewController: dialviewP animated: YES ];
	NSMutableString *tempStringP;
	NSString *strP;
	char typeP[30];
	struct AddressBook *addressP;
		
		tempStringP = [[NSMutableString alloc] init] ;
		addressP = getContactAndTypeCall(inComP->userIdChar,typeP);
		if(addressP)
		{
			strP = [[NSString alloc] initWithUTF8String:addressP->title] ;
			[tempStringP setString:strP];
			[strP release];
			strP = [[NSString alloc] initWithUTF8String:typeP] ;
			[tempStringP appendString:@"\n calling " ];
			[tempStringP appendString:strP];
			[strP release ];
		}
		else
		{
			strP = [[NSString alloc] initWithUTF8String:inComP->userIdChar] ;
			
			[tempStringP appendString:strP ];
			//[tempStringP setString:addressP->title];
			[tempStringP appendString:@"\n calling..." ];
			//[tempStringP appendString:strP];
			[strP release ];
			
		}
		//strP = [[NSString alloc] initWithUTF8String:noCharP] ;
		//[strP setString:@"Calling "];
		
		
		
		
		//	tempStringP = [NSMutableString stringWithString:@"calling "]	;
		
		
		
				//[]
		NSLog(@"\n%@",tempStringP);
	printf("\n calldsffdfd");
		[dialviewP setStatusText:tempStringP :TRYING_CALL :0];
		//[tempStringP release];
		[tempStringP release ];
		//	[strP release ];
		[[UIApplication sharedApplication] setProximitySensingEnabled:YES];
	AcceptInterface(ltpInterfacesP, inComP->lineid);
	free(inComP);
	//[self changeView];
	

}
-(void)RejectCall:(IncommingCallType *)inComP
{
	RejectInterface(ltpInterfacesP, inComP->lineid);
	self->incommingCallList[inComP->lineid] = 0;
	free(inComP);
	//[ dialNavigationController popToViewController: dialviewP animated: YES ];
	[tabBarController dismissModalViewControllerAnimated:YES];
	[self changeView];


}

-(Boolean)makeCall:(char *)noCharP
{
	NSMutableString *tempStringP;
	NSString *strP;
	Boolean retB = false;
	char typeP[30];
	struct AddressBook *addressP;
	
	if(!wifiavailable)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Status" 
														message:@"wifi not available"
													   delegate:self 
											  cancelButtonTitle:nil 
											  otherButtonTitles:@"OK", nil];
		[alert show];
		[alert release];
		return retB;
	}
	if(self->onLineB)
	{	
		tempStringP = [[NSMutableString alloc] init] ;
		addressP = getContactAndTypeCall(noCharP,typeP);
		if(addressP)
		{
			strP = [[NSString alloc] initWithUTF8String:addressP->title] ;
			[tempStringP setString:strP];
			[strP release];
			strP = [[NSString alloc] initWithUTF8String:typeP] ;
			[tempStringP appendString:@"\n calling " ];
			[tempStringP appendString:strP];
			[strP release ];
		}
		else
		{
			strP = [[NSString alloc] initWithUTF8String:noCharP] ;
			
			[tempStringP appendString:strP ];
			//[tempStringP setString:addressP->title];
			[tempStringP appendString:@"\n calling..." ];
			//[tempStringP appendString:strP];
			[strP release ];
			
		}
		//strP = [[NSString alloc] initWithUTF8String:noCharP] ;
		//[strP setString:@"Calling "];
	
		
		

		//	tempStringP = [NSMutableString stringWithString:@"calling "]	;
		
		
		
		retB = callLtpInterface(self->ltpInterfacesP,noCharP);
	//[]
		NSLog(@"\n%@",tempStringP);
		[dialviewP setStatusText:tempStringP :TRYING_CALL :0];
	//[tempStringP release];
		[tempStringP release ];
	//	[strP release ];
		[[UIApplication sharedApplication] setProximitySensingEnabled:YES];
	}	
	

	return retB;
		
	
}

-(Boolean)endCall:(int)lineid
{
	hangLtpInterface(self->ltpInterfacesP);
	[dialviewP setStatusText: @"call end" :ALERT_DISCONNECTED :0];
	//[tabBarController dismissModalViewControllerAnimated:YES];

	return true;
}

-(void)tabBarController:(UITabBarController*)tabBarController didSelectViewController:(UIViewController*)viewController
{
}
-(void)tabBarController:(UITabBarController*)tabBarController didEndCustomizingViewController:(NSArray*)viewcontrollers
				changed:(BOOL)changed
{
	
}
-(int) vmsPlayStart:(char *)fileName :(unsigned long*) sizeP
{
	unsigned long sz = 0; 
	if(vmsP)
	{
		return 2;
	}
	printf("\n");
	printf(fileName);
	vmsP = vmsInit((unsigned long )self, alertNotiFication,false);
	if(vmsP==0)
	{
		return 1;
	}
	

	if(vmsSetFilePlay(vmsP,fileName,&sz))
	{
		vmsDeInit(&vmsP);
		return 1;
	}
	*sizeP = sz;
	//printf("\nvms play");
	//[self VmsStreamStart: false];
	//[ vmsController pushViewController: vmsRPViewP animated: YES ];
	//tabBarController.selectedViewController = vmsController;
	//[vmsRPViewP vmsPlayStart:sz];
	//printf("\nvms start play");
	return 0;
}
-(void)setVmsDelegate :(id)deligateP
{
	VmsProtocolP = deligateP;
}
-(int)VmsStreamStart:(Boolean)recordB
{
	int er = 0;
	if(recordB==false)
	{	
		er = vmsStartPlay(vmsP);
	}
	else
	{
		er = vmsStartRecord(vmsP);
	}
	if(er)
	{
		[ vmsNavigationController popViewControllerAnimated:YES];
		vmsDeInit(&vmsP);
		return 1;
	}
	return 0;
}
-(int) vmsStop:(Boolean)recordB;
{
	if(recordB)
	{	
		return vmsStopRecord(vmsP);
	}
	else
	{
		return vmsStopPlay(vmsP);

	}
	return 0;
}
-(int)showContactScreen:(id) navObject returnnumber:(SelectedContctType *)lselectedContactP  result:(int *) resultP
{
	ContactViewController *contactP;
	contactP = [[ContactViewController alloc] initWithNibName:@"contact" bundle:[NSBundle mainBundle]];
	contactP.parentView = 1;
	[contactP setObject:self];
	contactP.uaObject = GETCONTACTLIST;
	[contactP setObjType:GETCONTACTLIST];
	contactP.ltpInterfacesP = ltpInterfacesP;
	[contactP setReturnVariable:navObject :lselectedContactP :resultP];
	[ [navObject navigationController] pushViewController:contactP animated: YES ];
	[contactP release];
	printf("\n retain countact details count %d\n",[contactviewP retainCount]);
	return 0;
}
-(int) vmsShowRecordScreen : (char*)noCharP
{
	struct AddressBook * addressP;
	char type[30];
	int max = 20;
	
	//printf("\n test122323232323");
	addressP = getContactAndTypeCall(noCharP,type);	
	if(addressP)
	{
		VmShowViewController     *vmShowViewControllerP;	
		printf("\n %s %s",type,noCharP);
		vmShowViewControllerP = [[VmShowViewController alloc] initWithNibName:@"vmshowviewcontroller" bundle:[NSBundle mainBundle]];
		//[ContactControllerDetailsviewP setAddressBook:addressP editable:false :CONTACTDETAILVIEWENUM];
		[vmShowViewControllerP setFileName: "temp" :0];
		[vmShowViewControllerP setvmsDetail: noCharP : addressP->title :type :VMSStateRecord :max :0];
		[vmShowViewControllerP setObject:self];
		[vmsNavigationController popToRootViewControllerAnimated:NO];
		UINavigationController *tmpCtl;
		tmpCtl = [[ [ UINavigationController alloc ] initWithRootViewController: vmShowViewControllerP ] autorelease];
		[tabBarController presentModalViewController:tmpCtl animated:YES];
		
		//[ vmsNavigationController pushViewController:vmShowViewControllerP animated: YES ];
		
		if([vmShowViewControllerP retainCount]>1)
			[vmShowViewControllerP release];
		
		
	}
	else
	{
		VmShowViewController     *vmShowViewControllerP;	
		vmShowViewControllerP = [[VmShowViewController alloc] initWithNibName:@"vmshowviewcontroller" bundle:[NSBundle mainBundle]];
		[vmShowViewControllerP setFileName: "temp" :0];
		//[ContactControllerDetailsviewP setAddressBook:addressP editable:false :CONTACTDETAILVIEWENUM];
		[vmShowViewControllerP setvmsDetail: noCharP : noCharP :"" :VMSStateRecord :max : 0];
		[vmShowViewControllerP setObject:self];
		[vmsNavigationController popToRootViewControllerAnimated:NO];
		//[ vmsNavigationController pushViewController:vmShowViewControllerP animated: YES ];
		UINavigationController *tmpCtl;
		tmpCtl = [[ [ UINavigationController alloc ] initWithRootViewController: vmShowViewControllerP ] autorelease];
		[tabBarController presentModalViewController:tmpCtl animated:YES];
		
		if([vmShowViewControllerP retainCount]>1)
			[vmShowViewControllerP release];
		printf("\n retain countact details count %d\n",[vmShowViewControllerP retainCount]);	
	}
	tabBarController.selectedViewController = vmsNavigationController;	
	
	return 0;
}
-(int) vmsRecordStart:(char*)fileNameP
{
	
	char *nameP=0;
	if(vmsP)
	{
		return 2;
	}
	vmsP = vmsInit((unsigned long )self, alertNotiFication,true);
	if(vmsP==0)
	{
		return 1;
	}
	if(fileNameP==0)
	{
		fileNameP="temp";
	}
	makeVmsFileName(fileNameP,&nameP);
	
	if(vmsSetFileRecord(vmsP, nameP))
	{
		vmsDeInit(&vmsP);
		if(nameP)
		free(nameP);
		return 1;
	}
	if(nameP)
	free(nameP);	
	return 0;
}
-(int) vmsForward:(char*)numberP :(char*)fileNameCharP
{
	return sendVms(numberP,fileNameCharP);
}
-(int) vmsSend:(char*)numberP :(char*)fileNameCharP
{
	int er = 0;
	char *nameP=0;
	if(fileNameCharP==0)
	{
		fileNameCharP="temp";
	}
	makeVmsFileName(fileNameCharP,&nameP);
	er =  sendVms(numberP,nameP);
	if(nameP)
		free(nameP);
	return er;
	
}
-(int)getFileSize:(char*)fileNameP :(unsigned long *)noSecP
{
	long sz;
	printf("\n");
	printf(fileNameP);
	FILE *fp;
	fp = fopen(fileNameP,"rb");
	if(fp)
	{
		
		*noSecP = 20;
		fseek(fp,0,SEEK_END);
		sz = ftell(fp);
		*noSecP = sz/(1650);
		fclose(fp);
		if(*noSecP==0)
		{	
			printf("\n file size %ld ",sz);
			return 1;
			
		}
	}	
	return 0;
		


}
#pragma mark RECHABILITY
-(void) startCheckNetwork
{
//static	struct sockaddr_in	addr;
	//addr.sin_addr.s_addr = inet_addr("0.0.0.123");
	//if (addr.sin_addr.s_addr == INADDR_NONE)
	//	return;
	//addr.sin_port = htons(80);	
//	addr.sin_family = AF_INET;
	
	
//	printf("\n host reach start");
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	[self stopCheckNetwork];
	printf("\n start Reachability");
	hostReach = [[Reachability reachabilityWithHostName: @"www.spokn.com"] retain];
	//hostReach = [[Reachability reachabilityWithAddress:&addr] retain];
	[hostReach startNotifer];
	//[self updateReachabilityStatus: hostReach];

	//wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
	//[wifiReach startNotifer];
}
-(void) stopCheckNetwork
{
	
	printf("\n host reach stop");
//	[hostReach stopNotifer];
	//[wifiReach stopNotifer];
	[hostReach release];
	[wifiReach release];
	
		
}
- (void)reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateReachabilityStatus: curReach];
}

- (void) configureTextField: (Reachability*) curReach
{
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired= [curReach connectionRequired];
    NSString* statusString= @"";
	printf("\n no network available\n\n");
    switch (netStatus)
    {
        case NotReachable:
        {
                 //Minor interface detail- connectionRequired may return yes, even when the host is unreachable.  We cover that up here...
         //   connectionRequired= NO;  
		/*	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Status" 
															message:@"connect via wifi"
														   delegate:self 
												  cancelButtonTitle:nil 
												  otherButtonTitles:@"OK", nil];
			[alert show];
			[alert release];*/
			SetConnection( ltpInterfacesP,0);
			printf("\n offline set");
			alertNotiFication(ALERT_OFFLINE,0,LOGIN_STATUS_NO_ACCESS,(long)self,0);
            break;
        }		
            
        case ReachableViaWWAN:
        {
            printf("\n richebility on trough ReachableViaWWAN");
			if(connectionRequired==NO)
			{	 
				printf("\n richable set via wwan");
				 wifiavailable = NO;
				alertNotiFication(ALERT_ONLINE,0,NO_WIFI_AVAILABLE,(long)self,0);
				//wifiavailable = YES;
				//SetConnection( ltpInterfacesP,2);
			}	 
			break;
        }
        case ReachableViaWiFi:
        {
			/*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Status" 
															message:@"connect via wifi"
														   delegate:self		
												  cancelButtonTitle:nil 
												  otherButtonTitles:@"OK", nil];
			[alert show];
			[alert release];*/
			 if(connectionRequired==NO)
			 {	 
				 printf("\n richable set");
				 wifiavailable = YES;
				 SetConnection( ltpInterfacesP,2);
			 }	 
			 break;
		}
    }
    if(connectionRequired)
    {
        statusString= [NSString stringWithFormat: @"%@, Connection Required %d", statusString,netStatus];
		SetConnection( ltpInterfacesP,0);
		printf("\n offline set");
		alertNotiFication(ALERT_OFFLINE,0,LOGIN_STATUS_NO_ACCESS,(long)self,0);
		wifiavailable = NO;
		 NSLog(statusString);
		
    }
   
	//textField.text= statusString;
}

- (void) updateReachabilityStatus: (Reachability*) curReach
{
	
	
	if(curReach == hostReach)
	{
		[self configureTextField:  curReach];
       		
    }
	
	
}

@end
