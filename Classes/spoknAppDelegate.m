
//  Created by on 26/06/09.

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
#import "GEventTracker.h"
#include "sipandltpwrapper.h"
#include "sipandltpwrapper.h"
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/sysctl.h>
@implementation spoknMessage
@synthesize spokndelegateP;
@synthesize status;
@synthesize subID;
@synthesize dataP;
@synthesize lineID;

-(id) init
{
	return [super init];
}
- (void)dealloc {
	[super dealloc];
}
@end

@implementation countrycodelist
@synthesize code;
@synthesize name;
@synthesize prefix;

-(id) init
{
	return [super init];
}
- (void) dealloc
{
	[code release];
	[name release];
	[prefix release];
	[super dealloc];
}

@end


@implementation geolocationData

@synthesize country;
@synthesize countryCode;
@synthesize locality;
@synthesize postalCode;
@synthesize subLocality;
@synthesize subAdministrativeArea;
@synthesize subThoroughfare;
@synthesize thoroughfare;

-(id) init
{
	return [super init];
}
- (void) dealloc
{
	[country release];
	[countryCode release];
	[locality release];
	[postalCode release];
	[subLocality release];
	[subAdministrativeArea release];
	[subThoroughfare release];
	[thoroughfare release];
	[super dealloc];
}

@end





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
@synthesize firstTimeB;
@synthesize dialviewP;
@synthesize globalAddressP;
@synthesize inbackgroundModeB;
@synthesize onLogB;
@synthesize osversionDouble;
@synthesize onoffSip;
@synthesize locationManager;
#ifdef _CALL_THROUGH_

@synthesize onlyCallThrough;
#endif

#pragma mark SIP LOGGING START
-(int)sendLogFile:(NSString **)stringP
{
	char *fileP;
	fileP = getLogFile(self->ltpInterfacesP->ltpObjectP);
	if(fileP)
	{
		char*userP = getLtpUserName(self->ltpInterfacesP);
		NSMutableURLRequest *request;
		NSError *nsP=0;
		char passP[20];
		if(self->actualOnlineB)
		{
			strcpy(passP,"pass");
		}
		else {
			strcpy(passP,"failed");
		}
	//	char*filescriptNameP=  getlogfilescript();
		
	/*	
		NSString *urlString = [NSString stringWithUTF8String:filescriptNameP];
		if(filescriptNameP)
		{
			free(filescriptNameP);
			filescriptNameP = 0;
		}
		*/
		NSMutableString	*loginString;
		NSMutableString	*passwordString;
		NSMutableString	*dataStr;
		NSMutableString	*authenticationString;
				
		
		NSString *urlString = @"https://www.spokn.com/siplogdump.php";
		
		//NSString *urlString = @"http://192.168.173.122/~mukesh/quickest.php";
		
		//NSString *urlString = @"http://192.168.175.102/~tasvir/logfile.php";
		NSString *filename = [NSString stringWithUTF8String:fileP];
		request= [[[NSMutableURLRequest alloc] init] autorelease];
		
		
		char *passwordCharP;
		
		passwordCharP = getLtpPassword(ltpInterfacesP);
		loginString = [NSMutableString stringWithUTF8String:userP];
		passwordString = [NSMutableString stringWithUTF8String:passwordCharP];
		free(passwordCharP);
		
		dataStr = (NSMutableString*)[@"" stringByAppendingFormat:@"%@:%@", loginString, passwordString];
		
		NSData *encodeData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
		
		char encodeArray[512];
		
		memset(encodeArray, '\0', sizeof(encodeArray));
		
		// Base64 Encode username and password
		encode([encodeData length], (char *)[encodeData bytes], sizeof(encodeArray), encodeArray);
		
		dataStr = (NSMutableString*)[[NSString alloc] initWithCString:encodeArray length:strlen(encodeArray)];
		authenticationString = (NSMutableString*)[@"" stringByAppendingFormat:@"Basic %@", dataStr];
		
		NSString *contentType1 = [[NSString alloc]initWithString: authenticationString];
		[request addValue:contentType1 forHTTPHeaderField:@"Authorization"];
		[contentType1 release]; 
		[dataStr release];
		
		
		
		
		
		
		[request setURL:[NSURL URLWithString:urlString]];
		[request setHTTPMethod:@"POST"];
		NSString *boundary = @"---------------------------14737809831466499882746641449";
		NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
		[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
		NSMutableData *postbody = [NSMutableData data];
		[postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%s\";filename=\"%s_%s_%@\"\r\n","uploadedfile",userP,passP, @"iphone_log.txt"] dataUsingEncoding:NSUTF8StringEncoding]];
		[postbody appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		NSData *tmpDataP = [NSData dataWithContentsOfFile:filename];
		[postbody appendData:[NSData dataWithData:tmpDataP]];
		//NSString *returnString1 = [[NSString alloc] initWithData:tmpDataP encoding:NSUTF8StringEncoding];
		//NSLog(@"\n%@\n re\n",returnString1);

		[postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[request setHTTPBody:postbody];
		
		NSData *returnData ;
		returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&nsP];
		//NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
		//NSLog(@"\n\nResult %@\n\n",returnString);
		free(userP);
		if(returnData==nil)
		{
			
			return [nsP code];
				
		}
		if(stringP)
		{	
			*stringP = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
		}	
		return 0;
	}
	return 1;

}
#pragma mark SIP LOGGING END
-(void)retianThisObject:(id)retainObject
{

	if(isBackgroundSupported)
	{	
		[retainObject retain];
	}	
}
- (void) handleTimer: (id) timer
{
	
	if(self.onLineB)
	{	
		profileResync();
		if(sipLoginAttemptStartB==false && actualOnlineB==false)
		{
			self->timeOutB = 0;
			[self startCheckNetwork];
			sipLoginAttemptStartB = true;

		}
		
		
	}
	else
	{
		if(self->timeOutB)
		{
			self->timeOutB = 0;
			[self startCheckNetwork];
		
		}	
	}
	if(inbackgroundModeB)
	{
		[nsTimerP invalidate];
		nsTimerP = nil;

	
	
	}
}
-(int) profileResynFromApp
{
	if(self.onLineB)
	{	
		profileResync();
		if(sipLoginAttemptStartB==false && actualOnlineB==false)
		{
			self->timeOutB = 0;
			[self startCheckNetwork];
			sipLoginAttemptStartB = true;
			
		}
		return 0;
	}	
	else
	{
		if(self->timeOutB)
		{
			self->timeOutB = 0;
			[self startCheckNetwork];
			
		}	
	}
	return 1;
}
#pragma mark PLIST VALUES START
-(void) enableLog
{
	NSString *toogleValue;
	toogleValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"key_logfile"];
	if(toogleValue)
	{	
		self->onLogB = [toogleValue intValue];//this value are reverse
	}
	else
	{
		self->onLogB = 0;
	}
	printf("%d",self->onLogB);
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

