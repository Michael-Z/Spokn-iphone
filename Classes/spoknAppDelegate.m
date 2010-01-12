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
@synthesize ltpInterfacesP;
@synthesize callOnB;
@synthesize handSetB;
@synthesize loginProgressStart;
- (void) handleTimer: (id) timer
{
	
	//printf("\n resync called");
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
- (void) PlayRing: (id) timer
{
	//printf("\n ring play....");
	AudioServicesPlayAlertSound(soundIncommingCallID);	
}
-(void) destroyRing
{

	if(soundIncommingCallID)
	{
		AudioServicesDisposeSystemSoundID(soundIncommingCallID);
		soundIncommingCallID = 0;
	}
	if(endcallsoundID)
	{
		AudioServicesDisposeSystemSoundID(endcallsoundID);
		endcallsoundID = 0;
	}
	if(onlinesoundID)
	{
		AudioServicesDisposeSystemSoundID(onlinesoundID);
		onlinesoundID = 0;
	}
}
-(void) createRing
{
		soundIncommingCallID = 0;
	
	
	NSBundle *mainBundle = [NSBundle mainBundle];
	
	NSString *path = [mainBundle pathForResource:@"phone" ofType:@"caf"];
	if (!path)
		return;
	
	NSURL *aFileURL = [NSURL fileURLWithPath:path isDirectory:NO];
	if (aFileURL != nil)  
	{
		SystemSoundID aSoundID;
		OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef)aFileURL, 
														  &aSoundID);
		if (error != kAudioServicesNoError)
			return;
		soundIncommingCallID = aSoundID;
		//printf("\n ring created");

	
	}
	
	
	
}
-(void) startRing
{
	if(soundIncommingCallID)
	{	
		//printf("\n ring play");
		if(ringTimer==nil)
		{	
		
			UInt32 route = kAudioSessionOverrideAudioRoute_Speaker;
			AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, 
									 sizeof(route), &route);
			//SetAudioTypeLocal(0,0);
			ringTimer = [NSTimer scheduledTimerWithTimeInterval: 2.0
				
												target: self
				
											  selector: @selector(PlayRing:)
				
											  userInfo: nil
				
											   repeats: YES];
		}	
	}	
}
-(int) stopRing
{
	if(ringTimer)
	{	
		//printf("ring stop");
		[ringTimer invalidate];
		ringTimer = nil;
		UInt32 route = kAudioSessionOverrideAudioRoute_None;
		AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, 
								 sizeof(route), &route);
		return 0;
	}	
	return 1;
	
}

-(void) playcallendTone
{
	
	
	if(endcallsoundID==0)
	{	
		NSBundle *mainBundle = [NSBundle mainBundle];
	
		NSString *path = [mainBundle pathForResource:@"doorbell" ofType:@"caf"];
		if (!path)
			return;
	
		NSURL *aFileURL = [NSURL fileURLWithPath:path isDirectory:NO];
		if (aFileURL != nil)  
		{
			SystemSoundID aSoundID;
			OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef)aFileURL, 
														  &aSoundID);
			if (error != kAudioServicesNoError)
				return;
			endcallsoundID = aSoundID;
		
		}
	}

	AudioServicesPlaySystemSound(endcallsoundID);	
}

-(void) playonlineTone
{
		
	if(onlinesoundID==0)
	{	
		NSBundle *mainBundle = [NSBundle mainBundle];
	
		NSString *path = [mainBundle pathForResource:@"gling" ofType:@"caf"];
		if (!path)
			return;
	
		NSURL *aFileURL = [NSURL fileURLWithPath:path isDirectory:NO];
		if (aFileURL != nil)  
		{
			SystemSoundID aSoundID;
			OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef)aFileURL, 
															  &aSoundID);
			if (error != kAudioServicesNoError)
				return;
			onlinesoundID = aSoundID;
			
		}
	}	
	AudioServicesPlayAlertSound(onlinesoundID);	
}
-(void) showText:(NSString *)testStringP
{
	[dialviewP setStatusText:testStringP :0 :0];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==0)
	{
		if(urlSendP)
		{	
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlSendP]];
		}
		NSLog(@" url %@",urlSendP);
	}
	if(urlSendP)
	{
		[urlSendP release];
		urlSendP = nil;
	}
	
	
}
- (void) handleIntrrept: (id) timer
{
	OSStatus x;
	
	SetAudioTypeLocal(self,0);
	x = AudioSessionSetActive(true);
	if(x==0)
	{	
		
		setHoldInterface(self->ltpInterfacesP, 0);
		printf("\n handleCallTimerHang ");
		
	}
	[(NSTimer*)timer invalidate];
}

