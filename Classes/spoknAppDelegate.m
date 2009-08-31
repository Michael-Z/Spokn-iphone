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
#import "VmsRecordPlayViewController.h"

#import "CalllogViewController.h"
#import "vmailviewcontroller.h"
//#import "NSFileManager.h"
@implementation SpoknAppDelegate

@synthesize window;
@synthesize dialviewP;

@synthesize contactviewP;

@synthesize vmsviewP;
@synthesize callviewP;
@synthesize vmsRPViewP;

@synthesize dialNavigationController;
@synthesize vmsNavigationController;
@synthesize calllogNavigationController;
@synthesize contactNavigationController;
@synthesize onLineB;
@synthesize tabBarController;

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
			openSoundInterface(ltpInterfacesP,1);
			[[UIApplication sharedApplication] setProximitySensingEnabled:YES];
			break;	
		case ALERT_DISCONNECTED:
			[dialviewP setStatusText: @"end call" :ALERT_DISCONNECTED :0 ];

			closeSoundInterface(ltpInterfacesP);
			
			[[UIApplication sharedApplication] setProximitySensingEnabled:NO];
			//reload log
			[self performSelectorOnMainThread : @ selector(LoadContactView: ) withObject:callviewP waitUntilDone:YES];
			break;
		case START_LOGIN:
				[dialviewP setStatusText: @"connecting..." :START_LOGIN :0 ];
			break;
		case ALERT_ONLINE://login
			#ifdef _LOG_DATA_
			//printf("\nonline");
			#endif
			self->onLineB = true;
				[dialviewP setStatusText: @"online" :ALERT_ONLINE :0 ];
			//[self performSelectorOnMainThread : @ selector(popLoginView: ) withObject:nil waitUntilDone:YES];

			profileResync();
			cdrLoad();
			[self performSelectorOnMainThread : @ selector(LoadContactView: ) withObject:callviewP waitUntilDone:YES];
			break;
		case ALERT_OFFLINE:
			self->onLineB = false;
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
						break;
					default:
							[dialviewP setStatusText: @"Offline" :ALERT_OFFLINE :self->subID ];
				}
			
			break;
		case VMS_PLAY_KILL:
			//remove object from memory
						
			[self performSelectorOnMainThread : @ selector(vmsDeinitRecordPlay: ) withObject:nil waitUntilDone:YES];
			break;
		case VMS_RECORD_KILL:	
			vmsDeInit(&vmsP);
			
			////printf("\n delete record object");
			[self performSelectorOnMainThread : @ selector(vmsDeinitRecordPlay: ) withObject:nil waitUntilDone:YES];
			
			break;
		case PLAY_KILL:
			RemoveSoundThread(ltpInterfacesP,true);
			break;
		case RECORD_KILL:
			RemoveSoundThread(ltpInterfacesP,false);
			break;	
		case ALERT_INCOMING_CALL:
			[self performSelectorOnMainThread : @ selector(LoadInCommingView: ) withObject:nil waitUntilDone:YES];

			//[ navigationNavigationController pushViewNavigationController: inCommingCallViewP animated: YES ];
			//[statusLabelP performSelectorOnMainThread : @ selector(setText: ) withObject:strP waitUntilDone:YES];
			break;
		case ALERT_NEWVMAIL:
	//put badge on vmail
		
			[self performSelectorOnMainThread : @ selector(newBadgeArrived: ) withObject:vmsNavigationController waitUntilDone:YES];
			
			break;
			case UA_ALERT:
			switch(self->subID)
			{
				case REFRESH_CONTACT:
					[self performSelectorOnMainThread : @ selector(LoadContactView: ) withObject:contactviewP waitUntilDone:YES];
					//refresh cradit
					[dialviewP setStatusText: nil :UA_ALERT :REFRESH_CONTACT ];
					break;
				
				case REFRESH_VMAIL:
					
					[self performSelectorOnMainThread : @ selector(LoadContactView: ) withObject:vmsviewP waitUntilDone:YES];
					break;
				
				case REFRESH_CALLLOG:
					[self performSelectorOnMainThread : @ selector(LoadContactView: ) withObject:callviewP waitUntilDone:YES];
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
					[ [self dialNavigationController] pushViewController:loginViewP animated: YES ];
					
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
	Boolean recordB = true;
	if(vmsP)
	{	
		recordB = vmsP->recordB ;	
	}
	vmsDeInit(&vmsP);
	
	//UINavigationController *tmp;
	if(recordB)
	{	
		recordB = [vmsRPViewP vmsUIStop];
		if(recordB==false)
		{	
			//[ vmsController popToViewController: vmsviewP animated: YES ];
			[ vmsNavigationController popViewControllerAnimated: YES ];
			
		}
	}
	else
	{
		[vmsviewP stopvmsPlay];
	}
	
			
	//tmp = tabBarController.selectedViewController;
	//tabBarController.selectedViewController = navigationController;	
	//tabBarController.selectedViewController = tmp;
	//tabBarController.selectedViewController = navigationController;

}
-(void)popLoginView:(id)object
{
	[ dialNavigationController popViewControllerAnimated:YES ];
	//[self changeView];
}
-(void)newBadgeArrived:(id)object
{
	UINavigationController *controllerP;
	controllerP = object;
	controllerP.tabBarItem.badgeValue= @"";
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
	
	[ dialNavigationController pushViewController: inCommingCallViewP animated: YES ];
	
	
	//NSLog(@"retainCount:%d", [addeditviewP retainCount]);
	if([inCommingCallViewP retainCount]>1)
		[inCommingCallViewP release];
	
	
//	[ dialNavigationController pushViewController: inCommingCallViewP animated: YES ];
	[self changeView];
}