-(void) getCallType
{
	int toogleValue;
	toogleValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"protocoltypeIndex"];
	if(toogleValue)
	{	
		self->outCallType = toogleValue;
	}
	else
	{
		self->outCallType = 1;
	}
}
-(void) enableSip
{
	NSString *toogleValue;
	int lrandowVariable;
	toogleValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"route_prefrence"];
	if(toogleValue)
	{	
		self->onoffSip = ![toogleValue intValue];//this value are reverse
	}
	else
	{
		self->onoffSip = 1;
	}
	lrandowVariable =  [[NSUserDefaults standardUserDefaults] integerForKey:@"random_variable"];
	if(lrandowVariable==0)
	{	
		lrandowVariable = time(0);//get random variable
		lrandowVariable = lrandowVariable;
		[[NSUserDefaults standardUserDefaults] setInteger:lrandowVariable forKey:@"random_variable"];
	
	}
	self->randowVariable = lrandowVariable;
	//printf("\nenablesip %d",self->onoffSip);
}
-(void) enableAnalytics
{
	NSString *toogleValue;
	toogleValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"analyst_prefrence"];
	if(toogleValue)
	{	
		self->onoffAnalytics = ![toogleValue intValue];//this value are reverse
	}
	else
	{
		self->onoffAnalytics = 1;
	}
}
#pragma mark PLIST VALUES STOP
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
#pragma mark RING_START
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
			if(isCallOnB==false)
			{	
				SetAudioTypeLocal(0,1);
			}	
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
		if(isCallOnB==false)
		{	
			SetAudioTypeLocal(0,3);
		}	
		isCallOnB = false;
		return 0;
	}	
	return 1;
	
}
-(void) setIncommingCallDelegate:(id)incommingP
{
	inCommingCallViewP = incommingP;

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

#pragma mark RING_END
-(void) showText:(NSString *)testStringP
{
	[dialviewP setStatusText:testStringP :nil :0 :0 :0];
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
extern void restartPlayAndRecord();
void restartPlayAndRecord()
{

}

- (void) handleIntrrept: (id) timer
{
	OSStatus x;
	
	x = AudioSessionSetActive(true);
	if(x==0)
	{	
		//printf("intrr co");
		restartPlayAndRecord();
		setHoldInterface(self->ltpInterfacesP, 0);
		intrrruptB = 0;
		
	}
	/*else {
		printf(" intrr different");
	}
	 */
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


#pragma mark TEST_CALL_START


#ifdef _TEST_CALL_
- (void) handleStartCall: (id) timer
{
	
	[(NSTimer*)timer invalidate];
	[self makeCall:"12345678"];
	[self endCall];//terminate call
}

- (void) handleEndCall: (id) timer
{
	static long count;
	count +=  1;
	if(count%20==0)
	{       
		printf("count call %ld",count);
	}       
	[(NSTimer*)timer invalidate];
	[self->dialviewP->callViewControllerP endCallPressed:nil];
	[self startCall];//terminate call
}
-(void)startCall
{
	[NSTimer scheduledTimerWithTimeInterval: 2.0
									 target: self
								   selector: @selector(handleStartCall:)
								   userInfo: nil
									repeats: YES];
	
	
	
}
-(void)endCall
{
	[NSTimer scheduledTimerWithTimeInterval: 7.0
									 target: self
								   selector: @selector(handleEndCall:)
								   userInfo: nil
									repeats: YES];
	
	
	
}
#endif
#pragma mark TEST_CALL_END

-(void) startTakingEvent
{
	self->dontTakeMsg = false;
}

-(void)alertAction:(NSNotification*)note
{
	
	Boolean lonlineB;
	if(self->dontTakeMsg)
	{
		if(self->status==ATTEMPT_LOGIN_ERROR)
		{
			ResetPortChecking(ltpInterfacesP);
		}
		return;
	}
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
				//[loginProtocolP cleartextField];
				//if(loginProtocolP)
				{	
					[dialviewP setStatusText: @"Authentication failed" :nil :ALERT_OFFLINE :HOST_NAME_NOT_FOUND_ERROR :0];
				}
				loginGprsB = false;
				
			}
			else
			{
				if(loginAttemptB)	
				{
					[loginProtocolP stoploginIndicator];
					[loginProtocolP cleartextField];
					[dialviewP setStatusText: @"Authentication failed" :nil :ALERT_OFFLINE :HOST_NAME_NOT_FOUND_ERROR :0 ];
					loginGprsB = false;
				
				}
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
					#ifndef _UA_LOGIN_FIRST_
						if(loginGprsB)//this is for login via gprs
					#else
						if(loginAttemptB)	
					#endif
						{
							[loginProtocolP stoploginIndicator];
							[loginProtocolP cleartextField];
							[dialviewP setStatusText: @"Authentication failed" :nil :ALERT_OFFLINE :LOGIN_STATUS_FAILED :0 ];
							loginGprsB = false;
						
						}
					break;
			
			}
		}
			break;
		case ALERT_CONNECTED:
			{
				int majorver =0,minor1ver=0,minor2ver=0;
				GetOsVersion(&majorver,&minor1ver,&minor2ver);
				if((majorver>=3 && minor1ver>0) || majorver>3  )
				{	
					
					self.blueTooth =  blueToothIsOn();
				}
				else
				{
					self.blueTooth =  false;
				}
			}

			openSoundInterface(ltpInterfacesP,1);
			[dialviewP setStatusText: @"ringing" :nil :ALERT_CONNECTED :0 :self->lineID];

			callOnB = true;
			//getProp();
			
		#ifdef __IPHONE_3_0
					[UIDevice currentDevice].proximityMonitoringEnabled = YES;
		#else
					[[UIApplication sharedApplication] setProximitySensingEnabled:YES];
		#endif
			
			
			#ifndef _LTP_COMPILE_
				[nsTimerP invalidate];
				nsTimerP = nil;
			#endif
			break;	
		case ALERT_CALL_NOT_START:
			[dialviewP setStatusText: @"end call" :nil :ALERT_CALL_NOT_START :0 :0];
			closeSoundInterface(ltpInterfacesP);
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
			
			break;
			
		case ALERT_DISCONNECTED:
			callOnB = false;
			if(inCommingCallViewP)
			{	
				if([inCommingCallViewP incommingViewDestroy:self->lineID]==0)
				{
					[dialviewP setStatusText:0 :0 :INCOMMING_CALL_REJECT :0 :self->lineID];
					[self stopRing];
				}
				
			}	
			
			if(self->subID)
			{
				[callviewP missCallSetCount];
			}
			[callviewP doRefresh];
			if([dialviewP callDisconnected:self->lineID]==0)
			{	
			//	[dialviewP setStatusText: @"end call" :nil :ALERT_DISCONNECTED :0 :self->lineID];
				closeSoundInterface(ltpInterfacesP);
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

				#ifndef _LTP_COMPILE_
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
		case ATTEMPT_VPN_CONNECT_SUCCESS:	
			openvpnConnect = 1;
			SendLoginPacket(self->ltpInterfacesP);
			break;
		
			
		case ATTEMPT_LOGIN_ON_OPEN_PORT:
			
			
	
		case  ATTEMPT_LOGIN:
			self->ltpInterfacesP->pjsipThreadStartB =0;
           
			if(openvpnConnect>=1 || self->openvpnOn == 0)
			{	
				SendLoginPacket(self->ltpInterfacesP);//==0)
			}
			
			break;
		case UA_LOGIN_SUCCESSFULL:	
			if(loginAttemptB)
			{   
				sipLoginAttemptStartB  = 1;
				DoLtpSipLoginInterface(ltpInterfacesP);
				loginAttemptB = false;
				[UIApplication sharedApplication] .networkActivityIndicatorVisible = YES;
				if(loginProtocolP)
				{	
					[self popLoginView];
				}
				uaLoginSuccessB = 1;
				self->onLineB = true;
				//self->onLineB = true;
				[self updateSpoknView:0];
				[vmsviewP setcomposeStatus:1 ];
				uaLoginSuccessB = 1;
			}	
			
			break;
		case ATTEMPT_VPN_CONNECT_EXIT:	
		case ATTEMPT_VPN_CONNECT_UNSUCCESS:
			openvpnConnect = 2;
			
				
		case ATTEMPT_LOGIN_ERROR:
		{	
			UIAlertView *alertP = [ [ UIAlertView alloc ] initWithTitle: _SIP_LIB_NOT_INIT_ 
												  message: [ NSString stringWithUTF8String:self->otherDataP ]
												 delegate: self
										cancelButtonTitle: nil
										otherButtonTitles: _OK_, nil
					 ];
			[alertP show];
			[alertP release];
			sipLoginAttemptStartB = 0;
			ltpInterfacesP->LogoutSendB = 0;
			stopCircularRingB = 1;
			sipLoginAttemptStartB = 0;
			[UIApplication sharedApplication] .networkActivityIndicatorVisible = NO;
			[ spoknViewControllerP cancelProgress];
			self->onLineB = false;
			self->timeOutB = 0;
			actualOnlineB = 0;
			self->subID =  NO_SIP_AVAILABLE;
			self->status =  ALERT_OFFLINE;
			ResetPortChecking(ltpInterfacesP);
			
			self->ltpInterfacesP->pjsipThreadStartB =0;
			
			//[dialviewP setStatusText: _STATUS_NO_ACCESS_ :nil :ALERT_OFFLINE :self->subID :self->lineID];
			if(uaLoginSuccessB  )//mean call back is allowed ,http online
			{
				loginProgressStart = 0;
				self->onLineB = true;
			}	
			[self updateSpoknView:0];
			
		}	
			break;
		case START_LOGIN:
				if(self->subID==1)//mean no connectivity
				{
					
					[self startCheckNetwork];
				}
				else
				{
					[UIApplication sharedApplication] .networkActivityIndicatorVisible = YES;
					
					loginProgressStart = 1;
					#ifdef _UA_LOGIN_FIRST_ 
						if(uaLoginSuccessB==0)
						{	
							loginAttemptB = YES;   
							ReStartUAThread();
							profileResync();
						}	
					#endif   
					
				
				}
			self->dontTakeMsg = false;
			//self->onLineB = false;
			[dialviewP setStatusText:_STATUS_CONNECTING_ :nil :START_LOGIN :0 :self->lineID];
			[loginProtocolP startloginIndicator];
			[spoknViewControllerP startProgress];
			break;
		case ALERT_ONLINE://login
			#ifdef _CALL_THROUGH_
					self->onlyCallThrough = 0;  //Means sip,callback,callthrough all are supported
			#endif
			stopCircularRingB = 1;
			[UIApplication sharedApplication] .networkActivityIndicatorVisible = NO;
			loginProgressStart = 0;
			[vmsviewP setcomposeStatus:1 ];
			[loginProtocolP stoploginIndicator];
			ltpInterfacesP->valChange=1;
			actualOnlineB = 1;
			#ifndef _LTP_COMPILE_
			[nsTimerP invalidate];
			sipLoginAttemptStartB = 0;
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
				if(loginProtocolP)
				{	
					[self popLoginView];
				}
				[ spoknViewControllerP cancelProgress];
			}
			self->onLineB = true;
			[dialviewP setStatusText:_STATUS_ONLINE_ :nil :ALERT_ONLINE :0 :self->lineID];
			
			//[self performSelectorOnMainThread : @ selector(updateSpoknView: ) withObject:nil waitUntilDone:YES];
			[self updateSpoknView:0];
			//[self performSelectorOnMainThread : @ selector(popLoginView: ) withObject:nil waitUntilDone:YES];
			profileResync();
			#ifndef _UA_LOGIN_FIRST_ 
				
			#else
				[ spoknViewControllerP cancelProgress];
			#endif
			
			
			cdrEmpty();
			cdrLoad();
			//[self performSelectorOnMainThread : @ selector(LoadContactView: ) withObject:callviewP waitUntilDone:YES];
			[self LoadContactView:callviewP];
			#ifdef _TEST_CALL_
				[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
				[self startCall];
			#endif
			break;
		case ALERT_OFFLINE:
			stopCircularRingB = 1;
			sipLoginAttemptStartB = 0;
			[UIApplication sharedApplication] .networkActivityIndicatorVisible = NO;
			[ spoknViewControllerP cancelProgress];
			lonlineB = self->actualOnlineB;
			self->onLineB = false;
			self->timeOutB = 0;
			actualOnlineB = 0;
			#ifdef _CALL_THROUGH_
				self->onlyCallThrough = 0;
			#endif
			//logOut(ltpInterfacesP,false);
			//[self performSelectorOnMainThread : @ selector(updateSpoknView: ) withObject:nil waitUntilDone:YES];
			[self updateSpoknView:0];
				switch(self->subID)
				{
					case LOGIN_STATUS_OFFLINE:
						[loginProtocolP stoploginIndicator];
						if(loginProtocolP && loginProgressStart)//mean login screen is on
						{
							[dialviewP setStatusText: _STATUS_OFFLINE_ :nil :ALERT_OFFLINE :self->subID :self->lineID];
						}
						break;
					case LOGIN_STATUS_FAILED:
							[loginProtocolP stoploginIndicator];
							[loginProtocolP cleartextField];
							if(loginProtocolP)
							{	
								[dialviewP setStatusText: _STATUS_AUTHENTICATION_FAILED_ :nil :ALERT_OFFLINE :self->subID :self->lineID];
							}	
							break;
					case NO_WIFI_OR_DATA_NETWORK_REACHEBLE: 
						uaLoginSuccessB = false;
					case LOGIN_STATUS_NO_ACCESS:
							loginProgressStart = 0;
							[loginProtocolP stoploginIndicator];
							if(loginProtocolP)//mean login screen is on
							{
								#ifdef _CALL_THROUGH_
								
								if(loginProtocolP)
								{	
									[self popLoginView];
								//	[dialviewP setStatusText: _STATUS_NO_ACCESS_ :nil :ALERT_OFFLINE :self->subID :self->lineID];
								}
								#else
								if(loginProtocolP)
								{	
									//[self popLoginView];
									[dialviewP setStatusText: _STATUS_NO_ACCESS_ :nil :ALERT_OFFLINE :self->subID :self->lineID];
								}
								#endif
								
								
							}	
						#ifdef _CALL_THROUGH_
							self->onlyCallThrough = 1;    //Means only call-through is supported
							[self updateSpoknView:0];    
						#endif

							break;
					case LOGIN_STATUS_TIMEDOUT:
						self->timeOutB = 1;
						if(showErrorOnTimeOut(ltpInterfacesP))
						{	
							[loginProtocolP stoploginIndicator];
							
							if(loginProtocolP)
							{	
								[dialviewP setStatusText: _STATUS_TIMEOUT2_ :nil :ALERT_OFFLINE :self->subID :self->lineID];	
							}		
							if(lonlineB && loginProtocolP==0)//mean previously on line
							{
								[self startCheckNetwork];
							
							}
							 
						}
						else {
									if(DoLtpLogin(self.ltpInterfacesP)==0)
									{	
										//[dialviewP setStatusText:_STATUS_CONNECTING_ :nil :START_LOGIN :0 :self->lineID];
										[loginProtocolP startloginIndicator];
										[spoknViewControllerP startProgress];
									}	
						}

						break;
					default:
						[loginProtocolP stoploginIndicator];
						if(loginProtocolP)//mean login screen is on
						{
							[dialviewP setStatusText: _STATUS_OFFLINE_ :nil :ALERT_OFFLINE :self->subID :self->lineID];
						}
				}
			if(uaLoginSuccessB  )//mean call back is allowed ,http online
			{
				loginProgressStart = 0;
				self->onLineB = true;
				[self updateSpoknView:0];
				[vmsviewP setcomposeStatus:1 ];
				#ifndef _LTP_COMPILE_
								[nsTimerP invalidate];
								sipLoginAttemptStartB = 0;
								nsTimerP = [NSTimer scheduledTimerWithTimeInterval: MAXTIME_RESYNC
											
																			target: self
											
																		  selector: @selector(handleTimer:)
											
																		  userInfo: nil
											
																		   repeats: YES];
				#endif
				
			
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
			
			#ifdef _ANALYST_
				[[GEventTracker sharedInstance] trackEvent:@"SPOKN" action:@"CALL-IN" label:@"CALL"];
			#endif
			
			[VmsProtocolP	VmsStopRequest];
			int result = [dialviewP isCallOn];
			if(result==2  || inCommingCallViewP)//mean more then one call is active
			{	
				
				
				RejectInterface(self->ltpInterfacesP, lineID);
				self->incommingCallList[lineID] = 0;
			}
			else
			{
				
				if(result==0)
				{	
					isCallOnB = false;
					SetAudioTypeLocal(0,1);
					[tabBarController dismissModalViewControllerAnimated:NO];
					[self LoadInCommingView:0 :tabBarController];	
					
				}
				else {
					isCallOnB = true;
					CallViewController *tmpObjP;
					tmpObjP = [dialviewP getCallViewController];
					[(CallViewController*)tmpObjP addTempId];
					[self LoadInCommingView:0 :tmpObjP];	
				}

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
					//SetAudioTypeLocal(0,0);
					AudioSessionSetActive(true);
					//printf("\n inttrrept come");
					restartPlayAndRecord();
					setHoldInterface(self->ltpInterfacesP, 0);
					intrrruptB = 0;
					
					break;
				case 1:
					intrrruptB = 1;
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
				[dialviewP setStatusText: _STATUS_ONLINE_ :nil :ALERT_ONLINE :0 :0];
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
				[dialviewP setStatusText: nil :nil :UA_ALERT :REFRESH_CONTACT :0];
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
				case BEGIN_THREAD:	
				
					[UIApplication sharedApplication] .networkActivityIndicatorVisible = YES;
				break;
				case END_THREAD:
					if(stopCircularRingB)
					{	
						[UIApplication sharedApplication] .networkActivityIndicatorVisible = NO;
					}	
					[vmsviewP cancelProgress];
					[self updateSpoknView:0];
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
					[UIApplication sharedApplication] .networkActivityIndicatorVisible = NO;
					[nsTimerP invalidate];
					nsTimerP = nil;
					TerminateUAThread();
					self->onLineB = false;
					self->actualOnlineB=false;
					self->uaLoginSuccessB=false;
					self->sipLoginAttemptStartB=false;
					self->dontTakeMsg = true;
					
					ltpInterfacesP->firstTimeLoginB = true;
					loginViewP = [[LoginViewController alloc] initWithNibName:@"loginview" bundle:[NSBundle mainBundle]];
					
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
	if(sipLoginAttemptStartB==true && uaLoginSuccessB)
	{
		[spoknViewControllerP setDetails:getTitle() :self->onLineB :ATTEMPTING_SIP_ :getBalance() :forwardCharP :getDidNo() forwardOn:result spoknID:unameP];
		
	}
	else
	{	
		if(actualOnlineB==false && onLineB==true)
		{
			
			[spoknViewControllerP setDetails:getTitle() :self->onLineB :NO_SIP_AVAILABLE :getBalance() :forwardCharP :getDidNo() forwardOn:result spoknID:unameP];
			
			
		}
		else {
			
		

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
-(void)LoadInCommingView:(id)object :(UIViewController*)controllerForIncommingView
{
		
	//[tabBarController dismissModalViewControllerAnimated:NO];
	inCommingCallViewP = [[IncommingCallViewController alloc] initWithNibName:@"incommingcall" bundle:[NSBundle mainBundle]];
	[inCommingCallViewP initVariable];
	
	[inCommingCallViewP setObject:self];
	[inCommingCallViewP setIncommingData:self->incommingCallList[self->lineID]];
	
	
	if(controllerForIncommingView)
	{	
		
		[inCommingCallViewP directAccept:YES];
		[controllerForIncommingView presentModalViewController:inCommingCallViewP animated:YES];

	}
	else {
		[inCommingCallViewP directAccept:NO];
		[tabBarController presentModalViewController:inCommingCallViewP animated:YES];

	}

	//[ dialNavigationController pushViewController: inCommingCallViewP animated: YES ];
	
		if([inCommingCallViewP retainCount]>1)
		[inCommingCallViewP release];
	

	//tabBarController.selectedViewController = dialNavigationController;
	
//	[ dialNavigationController pushViewController: inCommingCallViewP animated: YES ];
	[self changeView];
	
	[self startRing];
	
}
-(void)sendMessageFromOtherThread:(spoknMessage*)spoknMsgP
{
	//printf("\n msg %d %d %d",spoknMsgP->status,spoknMsgP->subID,spoknMsgP->lineID);
	[spoknMsgP.spokndelegateP setLtpInfo:spoknMsgP.status :spoknMsgP.subID :spoknMsgP.lineID :spoknMsgP.dataP];
	[spoknMsgP.spokndelegateP alertAction:nil];
	if(spoknMsgP.status==ALERT_SERVERMSG || spoknMsgP.status==ATTEMPT_LOGIN_ERROR || spoknMsgP.status == ATTEMPT_VPN_CONNECT_UNSUCCESS  || spoknMsgP.status == ATTEMPT_VPN_CONNECT_EXIT)
	{
		if(spoknMsgP.dataP)
		{	
			free(spoknMsgP.dataP);
			spoknMsgP.dataP = 0;
		}	
	}
	[spoknMsgP release];
}
-(int)getIncommingLineID
{
	if(self->callNumber.direction==2)//incomming call
	{
		return self->callNumber.lineId;
	}
	return -1;
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
			[dataP release];
			return 0;
			
		}
		else
		{
			[dataP release];	
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
		NSRange range = [capStrP rangeOfString:@"HEAD"];
		
		if (range.location == NSNotFound ) 
		{	
			[dataP release];
			return 0;
						
		}
	//	NSLog(@"connect %@",capStrP);
		[dataP release];
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
	SpoknAppDelegate *spoknDelP;
	spoknDelP = (SpoknAppDelegate *)inClientData;
	if(spoknDelP==0) return;
	
	
	if (inID == kAudioSessionProperty_AudioRouteChange)
	{
		CFDictionaryRef routeDictionary = (CFDictionaryRef)inData;			
		//CFShow(routeDictionary);
		CFNumberRef reason = (CFNumberRef)CFDictionaryGetValue(routeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
		SInt32 reasonVal;
		CFNumberGetValue(reason, kCFNumberSInt32Type, &reasonVal);
			
		
		
		if (reasonVal != kAudioSessionRouteChangeReason_CategoryChange)
		{
			/*CFStringRef oldRoute = (CFStringRef)CFDictionaryGetValue(routeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_OldRoute));
			 if (oldRoute)	
			 {
			 printf("old route:\n");
			 CFShow(oldRoute);
			 }
			 else 
			 printf("ERROR GETTING OLD AUDIO ROUTE!\n");
			 */
			 CFStringRef newRoute;
			 UInt32 size; size = sizeof(CFStringRef);
			 OSStatus error = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &size, &newRoute);
			if(error==0)
			{
				NSString *capStrP;
				//CFShow(newRoute);
				capStrP = [(NSString*)newRoute uppercaseString];
				//NSLog(@"connect %@",capStrP);
				
				if(capStrP==nil)
				{	
					return ;
				}
				NSRange range = [capStrP rangeOfString:@"SPEAKER"];
				if (range.location == NSNotFound ) 
				{
					range = [capStrP rangeOfString:@"BT"];//if bluetooth
					if (range.location == NSNotFound )
					{
						[spoknDelP->dialviewP setStatusText: @"nobluetooth" :nil :ROUTE_CHANGE :1 :0];
						if(spoknDelP->callOnB==false)
						{
							range = [capStrP rangeOfString:@"HEADSET"];//if bluetooth
							if (range.location == NSNotFound )
							{		
								SetSpeakerOnOrOffNew(0,1);
							}
						}

					}
					else
					{	
						[spoknDelP->dialviewP setStatusText: @"bluetooth" :nil :ROUTE_CHANGE :2 :0];
						
					}	
				}
				
				[(NSString*)newRoute release];
			}
			
			
			
		}	
		
	}
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
int alertNotiFication(int type,unsigned int llineID,int valSubLong, unsigned long userData,void *otherinfoP)
{
	SpoknAppDelegate *spoknDelP;
	if(type==CALL_ALERT)
	{
		spoknDelP = (SpoknAppDelegate *)userData;

		int er = 0;

		if(spoknDelP==0) return 0;
		if(valSubLong==1)
		{
			spoknDelP->callNumber.direction = 0;
			return 0;
		}
		switch(spoknDelP->callNumber.direction)
		{
			case 1:
				er = callLtpInterface(spoknDelP->ltpInterfacesP,spoknDelP->callNumber.number);
				spoknDelP->callNumber.direction = 0;
				break;
			case 2:
				AcceptInterface(spoknDelP->ltpInterfacesP, spoknDelP->callNumber.lineId);
				er = spoknDelP->callNumber.lineId;
				spoknDelP->callNumber.direction = 0;
				
				break;
		}		

		return er;
		
	
	
	}
	
	
	NSAutoreleasePool *autoreleasePool = [[ NSAutoreleasePool alloc ] init];
	spoknDelP = (SpoknAppDelegate *)userData;
	/*if(spoknDelP.inbackgroundModeB)
	{
	
		printf("\nspokn %d %d",type,llineID);
	}*/
	if( pthread_main_np() ){
		[spoknDelP setLtpInfo:type :valSubLong :llineID :otherinfoP];
		[spoknDelP sendMessage:spoknDelP];
		[autoreleasePool release];
		return 0;
	}
	if(type==UA_ALERT && valSubLong==LOAD_ADDRESS_BOOK)
	{
		[spoknDelP makeIndexingFromAddressBook];
	}
	else
	{	
	
		//[self postNotificationOnMainThreadWithName:name object:object userInfo:userInfo waitUntilDone:NO];
		
		/*if(type==ALERT_CONNECTED|| type==ALERT_ONLINE || type==ALERT_OFFLINE || type==ALERT_INCOMING_CALL || type==ALERT_DISCONNECTED || type==BEGIN_THREAD || type ==END_THREAD)
		{	
			[spoknDelP performSelectorOnMainThread : @ selector(sendMessage: ) withObject:spoknDelP waitUntilDone:YES];
		}
		else
		{
			[spoknDelP performSelectorOnMainThread : @ selector(sendMessage: ) withObject:spoknDelP waitUntilDone:NO];

		}*/
		spoknMessage *tmpObjP;
		tmpObjP = [[spoknMessage alloc] init];
		tmpObjP.status = type;
		tmpObjP.spokndelegateP = spoknDelP;
		tmpObjP.subID = valSubLong;
		tmpObjP.lineID = llineID;
		if(otherinfoP)
		{	
			if(type==ALERT_SERVERMSG)
			{
				if(otherinfoP)
				{	
					tmpObjP.dataP =  strdup(otherinfoP);
				}	
			}
			else {
				tmpObjP.dataP =  otherinfoP;
			}

			
		}
		else {
			tmpObjP.dataP  = 0;
		}

		[spoknDelP performSelectorOnMainThread : @ selector(sendMessageFromOtherThread: ) withObject:tmpObjP waitUntilDone:NO];
	}	
	[autoreleasePool release];
	return 0;
	//NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	//[nc postNotificationName:@"ALERTNOTIFICATION" object:(id)spoknDelP userInfo:nil];
	return 0;
}
-(void) setLtpInfo:(int)ltpstatus :(int)subid :(int)llineID :(void*)dataVoidP
{
	self->status = ltpstatus;
	self->subID = subid;
	self->lineID = llineID;
	self->otherDataP = dataVoidP;
	if(ltpstatus==ALERT_INCOMING_CALL)
	{
		self->incommingCallList[llineID] = dataVoidP;//this is ltp incomming call structure
	}
	if(ltpstatus==ALERT_SERVERMSG)
	{
		if(srvMsgCharP)
		{	
			free(srvMsgCharP);
			srvMsgCharP = 0;
		}
		if(dataVoidP)
		{	
			srvMsgCharP = malloc(strlen((char*)dataVoidP)+4);
			strcpy(srvMsgCharP,(char*)dataVoidP);
		}
	}
	
}
-(char*)getResourcePath
{
	char * returnCharP;
	const char *dataP;
	char *p=0;
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sandbox" ofType:@"crt"];
	if(filePath==0)
	{
		return 0;
	}
	dataP = [filePath cStringUsingEncoding:NSUTF8StringEncoding];
	returnCharP = malloc(strlen(dataP)+10);
	strcpy(returnCharP,dataP);
	p = strstr(returnCharP,"/sandbox");
	if(p)
	{
		*p = 0;
	}
	printf("\n%s",returnCharP);
	return 	returnCharP;
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
    //[defaultManager createDirectoryAtPath:nsP attributes:nil];
#ifdef __IPHONE_4_0
	[defaultManager createDirectoryAtPath:nsP withIntermediateDirectories:YES attributes:nil error:NULL];
#else
	[defaultManager createDirectoryAtPath:nsP attributes:nil];
#endif
	
	
	[nsP release];
}
-(void)setDeviceInforation:(NSString *)deviceTokenP
{
	//UIDevice *device = [UIDevice currentDevice];
	//NSString *uniqueIdentifier = [device uniqueIdentifier];
	NSString *versionP;
	versionP = [[UIDevice currentDevice] systemVersion] ;
	//float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	NSString *model = [[UIDevice currentDevice] model];
	char *osVerP=0;
	char *osModelP=0;
	char *uniqueIDCharP=0;
	self->osversionDouble = [versionP doubleValue];
	osVerP = (char*)[versionP cStringUsingEncoding:NSUTF8StringEncoding];
	osModelP = (char*)[model cStringUsingEncoding:NSUTF8StringEncoding];
	if(deviceTokenP)
	{	
		uniqueIDCharP = (char*)[deviceTokenP cStringUsingEncoding:NSUTF8StringEncoding];
	}	
	//uniqueIDCharP = (char*)[uniqueIdentifier cStringUsingEncoding:NSUTF8StringEncoding];
	//SetDeviceDetail("spokn","1.0.12","windows desktop",osVerP,osModelP,uniqueIDCharP);
	//SetDeviceDetail("spokn","1.0.3","Windows mobile",osVerP,osModelP,uniqueIDCharP);
	if(uniqueIDCharP==0)
	{
		uniqueIDCharP="\0";
	}
	ipadB = 0;
	ipadOrIpod = 0;
	if(model)
	{
		NSRange range={0,0};
		range = [model rangeOfString:@"iPod" options:NSCaseInsensitiveSearch];
		if (range.location !=NSNotFound)
		{
			ipadOrIpod = 1;
		}
		
		range = [model rangeOfString:@"iPad" options:NSCaseInsensitiveSearch];
		if (range.location !=NSNotFound)
		{
			ipadB = 1;
			iphoneHighResolationB = 1;
			ipadOrIpod = 1;
		}
		
		
		
	
	}
	if(ipadB==0)
	{
		double x;
		x = [versionP doubleValue];
		
		if(x>=3.2)
		{
			if(x<3.3)
			{	
				ipadB = 1;
			}	
			iphoneHighResolationB = 1;
		}
		
	}
	[self enableSip];
	sprintf(self->userAgent,"spokn version=%s,OsVersion=%s,OsModel=%s,UniqueID=%ld",CLIENT_VERSION,osVerP,osModelP,(long)self->randowVariable);
	
	SetDeviceDetail("Spokn",CLIENT_VERSION,"iphone",osVerP,osModelP,uniqueIDCharP);

}


#pragma mark StartRutine
- (void) openRscTimer: (id) timer
{

	[timer invalidate];
	[self startRutine];

}
-(void)startRutine
{
	if(self->firstTimeB)
	{
		
		self->firstTimeB = 0;
	}
	else
	{
		
		return;
	}	
	
		
	[self enableAnalytics];	
#ifdef _ANALYST_
	{
		GEventTracker *geventTP;
		geventTP = [GEventTracker sharedInstance];
		geventTP.showTrakerB = self->onoffAnalytics;
		[geventTP startEventTracker];
		[geventTP trackEvent:@"SPOKN" action:@"APPLICATION LAUNCH" label:@"LAUNCH"];
	}	
#endif	
		
		
	if(DoLtpLogin(ltpInterfacesP))//mean error ask dial to load login view
	{
		animation = 0;
		alertNotiFication(LOAD_VIEW,0,LOAD_LOGIN_VIEW,(unsigned long)self,0);
	}
	
		
	
	[self createRing];
	SetSpeakerOnOrOff(0,true);
	[vmsviewP setcomposeStatus:1 ];
	SetAudioSessionPropertyListener(self,MyAudioSessionPropertyListener);
	[self newBadgeArrived:vmsNavigationController];	
	loadMissCall();
	[callviewP setMissCallCount];
	
	
	
	pthread_t pt;
	pthread_create(&pt, 0,ThreadForContactLookup,self);	
	


}
- (BOOL) checkForHighResolution
{
	return self->iphoneHighResolationB;
}
- (BOOL) checkForIpad 
{
	return self->ipadB;
	
}/*
-(void) setPjsipBufferSize
{
	
	
	size_t size=0;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	if(size>0)
	{	
		char *machine = malloc(size);
		int numVersion=0;
		memset(machine,0,size);
		
		if(machine)
		{	
			char *ver;
			sysctlbyname("hw.machine", machine, &size, NULL, 0);
			ver = machine;
			while(*ver)
			{
				if(*ver>='0' && *ver<='9')
				{
					numVersion=numVersion*10+ (*ver-48);
				}
				ver++;	
			}
			printf("version name %s number %d",machine,numVersion);
			free(machine);
			if(numVersion<12)
			{
				set_sizeof_buffer(30);
			}
			else {
				set_sizeof_buffer(30);
			}

		}	
	}
	
	
	
	
	
	
}
*/
-(void)	applicationInit:(id)applicationP
{
	
	UIApplication *application;
	application = applicationP;
	addressRef = ABAddressBookCreate();
	//outCallType = 1;
	[self getCallType ];
	//[self setPjsipBufferSize ];
	application.applicationIconBadgeNumber = 0;
	if(setDeviceID==0)
	{	
		[self setDeviceInforation:@" "];
	}		
	
	UIDevice* device = [UIDevice currentDevice];
	isBackgroundSupported = NO;
	if ([device respondsToSelector:@selector(isMultitaskingSupported)])
		isBackgroundSupported = device.multitaskingSupported;	
	// Override point for customization after application launch
	//CGRect screenBounds = [ [ UIScreen mainScreen ] bounds ];
	
	//self.window = [ [ [ UIWindow alloc ] initWithFrame: screenBounds ] autorelease ];
	//viewController = [ [ spoknviewcontroller alloc ] init ];
	
	//[ window addSubview: viewController.view ];
	//[ window addSubview: viewController->usernameP ];
	//[ window addSubview: viewController->passwordP ];
	prvCtlP = 0;	
	wifiavailable = NO;
	gprsavailable = NO;
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
	contactviewP.contactTabControllerB	= YES;
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
	
	
	//tabBarController.selectedViewController = spoknViewNavigationController;//dialviewP;
	[calllogNavigationController.tabBarItem initWithTitle:@"Calls" image:[UIImage imageNamed:_TAB_CALLS_PNG_] tag:2];
	[vmsNavigationController.tabBarItem initWithTitle:@"VMS" image:[UIImage imageNamed:_TAB_VMS_PNG_] tag:4];
	
	
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
	
	self->firstTimeB = 1;
	
	[self enableEdge];
	[self enableSip];
	[self enableLog];
	
	ltpTimerP = nil;	
#ifndef _OWN_THREAD_
	ltpTimerP = [[LtpTimer alloc] init];
#endif	
	
	if(ltpTimerP)
	{	
		ltpInterfacesP =  ltpTimerP.ltpInterfacesP =  startLtp(self->onoffSip,alertNotiFication,(unsigned long)self,self->randowVariable&0x1FFF);
		self->openvpnOn =  startOpenVpn(ltpInterfacesP,GetPathFunction(0),[self getResourcePath]);
		
	}
	else
	{
		ltpInterfacesP = startLtp(self->onoffSip,alertNotiFication,(unsigned long)self,self->randowVariable&0x1FFF);
		self->openvpnOn = startOpenVpn(ltpInterfacesP,GetPathFunction(0),[self getResourcePath]);
		
	}
	setLogFile(ltpInterfacesP,self->onLogB);
#ifdef _LTP_
	if(self->sipOnB)
	{	
		setLtpServer(ltpInterfacesP,"www.spokn.com");
	}
	else
	{
		setLtpServer(ltpInterfacesP,"www.spokn.com");
	}
#else
	setLtpServer(ltpInterfacesP,"www.spokn.com");
#endif	
	
	int stunServer;
	stunServer = [[NSUserDefaults standardUserDefaults] integerForKey:@"stunserversetting"];
	if(stunServer)
	{
		stunServer--;
		setStunSettingIngetface(ltpInterfacesP, stunServer);
		
	}
	//start ua 
	UACallBackType uaCallback = {0};
	uaCallback.uData = self;
	uaCallback.pathFunPtr = GetPathFunction;
	uaCallback.creatorDirectoryFunPtr = CreateDirectoryFunction;
	uaCallback.alertNotifyP = alertNotiFication;
	
	UACallBackInit(&uaCallback,ltpInterfacesP->ltpObjectP);
	uaInit();
	
		//callviewP.ltpInterfacesP = ltpInterfacesP;
	
	//tabBarController.selectedViewController = dialviewP;
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(alertAction:) name:@"ALERTNOTIFICATION" object:nil];
	//NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	//[nc postNotificationName:@"DEQUEUEAUDIO" object:idP userInfo:nil];
	cdrLoad();
		
	
	[NSTimer scheduledTimerWithTimeInterval: 1
	 
									 target: self
	 
								   selector: @selector(openRscTimer:)
	 
								   userInfo: nil
	 
									repeats: YES];
	
	device = [UIDevice currentDevice];
	device.batteryMonitoringEnabled = YES;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(onCharging:)
												 name:UIDeviceBatteryStateDidChangeNotification
											   object:device];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(ProximityChange:)
												 name:UIDeviceProximityStateDidChangeNotification
											   object:device];
	
	setUserAgent(ltpInterfacesP,self->userAgent);
	
	{	
		int setIndex;
		setIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"tabBarIndex"];
		
		if(setIndex>0)
		{
			if(shifttovmsTab)
			{
				tabBarController.selectedIndex = 3;	//VMS tab
				[vmsviewP startProgress];
			}
			else
			{
				setIndex--;
				tabBarController.selectedIndex = setIndex;
			}
		}
		else
		{
			tabBarController.selectedIndex = 4;//spokn tab
		}
		//[[NSUserDefaults standardUserDefaults] synchronize];
	}
	//	[self startRutine];
	[ window makeKeyAndVisible ];
	
	
	
	
	
}
-(void)checkChangesInSetting
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs synchronize];
	NSString *toogleValue;
	Boolean reStartEveryThingB = false;
	int newValue;
	toogleValue = [prefs stringForKey:@"route_prefrence"];
	if(toogleValue)
	{	
		newValue = ![toogleValue intValue];//this value are reverse
	}
	else
	{
		newValue = 1;
	}
	if(newValue!=self->onoffSip)
	{
		reStartEveryThingB = true;
	}
	if(reStartEveryThingB==false)
	{	
		toogleValue = [prefs stringForKey:@"key_prefrence"];
		if(toogleValue)
		{	
			newValue = ![toogleValue intValue];//this value are reverse
		}
		else
		{
			newValue = 1;
		}
		if(newValue!=self->edgevalue)
		{
			reStartEveryThingB = true;
		}
	}	
	if(reStartEveryThingB==false)
	{	
		toogleValue = [prefs stringForKey:@"key_logfile"];
		if(toogleValue)
		{	
			newValue = [toogleValue intValue];//this value are reverse
		}
		else
		{
			newValue = 0;
		}
		printf("restart %d",self->onLogB);
		if(newValue!=self->onLogB)
		{
			reStartEveryThingB = true;
		}
	}	
	if(reStartEveryThingB==false)
	{	
			
		toogleValue = [prefs stringForKey:@"analyst_prefrence"];
		if(toogleValue)
		{	
			newValue = ![toogleValue intValue];//this value are reverse
		}
		else
		{
			newValue = 1;
		}
		if(onoffAnalytics!=newValue)
		{
			#ifdef _ANALYST_
				{
					GEventTracker *geventTP;
					geventTP = [GEventTracker sharedInstance];
					geventTP.showTrakerB = self->onoffAnalytics;
					[geventTP startEventTracker];
					[geventTP trackEvent:@"SPOKN" action:@"APPLICATION LAUNCH" label:@"LAUNCH"];
				}	
			#endif	
			
		
		}
	}	
	if(reStartEveryThingB)//restart thread
	{
		//first send logout and then relogin on new setting
		HangupAllCall(ltpInterfacesP);
		[self logOut:false];
		//logOut(ltpInterfacesP,false);
		if(onoffSip)
		{
			sleep(2);
		}
		endLtp(ltpInterfacesP);
		saveMissCall();
		[self stopCheckNetwork];
		[self enableEdge];
		[self enableSip];
		[self enableAnalytics];
		[self enableLog];
		
		uaLoginSuccessB = 0;
		ltpTimerP = nil;	
#ifndef _OWN_THREAD_
		ltpTimerP = [[LtpTimer alloc] init];
#endif	
		
		if(ltpTimerP)
		{	
			ltpInterfacesP =  ltpTimerP.ltpInterfacesP =  startLtp(self->onoffSip,alertNotiFication,(unsigned long)self,self->randowVariable&0x1FFF);
			self->openvpnOn = startOpenVpn(ltpInterfacesP,GetPathFunction(0),[self getResourcePath]);
		}
		else
		{
			ltpInterfacesP = startLtp(self->onoffSip,alertNotiFication,(unsigned long)self,self->randowVariable&0x1FFF);
			self->openvpnOn = startOpenVpn(ltpInterfacesP,GetPathFunction(0),[self getResourcePath]);
		}
		setLogFile(ltpInterfacesP,self->onLogB);
#ifdef _LTP_
		if(self->sipOnB)
		{	
			setLtpServer(ltpInterfacesP,"www.spokn.com");
		}
		else
		{
			setLtpServer(ltpInterfacesP,"www.spokn.com");
		}
#else
		setLtpServer(ltpInterfacesP,"www.spokn.com");
#endif	
		
		int stunServer;
		stunServer = [[NSUserDefaults standardUserDefaults] integerForKey:@"stunserversetting"];
		if(stunServer)
		{
			stunServer--;
			setStunSettingIngetface(ltpInterfacesP, stunServer);
			
		}
		//start ua 
		UACallBackType uaCallback = {0};
		uaCallback.uData = self;
		uaCallback.pathFunPtr = GetPathFunction;
		uaCallback.creatorDirectoryFunPtr = CreateDirectoryFunction;
		uaCallback.alertNotifyP = alertNotiFication;
		
		UACallBackInit(&uaCallback,ltpInterfacesP->ltpObjectP);
		uaInit();
		cdrLoad();
		[self enableAnalytics];	
#ifdef _ANALYST_
		{
			GEventTracker *geventTP;
			geventTP = [GEventTracker sharedInstance];
			geventTP.showTrakerB = self->onoffAnalytics;
			[geventTP startEventTracker];
			[geventTP trackEvent:@"SPOKN" action:@"APPLICATION LAUNCH" label:@"LAUNCH"];
		}	
#endif	
		
		loginAttemptB = false;
		[UIApplication sharedApplication] .networkActivityIndicatorVisible = NO;
		if(loginProtocolP==nil)
		{	
			if(DoLtpLogin(ltpInterfacesP))//mean error ask dial to load login view
			{
				animation = 0;
				alertNotiFication(LOAD_VIEW,0,LOAD_LOGIN_VIEW,(unsigned long)self,0);
			}
		}
		
		
		//[self createRing];
		//SetSpeakerOnOrOff(0,true);
		//[vmsviewP setcomposeStatus:1 ];
		//SetAudioSessionPropertyListener(self,MyAudioSessionPropertyListener);
		[self newBadgeArrived:vmsNavigationController];	
		loadMissCall();
		[callviewP setMissCallCount];
		
	}
	
	
	
}
#define _PUSH_NOTIFICATION_
//#ifdef _PUSH_NOTIFICATION_
#pragma mark PUSH NOTIFICATIONS
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	
	NSString *str = [NSString stringWithFormat:@"%@",deviceToken];
    
	NSString *newStr;
	if(str)
	{	
		newStr = [str stringByRemovingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" <>"]];
		setDeviceID = 1;
		[self setDeviceInforation:newStr];
	}
	
	//77ce8d8f 84ca6d40 41432d02 8d3aa87f bdd15f09 89be830d 473ee136 f1713a93
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {     

}
/*
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
	
	[self applicationDidFinishLaunching:application];
	application.applicationIconBadgeNumber = 0;
	printf("didFinishLaunchingWithOptions");
	
	return YES;
}
*/


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	[self profileResynFromApp];//profile Resyn
}