//@synthesize viewNavigationController;
-(void)alertAction:(NSNotification*)note
{
	switch(self->status)
	{
		case ALERT_ERROR:
		{
			switch(self->lineID)
			{
				case ERR_CODE_CALL_FWD_DUPLICATE:
				{
					char *callFdP;
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
															message:@"The number you provided for call forwarding has already been used by someone else.Please provide another number and try again."
															delegate:self 
														  cancelButtonTitle:nil 
														  otherButtonTitles:@"OK", nil];
					[alert show];
					[alert release];
					callFdP = getOldForwardNo();
					printf("oldfno = %s",callFdP);
					if(callFdP)
					{	
						if(strlen(callFdP)>0)
							SetOrReSetForwardNo(1,callFdP);
						else
							SetOrReSetForwardNo(0,callFdP);
					}
					else
					{
						SetOrReSetForwardNo(0,callFdP);
					}
					profileResync();
					[self updateSpoknView:0];
				}
					break;	
					
				case ERR_CODE_VMS_NO_CREDITS:
				{
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
																	message:@"Your VMS could not be sent because you do not have enough credit. Please recharge & try again."
																   delegate:self 
														  cancelButtonTitle:nil 
														  otherButtonTitles:@"OK", nil];
					[alert show];
					[alert release];
				}
					break;
			
			}
		}
			break;
		case ALERT_CONNECTED:
			[dialviewP setStatusText: @"ringing" :ALERT_CONNECTED :0];
			callOnB = true;
			printf("\n call connected %d",self->lineID);
			//openSoundInterface(ltpInterfacesP,1);
			[[UIApplication sharedApplication] setProximitySensingEnabled:YES];
			#ifndef _LTP_
				[nsTimerP invalidate];
				nsTimerP = nil;
			#endif
			break;	
		case ALERT_DISCONNECTED:
			callOnB = false;
			
			if(lineID == 0)
			{	
				[dialviewP setStatusText: @"end call" :ALERT_DISCONNECTED :0 ];
				//closeSoundInterface(ltpInterfacesP);
				SetSpeakerOnOrOff(0,true);
				[[UIApplication sharedApplication] setProximitySensingEnabled:NO];
				//reload log
				[self LoadContactView:callviewP];
				if([self stopRing]==0)//for incomming called not ans
				{
					printf("\n view dismiss");
					[tabBarController dismissModalViewControllerAnimated:NO];
				}
							
				#ifndef _LTP_
					[nsTimerP invalidate];
				
					nsTimerP = [NSTimer scheduledTimerWithTimeInterval: MAXTIME_RESYNC
							
															target: self
							
														  selector: @selector(handleTimer:)
							
														  userInfo: nil
							
														   repeats: YES];
				 #endif
			}	
			//[self performSelectorOnMainThread : @ selector(LoadContactView: ) withObject:callviewP waitUntilDone:YES];
			break;
		case START_LOGIN:
				if(self->subID==1)//mean no connectivity
				{
					//printf("\n start network request send");
					[self startCheckNetwork];
				}
				else
				{
					loginProgressStart = 1;
				
				}
				[dialviewP setStatusText: @"connecting..." :START_LOGIN :0 ];
			[loginProtocolP startloginIndicator];
			break;
		case ALERT_ONLINE://login
			
			loginProgressStart = 0;
			[vmsviewP setcomposeStatus:1 ];
			[loginProtocolP stoploginIndicator];
			
			
			#ifndef _LTP_
			[nsTimerP invalidate];
			
			nsTimerP = [NSTimer scheduledTimerWithTimeInterval: MAXTIME_RESYNC
						
														target: self
						
													  selector: @selector(handleTimer:)
						
													  userInfo: nil
						
													   repeats: YES];
			#endif
			#ifdef _LOG_DATA_
			////printf("\nonline");
			#endif
			if(self->onLineB == false)
			{
				[self playonlineTone];
				[self popLoginView];
				[self newBadgeArrived:vmsNavigationController];	
			}	
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
							[loginProtocolP stoploginIndicator];
							[loginProtocolP cleartextField];
							[dialviewP setStatusText: @"Authentication failed" :ALERT_OFFLINE :self->subID ];
						break;
					case LOGIN_STATUS_NO_ACCESS:
							loginProgressStart = 0;
							[loginProtocolP stoploginIndicator];
							[dialviewP setStatusText: @"no access" :ALERT_OFFLINE :self->subID ];
							//printf("\n no access to network");
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
			
			//////printf("\n delete record object");
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
			printf("\n called from incomming\n");
			[[UIApplication sharedApplication] setProximitySensingEnabled:YES];
			[VmsProtocolP	VmsStopRequest];
			if(lineID != 0)
			{	
				RejectInterface(self->ltpInterfacesP, lineID);
				self->incommingCallList[lineID] = 0;
			}
			else
			{
				[self LoadInCommingView:0];	
				
			}	
			//[ navigationNavigationController pushViewNavigationController: inCommingCallViewP animated: YES ];
			//[statusLabelP performSelectorOnMainThread : @ selector(setText: ) withObject:strP waitUntilDone:YES];
			break;
		case ALERT_NEWVMAIL:
	//put badge on vmail
		
		//	[self performSelectorOnMainThread : @ selector(newBadgeArrived: ) withObject:vmsNavigationController waitUntilDone:YES];
			[self newBadgeArrived:vmsNavigationController];	
			[self playonlineTone];
			break;
		
		case ALERT_SERVERMSG:
			if(!upgradeAlerted)
			{
				
							
				char* token, href[MAX_PATH], seps[2],msg[MAX_PATH];
							sprintf(seps,"%c\0",SEPARATOR);
				token = strtok(srvMsgCharP, seps);
				//if there's href and msg then show messagebox with OK & Cancel buttons
				if (srvMsgCharP[0]!=SEPARATOR && token)
				{
					UIAlertView *alert;
					NSString *msgStrP;
					strcpy(href, token);
					token = strtok(NULL, seps);
					strcpy(msg, token);
					msgStrP = [[NSString alloc] initWithUTF8String:msg];
					if(urlSendP)
					{
						[urlSendP release];
					}
					urlSendP = [[NSString alloc] initWithUTF8String:href];
					alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
														  message: [ NSString stringWithString:msgStrP ]
														 delegate: self
												cancelButtonTitle: nil
												otherButtonTitles: @"OK", nil
							 ];
					[alert addButtonWithTitle:@"cancel"];
					
					[ alert show ];
					[alert release];
					[msgStrP release];
				}  
				upgradeAlerted = 1;
			}
			//just show a message}
			break;
		case INTERRUPT_ALERT:
			switch(self->subID)
			{
				case 0:
					printf("\n hold off");
					SetAudioTypeLocal(self,0);
					AudioSessionSetActive(true);
					setHoldInterface(self->ltpInterfacesP, 0);
					
					break;
				case 1:
					printf("\n hold On");
					setHoldInterface(self->ltpInterfacesP, 1);
					[VmsProtocolP	VmsStopRequest];
					if(callOnB)
					{	
						[NSTimer scheduledTimerWithTimeInterval: 0.5
																  target: self
																selector: @selector(handleIntrrept:)
																userInfo: nil
																 repeats: YES];
					}
					//AudioSessionSetActive(true);
					//SetAudioTypeLocal(self,0);
					break;
			}
			break;
		case CALL_ALERT:
			switch(self->callNumber.direction)
			{
				case 1:
					callLtpInterface(self->ltpInterfacesP,self->callNumber.number);
					self->callNumber.direction = 0;
					break;
				case 2:
					break;
			}		
			//	retB = callLtpInterface(self->ltpInterfacesP,resultCharP);
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
					if(animation)
					{
						[tabBarController presentModalViewController:loginViewP animated:YES];
					}
					else
					{	
						[tabBarController presentModalViewController:loginViewP animated:NO];
					}
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
	printf("\n call form deinit");
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
	int count;
	count = newVMailCount();
	if(count)
	{	
		sprintf(s1,"%d",count);
		stringStrP = [[NSString alloc] initWithUTF8String:s1 ];
		controllerP.tabBarItem.badgeValue= stringStrP;

		[stringStrP release];
		
	}	
	
	
}
-(void)updateSpoknView:(id)object
{
	char *forwardCharP;
	int result=0;
	char *unameP;
	forwardCharP = getForwardNo(&result);
	//if(self->onLineB==false)//if user not online
	{
		 
		unameP = getLtpUserName(ltpInterfacesP);
		if(!unameP || strlen(unameP)==0 )
		{	
			[vmsviewP setcomposeStatus:0 ];
			self->subID  = LOGIN_STATUS_OFFLINE;
			if(unameP)
			{
				free(unameP);
				unameP = 0;
			}
		}	
		//printf("\nstatus %s",unameP);
		
		
	}
	if(wifiavailable)
	{	
		
		[spoknViewControllerP setDetails:getTitle() :self->onLineB :self->subID :getBalance() :forwardCharP :getDidNo() forwardOn:result spoknID:unameP];
	}
	else
	{
		if(self->onLineB)
		{	
			[spoknViewControllerP setDetails:getTitle() :self->onLineB :NO_WIFI_AVAILABLE :getBalance() :forwardCharP :getDidNo() forwardOn:result spoknID:unameP];
		}
		else
		{
			[spoknViewControllerP setDetails:getTitle() :self->onLineB :self->subID :getBalance() :forwardCharP :getDidNo() forwardOn:result spoknID:unameP];
			
		}
	}
	if(unameP)
	{
		free(unameP);
		unameP = 0;
	}
}
-(void)LoadContactView:(id)object
{
	[object reload];
}
-(void)LoadInCommingView:(id)object
{
	IncommingCallViewController     *inCommingCallViewP;	
	[tabBarController dismissModalViewControllerAnimated:NO];
	////printf("\nview added");
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
	
	[self startRing];
}
-(void) sendMessage:(id)object
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"ALERTNOTIFICATION" object:(id)object userInfo:nil];
}
void MyAudioSessionPropertyListener(
									void *                  inClientData,
									AudioSessionPropertyID	inID,
									UInt32                  inDataSize,
									const void *            inData)
{
	
	
	UInt32                              lioDataSize=0;
	//char *dataP;
	NSString *dataP=0;
	
	
	return;
	AudioSessionGetPropertySize(kAudioSessionProperty_AudioRoute,&lioDataSize);
	AudioSessionGetProperty(          kAudioSessionProperty_AudioRoute,
							&lioDataSize,
							&dataP);    
	NSLog(@"dada %@",dataP);
	if(dataP)
	{
		SpoknAppDelegate *spoknDelP;
		spoknDelP = (SpoknAppDelegate *)inClientData;

		NSRange range = [dataP rangeOfString:@"Headset"];
		if (range.location == NSNotFound ) 
		{	
						
			if(spoknDelP.handSetB)
			{	
				NSLog(@"dada %@",dataP);
				
				if(spoknDelP)
				{	
					if(spoknDelP.callOnB==0)
					{	
						SetSpeakerOnOrOff(0,1);
					}
				}
				spoknDelP.handSetB = false;

			}	
			
		}
		else
		{
			spoknDelP.handSetB = true;
		}
	}
	//printf("\n prop %d %d %s",(int)inID,(int )lioDataSize,dataP);
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
	if(ltpstatus==ALERT_SERVERMSG)
	{
		if(srvMsgCharP)
		{	
			free(srvMsgCharP);
		}
		srvMsgCharP = malloc(strlen((char*)dataVoidP)+4);
		strcpy(srvMsgCharP,(char*)dataVoidP);
		
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
	printf("\n %s\n",pathCharP);
	
	[nsP release];
}

#pragma mark STARTING POINT
- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
	//CGRect screenBounds = [ [ UIScreen mainScreen ] bounds ];
	
	//self.window = [ [ [ UIWindow alloc ] initWithFrame: screenBounds ] autorelease ];
	//viewController = [ [ spoknviewcontroller alloc ] init ];
	
	//[ window addSubview: viewController.view ];
	//[ window addSubview: viewController->usernameP ];
	//[ window addSubview: viewController->passwordP ];
	prvCtlP = 0;	
	wifiavailable = NO;
	urlSendP = nil;
	//char *userNameCharP;
	//char *passwordCharP;
	animation = 1;
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
	//printf("\n tab retain count %d",[tabBarController retainCount]);
	tabBarController.viewControllers = viewControllers;
	[viewControllers release];
	
	//printf("\n dialviewP retain count %d",[dialviewP retainCount]);

	//printf("\n tab retain count %d",[tabBarController retainCount]);
	
	tabBarController.delegate = self; 	
	[window addSubview:tabBarController.view];
	//printf("\n \n add tab retain count %d",[tabBarController retainCount]);
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
#ifdef _LTP_
	setLtpServer(ltpInterfacesP,"64.49.236.88");
#else
	setLtpServer(ltpInterfacesP,"www.spokn.com");
#endif	
	
	//setLtpServer(ltpInterfacesP,"64.49.244.225");

	//start ua 
	UACallBackType uaCallback = {0};
	uaCallback.uData = self;
	uaCallback.pathFunPtr = GetPathFunction;
	uaCallback.creatorDirectoryFunPtr = CreateDirectoryFunction;
	uaCallback.alertNotifyP = alertNotiFication;
	
	UACallBackInit(&uaCallback,ltpInterfacesP->ltpObjectP);
	uaInit();
	UIDevice *device = [UIDevice currentDevice];
	NSString *uniqueIdentifier = [device uniqueIdentifier];
	NSString *versionP;
	versionP = [[UIDevice currentDevice] systemVersion] ;
	//float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	NSString *model = [[UIDevice currentDevice] model];
	char *osVerP;
	char *osModelP;
	char *uniqueIDCharP;
	osVerP = (char*)[versionP cStringUsingEncoding:NSUTF8StringEncoding];
	osModelP = (char*)[model cStringUsingEncoding:NSUTF8StringEncoding];
	uniqueIDCharP = (char*)[uniqueIdentifier cStringUsingEncoding:NSUTF8StringEncoding];
		//SetDeviceDetail("spokn","1.0.12","windows desktop",osVerP,osModelP,uniqueIDCharP);
//	SetDeviceDetail("spokn","1.0.3","Windows mobile",osVerP,osModelP,uniqueIDCharP);
	SetDeviceDetail("Spokn","0.0.1","iphone",osVerP,osModelP,uniqueIDCharP);
	
//	[versionP release];
	//[model release];
	//[uniqueIdentifier release];
	//[device release];
	
	
	//;
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
			//printf("\n%s %s",idValueCharP,idPasswordCharP);
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
		animation = 0;
		alertNotiFication(LOAD_VIEW,0,LOAD_LOGIN_VIEW,(unsigned long)self,0);
	}
	
	//[self startCheckNetwork];	
	/*
	[self LoadContactView:contactviewP];
	[self LoadContactView:vmsviewP];
	[self LoadContactView:callviewP];
	*/	

	//printf("\n tab retain count %d",[tabBarController retainCount]);
	//printf("\n after %d %d",[callviewP retainCount],[dialviewP retainCount]	);
	//tabBarController.selectedViewController = vmsNavigationController;
	
	tabBarController.selectedViewController = spoknViewNavigationController;
	[vmsNavigationController.tabBarItem initWithTitle:@"VMS" image:[UIImage imageNamed:@"TB-VMS.png"] tag:4];
	[self createRing];
	SetSpeakerOnOrOff(0,true);
	[vmsviewP setcomposeStatus:1 ];
	SetAudioSessionPropertyListener(self,MyAudioSessionPropertyListener);
	[self newBadgeArrived:vmsNavigationController];	
	
		
}
/*
#pragma mark PUSH NOTIFICATIONS
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	NSLog(@"devToken=%@", deviceToken);
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"APNS", @"") message:[NSString stringWithFormat:@"%@", deviceToken] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil] autorelease];
		[alert show];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {     
    NSLog(@"Error in registration. Error: %@", err);
	//	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Device Token", @"") message:[NSString stringWithFormat:@"%@", err] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil] autorelease];
	//	[alert show];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"APNS" message:[NSString stringWithFormat:@"%@", launchOptions] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil] autorelease];
	[alert show];
	[self applicationDidFinishLaunching:application];
	return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"APNS" message:[NSString stringWithFormat:@"%@", userInfo] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil] autorelease];
	[alert show];
}
*/


