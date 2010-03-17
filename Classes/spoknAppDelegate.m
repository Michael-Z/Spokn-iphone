
//  Created by on 26/06/09.

/**
  Copyright 2009, 2010 Geodesic Limited. <http://www.geodesic.com/>
 
 Spokn for iPhone and iPod Touch.
 
 This file is part of Spokn for iPhone.
 
 Spokn for iPhone is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 Spokn for iPhone is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Spokn for iPhone.  If not, see <http://www.gnu.org/licenses/>.
 */

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
#include "alertmessages.h"
#import "contactlookup.h"
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
@synthesize addressRef;
@synthesize vmsNavigationController;
@synthesize calllogNavigationController;
@synthesize contactNavigationController;
@synthesize onLineB;
@synthesize tabBarController;
@synthesize ltpInterfacesP;
@synthesize callOnB;
@synthesize handSetB;
@synthesize loginProgressStart;
@synthesize blueTooth;
- (void) handleTimer: (id) timer
{
	
	if(self.onLineB)
	{	
		profileResync();
	}	
	
}
-(int) profileResynFromApp
{
	if(self.onLineB)
	{	
		profileResync();
		return 0;
	}	
	return 1;
}
-(void) enableEdge
{
	NSString *toogleValue;
	toogleValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"key_prefrence"];
	if(toogleValue)
	{	
		self->edgevalue = ![toogleValue intValue];//this value are reverse
	}
	else
	{
		self->edgevalue = 1;
	}
}
+(BOOL) emailValidate : (NSString *)emailid
{
	NSString *localPart;
	NSString *domainPart;
	NSString *secondlevelDomain;
	NSString *toplevelDomain;

	if([emailid rangeOfString:@"@"].location==NSNotFound || [emailid rangeOfString:@"."].location==NSNotFound)
		return NO;

	localPart=[emailid substringToIndex: [emailid rangeOfString:@"@"].location];
	domainPart=[emailid substringFromIndex:[emailid rangeOfString:@"@"].location+1];
	
	if(!(localPart.length>=1 && localPart.length<=64)) 
		return NO;
	if([domainPart rangeOfString:@"."].location==NSNotFound)
	{
		return NO;
	}
	secondlevelDomain=[domainPart substringToIndex:[domainPart rangeOfString:@"."].location];
	if(secondlevelDomain.length==0)
		return NO;
	toplevelDomain=[domainPart substringFromIndex:[domainPart rangeOfString:@"."].location+1];
	
	if(!(toplevelDomain.length>=2 )) 
		return NO;
	
	if([localPart isEqualToString:@""] || [localPart rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@" ~!@#$^&*()={}[]|;’:\"<>,?/`"]].location!=NSNotFound 
	 || [secondlevelDomain isEqualToString:@""] || [secondlevelDomain rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@" ~!@#$%^&*()={}[]|;’:\"<>,+?/`"]].location!=NSNotFound
	 || [toplevelDomain isEqualToString:@""]  || [toplevelDomain rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"1234567890 `~!@*$#^&%()={}[]:\";’<>,?/"]].location!=NSNotFound)
		
		return NO;
	
	return YES;
}

-(void) destroyRing
{
	[SpoknAudio destorySoundUrl:&incommingSoundP];
	[SpoknAudio destorySoundUrl:&allSoundP];
	[SpoknAudio destorySoundUrl:&onLineSoundP];
	[SpoknAudio destorySoundUrl:&endSoundP];
	
}
-(void) createRing
{
	NSBundle *mainBundle = [NSBundle mainBundle];
	[SpoknAudio destorySoundUrl:&incommingSoundP];
	[SpoknAudio destorySoundUrl:&onLineSoundP];
	[SpoknAudio destorySoundUrl:&endSoundP];
	
	NSString *path = [mainBundle pathForResource:_TONE_PHONE_ ofType:_TONE_FILE_TYPE_];
	if (path)
	{
		incommingSoundP = [[SpoknAudio alloc] init];
		#ifdef _PLAY_SYSTEM_SOUND_
		{
			CFURLRef soundFileURLRef;
			CFBundleRef mainBundleRef = CFBundleGetMainBundle ();
			soundFileURLRef  =	CFBundleCopyResourceURL (mainBundleRef,CFSTR( _TONE_PHONE_C_),
													 CFSTR(_TONE_FILE_TYPE_C_), NULL);
			if(soundFileURLRef)
			{	
				[incommingSoundP setUrlToPlayFromSystemSound:soundFileURLRef];
				CFRelease(soundFileURLRef);
			}	
		}	
		#else
			[incommingSoundP setUrlToPlay:path];
		#endif
		//incommingSoundP = [SpoknAudio createSoundPlaybackUrl:path play:false];
		[incommingSoundP setvolume:1.0];
	}
	path = [mainBundle pathForResource:_TONE_ONLINE_ ofType:_TONE_FILE_TYPE_];
	if (path)
			onLineSoundP = [SpoknAudio createSoundPlaybackUrl:path play:false];
	path = [mainBundle pathForResource:_TONE_CALL_END_ ofType:_TONE_FILE_TYPE_];
	if (path)
		endSoundP = [SpoknAudio createSoundPlaybackUrl:path play:false];

	
		//[incommingP repeatPlay:-1];
	
	
}
- (void) PlayRing: (id) timer
{
	
	[incommingSoundP playSoundUrl];
	AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}