//#pragma mark STARTING POINT
- (void)applicationDidFinishLaunching:(UIApplication *)application { 
	
	/*	
	 NSLocale *locale = [NSLocale currentLocale];
	 NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
	 NSLog(@"%@",countryCode);
	 NSString *countryName = [locale displayNameForKey: NSLocaleCountryCode	value: countryCode];
	 NSLog(@"%@",countryName);
	 
	 */
	self->prefixavailable = FALSE;
	self->roaming = -1;
	self->callthroughSupported = -1;

	self.locationManager = [[CLLocationManager alloc] init];
	if (locationManager.locationServicesEnabled == NO)
	{
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be reenabled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [servicesDisabledAlert show];
        [servicesDisabledAlert release];
    }
	self.locationManager.delegate = self; // Tells the location manager to send updates to this object
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[locationManager startUpdatingLocation];
	[self performSelector:@selector(stopUpdatingCoreLocation:) withObject:@"Timed Out" afterDelay:10];
	[locationManager release]; 

	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
	//[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

		/*struct tm *tmP=0;
		//struct tm tmP1,tmP2;
		time_t timeP;
		timeP = time(0);
		tmP = localtime(&timeP);
		printf(" appstart %2d:%2d:%2d",tmP->tm_hour,tmP->tm_min,tmP->tm_sec);*/
		self->onLogB = 1;
		firstTimeB = 1;
		applicationLoadedB = 0;
		self->endAppB = 0;
		[self applicationInit:application];
			
}
#pragma mark Core Location methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
//	NSLog(@"\n\nNEW:%@\n\n", [newLocation description]);
//	NSLog(@"location x:%lf, y:%lf", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
//	NSLog(@"\n%@\n", newLocation.altitude);
//	NSLog(@"\n%@\n", newLocation.course);
//	NSLog(@"\n%@\n", newLocation.horizontalAccuracy);
//	NSLog(@"\n%@\n", newLocation.isAccessibilityElement);
//	NSLog(@"\n%@\n", newLocation.speed);
//	NSLog(@"\n%@\n", newLocation.timestamp);
//	NSLog(@"\n%@\n", newLocation.verticalAccuracy);
	//if(newLocation.coordinate.latitude && newLocation.coordinate.longitude){
	geoCoder=[[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
	geoCoder.delegate = self;
	[geoCoder start];
	//}
}
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
	NSLog(@"Reverse Geocoder Errored");
	
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	myPlacemark = placemark;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{
	NSLog(@"Error: %@", [error description]);
	
//	kCLErrorLocationUnknown  = 0,         // location is currently unknown, but CL will keep trying
//	kCLErrorDenied,                       // CL access has been denied (eg, user declined location use)
//	kCLErrorNetwork,                      // general, network-related error
//	kCLErrorHeadingFailure,               // heading could not be determined
//	kCLErrorRegionMonitoringDenied,       // Location region monitoring has been denied by the user
//	kCLErrorRegionMonitoringFailure,      // A registered region cannot be monitored
//	kCLErrorRegionMonitoringSetupDelayed  // CL could not immediately initialize region monitoring
	
	switch ([error code])
	{
		case kCLErrorDenied:
			//[errorString appendFormat:@"%@\n", NSLocalizedString(@"LocationDenied", nil)];
			break;
			
			
		case kCLErrorLocationUnknown:
			//[errorString appendFormat:@"%@\n", NSLocalizedString(@"LocationUnknown", nil)];
			//[self stopUpdatingCoreLocation:nil];
			break;
			
		case kCLErrorNetwork:
			//[errorString appendFormat:@"%@\n", NSLocalizedString(@"LocationUnknown", nil)];
			break;
		
		case kCLErrorHeadingFailure:
			//[errorString appendFormat:@"%@\n", NSLocalizedString(@"LocationUnknown", nil)];
			break;
			
		default:
			//[errorString appendFormat:@"%@ %d\n", NSLocalizedString(@"GenericLocationError", nil), [error code]];
			break;
	}
}
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
	NSLog(@"did update heading %@", [newHeading description]);
}
- (void)stopUpdatingCoreLocation:(NSString *)state
{
	[locationManager stopUpdatingLocation];
	locationManager.delegate = nil;	
	NSLog(@"\n\n\n\n\n");
	NSLog(@"country:%@", myPlacemark.country);
	NSLog(@"countryCode:%@", myPlacemark.countryCode);
//	NSLog(@"locality:%@", myPlacemark.locality);
//	NSLog(@"postalCode:%@", myPlacemark.postalCode);
//	NSLog(@"subLocality:%@", myPlacemark.subLocality);
//	NSLog(@"subAdministrativeArea:%@", myPlacemark.subAdministrativeArea);
//	NSLog(@"subThoroughfare:%@", myPlacemark.subThoroughfare);
//	NSLog(@"thoroughfare:%@", myPlacemark.thoroughfare);
	NSLog(@"\n\n\n\n\n");
	
	
	geodataP = [[geolocationData alloc] init];
	geodataP.country = myPlacemark.country;
	geodataP.countryCode =myPlacemark.countryCode;
	
	//NSLog(@"country:%@ countryCode:%@",geodataP.country, geodataP.countryCode);
}