-(void)logOut:(Boolean) clearAllB
{
	animation = 1;
	//popup all tab
	if(clearAllB)
	{
		[vmsNavigationController popToRootViewControllerAnimated:NO];
		[calllogNavigationController popToRootViewControllerAnimated:NO];
		[contactNavigationController popToRootViewControllerAnimated:NO];
		[spoknViewNavigationController popToRootViewControllerAnimated:NO];
	}
	[vmsviewP setcomposeStatus:0 ];
	logOut(ltpInterfacesP,clearAllB);
	self.vmsNavigationController.tabBarItem.badgeValue= nil;
	SetSpeakerOnOrOff(0,true);
	self->onLineB = false;
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
	//printf("\n  count %d tab %d",[dialviewP retainCount],[tabBarController retainCount]);
	[tabBarController release];
	[self destroyRing];
	if(srvMsgCharP)
	{	
		free(srvMsgCharP);
		srvMsgCharP = 0;
	}
	[urlSendP release];
	SetSpeakerOnOrOff(0,true);
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
	//[vmsviewP setcomposeStatus:0 ];
	loginProtocolP = nil;
	//[self changeView];


}
-(void)cancelLoginView
{
	[tabBarController dismissModalViewControllerAnimated:YES];
	//printf("\n pridfd fdfd df");
	[self updateSpoknView:0];
	[ spoknViewControllerP cancelProgress];
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
	[self stopRing];
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
			[tempStringP appendString:@"\n" ];
			[tempStringP appendString:strP];
			[strP release ];
		}
		else
		{
			strP = [[NSString alloc] initWithUTF8String:inComP->userIdChar] ;
			
			[tempStringP appendString:strP ];
			//[tempStringP setString:addressP->title];
			[tempStringP appendString:@"\nUnknown" ];
			
			//[tempStringP appendString:strP];
			[strP release ];
			
		}
		//strP = [[NSString alloc] initWithUTF8String:noCharP] ;
		//[strP setString:@"Calling "];
		
		
		
		
		//	tempStringP = [NSMutableString stringWithString:@"calling "]	;
		
		
		
				//[]
		NSLog(@"\n%@",tempStringP);
	//printf("\n calldsffdfd");
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
	[self stopRing];
	RejectInterface(ltpInterfacesP, inComP->lineid);
	self->incommingCallList[inComP->lineid] = 0;
	free(inComP);
	//[ dialNavigationController popToViewController: dialviewP animated: YES ];
	[tabBarController dismissModalViewControllerAnimated:YES];
	[self changeView];


}
-(char*) getNameAndTypeFromNumber:(char*)pnumberP :(char*)typeP :(Boolean*)pfindBP 
{
	struct AddressBook *addressP;
	char *nameP=0;
	char *returnCharP=0;
	Boolean findB=false;
	addressP = getContactAndTypeCall(pnumberP,typeP);
	if(addressP)
	{
		nameP = addressP->title;
		if(nameP)
		{	
			while(*nameP==' '){
				nameP++;
			}
			if(*nameP!='\0')
			{
				nameP = addressP->title;
				findB = true;
			}
			else
			{
				nameP = pnumberP;
			}
			
		}	
		returnCharP = malloc(strlen(nameP)+10);
		strcpy(returnCharP,nameP);
	}
	else
	{
		int uID;
		char *addressBookNameP = 0;
		char *addressBookTypeP = 0;
		uID = getAddressUid(self->ltpInterfacesP);
		if(uID)
		{
			[ContactViewController	getNameAndType:uID :pnumberP :&addressBookNameP :&addressBookTypeP];
			if(addressBookNameP)
			{	
				nameP = addressBookNameP;
				if(nameP)
				{	
					while(*nameP==' '){
						nameP++;
					}
					if(*nameP!='\0')
					{
						nameP = addressBookNameP;
						findB = true;
					}
					else
					{
						nameP = pnumberP;
					}
					
				}	
				returnCharP = malloc(strlen(nameP)+10);
				strcpy(returnCharP,nameP);
				
				if(addressBookTypeP)
				{	
					strcpy(typeP,addressBookTypeP);
				}
				else
				{
					strcpy(typeP,"Unknown");
				}
				free(addressBookNameP);
				if(addressBookTypeP)
				{	
					free(addressBookTypeP);
				}	
				
			}
			
		}
		else
		{
			returnCharP = malloc(strlen(pnumberP)+10);
			strcpy(returnCharP,pnumberP);

			strcpy(typeP,"Unknown");
		
		}
		
	
	
	
	}
	if(pfindBP)
	{
		*pfindBP = findB;
	}
	return returnCharP;
		
}
//text1 = [labelStringP stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" ()<>-./"]];
-(Boolean)makeCall:(char *)noCharP
{
	NSMutableString *tempStringP;
	NSString *strP;
	char *nameP;
	Boolean retB = false;
	char typeP[30];
	char *resultCharP;
	struct AddressBook *addressP;
	resultCharP = NormalizeNumber(noCharP,0);
	printf("\n no = %s",resultCharP);
	if(validateNo(resultCharP))//mean invalid number
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:@"Invalid number"
													   delegate:self 
											  cancelButtonTitle:nil 
											  otherButtonTitles:@"OK", nil];
		[alert show];
		[alert release];
		if(resultCharP)
		free(resultCharP);
		return retB;
		
	}
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
		
		UInt32 mic, size;
		
		// Verify if microphone is available (perhaps we should verify in another place ?)
		size = sizeof(UInt32);
		AudioSessionGetProperty(kAudioSessionProperty_AudioInputAvailable,
								&size, &mic);
		if (!mic)
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Spokn"
															message:@"No Microphone Available"
														   delegate:nil 
												  cancelButtonTitle:@"Ok"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			return retB;
		}
		
		
		tempStringP = [[NSMutableString alloc] init] ;
		
		nameP = [self getNameAndTypeFromNumber:resultCharP :typeP :0];
		strP = [[NSString alloc] initWithUTF8String:nameP] ;
		[tempStringP setString:strP];
		[strP release];
		strP = [[NSString alloc] initWithUTF8String:typeP] ;
		[tempStringP appendString:@"\ncalling " ];
		//[tempStringP appendString:@"\n calling " ];
		[tempStringP appendString:strP];
		[strP release ];
		free(nameP);
				
		callOnB =true;
		strcpy(self->callNumber.number,resultCharP);
		self->callNumber.direction = 1;
		retB = 1;
	//	retB = callLtpInterface(self->ltpInterfacesP,resultCharP);
		NSLog(@"\n%@",tempStringP);
		[dialviewP setStatusText:tempStringP :TRYING_CALL :0];
			[tempStringP release ];
	
		[[UIApplication sharedApplication] setProximitySensingEnabled:YES];
	}	
	else
	{
		if(self->loginProgressStart)
		{	
			UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"" 
															   message: [ NSString stringWithString:@"User not online" ]
															  delegate: nil
													 cancelButtonTitle: nil
													 otherButtonTitles: @"OK", nil
								  ];
			[ alert show ];
			[alert release];
		}
		else
		{
			UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"" 
															   message: [ NSString stringWithString:@"No Network" ]
															  delegate: nil
													 cancelButtonTitle: nil
													 otherButtonTitles: @"OK", nil
								  ];
			[ alert show ];
			[alert release];
			
		}
		
	
	
	
	
	}
	free(resultCharP);
	return retB;
		
	
}