void alertNotiFication(int type,unsigned int lineID,int valSubLong, unsigned long userData,void *otherinfoP)
{
	SpoknAppDelegate *spoknDelP;
	spoknDelP = (SpoknAppDelegate *)userData;
	[spoknDelP setLtpInfo:type :valSubLong :lineID :otherinfoP];
	
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"ALERTNOTIFICATION" object:(id)spoknDelP userInfo:nil];

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
	dataP = [nsP cStringUsingEncoding:1];
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
	
	
	vmsP = 0;
	dialNavigationController = [ [ UINavigationController alloc ] initWithRootViewController: dialviewP ];
	contactNavigationController = [ [ UINavigationController alloc ] initWithRootViewController: contactviewP ];
	vmsNavigationController = [ [ UINavigationController alloc ] initWithRootViewController: vmsviewP ];
	calllogNavigationController = [ [ UINavigationController alloc ] initWithRootViewController: callviewP ];

	
	[dialviewP setObject:self];
	[contactviewP setObject:self];
	contactviewP.uaObject = GETCONTACTLIST;
	[contactviewP setObjType:GETCONTACTLIST];

	
	
	//vmsviewP.uaObject = GETVMAILLIST;
	[vmsviewP setObjType:GETVMAILLIST];

	[vmsviewP setObject:self];
	[vmsRPViewP setObject:self];
	//callviewP.uaObject = GETCALLLOGLIST;
	[callviewP setObject:self];
	[callviewP setObjType:GETCALLLOGLIST];
	
	//now inin variable of incomming class
		

	
	
	
	viewControllers = [[NSMutableArray alloc] init];
	//[viewControllers addObject:loginViewP];
	[viewControllers addObject:dialNavigationController];
	[viewControllers addObject:calllogNavigationController];
	[viewControllers addObject:contactNavigationController];
	[viewControllers addObject:vmsNavigationController];
	
	tabBarController = [ [ UITabBarController alloc ] init ];
	tabBarController.viewControllers = viewControllers;
	
	//[window addSubview:navigationController.view];
	dialNavigationController.tabBarItem = [UITabBarItem alloc];
	[dialNavigationController.tabBarItem initWithTitle:@"Dial" image:nil tag:1];
	contactNavigationController.tabBarItem = [UITabBarItem alloc];
	[contactNavigationController.tabBarItem initWithTitle:@"Contact" image:nil tag:3];
	
	vmsNavigationController.tabBarItem = [UITabBarItem alloc];
	[vmsNavigationController.tabBarItem initWithTitle:@"Vms" image:nil tag:4];
	
	
	calllogNavigationController.tabBarItem = [UITabBarItem alloc];
	[calllogNavigationController.tabBarItem initWithTitle:@"Calllog" image:nil tag:4];

	[window addSubview:tabBarController.view];
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
	tabBarController.selectedViewController = vmsNavigationController;
	tabBarController.selectedViewController = contactNavigationController;
	tabBarController.selectedViewController = calllogNavigationController;
	tabBarController.selectedViewController = dialNavigationController;

	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(alertAction:) name:@"ALERTNOTIFICATION" object:nil];
	//NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	//[nc postNotificationName:@"DEQUEUEAUDIO" object:idP userInfo:nil];
	cdrLoad();
	if(DoLtpLogin(ltpInterfacesP))//mean error ask dial to load login view
	{
		alertNotiFication(LOAD_VIEW,0,LOAD_LOGIN_VIEW,(unsigned long)self,0);
	}
	/*
	[self LoadContactView:contactviewP];
	[self LoadContactView:vmsviewP];
	[self LoadContactView:callviewP];
	*/	
	
		
}