-(void) startRing
{
	
			if(ringStartB==0)
		{	
		
			
			
						
			ringTimer = [NSTimer scheduledTimerWithTimeInterval: 2.0
						
														target: self
						
													  selector: @selector(PlayRing:)
						
													  userInfo: nil
						
													   repeats: YES];
		
			
		//	[incommingP playSoundUrl];
			ringStartB = 1;
			SetAudioTypeLocal(0,1);
		//	[path release];
		}	
		
}
-(int) stopRing
{
	if(ringStartB)
	{	
		ringStartB = 0;
		[ringTimer invalidate];
		ringTimer = nil;
		[incommingSoundP stopSoundUrl];
		SetAudioTypeLocal(0,3);
		return 0;
	}	
	return 1;
	
}

-(void) playcallendTone
{
#ifdef DTMF_TONE
	[endSoundP playSoundUrl];
	
#else
	[UIApplication sharedApplication] .statusBarStyle = UIStatusBarStyleDefault;
	//[self setStatusBarStyle:UIStatusBarStyleDefault animation:NO];
	NSBundle *mainBundle = [NSBundle mainBundle];
	
		NSString *path = [mainBundle pathForResource:_TONE_CALL_END_ ofType:_TONE_FILE_TYPE_];
		if (!path)
			return;
	[self playUrlPath:path]	;
	//[path release];
		
#endif	

		
}
-(int)playUrlPath:(NSString*)pathP
{
	[SpoknAudio destorySoundUrl:&allSoundP];
	allSoundP = [SpoknAudio createSoundPlaybackUrl:pathP play:true];
	if(allSoundP)
		return 0;
	return 1;

}
-(void) playonlineTone
{
	
		
	#ifdef DTMF_TONE
	[onLineSoundP playSoundUrl];
	#else
	
		NSBundle *mainBundle = [NSBundle mainBundle];
	
		NSString *path = [mainBundle pathForResource:_TONE_ONLINE_ ofType:_TONE_FILE_TYPE_];
		if (!path)
			return;
		[self playUrlPath:path]	;
	#endif	
	//[path release];	
}
-(void) showText:(NSString *)testStringP
{
	[dialviewP setStatusText:testStringP :nil :0 :0];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if(buttonIndex==0)
	{
		if(urlSendP)
		{	
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlSendP]];
		}
		
	}
	if(buttonIndex==1)
	{
		[spoknViewControllerP buyCredit:nil];
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
	
	SetAudioTypeLocal(0,0);
	x = AudioSessionSetActive(true);
	if(x==0)
	{	
		
		setHoldInterface(self->ltpInterfacesP, 0);
		
	}
	[(NSTimer*)timer invalidate];
}
/*
void setProp()
{
	UInt32 flag = 0;
	int er = 0;
	//UInt32 sndSz= sizeof(UInt32);
	UInt32 aSoundID=1;
	
	er =  AudioServicesSetProperty(kAudioServicesPropertyIsUISound,
	 sizeof(UInt32),
	 &aSoundID,
	 sizeof(UInt32),
	 &flag);
	
er = 	AudioServicesSetProperty(kAudioServicesPropertyCompletePlaybackIfAppDies,
							 sizeof(UInt32),
							 &aSoundID,
							 sizeof(UInt32),
							 &flag);
	

}
void getProp()
{
	UInt32 flag = 0;
	UInt32 sndSz= sizeof(UInt32);
	UInt32 aSoundID=0;
		AudioServicesGetProperty(  kAudioServicesPropertyIsUISound,
							 sizeof(UInt32),
							 &aSoundID,
							 &sndSz,
							 &flag); 
	printf("\n %ld %ld %ld",aSoundID,sndSz,flag);
	AudioServicesGetProperty(  kAudioServicesPropertyCompletePlaybackIfAppDies,
							 sizeof(UInt32),
							 &aSoundID,
							 &sndSz,
							 &flag); 
	printf("\n %ld %ld %ld",aSoundID,sndSz,flag);
	
	
}

*/
//@synthesize viewNavigationController;
-(void)alertAction:(NSNotification*)note
{
	switch(self->status)
	{
		
		case ATTEMPT_GPRS_LOGIN:
			profileResync();
			//resync called
			loginGprsB = true;
			break;
			
		case ALERT_HOSTNOTFOUND:
			if(loginGprsB)//this is for login via gprs
			{
				[loginProtocolP stoploginIndicator];
				[loginProtocolP cleartextField];
				//if(loginProtocolP)
				{	
					[dialviewP setStatusText: @"Authentication failed" :nil :ALERT_OFFLINE :HOST_NAME_NOT_FOUND_ERROR ];
				}
				loginGprsB = false;
				
			}
			break;
			
			break;
		case ALERT_ERROR:
		{
			switch(self->lineID)
			{
				case ERR_CODE_CALL_FWD_DUPLICATE:
				{
					char *callFdP;
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_DUPLICATE_FORWARD_NUMBER_ 
															message:_DUPLICATE_FORWARD_NUMBER_MESSAGE_
															delegate:self 
														  cancelButtonTitle:nil 
														  otherButtonTitles:_OK_, nil];
					[alert show];
					[alert release];
					callFdP = getOldForwardNo();
					
					if(callFdP)
					{	
						if(strlen(callFdP)>0)
							SetOrReSetForwardNo(1,callFdP);
						else
							SetOrReSetForwardNo(2,callFdP);
					}
					else
					{
						SetOrReSetForwardNo(2,callFdP);
					}
					profileResync();
					[self updateSpoknView:0];
				}
					break;	
					
				case ERR_CODE_VMS_NO_CREDITS:
				{
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_NO_CREDITS_ 
																	message:_NO_CREDITS_MESSAGE_
																   delegate:self 
														  cancelButtonTitle:_CANCEL_ 
														  otherButtonTitles:_OK_, nil];
					[alert show];
					[alert release];
				}
				break;
				case 401:
					if(loginGprsB)//this is for login via gprs
					{
						[loginProtocolP stoploginIndicator];
						[loginProtocolP cleartextField];
						[dialviewP setStatusText: @"Authentication failed" :nil :ALERT_OFFLINE :LOGIN_STATUS_FAILED ];
						loginGprsB = false;
						
					}
					break;
			
			}
		}
			break;
		case ALERT_CONNECTED:
			[dialviewP setStatusText: @"ringing" :nil :ALERT_CONNECTED :0];
			callOnB = true;
			//getProp();
			//openSoundInterface(ltpInterfacesP,1);
		#ifdef __IPHONE_3_0
					[UIDevice currentDevice].proximityMonitoringEnabled = YES;
		#else
					[[UIApplication sharedApplication] setProximitySensingEnabled:YES];
		#endif
			
			
			#ifndef _LTP_
				[nsTimerP invalidate];
				nsTimerP = nil;
			#endif
			break;	
		case ALERT_DISCONNECTED:
			callOnB = false;
			
			if(lineID == 0)
			{	
				[dialviewP setStatusText: @"end call" :nil :ALERT_DISCONNECTED :0 ];
				//closeSoundInterface(ltpInterfacesP);
				SetAudioTypeLocal(0,3);
				SetSpeakerOnOrOff(0,true);
				#ifdef __IPHONE_3_0
								[UIDevice currentDevice].proximityMonitoringEnabled = NO;
				#else
								[[UIApplication sharedApplication] setProximitySensingEnabled:NO];
				#endif
				
				//reload log
				[self LoadContactView:callviewP];
				[callviewP doRefresh];
				if([self stopRing]==0)//for incomming called not ans
				{
					
					[tabBarController dismissModalViewControllerAnimated:NO];
				}
				if(self->subID)
				{
					[callviewP missCallSetCount];
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
					
					[self startCheckNetwork];
				}
				else
				{
					loginProgressStart = 1;
				
				}
			[dialviewP setStatusText:_STATUS_CONNECTING_ :nil :START_LOGIN :0 ];
			[loginProtocolP startloginIndicator];
			[spoknViewControllerP startProgress];
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
			
			#endif
			if(self->onLineB == false)
			{
				[self playonlineTone];
				[self popLoginView];
				[self newBadgeArrived:vmsNavigationController];	
				//tabBarController.selectedViewController = dialviewP;
			}
			else
			{
				[ spoknViewControllerP cancelProgress];
			}
			self->onLineB = true;
			[dialviewP setStatusText:_STATUS_ONLINE_ :nil :ALERT_ONLINE :0 ];
			
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
			[ spoknViewControllerP cancelProgress];
			self->onLineB = false;
			//logOut(ltpInterfacesP,false);
			//[self performSelectorOnMainThread : @ selector(updateSpoknView: ) withObject:nil waitUntilDone:YES];
			[self updateSpoknView:0];
				switch(self->subID)
				{
					case LOGIN_STATUS_OFFLINE:
						[loginProtocolP stoploginIndicator];
						if(loginProtocolP)//mean login screen is on
						{
							[dialviewP setStatusText: _STATUS_OFFLINE_ :nil :ALERT_OFFLINE :self->subID ];
						}
						break;
					case LOGIN_STATUS_FAILED:
							[loginProtocolP stoploginIndicator];
							[loginProtocolP cleartextField];
							[dialviewP setStatusText: _STATUS_AUTHENTICATION_FAILED_ :nil :ALERT_OFFLINE :self->subID ];
								
							break;
					case LOGIN_STATUS_NO_ACCESS:
							loginProgressStart = 0;
							[loginProtocolP stoploginIndicator];
							if(loginProtocolP)//mean login screen is on
							{
								[dialviewP setStatusText: _STATUS_NO_ACCESS_ :nil :ALERT_OFFLINE :self->subID ];
							}	
							break;
					case LOGIN_STATUS_TIMEDOUT:
						[loginProtocolP stoploginIndicator];
						[dialviewP setStatusText: _STATUS_TIMEOUT2_ :nil :ALERT_OFFLINE :self->subID ];
						break;
					default:
						[loginProtocolP stoploginIndicator];
						if(loginProtocolP)//mean login screen is on
						{
							[dialviewP setStatusText: _STATUS_OFFLINE_ :nil :ALERT_OFFLINE :self->subID ];
						}
				}
			
			break;
		case VMS_PLAY_KILL:
			//remove object from memory
			[self vmsDeinitRecordPlay:nil];			
			//[self performSelectorOnMainThread : @ selector(vmsDeinitRecordPlay: ) withObject:nil waitUntilDone:YES];
			break;
		case VMS_RECORD_KILL:	
			//vmsDeInit(&vmsP);
			
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
			#ifdef __IPHONE_3_0
						[UIDevice currentDevice].proximityMonitoringEnabled = YES;
			#else
						[[UIApplication sharedApplication] setProximitySensingEnabled:YES];
			#endif
			[VmsProtocolP	VmsStopRequest];
			if(lineID != 0)
			{	
				
				
				RejectInterface(self->ltpInterfacesP, lineID);
				self->incommingCallList[lineID] = 0;
			}
			else
			{
				SetAudioTypeLocal(0,1);
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
		
	/*	case ALERT_SERVERMSG:
			if(!upgradeAlerted)
			{
				
							
				char* token, href[MAX_PATH], seps[2],msg[MAX_PATH];
							sprintf(seps,"%c\0",SEPARATOR);
				token = strstr(srvMsgCharP, seps);
				//if there's href and msg then show messagebox with OK & Cancel buttons
				if (srvMsgCharP[0]!=SEPARATOR && token)
				{
					UIAlertView *alert;
					NSString *msgStrP;
					
					*token = 0;
					strcpy(href, srvMsgCharP);
					*token = SEPARATOR;
					token++;
					
					if(token)
					{	
						
						strcpy(msg, token);
						
						msgStrP = [[NSString alloc] initWithUTF8String:msg];
						if(urlSendP)
						{
							[urlSendP release];
						}
						urlSendP = [[NSString alloc] initWithUTF8String:href];
						alert = [ [ UIAlertView alloc ] initWithTitle: _UPGRADE_AVAILABLE_ 
															  message: [ NSString stringWithString:msgStrP ]
															 delegate: self
													cancelButtonTitle: nil
													otherButtonTitles: _OK_, nil
								 ];
						[alert addButtonWithTitle:_CANCEL_];
						
						[ alert show ];
						[alert release];
						[msgStrP release];
					}	
				}  
				upgradeAlerted = 1;
			}
			//just show a message}
			break;*/
		case INTERRUPT_ALERT:
			switch(self->subID)
			{
				case 0:
					SetAudioTypeLocal(0,0);
					AudioSessionSetActive(true);
					setHoldInterface(self->ltpInterfacesP, 0);
					
					break;
				case 1:
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
			if(self->subID==1)
			{
				self->callNumber.direction = 0;
				break;
			}
			switch(self->callNumber.direction)
			{
				case 1:
					callLtpInterface(self->ltpInterfacesP,self->callNumber.number);
					self->callNumber.direction = 0;
					break;
				case 2:
					AcceptInterface(ltpInterfacesP, self->callNumber.lineId);
					self->callNumber.direction = 0;
					
					break;
			}		
			//	retB = callLtpInterface(self->ltpInterfacesP,resultCharP);
			break;
		case UA_ALERT:
			if(loginGprsB)
			{	
				loginProgressStart = 0;
				[vmsviewP setcomposeStatus:1 ];
				[loginProtocolP stoploginIndicator];
				self->onLineB = true;
				[dialviewP setStatusText: _STATUS_ONLINE_ :nil :ALERT_ONLINE :0 ];
				[self playonlineTone];
				[self popLoginView];
				[self newBadgeArrived:vmsNavigationController];	
				
				loginGprsB = false;
				
			}
			switch(self->subID)
		{
			case STOP_ANIMATION:
				[vmsviewP cancelProgress];
				[self updateSpoknView:0];
				//[spoknViewControllerP cancelProgress];
				break;
			case REFRESH_ALL:
				[ spoknViewControllerP cancelProgress];
				[self LoadContactView:contactviewP];
				[vmsviewP cancelProgress];
				[self LoadContactView:vmsviewP];
				[self newBadgeArrived:vmsNavigationController];	
				[self updateSpoknView:0];

				
				
				break;
				case REFRESH_CONTACT:
					[ spoknViewControllerP cancelProgress];
					[self LoadContactView:contactviewP];
					//[self performSelectorOnMainThread : @ selector(LoadContactView: ) withObject:contactviewP waitUntilDone:YES];
					//refresh cradit
					//balance = getBalance();
				[dialviewP setStatusText: nil :nil :UA_ALERT :REFRESH_CONTACT ];
					[self updateSpoknView:0];
					//[self performSelectorOnMainThread : @ selector(updateSpoknView: ) withObject:nil waitUntilDone:YES];
					

					
					break;
				
				case REFRESH_VMAIL:
					[vmsviewP cancelProgress];
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
					
					if(loginProtocolP)
					{
						break;//already in login view
					}
					[nsTimerP invalidate];
					nsTimerP = nil;
					
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
	int count;
	count = newVMailCount();
	if(count)
	{	
		sprintf(s1,"%d",count);
		stringStrP = [[NSString alloc] initWithUTF8String:s1 ];
		controllerP.tabBarItem.badgeValue= stringStrP;

		[stringStrP release];
		[vmsviewP doRefresh];
		
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
	inCommingCallViewP = [[IncommingCallViewController alloc] initWithNibName:@"incommingcall" bundle:[NSBundle mainBundle]];
	[inCommingCallViewP initVariable];
	inCommingCallViewP.ltpInterfacesP = ltpInterfacesP;
	[inCommingCallViewP setIncommingData:self->incommingCallList[self->lineID]];
	[inCommingCallViewP setObject:self];
	
	//[ dialNavigationController pushViewController: inCommingCallViewP animated: YES ];
	
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
	//[nc postNotificationName:@"ALERTNOTIFICATION" object:(id)object userInfo:nil];
	[object alertAction:nil];
}
int blueToothIsOn()
{
	UInt32                              lioDataSize=0;
	//char *dataP;
	NSString *dataP=0;
	
	
	
	AudioSessionGetPropertySize(kAudioSessionProperty_AudioRoute,&lioDataSize);
	AudioSessionGetProperty(          kAudioSessionProperty_AudioRoute,
							&lioDataSize,
							&dataP);    
	if(dataP)
	{
		
		NSString *capStrP;
		capStrP = [dataP uppercaseString];
	//	NSLog(@"connect %@",capStrP);
		
		NSRange range = [capStrP rangeOfString:@"BT"];
		if (range.location == NSNotFound ) 
		{	
			return 0;
			
		}
		else
		{
			return 1;
		}
	}
	
	return 0;

}
int HeadSetIsOn()
{
	UInt32                              lioDataSize=0;
	//char *dataP;
	NSString *dataP=0;
	
	
	
	AudioSessionGetPropertySize(kAudioSessionProperty_AudioRoute,&lioDataSize);
	AudioSessionGetProperty(          kAudioSessionProperty_AudioRoute,
							&lioDataSize,
							&dataP);    
	if(dataP)
	{
		
		NSString *capStrP;
		capStrP = [dataP uppercaseString];
		//NSLog(@"connect %@",capStrP);
		
		if(capStrP==nil)
		{	
			return 0;
		}
		NSRange range = [capStrP rangeOfString:@"HEADSET"];
		if (range.location == NSNotFound ) 
		{	
			return 0;
						
		}
	//	NSLog(@"connect %@",capStrP);
		return 1;
	}
	return 0;
	

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
	if(dataP)
	{
		SpoknAppDelegate *spoknDelP;
		spoknDelP = (SpoknAppDelegate *)inClientData;

		NSRange range = [dataP rangeOfString:@"Headset"];
		if (range.location == NSNotFound ) 
		{	
						
			if(spoknDelP)
			{	
				if(spoknDelP.handSetB)
				{	
					
					if(spoknDelP)
					{	
						if(spoknDelP.callOnB==0)
						{	
							SetSpeakerOnOrOffNew(0,1);
						}
					}
					spoknDelP.handSetB = false;

				}	
			}
			else
			{
				SetSpeakerOnOrOffNew(0,1);
			}
			
		}
		else
		{
			if(spoknDelP)
			{	
				spoknDelP.handSetB = true;
			}	
		}
	}
	
}


void * ThreadForContactLookup(void *udata)
{
	SpoknAppDelegate *spoknDelP;
	NSAutoreleasePool *autoreleasePool = [[ NSAutoreleasePool alloc ] init];
	spoknDelP = (SpoknAppDelegate *)udata;
	
	[spoknDelP makeIndexingFromAddressBook];
	
	[autoreleasePool release];
	return 0;
}
int GetOsVersion(int *majorP,int *minor1P,int *minor2P)
{
	
	NSString *versionP;
	NSArray *nsP;
	NSString *verP;
	
	versionP = [[UIDevice currentDevice] systemVersion] ;
	if(versionP==nil) 
		return 1;
	
	nsP = [versionP componentsSeparatedByString :@"."] ;
	if(nsP)
	{
		for(int i=0;i<nsP.count;++i)
		{
			verP = [nsP objectAtIndex:i];
			if(verP)
			{
				if(i==0 && majorP)
				{
					*majorP = [verP intValue];
				}
				if(i==1 && minor1P)
				{
					*minor1P = [verP intValue];
				}
				if(i==2 && minor2P)
				{
					*minor2P = [verP intValue];
				}
			}
		}
	
	}
	return 0;

}
void alertNotiFication(int type,unsigned int lineID,int valSubLong, unsigned long userData,void *otherinfoP)
{
	SpoknAppDelegate *spoknDelP;
	NSAutoreleasePool *autoreleasePool = [[ NSAutoreleasePool alloc ] init];
	spoknDelP = (SpoknAppDelegate *)userData;
	[spoknDelP setLtpInfo:type :valSubLong :lineID :otherinfoP];
	if( pthread_main_np() ){
		[spoknDelP sendMessage:spoknDelP];
		[autoreleasePool release];
		return;
	}
	if(type==UA_ALERT && valSubLong==LOAD_ADDRESS_BOOK)
	{
		[spoknDelP makeIndexingFromAddressBook];
	}
	else
	{	
	
		//[self postNotificationOnMainThreadWithName:name object:object userInfo:userInfo waitUntilDone:NO];
		
		/*	if(type==ALERT_CONNECTED|| type==ALERT_ONLINE || type==ALERT_OFFLINE || type==ALERT_INCOMING_CALL || type==ALERT_DISCONNECTED)
		{	
			[spoknDelP performSelectorOnMainThread : @ selector(sendMessage: ) withObject:spoknDelP waitUntilDone:YES];
		}
		else*/
		{
			[spoknDelP performSelectorOnMainThread : @ selector(sendMessage: ) withObject:spoknDelP waitUntilDone:NO];

		}
	}	
	[autoreleasePool release];
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
	
	
	[nsP release];
}

#pragma mark STARTING POINT
- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	//[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	[self enableEdge];
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
	
	tabBarController.viewControllers = viewControllers;
	[viewControllers release];
	
	
	
	tabBarController.delegate = self; 	
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
	//SetDeviceDetail("spokn","1.0.3","Windows mobile",osVerP,osModelP,uniqueIDCharP);
	//SetDeviceDetail("Spokn","0.1.7","iphone",osVerP,osModelP,uniqueIDCharP);
	
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

		
	tabBarController.selectedViewController = spoknViewNavigationController;//dialviewP;
	[vmsNavigationController.tabBarItem initWithTitle:@"VMS" image:[UIImage imageNamed:_TAB_VMS_PNG_] tag:4];
	[self createRing];
	SetSpeakerOnOrOff(0,true);
	[vmsviewP setcomposeStatus:1 ];
	SetAudioSessionPropertyListener(self,MyAudioSessionPropertyListener);
	[self newBadgeArrived:vmsNavigationController];	
	loadMissCall();
	[callviewP setMissCallCount];
	
	 addressRef = ABAddressBookCreate();

	pthread_t pt;
	pthread_create(&pt, 0,ThreadForContactLookup,self);	
	/*int majorver =0,minor1ver=0,minor2ver=0;
	GetOsVersion(&majorver,&minor1ver,&minor2ver);
	if(majorver>=3 && minor1ver>0 )
	{
		self->blueTooth = true;
	}
	else
	{
		self->blueTooth = false;
	}*/
	self->blueTooth = false;
	//setProp();
	//getProp();	
		
}/*
-(BOOL) transformedValue: (id) value 
{ 
	if (value isKindOfClass: [BOOL class]) 
	{ 
		if (value==YES) return @"Yes" ; 
		return @"No" ; 
	}
}*/
-(void)makeIndexingFromAddressBook
{
	if(contactlookupP==0)
	{	
		Contactlookup *lcontactLookup;
		lcontactLookup = [[Contactlookup alloc] init];
		intiallookupP = lcontactLookup;
		if ([lcontactLookup makeIndex]==0)
		{	
			lcontactLookup.addressRef = self.addressRef;
			contactlookupP = lcontactLookup;
			intiallookupP = 0;
		}	
		else
		{
			intiallookupP = 0;
			[lcontactLookup release];
			lcontactLookup = 0;
			
		}
	}	
}
/*
#pragma mark PUSH NOTIFICATIONS
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"APNS", @"") message:[NSString stringWithFormat:@"%@", deviceToken] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil] autorelease];
		[alert show];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {     
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
	self.calllogNavigationController.tabBarItem.badgeValue= nil;
	SetSpeakerOnOrOff(0,true);
	self->onLineB = false;
}
- (void)applicationWillTerminate:(UIApplication *)application
{
	#ifndef _LTP_
		[nsTimerP invalidate];
		nsTimerP = nil;
	#endif
	if(contactlookupP)
	{	
		[contactlookupP release];
		contactlookupP = 0;
	}
	else
	{
		if(intiallookupP)
		{
			[intiallookupP applicationwillTerminate];
			intiallookupP = 0;
		}
		
	}
	//[super applicationWillTerminate:application];
	[ltpTimerP stopTimer ];
	//logOut(ltpInterfacesP);
	logOut(ltpInterfacesP,false);
	endLtp(ltpInterfacesP);
	saveMissCall();
	[self stopCheckNetwork];
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
	//NSMutableString *tempStringP;
	NSString *strP;
	NSString *strtypeP;
	char typeP[30];
	struct AddressBook *addressP;
		
		//tempStringP = [[NSMutableString alloc] init] ;
		addressP = getContactAndTypeCall(inComP->userIdChar,typeP);
		if(addressP)
		{
			strP = [[NSString alloc] initWithUTF8String:addressP->title] ;
			//[tempStringP setString:strP];
			//[strP release];
			strtypeP = [[NSString alloc] initWithUTF8String:typeP] ;
			//[tempStringP appendString:@"\n" ];
			//[tempStringP appendString:strP];
			//[strP release ];
		}
		else
		{
			strP = [[NSString alloc] initWithUTF8String:inComP->userIdChar] ;
			strtypeP = [[NSString alloc] initWithString:@"Unknown"];
			//[tempStringP appendString:strP ];
			//[tempStringP setString:addressP->title];
			//[tempStringP appendString:@"\nUnknown" ];
			//[tempStringP appendString:strP];
			//[strP release ];
			
		}
		//strP = [[NSString alloc] initWithUTF8String:noCharP] ;
		//[strP setString:@"Calling "];
		//	tempStringP = [NSMutableString stringWithString:@"calling "]	;
	[dialviewP setStatusText:strP :strtypeP :TRYING_CALL :0];
		//[tempStringP release];
		//[tempStringP release ];
	[strP release ];
	[strtypeP release];
	#ifdef __IPHONE_3_0
		[UIDevice currentDevice].proximityMonitoringEnabled = YES;
	#else
		[[UIApplication sharedApplication] setProximitySensingEnabled:YES];
	#endif
	self->callNumber.direction = 2;
	self->callNumber.lineId = inComP->lineid;
	//AcceptInterface(ltpInterfacesP, inComP->lineid);
	free(inComP);
	//[self changeView];
	

}
-(void)RejectCall:(IncommingCallType *)inComP
{
	[self stopRing];
	 //pjsua_call_answer(call_id, 180, NULL, NULL);
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
		int uID=0;
		char *addressBookNameP = 0;
		char *addressBookTypeP = 0;
		uID = getAddressUid(self->ltpInterfacesP);
		if(uID)
		{
			[ContactViewController	getNameAndType:self.addressRef :uID :pnumberP :&addressBookNameP :&addressBookTypeP];
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
			else
			{
				uID = 0;
			}
			
		}
		if(uID==0)
		{
			
			
			ABRecordID recIDP =-1;
			[contactlookupP	searchNameAndTypeBynumber:pnumberP :&addressBookNameP :&addressBookTypeP :&recIDP] ;
			if(recIDP>=0)
			{
				SetAddressBookDetails(ltpInterfacesP,recIDP,recIDP);
			}
			else
			{
				SetAddressBookDetails(ltpInterfacesP,0,0);
			}
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
			else
			{
				returnCharP = malloc(strlen(pnumberP)+10);
				strcpy(returnCharP,pnumberP);
				
				strcpy(typeP,"Unknown");
				
			}
			
			
					
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
	//NSMutableString *tempStringP;
	NSString *strP;
	NSString *strtypP;
	NSString *tempP;
	NSString *temp1P;
	char *nameP;
	Boolean retB = false;
	char typeP[30];
	char *resultCharP;
	//struct AddressBook *addressP;
	resultCharP = NormalizeNumber(noCharP,0);
	
/*	if(validateNo(resultCharP))//mean invalid number
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_INVALID_NUMBER_ 
														message:_INVALID_NUMBER_MESSAGE_
													   delegate:self 
											  cancelButtonTitle:nil 
											  otherButtonTitles:_OK_, nil];
		[alert show];
		[alert release];
		if(resultCharP)
		free(resultCharP);
		return retB;
		
	}*/
	if(!wifiavailable)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_NO_WIFI_ 
														message:_CHECK_NETWORK_SETTINGS_
													   delegate:self 
											  cancelButtonTitle:nil 
											  otherButtonTitles:_OK_, nil];
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
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_NO_MICROPHONE_
															message:_NO_MICROPHONE_MESSAGE_
														   delegate:nil 
												  cancelButtonTitle:_OK_
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			return retB;
		}
		
		
		//tempStringP = [[NSMutableString alloc] init] ;
		
		nameP = [self getNameAndTypeFromNumber:resultCharP :typeP :0];
		strP = [[NSString alloc] initWithUTF8String:nameP] ;
		//[tempStringP setString:strP];
		//[strP release];
		tempP = [[NSString alloc] initWithString:@"calling "];
		
		strtypP = [[NSString alloc] initWithUTF8String:typeP] ;
		//temp1P = [[NSString alloc] initWithString:[tempP stringByAppendingString:strtypP]];
		temp1P = [tempP stringByAppendingString:strtypP];
		//[strtypP appendString:@"\ncalling " ];
		//[tempStringP appendString:@"\n" ];
		//[tempStringP appendString:strP];
		//[strP release ];
		free(nameP);
		
		callOnB =true;
		strcpy(self->callNumber.number,resultCharP);
		self->callNumber.direction = 1;
		retB = 1;
		[SpoknAudio destorySoundUrl:&allSoundP];
		//	retB = callLtpInterface(self->ltpInterfacesP,resultCharP);
		[dialviewP setStatusText:strP :temp1P :TRYING_CALL :0];
		//[tempStringP release ];
		[strP release];
		[strtypP release];
		[tempP release];
		[temp1P release];
	
		#ifdef __IPHONE_3_0
				[UIDevice currentDevice].proximityMonitoringEnabled = YES;
		#else
				[[UIApplication sharedApplication] setProximitySensingEnabled:YES];
		#endif
	}	
	else
	{
		if(self->loginProgressStart)
		{	
			UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: _USER_OFFLINE_ 
															   message: [ NSString stringWithString:_USER_OFFLINE_MESSAGE_ ]
															  delegate: nil
													 cancelButtonTitle: nil
													 otherButtonTitles: _OK_, nil
								  ];
			[ alert show ];
			[alert release];
		}
		else
		{
			UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: _NO_NETWORK_
															   message: [ NSString stringWithString:_CHECK_NETWORK_SETTINGS_ ]
															  delegate: nil
													 cancelButtonTitle: nil
													 otherButtonTitles: _OK_, nil
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
	
	//hangLtpInterface(self->ltpInterfacesP);
	[dialviewP setStatusText: @"call end" :nil :ALERT_DISCONNECTED :0];
	//SetSpeakerOnOrOff(0,true);
	#ifdef __IPHONE_3_0
		[UIDevice currentDevice].proximityMonitoringEnabled = NO;
	#else
		[[UIApplication sharedApplication] setProximitySensingEnabled:NO];
	#endif
	//[tabBarController dismissModalViewControllerAnimated:YES];

	return true;
}