-(Boolean)endCall:(int)lineid
{
	callOnB =false;
	printf("\n hang");
	hangLtpInterface(self->ltpInterfacesP);
	[dialviewP setStatusText: @"call end" :ALERT_DISCONNECTED :0];
	SetSpeakerOnOrOff(0,true);
	[[UIApplication sharedApplication] setProximitySensingEnabled:NO];

	//[tabBarController dismissModalViewControllerAnimated:YES];

	return true;
}

-(void)tabBarController:(UITabBarController*)tabBarController didSelectViewController:(UIViewController*)viewController
{
	
	if(prvCtlP)
	{
		if([prvCtlP isKindOfClass:[UINavigationController class]])
		{
			[(UINavigationController*)prvCtlP popToRootViewControllerAnimated:NO];
			if(prvCtlP==vmsNavigationController)
			{	
				[VmsProtocolP	VmsStopRequest];
			}	
		}
		//printf("\n dele called");
		
	}
	prvCtlP = viewController;
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
	//printf("\n");
	//printf(fileName);
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
	////printf("\nvms play");
	//[self VmsStreamStart: false];
	//[ vmsController pushViewController: vmsRPViewP animated: YES ];
	//tabBarController.selectedViewController = vmsController;
	//[vmsRPViewP vmsPlayStart:sz];
	////printf("\nvms start play");
	return 0;
}
-(void)setLoginDelegate :(id)deligateP
{
	loginProtocolP = deligateP;
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
	//printf("\n retain countact details count %d\n",[contactviewP retainCount]);
	return 0;
}
-(int) vmsShowRecordScreen : (char*)noCharP
{
	//struct AddressBook * addressP;
	char type[30];
	int max = 20;
	char *nameP;
	Boolean findB= false;
	[VmsProtocolP	VmsStopRequest];
	////printf("\n test122323232323");
	nameP = [self getNameAndTypeFromNumber:noCharP :type :&findB];
	
	VmShowViewController     *vmShowViewControllerP;	
	//printf("\n %s %s",type,noCharP);
	//	
	vmShowViewControllerP = [[VmShowViewController alloc] initWithNibName:@"vmshowviewcontroller" bundle:[NSBundle mainBundle]];
	//[ContactControllerDetailsviewP setAddressBook:addressP editable:false :CONTACTDETAILVIEWENUM];
	[vmShowViewControllerP setFileName: "temp" :0];
	if(findB==true)
	{	
		[vmShowViewControllerP setvmsDetail: noCharP : nameP :type :VMSStateRecord :max :0];
	}
	else
	{
		[vmShowViewControllerP setvmsDetail: noCharP : noCharP :"" :VMSStateRecord :max : 0];
		
	}
	[vmShowViewControllerP setObject:self];
	[vmsNavigationController popToRootViewControllerAnimated:NO];
	UINavigationController *tmpCtl;
	tmpCtl = [[ [ UINavigationController alloc ] initWithRootViewController: vmShowViewControllerP ] autorelease];
	[tabBarController presentModalViewController:tmpCtl animated:YES];
	
	//[ vmsNavigationController pushViewController:vmShowViewControllerP animated: YES ];
	
	if([vmShowViewControllerP retainCount]>1)
		[vmShowViewControllerP release];
	free(nameP);
	
	/*addressP = getContactAndTypeCall(noCharP,type);	
	if(addressP)
	{
		VmShowViewController     *vmShowViewControllerP;	
		//printf("\n %s %s",type,noCharP);
		//	
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
		//printf("\n retain countact details count %d\n",[vmShowViewControllerP retainCount]);	
	}
	 */
	//tabBarController.selectedViewController = vmsNavigationController;	
	
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
	//printf("\n");
	//printf(fileNameP);
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
			//printf("\n file size %ld ",sz);
			return 1;
			
		}
	}	
	return 0;
		


}