- (void)dealloc {
 //   [viewController release];
	[ltpTimerP stopTimer ];
	//[navigationController.tabBarItem release];
	
	endLtp(ltpInterfacesP);
	ltpInterfacesP = 0;
	[ltpTimerP release ];
	
	[dialviewP release];
	[contactviewP release];

	
	[tabBarController release];
	[viewControllers release];
	[dialNavigationController.tabBarItem release];
	[contactNavigationController.tabBarItem release];
	[contactNavigationController release];
		
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
	[dialNavigationController popToRootViewControllerAnimated:TRUE];

}
-(void)changeView
{
	//[ navigationController pushViewController: dialviewP animated: YES ];
	//[navigationController setViewControllers: dialviewP animated: YES ];
	//tabBarController.selectedViewController = dialviewP;
	
	tabBarController.selectedViewController = dialNavigationController;
}
//call by incomming method
-(void)AcceptCall:(IncommingCallType*) inComP
{
	AcceptInterface(ltpInterfacesP, inComP->lineid);
	self->incommingCallList[inComP->lineid] = 0;
	free(inComP);
	dialviewP.currentView = 1;//mean show hang button
	[ dialNavigationController popToViewController: dialviewP animated: YES ];
	

}
-(void)RejectCall:(IncommingCallType *)inComP
{
	RejectInterface(ltpInterfacesP, inComP->lineid);
	self->incommingCallList[inComP->lineid] = 0;
	free(inComP);
	[ dialNavigationController popToViewController: dialviewP animated: YES ];


}

-(Boolean)makeCall:(char *)noCharP
{
	NSMutableString *tempStringP;
	NSString *strP;
	Boolean retB = false;
	if(self->onLineB)
	{	
		strP = [[NSString alloc] initWithUTF8String:noCharP] ;
		//[strP setString:@"Calling "];
	
		tempStringP = [[NSMutableString alloc] init] ;
		[tempStringP setString:@"Calling "];

		//	tempStringP = [NSMutableString stringWithString:@"calling "]	;
		[tempStringP appendString:strP ];
		
		
		retB = callLtpInterface(self->ltpInterfacesP,noCharP);
	//[]
		[dialviewP setStatusText:tempStringP :TRYING_CALL :0];
	//[tempStringP release];
		[tempStringP release ];
		[strP release ];
		[[UIApplication sharedApplication] setProximitySensingEnabled:YES];
	}	
	

	return retB;
		
	
}

-(Boolean)endCall:(int)lineid
{
	hangLtpInterface(self->ltpInterfacesP);
	[dialviewP setStatusText: @"call end" :0 :0];
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
	[self VmsStreamStart: false];
	//[ vmsController pushViewController: vmsRPViewP animated: YES ];
	//tabBarController.selectedViewController = vmsController;
	//[vmsRPViewP vmsPlayStart:sz];
	//printf("\nvms start play");
	return 0;
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
-(int) vmsRecordStart:(char*)noCharP
{
	
	char nameP[200];
	if(vmsP)
	{
		return 2;
	}
	vmsP = vmsInit((unsigned long )self, alertNotiFication,true);
	if(vmsP==0)
	{
		return 1;
	}
	makeVmsFileName("temp",nameP);
	
	if(vmsSetFileRecord(vmsP, nameP))
	{
		vmsDeInit(&vmsP);
		return 1;
	}
	else
	{
		[ vmsNavigationController pushViewController: vmsRPViewP animated: YES ];
		tabBarController.selectedViewController = vmsNavigationController;
		[vmsRPViewP vmsRecordStart:20 :noCharP];
	}
	
	return 0;
}
-(int) vmsSend:(char*)numberP
{
	char nameP[200];
	makeVmsFileName("temp",nameP);
	return sendVms(numberP,nameP);
	
}
@end