-(void)tabBarController:(UITabBarController*)tabBarController didSelectViewController:(UIViewController*)viewController
{
	
	if(prvCtlP )
	{
		if([prvCtlP isKindOfClass:[UINavigationController class]])
		{
			if(prvCtlP==vmsNavigationController)
			{	
				[VmsProtocolP	VmsStopRequest];
			}	
			if(prvCtlP==calllogNavigationController && viewController!=calllogNavigationController)
			{
				[callviewP resetMissCallCount];
			}
			[(UINavigationController*)prvCtlP popToRootViewControllerAnimated:NO];
		
			
		}
		
		
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
	
	SetSpeakerOnOrOff(0,true);
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
	return 0;
}
-(int) vmsShowRecordOrForwardScreen : (char*)noCharP VMSState:(VMSStateType)state filename:(char*)fileNameCharP duration:(int) maxtime vmail:(struct VMail*) lvmailP;
{
	//struct AddressBook * addressP;
	char type[30];
	int max = 20;
	char *nameP;
	Boolean findB= false;
	[VmsProtocolP	VmsStopRequest];
	if(maxtime)
	{
		max = maxtime;
	}
	if(noCharP)
	{	
		nameP = [self getNameAndTypeFromNumber:noCharP :type :&findB];
	}
	else
	{
		nameP = 0;
		noCharP = "";
		
	}
	VmShowViewController     *vmShowViewControllerP;	
		vmShowViewControllerP = [[VmShowViewController alloc] initWithNibName:@"vmshowviewcontroller" bundle:[NSBundle mainBundle]];
	[vmShowViewControllerP setFileName: fileNameCharP :0];
	if(findB==true)
	{	
		[vmShowViewControllerP setvmsDetail: noCharP : nameP :type :state :max :lvmailP];
	}
	else
	{
		[vmShowViewControllerP setvmsDetail: noCharP : noCharP :"" :state :max : lvmailP];
		
	}
	[vmShowViewControllerP setObject:self];
	//[vmsNavigationController popToRootViewControllerAnimated:NO];
	UINavigationController *tmpCtl;
	tmpCtl = [[ [ UINavigationController alloc ] initWithRootViewController: vmShowViewControllerP ] autorelease];
	[tabBarController presentModalViewController:tmpCtl animated:YES];
	
	//[ vmsNavigationController pushViewController:vmShowViewControllerP animated: YES ];
	
	if([vmShowViewControllerP retainCount]>1)
		[vmShowViewControllerP release];
	free(nameP);
	
		
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
	//return sendVms(numberP,fileNameCharP);
	return sendVms(numberP,fileNameCharP,0,0);
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
	//er =  sendVms(numberP,nameP);
	er =  sendVms(numberP,nameP,self->ltpInterfacesP->recordUId,self->ltpInterfacesP->recordID);
	if(nameP)
		free(nameP);
	return er;
	
}
-(int)getFileSize:(char*)fileNameP :(unsigned long *)noSecP
{
	long sz;
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
	
	
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	[self stopCheckNetwork];
	
	
	hostReach = [[Reachability reachabilityWithHostName: @"www.spokn.com"] retain];
	//hostReach = [[Reachability reachabilityWithAddress:&addr] retain];
	[hostReach startNotifer];
	//[self updateReachabilityStatus: hostReach];

	//wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
	//[wifiReach startNotifer];
}
-(void) stopCheckNetwork
{
	
	[hostReach release];
	[wifiReach release];
	hostReach = nil;
	wifiReach = nil;
	 
		
}
- (void)reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateReachabilityStatus: curReach];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	if(error)
	{
		SetConnection( ltpInterfacesP,0);
		alertNotiFication(ALERT_OFFLINE,0,LOGIN_STATUS_NO_ACCESS,(long)self,0);
		wifiavailable = NO;
		
	
	}



}
- (void) configureTextField: (Reachability*) curReach
{
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired=[curReach connectionRequired];
    NSString* statusString= @"";
	/*//only for wifi testing
	if(netStatus==ReachableViaWiFi)
	{
		netStatus = ReachableViaWWAN;
	}*/

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
			logOut(ltpInterfacesP,false);
			SetConnection( ltpInterfacesP,0);
			
			alertNotiFication(ALERT_OFFLINE,0,LOGIN_STATUS_NO_ACCESS,(long)self,0);
		//	[vmsviewP setcomposeStatus:0 ];
            break;
        }		
            
        case ReachableViaWWAN:
        {
          	//connectionRequired = NO;
			
			if(connectionRequired==NO)
			{	 
				if(self->edgevalue)//if edge is specified
				{	
					//#define _TEST_QUALITY_ON_GPRS_ 
					//#ifdef _TEST_QUALITY_ON_GPRS_
					wifiavailable = YES;
					if(SetConnection( ltpInterfacesP,2)==0)
					{	 
						[spoknViewControllerP startProgress];
						//	 [vmsviewP setcomposeStatus:1 ];
					}	
				}
				else
				{

					wifiavailable = NO;
					[self logOut:NO];
				//logOut(ltpInterfacesP,NO);
					SetConnection( ltpInterfacesP,0);
				
					alertNotiFication(ATTEMPT_GPRS_LOGIN,0,NO_WIFI_AVAILABLE,(long)self,0);
				//[vmsviewP setcomposeStatus:1 ];
				//wifiavailable = YES;
				//SetConnection( ltpInterfacesP,2);
				}
			}
			else
			{
				
				//this is for invoking internet library
				NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_URL_SPOKN_] cachePolicy:NO timeoutInterval:15.0] ;
				
				NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
				if (theConnection) {
					connectionRequired	= NO;	
				}
				else {
				}
				
				[theConnection autorelease];
				
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
			//connectionRequired = NO;//this need 
			 if(connectionRequired==NO)
			 {	 
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
		
		alertNotiFication(ALERT_OFFLINE,0,LOGIN_STATUS_NO_ACCESS,(long)self,0);
		wifiavailable = NO;
		
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