-(void)registerUnregisterOriantation:(BOOL)registerB
{
	UIDevice *device = [UIDevice currentDevice];
	prioximityB = 0;
	if(registerB)
	{	
		[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(onOrientationChangeApp:)
												 name:UIDeviceOrientationDidChangeNotification
											   object:device];
	}
	else {
		[[NSNotificationCenter defaultCenter] removeObserver:self
												  name:UIDeviceOrientationDidChangeNotification
												   object:device];
	}


}
	
-(void)onOrientationChangeApp:(NSNotification *)notification
	{
		
		

		if(prioximityB)
		{	
			UIDevice *device = [notification object];
			if(device.orientation!=UIDeviceOrientationLandscapeLeft && device.orientation!=UIDeviceOrientationLandscapeRight)
			{
				if(VmsProtocolP)
				{	
					if(device.orientation!=UIDeviceOrientationUnknown)
					{
						[VmsProtocolP proximityChange:0];
					}
					else {
						[VmsProtocolP proximityChange:1];
					}

				}
				
			}	
			else {
				if(VmsProtocolP)
				{	
					[VmsProtocolP proximityChange:1];
				}
			}

		}	
	
	}
-(void)onCharging:(NSNotification *)notification
{
	UIDevice *device = [notification object];
	if (device.batteryState == UIDeviceBatteryStateCharging ||
		device.batteryState == UIDeviceBatteryStateFull) {
		[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
		
	}
	else
	{
		[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
	}
	
}
- (void) ProximityChange:(NSNotification *)notification {
		UIDevice *device = [notification object];
		

	if(VmsProtocolP)
	{	
		if(device.proximityState)
		{	
			[VmsProtocolP proximityChange:device.proximityState];
			prioximityB = 1;
		}	
	}
}	
/*
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
	
#pragma mark Actionsheet methods
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
	
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
		if(actionSheet.tag == 1)//call
		{
			switch(buttonIndex)
			{
				case 0:
					[self makeSipCallOrCallBack:numberToCall callType:1];
					break;
				case 1:
					[self makeSipCallOrCallBack:numberToCall callType:2];
					break;
				case 2:
				{
					int tmpN;
					tmpN = outCallType;
					outCallType = 3;
					[self makeCall:numberToCall];
					outCallType = tmpN;
					
				}	break;
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
*/
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	 shifttovmsTab = 0;
	 if(launchOptions == nil)
	 {
			shifttovmsTab = 0;
	 }
	 else
	 {
			shifttovmsTab = 1;
	 }
 
	 [self applicationDidFinishLaunching:application];
	 return YES;
 } 

	/*
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"APNS" message:[NSString stringWithFormat:@"%@", userInfo] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil] autorelease];
	[alert show];
}
*/


-(void)logOut:(Boolean) clearAllB
{
	[arrayCountries release];
	animation = 1;
	//popup all tab
	if(clearAllB)
	{
		[vmsNavigationController popToRootViewControllerAnimated:NO];
		[calllogNavigationController popToRootViewControllerAnimated:NO];
		[contactNavigationController popToRootViewControllerAnimated:NO];
		[spoknViewNavigationController popToRootViewControllerAnimated:NO];
		uaLoginSuccessB = 0;
		
		
	}
	[vmsviewP setcomposeStatus:0 ];
	logOut(ltpInterfacesP,clearAllB);
	self.vmsNavigationController.tabBarItem.badgeValue= nil;
	self.calllogNavigationController.tabBarItem.badgeValue= nil;
	SetSpeakerOnOrOff(0,true);
	self->onLineB = false;
	if(clearAllB)
	{
		[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"forwardnumber"]; 
		[[NSUserDefaults standardUserDefaults] synchronize];

	}
}
-(void)endApplication:(UIApplication *)application
	{
		
		[arrayCountries release];
		int count;
		if(self->endAppB)
			return;
		
		self->endAppB = true;
		//	printf("\napplicationWillTerminate  tese\n");
		[[NSUserDefaults standardUserDefaults] setInteger:getStunSettingInterface(ltpInterfacesP)+1  forKey:@"stunserversetting"];
		count = newVMailCount();
		if(count)
		{	
			char *userNameP = getLtpUserName(ltpInterfacesP);
			char *passwordCharP = getLtpPassword(ltpInterfacesP);
			if(userNameP&&passwordCharP)
			{	
				if(strlen(userNameP)==0 || strlen(passwordCharP)== 0 )
				{
					application.applicationIconBadgeNumber = 0;
				}
				else
				{
					application.applicationIconBadgeNumber = count;
				}
				free(userNameP);
				free(passwordCharP);
			}	
		}
		else
		{
			application.applicationIconBadgeNumber = 0;
		}
		
		
		
#ifndef _LTP_
		[nsTimerP invalidate];
		nsTimerP = nil;
#endif
		[[NSUserDefaults standardUserDefaults] setInteger:[tabBarController selectedIndex]+1  forKey:@"tabBarIndex"];
		
		if(contactlookupP)
		{	
			[contactlookupP release];
			contactlookupP = 0;
		}
		else
		{
			if(intiallookupP)
			{
				[intiallookupP appTerminate];
				intiallookupP = 0;
			}
			
		}
		[devicePushTokenStrP release];
		devicePushTokenStrP = nil;
		[ltpTimerP stopTimer ];
		ltpTimerP = 0;
		HangupAllCall(ltpInterfacesP);
		logOut(ltpInterfacesP,false);
		if(onoffSip)
		{
			sleep(2);
		}
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
		if(self->globalAddressP)
		{
			[self->globalAddressP release];
			self->globalAddressP =0;
			
		}
		//[contactNavigationController release];
		//[vmsNavigationController release];
		//[calllogNavigationController release];
		//[dialviewP release];
		/*
		struct tm *tmP=0;
		//struct tm tmP1,tmP2;
		time_t timeP;
		timeP = time(0);
		tmP = localtime(&timeP);
		printf(" appstop %2d:%2d:%2d",tmP->tm_hour,tmP->tm_min,tmP->tm_sec);
		*/
		
	
	}
	
- (void)applicationWillTerminate:(UIApplication *)application
{
	[countrylispP release];
	countrylispP = nil;
	[self endApplication:application];
		

	

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
	-(void)AcceptCall:(IncommingCallType*) inComP :(UIViewController*)perentControllerP
{
	[self stopRing];
	self->incommingCallList[inComP->lineid] = 0;
	
	
	
	dialviewP.currentView = 1;//mean show hang button
	[perentControllerP dismissModalViewControllerAnimated:NO];
	
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
	self->callNumber.direction = 2;
	self->callNumber.lineId = inComP->lineid;
	[dialviewP setStatusText:strP :strtypeP :INCOMMING_CALL_ACCEPTED :0 :inComP->lineid];
		//[tempStringP release];
		//[tempStringP release ];
	[strP release ];
	[strtypeP release];
	#ifdef __IPHONE_3_0
		[UIDevice currentDevice].proximityMonitoringEnabled = YES;
	#else
		[[UIApplication sharedApplication] setProximitySensingEnabled:YES];
	#endif
	
	//AcceptInterface(ltpInterfacesP, inComP->lineid);
	free(inComP);
	//[self changeView];
	

}
	-(void)RejectCall:(IncommingCallType *)inComP :(UIViewController*)parentViewP
{
	[self stopRing];
	[dialviewP setStatusText:0 :0 :INCOMMING_CALL_REJECT :0 :inComP->lineid];
	 //pjsua_call_answer(call_id, 180, NULL, NULL);
	RejectInterface(ltpInterfacesP, inComP->lineid);
	self->incommingCallList[inComP->lineid] = 0;
	free(inComP);
	//[ dialNavigationController popToViewController: dialviewP animated: YES ];
	[parentViewP dismissModalViewControllerAnimated:YES];
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
		int result = 0;
		char *addressBookNameP = 0;
		char *addressBookTypeP = 0;
		uID = getAddressUid(self->ltpInterfacesP);
		if(uID)
		{
			result = [ContactViewController	getNameAndType:self.addressRef :uID :pnumberP :&addressBookNameP :&addressBookTypeP];
			if(result==0)
			{	
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
					if(addressBookNameP)
					{	
						free(addressBookNameP);
					}	
					uID = 0;
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
#pragma mark ROAMING START
-(void) checkforRoaming
{
	NSString *xmlDataFromChannelSchemes;
	NSError *fileError = 0;
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"countrycodelist" ofType:@"txt"];
	NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:&fileError];
	if(fileError)
	{
		fileContents = @"";
	}	
	xmlDataFromChannelSchemes = [[NSString alloc] initWithString:fileContents];
	
	if(xmlDataFromChannelSchemes)
	{	
		xmlDataFromChannelSchemes = [[NSString alloc] initWithString:fileContents];
		//NSLog(@"%@",xmlDataFromChannelSchemes);
		NSData *xmlDataInNSData = [xmlDataFromChannelSchemes dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
		myxmlParser = [[NSXMLParser alloc] initWithData:xmlDataInNSData];
		myxmlParser.delegate = self;
		[myxmlParser parse];
		//NSLog(@"Error: %@", [myxmlParser.parserError localizedDescription]);
		[myxmlParser release];
		[xmlDataFromChannelSchemes release];
	
	}	
	
	NSString * tempPrefix = nil;
	tempPrefix = [[NSUserDefaults standardUserDefaults] stringForKey:@"prefix"];
	NSLog(@"\n sim country code %@",tempPrefix);
	if([tempPrefix length] == 0)
	{
		prefixavailable = FALSE;
	}
	else {
		prefixavailable = TRUE;
	}

	
	countrycodelist *tempCountrycodelistP;
	NSEnumerator * enumerator = [arrayCountries objectEnumerator];
	
	while(tempCountrycodelistP = [enumerator nextObject])
	{
		if([tempCountrycodelistP.prefix isEqualToString:tempPrefix])
		{
			NSLog(@"\n%@-%@",tempCountrycodelistP.prefix,tempPrefix);
			//if it enters here that means sim country code is equal to supported callthrough country code 
			callthroughSupported = 1; //Supported
			//printf("\ncallthroughSupported = %d\n",callthroughSupported);
			if([geodataP.countryCode isEqualToString:tempCountrycodelistP.code])
			{
				NSLog(@"\n%@-%@",geodataP.countryCode,tempCountrycodelistP.code);
				//if it enters here that means  2 digit country code matches with (sim country number + callthrough country code) 
				roaming = 0;
			}
			else {
				NSLog(@"\n%@-%@",geodataP.countryCode,tempCountrycodelistP.code);
				//he is in roaming
				roaming = 1;
			}
			break;
		}
	}
	if(callthroughSupported != 1)
	{
		
//		if([geodataP.countryCode isEqualToString:tempPrefix])
//		{
//			//if it enters here that means geo country code matches with sim country code but there is no callthrough number of this country
//			roaming = 0; //Local
//		}
//		else
//		{
//			roaming = 1; //Roaming
//			
//		}

		//if it enters here that means sim country code is NOT equal to supported callthrough country code 
		callthroughSupported = 0; // NOT supported
		roaming = 1; //Roaming
	}	
}

/* Called when the parser runs into an open tag (<tag>) */ 
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 	attributes:(NSDictionary *)attributeDict 
{
	if([elementName isEqualToString:@"spokn"])
	{
		arrayCountries = [[NSMutableArray alloc] init];
	}
	else if([elementName isEqualToString:@"country"])
	{
		countrycodelistP = [[countrycodelist alloc] init];
		countrycodelistP.name = [attributeDict objectForKey:@"name"];			
		countrycodelistP.code = [attributeDict objectForKey:@"code"];
		countrycodelistP.prefix = [attributeDict objectForKey:@"prefix"];
		//NSLog(@"\nname: %@ code: %@  prefix: %@\n", countrycodelistP.name, countrycodelistP.code,countrycodelistP.prefix);
	}
}


/* Called when the parser runs into a close tag (</tag>). */
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{
	if([elementName isEqualToString:@"spokn"])
	{
		NSSortDescriptor *alphaDesc = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(compare:)];
		[arrayCountries sortUsingDescriptors:[NSMutableArray arrayWithObjects:alphaDesc, nil]];	
		[alphaDesc release], alphaDesc = nil;
		return;
	}
	else if([elementName isEqualToString:@"country"])
	{
		[arrayCountries addObject:countrycodelistP];
		[countrycodelistP release];
		countrycodelistP = nil;
	}	

}
#pragma mark ROAMING END

-(void) setoutCallTypeProtocol:(int)type
{
#ifndef _CLICK_TO_CALL_
	outCallType = 1;
#else
	outCallType = type;
#endif
	
	
}
-(void)setcallthroughData:(id)objectP
{
	[countrylispP release];
	countrylispP = objectP;
	[countrylispP retain];
   // NSLog(@"\n %@ : %i :%@  :%i\n", countrylispP.name, countrylispP.code,countrylispP.secondaryname,countrylispP.number);
}
//text1 = [labelStringP stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" ()<>-./"]];

#pragma mark CALLING_START
-(Boolean)makeCall:(char *)noCharP
{
	NSLog(@"\n\n value of stream type %@",kCFStreamNetworkServiceType);
	//check for current location
	[self checkforRoaming];


	printf("\n edge=%i\n",self->edgevalue);
	printf("\n wifiavailable=%i\n",self->wifiavailable);
	printf("\n gprsavailable=%i\n",self->gprsavailable);
	printf("\n actualOnline=%i\n",self->actualOnlineB);
	printf("\n actualWiFi=%i\n",self->actualwifiavailable);
	printf("\n callthroughSupported=%i\n",self->callthroughSupported);
	printf("\n roaming=%i\n",self->roaming);
	
	#ifndef _CLICK_TO_CALL_
	outCallType = 1;
	#endif
	#ifdef _CALL_THROUGH_
	if(outCallType==3 ||  self->onlyCallThrough==1)
	#else
	if(outCallType==3)  //Means call-through is selected
	#endif	
	{
		return [self makeCallthrough:noCharP callType:outCallType];
	}
	if(outCallType==1|| outCallType==2)
	{	
		callthroughSupported = -1;
		return [self makeSipCallOrCallBack:noCharP callType:outCallType];
	}	
	else
	{
		
/********************************************************************************************************************/	
//		if(actualOnlineB==false)
//		{       
//			callthroughSupported = -1;
//			return [self makeSipCallOrCallBack:noCharP callType:outCallType];
//		}
//		else {        // Means "ALL" option is selected as PROTOCOL option
//		
//			strcpy(numberToCall,noCharP);
//			UIActionSheet *uiappActionSheetgP=0;
//			uiappActionSheetgP= [[[UIActionSheet alloc] 
//							  initWithTitle: @"Please select your prefrences" 
//							  delegate:self
//							  cancelButtonTitle:_CANCEL_ 
//							  destructiveButtonTitle:nil
//							  otherButtonTitles:@"Sip",@"CallBack",@"CallThrough", nil]autorelease];
//			uiappActionSheetgP.tag = 1;
//			uiappActionSheetgP.actionSheetStyle = UIBarStyleBlackTranslucent;
//			[uiappActionSheetgP showInView:[self tabBarController].view];
//			callthroughSupported = -1;
//			
//			return 0;
//			
//		}
//	}
/********************************************************************************************************************/			
		
		//First case NO Wifi/GPRS
		if(wifiavailable==NO && gprsavailable==NO)
		{
			printf("\n%s\n"," NO NETWORK ");
			//Tell the user of no connectivity and ask him to use call-through if he has local sim
			UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"NO NETWORK" 
															   message: [ NSString stringWithString:@"You can  use call-through feature if you have local sim." ]
															  delegate: nil
													 cancelButtonTitle: nil
													 otherButtonTitles: _OK_, nil
								  ];
			[ alert show ];
			[alert release];
		}	
		
		if(gprsavailable==YES &&  actualwifiavailable==NO)
		{
			//check for Location
			if(roaming) //He is in roaming
			{
//				
//				//If call quality is  Bad tell the user  to use call-through if he has local sim
//				UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"ALERT ROAMING" 
//																   message: [ NSString stringWithString:@"If call quality is  Bad  you can use call-through if he has local sim but higher charges may Apply." ]
//																  delegate: nil
//														 cancelButtonTitle: nil
//														 otherButtonTitles: _OK_, nil
//									  ];
//				[ alert show ];
//				[alert release];

				//By default on SIP
				return [self makeSipCallOrCallBack:noCharP callType:1];
				

			}
			else //He is in same country as his SIM
			{
				//check if it is spokn number
				if((strlen(noCharP)) <= 7)
				{
					CallViewController *tmpObjP;
					tmpObjP = [dialviewP getCallViewController];
					[(CallViewController*)tmpObjP setuserMessage:@"SIP"];
					//Means it is spokn number
					return [self makeSipCallOrCallBack:noCharP callType:1];
				}	
				else //it is not spokn number
				{
					if(self->callthroughSupported == 1)
					{	
						return [self makeCallthrough:noCharP callType:outCallType];
					}
					else
					{
							//Means callthrough number not supported
							return [self makeSipCallOrCallBack:noCharP callType:2];
					}

				}
				
			}
			
		}
		
		if(self->actualwifiavailable == YES && self->gprsavailable == YES)
		{
			//Both network are available 
			//By defaul it will be on Wifi
			printf("\n%s\n"," NETWORK AVAILABLE");
			//check for Location
			if(roaming) //He is in roaming
			{
					
				//By default on SIP
				return [self makeSipCallOrCallBack:noCharP callType:1];
				
			}
			else
			{
				//He is in same country as his SIM
				//By default on SIP
				return [self makeSipCallOrCallBack:noCharP callType:1];
			}
		}
		if(self->actualwifiavailable == YES && self->gprsavailable == NO)
		{
			printf("rishi");
			//check for Location
			if(roaming) //He is in roaming
			{
				
				//By default on SIP
				return [self makeSipCallOrCallBack:noCharP callType:1];
				
			}
			else
			{
				//He is in same country as his SIM
				//By default on SIP
				return [self makeSipCallOrCallBack:noCharP callType:1];
			}
			
		}
		
		
		
	}


	callthroughSupported = -1;
	return true;

}

-(Boolean)makeCallthrough:(char *)noCharP callType:(int) loutCallType
{
	/*		spoknid*pin*bpartyno.
	 where
	 spoknid : seven digit spokn id
	 e.g. 1234567
	 pin : 1st 5 digit(md5(pwd))
	 e.g. md5(vel) = d41d8cd98f00b204e9800998ecf8427e
	 1st 5 digit of md5 = d41d8
	 replace a = 6, b = 5, c = 4, d = 3, e = 2, f = 1(digit more than 9 subtract it with 16)
	 so the pin = 34138
	 bpartyno = 919821988975*/
	if(self->ipadOrIpod)
	{
		UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
														   message: [ NSString stringWithString:@"call through will only work on iphone." ]
														  delegate: nil
												 cancelButtonTitle: nil
												 otherButtonTitles: _OK_, nil
							  ];
		[ alert show ];
		[alert release];
		callthroughSupported = -1;
		return 0;
		
		
	}
	if(self->outCallType==4 && self->prefixavailable == FALSE)
	{
		UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
														   message: [ NSString stringWithString:@"Sim country code not entered." ]
														  delegate: nil
												 cancelButtonTitle: nil
												 otherButtonTitles: _OK_, nil
							  ];
		[ alert show ];
		[alert release];
		callthroughSupported = -1;
		return 0;
	
	}	
	char *unameCharP=0;
	char *encryptypasswordCharP=0;
	char *countrycodeCharP=0;
	char *countrynumberCharP=0;
	char number[50];
	NSString *finalnumber;
	if(countrylispP==nil)
	{
		countrylispP = [countrylist getCallThroughSavedObject ];
		if(countrylispP==nil)
		{
			UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
															   message: [ NSString stringWithString:@"Please select callthrough country." ]
															  delegate: nil
													 cancelButtonTitle: nil
													 otherButtonTitles: _OK_, nil
								  ];
			[ alert show ];
			[alert release];
			
			callthroughSupported = -1;
			return 0;
			
		}
		
	}
	
	NSTimeInterval time;
	char *resultCharP = 0;
	//char *contactNameP = 0;
	//char type[100];
	resultCharP = NormalizeNumber(noCharP,0);
	unameCharP = getLtpUserName(ltpInterfacesP);
	encryptypasswordCharP = getencryptedPassword();
	countrycodeCharP = (char*)[countrylispP.code cStringUsingEncoding:NSUTF8StringEncoding];
	countrynumberCharP = (char*)[countrylispP.number cStringUsingEncoding:NSUTF8StringEncoding];
	sprintf(number,"tel:+%s%s,0%s%s%s",countrycodeCharP,countrynumberCharP,unameCharP,encryptypasswordCharP,resultCharP);
	printf("\n%s\n",number);
	time = [[NSDate date] timeIntervalSince1970];
	setCallbackCdr(ltpInterfacesP,resultCharP,time);
	[self refreshallViews];
	finalnumber = [[NSString alloc] initWithUTF8String:number];
	//NSLog(@"final number : %@",finalnumber);
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:finalnumber]];
	free(unameCharP);
	free(encryptypasswordCharP);
	[finalnumber release];
	if(resultCharP)
	{
		free(resultCharP);
		resultCharP = 0;
	}
	callthroughSupported = -1;
	return 0;
}
-(int)getCallingMethod
{
	return self->currentMethodOfCall;
}
-(int)DoCurrentCallMethod:(int)currentMethod :(NSString**)nsP
{
	if(currentMethod<0)
	{
		currentMethod = self->currentMethodOfCall;
		
	}
	switch(currentMethod)
	{
		case 2:
		{
			NSTimeInterval time;
			NSString *callbackP;
			NSString *callerP;
			int result;
			
			callerP = (NSString*) [[NSUserDefaults standardUserDefaults] objectForKey:@"callbacknumber"];
			callbackP = [[NSString alloc] initWithUTF8String:self->callNumber.number] ;
			self->callNumber.direction = 0;
//			if([callerP length] == 0)
//			{
//				UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
//																   message: [ NSString stringWithString:@"Callback number is not entered." ]
//																  delegate: nil
//														 cancelButtonTitle: nil
//														 otherButtonTitles: _OK_, nil
//									  ];
//				[ alert show ];
//				[alert release];
//				return 0;
//			}  
			result = [spoknViewControllerP CallBackMe:callerP bparty:callbackP];
			time = [[NSDate date] timeIntervalSince1970];
			setCallbackCdr(ltpInterfacesP,self->callNumber.number,time);
			[self refreshallViews];
			[callbackP release];
			if(nsP)
			{	
			//*nsP = [NSString stringWithString:@"call back come"];
			//[nsP retain]
				switch(result)
				{
						
					case 200://Request Sucessful
					{	
						//NSLog(@"Request Sucessful");
						*nsP = [NSString stringWithString:@"Request Sucessful"];
					}	
						break;
						
					case 101://Auth Failed
					{	
						//NSLog(@"Invalid Spokn Id or Password");
						*nsP = [NSString stringWithString:@"Invalid Spokn Id or Password"];
					}	
						break;
						
					case 102://Invalid Input
					{	
						NSLog(@"Invalid Input");
						*nsP = [NSString stringWithString:@"call back come"];
					}	
						break;
						
						
					case 103://Bad aparty
					{	
						//NSLog(@"Bad aparty.");
						*nsP = [NSString stringWithString:@"Bad aparty."];
					}	
						break;
						
						
					case 104://Bad bparty
					{	
						//NSLog(@"Bad bparty.");
						*nsP = [NSString stringWithString:@"Bad bparty."];
					}	
						break;
						
	
					case 105://Billing details cannot be retrived
					{	
						//NSLog(@"Billing details cannot be retrived.");
						*nsP = [NSString stringWithString:@"Billing details cannot be retrived."];
					}	
						break;
						
					case 106://aparty not supported
					{	
						//NSLog(@"aparty not supported.");
						*nsP = [NSString stringWithString:@"aparty not supported."];
					}	
						break;
						
					case 107://bparty not supported
					{	
						//NSLog(@"bparty not supported");
						*nsP = [NSString stringWithString:@"bparty not supported"];
					}	
						break;
						
					case 108://No credits to make a call
					{	
						//NSLog(@"Not enough credits to make call.");
						*nsP = [NSString stringWithString:@"Not enough credits to make call."];
					}	
						break;
						
					default:
					{	
						//NSLog(@"Call failed due to an unknown error.");
						*nsP = [NSString stringWithString:@"Call failed due to an unknown error."];
					}	break;
						
						
						
				}
				
			}	
		}	
			break;
			
		case 3:
		{
			[self makeCallthrough:self->numberToCall callType:4];
		//	UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"CALLTHROUGH" 
//															   message: [ NSString stringWithString:@"ON CALLTHROUGH" ]
//															  delegate: nil
//													 cancelButtonTitle: nil
//													 otherButtonTitles: _OK_, nil
//								  ];
//			[ alert show ];
//			[alert release];
		}
			break;
		
	}
	return 0;

}
-(void) setCallType:(int)typeB
{
	self->currentMethodOfCall = typeB;
}
-(Boolean)makeSipCallOrCallBack:(char *)noCharP callType:(int) loutCallType
{
	//NSMutableString *tempStringP;
	NSString *strP;
	NSString *strtypP;
	NSString *tempP;
	NSString *temp1P;
	char *nameP;
	Boolean retB = false;
	char typeP[30];
	char *resultCharP=0;
	self->currentMethodOfCall = loutCallType;
	if(actualOnlineB==false &&loutCallType==1 )
	{
		if(self.onLineB)
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
				return retB;
			}
			else {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_SERVER_UNREACHABLE_ 
																message:VOIP_CALL_NOT_POSSIBLE
															   delegate:nil 
													  cancelButtonTitle:nil 
													  otherButtonTitles:_OK_, nil];
				[alert show];
				[alert release];
				return retB;
				
			}
		}	
	}
	//struct AddressBook *addressP;
	
	
	if(loutCallType==2 || loutCallType==3)
	{
		NSString *callerP;
		callerP = (NSString*) [[NSUserDefaults standardUserDefaults] objectForKey:@"callbacknumber"];
		if([callerP length] == 0)
		{
			UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
															   message: [ NSString stringWithString:@"Callback number is not entered." ]
															  delegate: nil
													 cancelButtonTitle: nil
													 otherButtonTitles: _OK_, nil
								  ];
			[ alert show ];
			[alert release];
			return 0;
		} 
		
		[dialviewP setStatusTextMessage:@"Call is routing via  CALLBACK . You will get an incoming call. You  change it by presseing Change Protocol Button. "];
		[dialviewP setStatusText:nil :nil :TRYING_CALL :0  :0];
	
		//int result;
		self->currentMethodOfCall = 2;
		resultCharP = NormalizeNumber(noCharP,0);
		strcpy(self->callNumber.number,resultCharP);
		self->callNumber.direction = 1;
		
		return 1;
	}
	
	
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
		
		resultCharP = NormalizeNumber(noCharP,0);
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
		if(roaming)
		{
			[dialviewP setStatusTextMessage:@"    Alert Roaming                  Call is routing via  SIP . You can change it by presseing Change Protocol Button. "];
		}
		else {
			[dialviewP setStatusTextMessage:@"Call is routing via  SIP . You can change it by presseing Change Protocol Button. "];
		}

		[dialviewP setStatusText:strP :temp1P :TRYING_CALL :0  :0];
				
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
	if(resultCharP)
	{	
		free(resultCharP);
	}	
	return retB;
		
	
}