-(void)refreshallViews
{
	[vmsviewP doRefresh];
	[callviewP doRefresh];
	[contactviewP doRefresh];
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
	
	
//	//printf("\n host reach start");
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	[self stopCheckNetwork];
	//printf("\n start Reachability");
	hostReach = [[Reachability reachabilityWithHostName: @"www.spokn.com"] retain];
	//hostReach = [[Reachability reachabilityWithAddress:&addr] retain];
	[hostReach startNotifer];
	//[self updateReachabilityStatus: hostReach];

	//wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
	//[wifiReach startNotifer];
}
-(void) stopCheckNetwork
{
	
	//printf("\n host reach stop");
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
	//printf("\n no network available\n\n");
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
			//printf("\n offline set");
			alertNotiFication(ALERT_OFFLINE,0,LOGIN_STATUS_NO_ACCESS,(long)self,0);
		//	[vmsviewP setcomposeStatus:0 ];
            break;
        }		
            
        case ReachableViaWWAN:
        {
            //printf("\n richebility on trough ReachableViaWWAN");
			if(connectionRequired==NO)
			{	 
				//printf("\n richable set via wwan");
				 wifiavailable = NO;
				alertNotiFication(ALERT_ONLINE,0,NO_WIFI_AVAILABLE,(long)self,0);
				//[vmsviewP setcomposeStatus:1 ];
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
				 //printf("\n richable set");
				 wifiavailable = YES;
				 if(SetConnection( ltpInterfacesP,2)==0)
				 {	 
					 [spoknViewControllerP startProgress];
				//	 [vmsviewP setcomposeStatus:1 ];
				 }	 
			 }	 
			 break;
		}
    }
    if(connectionRequired)
    {
        statusString= [NSString stringWithFormat: @"%@, Connection Required %d", statusString,netStatus];
		SetConnection( ltpInterfacesP,0);
		//printf("\n offline set");
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