-(Boolean)endCall:(int)lineid
{
	callOnB =false;
	
	//hangLtpInterface(self->ltpInterfacesP);
	[dialviewP setStatusText: @"call end" :nil :ALERT_DISCONNECTED :0 :lineid];
	//SetSpeakerOnOrOff(0,true);
	#ifdef __IPHONE_3_0
		[UIDevice currentDevice].proximityMonitoringEnabled = NO;
	#else
		[[UIApplication sharedApplication] setProximitySensingEnabled:NO];
	#endif
	//[tabBarController dismissModalViewControllerAnimated:YES];

	return true;
}
#pragma mark CALLING_END
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
//	if(self->firstTimeB )
//	{
//		self->firstTimeB = 0;
//		[self startRutine];
//	}
	prvCtlP = viewController;
}
-(void)tabBarController:(UITabBarController*)tabBarController didEndCustomizingViewController:(NSArray*)viewcontrollers
				changed:(BOOL)changed
{
	
}
#pragma mark VMS_START
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
			*noSecP= 1;
			return 0;
			//return 1;
			
		}
	}	
	return 0;
		


}
#pragma mark VMS_END
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
	[hostReach startNotifier];
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
	//	wifiavailable = NO;
		
	
	}



}
- (void) configureTextField: (Reachability*) curReach
{
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired=[curReach connectionRequired];
  //  NSString* statusString= @"";
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
			
			alertNotiFication(ALERT_OFFLINE,0,NO_WIFI_OR_DATA_NETWORK_REACHEBLE,(long)self,0);
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
					gprsavailable = YES;
					actualwifiavailable = NO;
					if(SetConnection( ltpInterfacesP,2)==0)
					{	 
						[spoknViewControllerP startProgress];
						//	 [vmsviewP setcomposeStatus:1 ];
					}	
				}
				else
				{
					gprsavailable = NO;
					wifiavailable = NO;
					actualwifiavailable = NO;
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
				 actualwifiavailable = YES;
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
       // statusString= [NSString stringWithFormat: @"%@, Connection Required %d", statusString,netStatus];
		SetConnection( ltpInterfacesP,0);
		
		alertNotiFication(ALERT_OFFLINE,0,NO_WIFI_OR_DATA_NETWORK_REACHEBLE,(long)self,0);
		wifiavailable = NO;
		gprsavailable = NO;
		actualwifiavailable = NO;
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
//#define G4_DEFINE
#ifdef G4_DEFINE	
#ifdef __IPHONE_4_0	
	
#pragma mark 4gfunction
	- (void)applicationWillResignActive:(UIApplication *)application {
		/*
		 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
		 */
	}
	
		
	- (void)applicationDidEnterBackground:(UIApplication *)application {
		
	
		if(self->isBackgroundSupported==NO)
		{
			//[self endApplication:application];
			return;
		}

	#ifndef _LTP_
			[nsTimerP invalidate];
			nsTimerP = nil;
			
	#endif
		int count;
		count = newVMailCount();
		if(count)
		{	
			application.applicationIconBadgeNumber = count;
			
		}
		else
		{
			application.applicationIconBadgeNumber = 0;
		}
		
		
		/*
		 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
		 If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
		 */
		//- (BOOL)setKeepAliveTimeout:(NSTimeInterval)timeout handler:(void(^)(void))keepAliveHandler __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
		inbackgroundModeB = true;
		if(self.onLineB==false)
		{
			char*userNameP=0;
			char *passwordCharP=0;
			userNameP = getLtpUserName(ltpInterfacesP);
			passwordCharP = getLtpPassword(ltpInterfacesP);
			if(userNameP&&passwordCharP)
			{	
				if(strlen(userNameP)==0 || strlen(passwordCharP)== 0 )
				{
					application.applicationIconBadgeNumber = 0;
					free(userNameP);
					free(passwordCharP);
					[application clearKeepAliveTimeout];
					bg_task = 	 [application beginBackgroundTaskWithExpirationHandler: ^{
						dispatch_async(dispatch_get_main_queue(), ^{
							//printf("\nI am going to expire\n");
							[application endBackgroundTask:bg_task];
							
						});
					}];
				//	[application endBackgroundTask:bg_task];
					return;
					
				}
				free(userNameP);
				free(passwordCharP);
			}
			else {
				[application clearKeepAliveTimeout];
				bg_task = 	 [application beginBackgroundTaskWithExpirationHandler: ^{
					dispatch_async(dispatch_get_main_queue(), ^{
						//printf("\nI am going to expire\n");
						[application endBackgroundTask:bg_task];
						
					});
				}];
			//	[application endBackgroundTask:bg_task];
				
				
				return;
			}

		
		}
	//	printf("\nbackground time %lf ",[application backgroundTimeRemaining] );
		[ application setKeepAliveTimeout:600 handler:^{
		
			//printf("\n hello mukesh where are u");
		} ];
		
		//NSLog(@"Application entered background state.");
		// UIBackgroundTaskIdentifier bgTask is instance variable
			
		bg_task = 	 [application beginBackgroundTaskWithExpirationHandler: ^{
			dispatch_async(dispatch_get_main_queue(), ^{
				//printf("\nI am going to expire\n");
				//[application endBackgroundTask:bg_task];
				
			});
		}];
		
		/*dispatch_async(dispatch_get_main_queue(), ^{
			while ([application backgroundTimeRemaining] > 1.0) {
				/*NSString *friend = @"mukesh";//[self checkForIncomingChat];
				if (friend) {
					UILocalNotification *localNotif = [[UILocalNotification alloc] init];
					if (localNotif) {
						localNotif.alertBody = [NSString stringWithFormat:
												NSLocalizedString(@"%@ has a message for you.", nil), friend];
						localNotif.alertAction = NSLocalizedString(@"Read Msg", nil);
						localNotif.soundName = @"alarmsound.caf";
						localNotif.applicationIconBadgeNumber = 1;
						[application presentLocalNotificationNow:localNotif];
						[localNotif release];
						friend = nil;
						break;
					}
				}
				printf("\nmy message %lf",[application backgroundTimeRemaining]);
				
			}
			//[application endBackgroundTask:tmp1];
			
		});*/
		
	}
	
	
	- (void)applicationWillEnterForeground:(UIApplication *)application {
		/*
		 Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
		 */
		if(self->isBackgroundSupported==YES)
		{	
			[self checkChangesInSetting ];
		}	
		inbackgroundModeB = false;
		if(intrrruptB)
		{
			intrrruptB = 0;
			if(callOnB)
			{
				AudioSessionSetActive(true);
				//printf("\n inttrrept come");
				restartPlayAndRecord();
				setHoldInterface(self->ltpInterfacesP, 0);
				intrrruptB = 0;
				
			}
		}
	}
	
	
	- (void)applicationDidBecomeActive:(UIApplication *)application {
		/*
		 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		 */
	/*if(applicationLoadedB==false)
	{	
		[self applicationInit:application];
		applicationLoadedB = true;
	}	
		*/
		inbackgroundModeB = false;
		
#ifndef _LTP_COMPILE_
		
		if(onLineB)
		{	
			[nsTimerP invalidate];
			nsTimerP = nil;
			nsTimerP = [NSTimer scheduledTimerWithTimeInterval: MAXTIME_RESYNC
					
													target: self
					
												  selector: @selector(handleTimer:)
					
												  userInfo: nil
					
												   repeats: YES];
			profileResync();
			
		}	
#endif
		
		
		
	}
	- (void)sendIncommingPushNotification:(NSString*)msgStringP
	{
		UIApplication* app = [UIApplication sharedApplication];
		NSArray*    oldNotifications = [app scheduledLocalNotifications];
		//NSDate* theDate,*newDate;
		//theDate = [NSDate date];
		//newDate = [theDate dateByAddingTimeInterval:2];
		
		// Clear out the old notification before scheduling a new one.
		
		if ([oldNotifications count] > 0)
			[app cancelAllLocalNotifications];
		
		// Create a new notification
		Class UInotificationTest =  NSClassFromString(@"UILocalNotification");
		if(UInotificationTest)	
		{

			UILocalNotification* alarm = [[[UInotificationTest alloc] init] autorelease];
			if (alarm)
			{
			//alarm.fireDate = newDate;
			//alarm.timeZone = [NSTimeZone defaultTimeZone];
				alarm.repeatInterval = 0;
			//alarm.soundName = @"alarmsound.caf";
				alarm.alertBody = msgStringP;
			
			//[app scheduleLocalNotification:alarm];
				[app presentLocalNotificationNow:alarm];
			}	
		}
	}
#endif
#endif	
@end
