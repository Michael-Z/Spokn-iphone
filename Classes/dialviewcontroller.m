
//  Created on 01/07/09.

/**
 Copyright 2009,2010 Geodesic, <http://www.geodesic.com/>
 
 Spokn SIP-VoIP for iPhone and iPod Touch.
 
 This file is part of Spokn iphone.
 
 Spokn iphone is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 Spokn iphone is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Spokn iphone.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "dialviewcontroller.h"
#import "Ltptimer.h"
#import "LtpInterface.h"
#import "SpoknAppDelegate.h"
#import "spoknalert.h"
#include "time.h"
#import "keypadview.h"
#import "callviewcontroller.h"
#import <AudioToolbox/AudioToolbox.h>
@implementation DialviewController
const static char _keyValues[] = {0, '1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'};
static SystemSoundID sounds[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
@synthesize ltpInterfacesP;
@synthesize currentView;
- (void)keyPressedDown:(NSString *)stringkey keycode:(int)keyVal
{
		
	//NSLog(@"%@   %d",stringkey ,keyVal);
	NSString *curText = [numberlebelP text];
	int length = [curText length];
	
	if(length==0)
	{	
		statusLabel1P.hidden = YES;
		statusLabel2P.hidden = YES;
	}
	if([curText length]<NUMBER_RANGE)
	{
		if([stringkey isEqualToString:@"+"])
		{
			[self deleteRepeat];
			statusLabel1P.hidden = YES;
			statusLabel2P.hidden = YES;
			NSString *curText = [numberlebelP text];
			[numberlebelP setText:[curText stringByAppendingString:stringkey]];
		}
		else
		{	
			[numberlebelP setText: [curText stringByAppendingString: stringkey]];
		}
	}	
	if( [stringkey isEqualToString:@"*"] )
	{
		_downKey = 10;
	}
	else if( [stringkey isEqualToString:@"0"] )
	{
		_downKey = 11;
	}
	else if( [stringkey isEqualToString:@"#"] )
	{
		_downKey = 12;
	}
	else
	{
		_downKey = [stringkey intValue];
	}	
	[self playSoundForKey:_downKey];

}

- (void)playSoundForKey:(int)key
{
	if (!sounds[key])
	{
		NSBundle *mainBundle = [NSBundle mainBundle];
		NSString *filename = [NSString stringWithFormat:@"dtmf-%c", (key == 10 ? 's' : _keyValues[key])];
		NSString *path = [mainBundle pathForResource:filename ofType:@"aif"];
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
			
			sounds[_downKey] = aSoundID;
		}
	}
	
	AudioServicesPlaySystemSound(sounds[_downKey]);
}
- (void)keyPressedUp:(NSString *)stringkey keycode:(int)keyVal
{

}


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		[self.tabBarItem initWithTitle:@"Keypad" image:[UIImage imageNamed:@"Dial.png"] tag:3];
		callingstringP = nil;
		callingstringtypeP = nil;
    }
    return self;
}

- (IBAction)valueChanged: (id)sender
{
	
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
//	[self dismissKeyboard:numberFieldP];
	
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
	if(currentView==1)//mean call is on, send dtmp tone
	{
		char *numbercharP;
		numbercharP = (char*)[string cStringUsingEncoding:NSUTF8StringEncoding];
		SendDTMF(ltpInterfacesP,0,numbercharP);
	
	}
	//NSLog(string);
	////////printf("\n mukesh");
	return YES;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  //  [super viewDidLoad];
	//numberFieldP.text = @"19176775362";
	//numberFieldP.text = @"19176775335";
	//numberFieldP.text = @"919967358084";
	
	//self.tabBarItem = [UITabBarItem alloc];
	//[self.tabBarItem initWithTitle:@"Dial" image:nil tag:2];
	/*self.navigationItem.leftBarButtonItem 
	= [ [ [ UIBarButtonItem alloc ]
		 initWithTitle: @"Login" style:UIBarButtonItemStylePlain
		 target: self
		 action: @selector(LoginPressed) ] autorelease ];*/
	currentView = 0;
	
	//[statusLabelP setText:@"not logged in"];
//	[activityIndicator stopAnimating]; 
	//statusLabelP.textAlignment=UITextAlignmentCenter;
	keypadmain.objectId = 0;
	//keypadmain.dataStringP = @"mukesh\nsharma";
	[keypadmain setImage:@"dialerkeypad.png" : @"dialerkeypad_pressed.png"];
	[keypadmain setElement:3 :4];
	keypadmain.keypadProtocolP = self;
	
	callButtonP.exclusiveTouch = YES;
	hangUpButtonP.exclusiveTouch = YES;
	/*
	segmentedControl = [ [ UISegmentedControl alloc ] initWithItems: nil ];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	
	[ segmentedControl insertSegmentWithTitle: @"Call " atIndex: 0 animated: YES ];
	[ segmentedControl insertSegmentWithTitle: @"Vms " atIndex: 1 animated: YES ];
	
	[ segmentedControl addTarget: self action: @selector(controlPressed:) forControlEvents:UIControlEventValueChanged ];
	
	self.navigationItem.titleView = segmentedControl;
	segmentedControl.selectedSegmentIndex = 0;
	*/ 
	status = 0;
	subStatus = 0;
	//[numberFieldP becomeFirstResponder];
	//numberFieldP.delegate = self;
	/*
	[callButton setImage:[UIImage imageNamed:@"answer.png"] 
				 forState: UIControlStateNormal];
	callButton.imageEdgeInsets = UIEdgeInsetsMake (0., 0., 0., 5.);
	[callButton setTitle:@"Sip" forState:UIControlStateNormal];
	callButton.titleShadowOffset = CGSizeMake(0,-1);
	[callButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
	[callButton setTitleShadowColor:[UIColor colorWithWhite:0. alpha:0.2]  forState:UIControlStateDisabled];
	[callButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
	[callButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5]  forState:UIControlStateDisabled];
	callButton.font = [UIFont boldSystemFontOfSize:26];
	callButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"call.png"]];
	*/

}
-(void) LoginPressed {
		alertNotiFication(LOAD_VIEW,0,LOAD_LOGIN_VIEW,(unsigned long)self->ownerobject,0);
		[self.navigationItem.leftBarButtonItem initWithTitle: @"Logout" style:UIBarButtonItemStylePlain
		 target: self
		 action: @selector(LogoutPressed) ] ;

}
-(void) LogoutPressed {
	
	logOut(ltpInterfacesP,true);
	//statusLabelP. textAlignment=UITextAlignmentCenter;
	//[statusLabelP setText:@""];
	[self.navigationItem.leftBarButtonItem initWithTitle: @"Login" style:UIBarButtonItemStylePlain
	 target: self
	 action: @selector(LoginPressed) ] ;
	//[activityIndicator stopAnimating]; 
	//[activityIndicator startAnimating];
	
	
}	
/*
- (void)controlPressed:(id) sender {
	//[ self setPage ];
	int index = segmentedControl.selectedSegmentIndex;
	////////printf("%d",index);
	//index = 1;
	switch(index)
	{
		case  1:
		{
			char *numbercharP;
			numbercharP = (char*)[[numberFieldP text] cStringUsingEncoding:1];
			if(strlen(numbercharP)>5)
			{	
				char *numcharP;
				numcharP = malloc(strlen(numbercharP)+10);
				strcpy(numcharP,numbercharP);
				[ownerobject vmsRecordStart:numcharP];
			}	
		}
			break;
			
	}
}
 */
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	//printf("\n dialview dealloc");
	int i;
	for (i = 1; i < 13; ++i)
		if (sounds[i])
		{
			AudioServicesDisposeSystemSoundID(sounds[i]);
			sounds[i] = 0;
		}
	[calltimerP release];
	[callingstringP release];
	if(callingstringtypeP != nil)
	{	
		[callingstringtypeP release];
	}
	
	//[statusLabelP release];
	//[numberFieldP release];
    [super dealloc];
}
-(void)setObject:(id) object 
{
	self->ownerobject = object;
}
-(void)setViewButton:(int)viewButton
{
	currentView = viewButton;
	switch(currentView)
	{
		case 0:
			[hangUpButtonP setTitle:@"VMS" forState:UIControlStateNormal];
			break;
		case 1:
			[hangUpButtonP setTitle:@"Hang" forState:UIControlStateNormal];
			break;
	}
	

}
- (void)stopTimer
{
	if (_deleteTimer)
	{
		[_deleteTimer invalidate];
		[_deleteTimer release];
		_deleteTimer = NULL;
	}
}
- (void)deleteRepeat
{
	/*NSString *curText = [_label text];
	int length = [curText length];
	if(length > 0)
	{
		[_label setText: [curText substringToIndex:(length-1)]];
	}
	else
	{
		[self stopTimer];
	}
	if (length == 1)
	{
		//_callButton.enabled = NO;
	}*/
	NSString *curText = [numberlebelP text];
	int length = [curText length];
	if(length > 0) 
	{
		[numberlebelP setText: [curText substringToIndex:(length-1)]];
		curText = [numberlebelP text];
		length = [curText length];
	}
	else
	{
		[self stopTimer];
	}
	if(length==0)
	{
		statusLabel1P.hidden = NO;
		statusLabel2P.hidden = NO;
	}
	
}
-(IBAction)backkeyPressed:(id)sender
{
	[self deleteRepeat];
/*	NSString *curText = [numberlebelP text];
	int length = [curText length];
	if(length > 0)
	{
		[numberlebelP setText: [curText substringToIndex:(length-1)]];
		curText = [numberlebelP text];
		length = [curText length];
	}
	if(length==0)
	{
		statusLabel1P.hidden = NO;
		statusLabel2P.hidden = NO;
	}*/
	_deleteTimer = [[NSTimer scheduledTimerWithTimeInterval:0.2 target:self 
												   selector:@selector(deleteRepeat) 
												   userInfo:nil 
													repeats:YES] retain];
	
	
}
-(IBAction)backkeyReleased:(id)sender
{
	[self stopTimer];
}
-(IBAction)callLtp:(id)sender
{
	//[self->ownerobject->navigationController pushViewController: ownerobject.inCommingCallViewP animated: YES ];
	//printf("\n %d %d",onLineB,self->onLineB);
	if(onLineB)
	{	
		char *numbercharP;
		numbercharP = (char*)[[numberlebelP text] cStringUsingEncoding:NSUTF8StringEncoding];
		if(numbercharP==NULL || strlen(numbercharP)==0)
		{
			
			if(strlen(lastTypeNo)==0)
			{
				alert = [ [ UIAlertView alloc ] initWithTitle: @"Error" 
																   message: [ NSString stringWithString:@"Please enter a valid number." ]
																  delegate: nil
														 cancelButtonTitle: nil
														 otherButtonTitles: @"OK", nil
									  ];
				[ alert show ];
				;
				
			}
			else
			{
				numberlebelP.text = [NSString stringWithUTF8String:lastTypeNo];
				statusLabel1P.hidden = YES;
				statusLabel2P.hidden = YES;
			}
			return;
		}
		strcpy(lastTypeNo,numbercharP);
		if([ownerobject makeCall:numbercharP])
		{	
			currentView = 1;
			[hangUpButtonP setTitle:@"Hang" forState:UIControlStateNormal];
			numberlebelP.text = @"";
			statusLabel1P.hidden = NO;
			statusLabel2P.hidden = NO;
		}	
	}
	else
	{
		char *numbercharP;
		numbercharP = (char*)[[numberlebelP text] cStringUsingEncoding:NSUTF8StringEncoding];
		if(numbercharP==NULL || strlen(numbercharP)==0)
		{
			
			if(strlen(lastTypeNo)==0)
			{
				alert = [ [ UIAlertView alloc ] initWithTitle: @"Error" 
																   message: [ NSString stringWithString:@"Please enter a valid number." ]
																  delegate: nil
														 cancelButtonTitle: nil
														 otherButtonTitles: @"OK", nil
									  ];
				[ alert show ];
				
			}
			else
			{
				numberlebelP.text = [NSString stringWithUTF8String:lastTypeNo];
				statusLabel1P.hidden = YES;
				statusLabel2P.hidden = YES;
			}
			return;
		}
		strcpy(lastTypeNo,numbercharP);
		
		if(self->ownerobject.loginProgressStart)
		{	
			alert = [ [ UIAlertView alloc ] initWithTitle: @"" 
														   message: [ NSString stringWithString:@"User not online" ]
														  delegate: nil
												 cancelButtonTitle: nil
												 otherButtonTitles: @"OK", nil
							  ];
			[ alert show ];
			
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
			
		}
		//[self dismissKeyboard:numberFieldP];

		
	}
}
-(IBAction)hangLtp:(id)sender
{
	//if(onLineB)
	//{
		
		if(currentView==1)
		{	
			hangLtpInterface(ltpInterfacesP);
			//[self dismissKeyboard:numberFieldP];
			currentView = 0;
		//	[hangUpButtonP setTitle:@"Vms" forState:UIControlStateNormal];
		}
		else
		{
			char *numbercharP;
			numbercharP = (char*)[[numberlebelP text] cStringUsingEncoding:NSUTF8StringEncoding];
			//if(strlen(numbercharP)>5)
			{	
				//char *numcharP;
				//numcharP = malloc(strlen(numbercharP)+10);
				//strcpy(numcharP,numbercharP);
				if(numbercharP==NULL || strlen(numbercharP)==0)
				{
					
					if(strlen(lastTypeNo)==0)
					{
						alert = [ [ UIAlertView alloc ] initWithTitle: @"Error" 
																		   message: [ NSString stringWithString:@"please enter the number." ]
																		  delegate: nil
																 cancelButtonTitle: nil
																 otherButtonTitles: @"OK", nil
											  ];
						[ alert show ];
						
						
					}
					else
					{
						numberlebelP.text = [NSString stringWithUTF8String:lastTypeNo];
						statusLabel1P.hidden = YES;
						statusLabel2P.hidden = YES;
					}
					return;
				}
				strcpy(lastTypeNo,numbercharP);
				
				
				
				
				[ownerobject vmsShowRecordScreen:numbercharP];
				numberlebelP.text = @"";
				statusLabel1P.hidden = NO;
				statusLabel2P.hidden = NO;
			}	
		}
	//}
	/*else
	{
		UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"Error" 
														   message: [ NSString stringWithString:@"user not online"]
														  delegate: nil
												 cancelButtonTitle: nil
												 otherButtonTitles: @"OK", nil
							  ];
		[ alert show ];
		[alert release];
	//	[self dismissKeyboard:numberFieldP];

		
	
	}*/
}
-(IBAction)dismissKeyboard: (id)sender {
	[sender resignFirstResponder];
}
- (void) handleCallTimer: (id) timer
{
	self->timecallduration++;
	time_t timeP = {0};
	//struct tm  tmLoc;
	//struct tm *tmP=0;
	//readSocketData(self->ltpInterfacesP);//read socket
	
	timeP = self->timecallduration;
	
	if(sec>59)
	{
		min++;
		sec=0;
	}
	if(min>59)
	{
		min = 0;
		hour++;
	}
	//	tmLoc.tm_sec = 
	//tmP = localtime(&timeP);
	//if(tmP)
	{	
		char s1[20];
		NSString *stringStrP;
		//sprintf(s1,"%02d:%02d:%02d",tmLoc.tm_hour,tmLoc.tm_min,tmLoc.tm_sec);
		sprintf(s1,"%02d:%02d:%02d",hour,min,sec);
		stringStrP = [[NSString alloc] initWithUTF8String:s1 ];
		//[statusLabelP setText:stringStrP];
		[stringStrP release];
		
	}
	sec++;
}
- (void) handleCallTimerHang: (id) timer
{
	printf("\n hang timer ");
	hangLtpInterface(ownerobject.ltpInterfacesP);
	timecallduration = 0;
	[(NSTimer*)timer invalidate];
	

}
- (void) handleCallTimerEnd: (id) timer
{
	//[statusLabelP setText:@"end call"];
	
	hangLtpInterface(ownerobject.ltpInterfacesP);
	timecallduration = 0;
	[(NSTimer*)timer invalidate];
	profileResync();//to get balance
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation
{
	
	//	//printf("\n%d",buttonIndex);
	
	if(buttonIndex==0 && invalidUserB)
	{	
		alertNotiFication(LOAD_VIEW,0,LOAD_LOGIN_VIEW,(unsigned long)self->ownerobject,0);
		invalidUserB = false;
	}
	[alertView release];
	alert = nil;
	
	//[alertView release];
}

-(void) setButton:(id) sender
{
	switch(self->status)
	{
		case START_LOGIN:
			//statusLabelP. textAlignment=UITextAlignmentLeft;

		//	[activityIndicator startAnimating];
			[self.navigationItem.leftBarButtonItem initWithTitle: @"Cancel" style:UIBarButtonItemStylePlain
			 target: self
			 action: @selector(LogoutPressed) ] ;
			

			break;
		case ALERT_ONLINE:	
			{
				NSString *stringStrP;
				char *unameP;
				[alert dismissWithClickedButtonIndex:0 animated:NO]	;
				[alert release];
				alert = nil;
				unameP = getLtpUserName(ltpInterfacesP);
				if(unameP && strlen(unameP)>0)
				{	
					
					stringStrP = [[NSString alloc] initWithUTF8String:unameP ];
					//[ltpNameLabelP setText:stringStrP];
					[stringStrP release];
					free(unameP);
				
				}	
			
				//statusLabelP. textAlignment=UITextAlignmentCenter;
		
				[self.navigationItem.leftBarButtonItem initWithTitle: @"Logout" style:UIBarButtonItemStylePlain
				 target: self
				 action: @selector(LogoutPressed) ] ;
				//[self->ownerobject popLoginView];
				//printf("\n online code");
				onLineB = true;
				//printf("\n %d",self->onLineB);
			//	[activityIndicator stopAnimating];
			}	
			break;
		case ALERT_OFFLINE:
		//	statusLabelP. textAlignment=UITextAlignmentCenter;
			if(alert)
			{	
				if(alert.tag!=self->subStatus && alert.tag!=LOGIN_STATUS_FAILED)
				{	
					[alert dismissWithClickedButtonIndex:0 animated:NO]	;
					[alert release];
					alert = nil;
				}
				
			}	
			//[alert]
			switch(self->subStatus)
			{
				
				case HOST_NAME_NOT_FOUND_ERROR:
					alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
														  message: [ NSString stringWithString:@"Server not richable" ]
														 delegate: self
												cancelButtonTitle: nil
												otherButtonTitles: @"OK", nil
							 ];
					invalidUserB = true;
					alert.tag=self->subStatus;
					
					//[alert addButtonWithTitle:@"Cancel"];
					[ alert show ];
					break;
				case LOGIN_STATUS_OFFLINE:
					if(alert==nil)
					{	
						alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
															  message: [ NSString stringWithString:@"Server not richebale" ]
															 delegate: self
													cancelButtonTitle: nil
													otherButtonTitles: @"OK", nil
								 ];
						//invalidUserB = true;
						alert.tag=self->subStatus;
						
						//[alert addButtonWithTitle:@"Cancel"];
						[ alert show ];
					}	
					break;
				case LOGIN_STATUS_FAILED:
					{	
						if(alert==nil)
						{	
							alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
									   message: [ NSString stringWithString:@"Authentication failed" ]
									  delegate: self
				 					 cancelButtonTitle: nil
									 otherButtonTitles: @"OK", nil
									  ];
							invalidUserB = true;
							alert.tag=self->subStatus;
							
				//[alert addButtonWithTitle:@"Cancel"];
							[ alert show ];
						}	
						//[alert release];
				
						break;
					}
					break;
				case LOGIN_STATUS_NO_ACCESS:
				{	
					
						
					if(alert==nil)
					{	
						alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
															  message: [ NSString stringWithString:@"Network is not available" ]
															 delegate: self
													cancelButtonTitle: nil
													otherButtonTitles: @"OK", nil
								 ];
						
						alert.tag=self->subStatus;
						
						//[alert addButtonWithTitle:@"Cancel"];
						[ alert show ];
					}		
						//[alert addButtonWithTitle:@"Cancel"];
												
						
					
					break;
				}
					break;
				default:
				{
					
					if(alert==nil)
					{		
						alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
																	   message: [ NSString stringWithString:@"Unable to connect server." ]
																	  delegate: self
															 cancelButtonTitle: nil
															 otherButtonTitles: @"OK", nil
										  ];
					//[alert addButtonWithTitle:@"Cancel"];
						alert.tag=self->subStatus;
						[ alert show ];
						
						
					}	
					
					break;
					
				}
					
					
			}
			//[self->ownerobject popLoginView];
			[self setViewButton:0];
		//	[activityIndicator stopAnimating];
			////printf("\n offline code");
			onLineB = false;
			break;
		case ALERT_CONNECTED:
			if(calltimerP==nil)
			{	
				/*calltimerP = [NSTimer scheduledTimerWithTimeInterval: 1
													  target: self
													selector: @selector(handleCallTimer:)
													userInfo: nil
													 repeats: YES];*/
				//timecallduration = time(0);
				timecallduration = 0;
				hour = 0;
				min = 0;
				sec = 0;
				//disconnectet call
				if(callViewControllerP==0)
				{
					
					printf("\n sdbarman");
					//hangLtpInterface(ownerobject.ltpInterfacesP);
					calltimerP = [NSTimer scheduledTimerWithTimeInterval: 0.5
																  target: self
																selector: @selector(handleCallTimerHang:)
																userInfo: nil
																 repeats: YES];
					
					printf("\n call end");
					//dont get panic it will release in handleCallTimerend
					calltimerP = nil;
					
					break;
				
				}
				else
				{
						printf("\n shankarjaikishan");
				}	
				[callViewControllerP startTimer];
			}	
			
		case TRYING_CALL:
			
			//[self setViewButton:1];
			printf("\n try calling");
			if(callViewControllerP==0)
			{	
				AudioSessionSetActive(true);
				//SetAudioTypeLocal(self,0);
				//setHoldInterface(ownerobject.ltpInterfacesP, 0);
				callViewControllerP = [[CallViewController alloc] initWithNibName:@"callviewcontroller" bundle:[NSBundle mainBundle]];
				[callViewControllerP setObject:self->ownerobject];
				
				//callViewControllerP.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;

				[callViewControllerP setLabel:callingstringP :callingstringtypeP];
				
				[ownerobject.tabBarController presentModalViewController:callViewControllerP animated:YES];
				
				if([callViewControllerP retainCount]>1)
					[callViewControllerP release];
				
			}	
			[numberlebelP setText:@""];
			statusLabel1P.hidden = NO;
			statusLabel2P.hidden = NO;

			

			break;
		case END_CALL_PRESSED:
				[self setViewButton:0];
			[callViewControllerP stopTimer];
				callViewControllerP = 0;
			break;
		case ALERT_DISCONNECTED:
			printf("\n call disconnected");
			[self setViewButton:0];
			[calltimerP invalidate];
			timecallduration = [callViewControllerP stopTimer];
			//[ownerobject.tabBarController dismissModalViewControllerAnimated:YES];
			callViewControllerP = 0;
			////printf("\ndisconnected");
			calltimerP = nil;
			//again for show time for sec
			if(calltimerP==nil)
			{	
				if(timecallduration>0)//mean it is connected
				{	
					calltimerP = [NSTimer scheduledTimerWithTimeInterval: 2
															  target: self
															selector: @selector(handleCallTimerEnd:)
															userInfo: nil
															 repeats: YES];
					
					printf("\n call end");
					//dont get panic it will release in handleCallTimerend
					calltimerP = nil;
					timecallduration = -1;
					[ownerobject playcallendTone];
				}	
				//timecallduration = time(0);
				
			}	
			
			
			break;
			case UA_ALERT://update balance 
			{
				float balfloat = getBalance();
				balfloat = balfloat/100;
				char s1[20];
				NSString *stringStrP;
				sprintf(s1,"$ %.2f",balfloat);
				stringStrP = [[NSString alloc] initWithUTF8String:s1 ];
				//[balanceLabelP setText:stringStrP];
				[stringStrP release];
				
				
			}	
	}		
	

}

-(void)setStatusText:(NSString *)strP :(NSString *)strtypeP :(int)lstatus :(int)lsubStatus
{
	//statusLabelP.text = strP;
		//[statusLabelP performSelector:@selector(setText:) withObject:@"Updated Text" afterDelay:0.1f];
	if(lstatus !=ALERT_DISCONNECTED || timecallduration==0 )
	{	
		if(strP)
		{	
			[callingstringP release]; 
			callingstringP = [[NSString alloc] initWithString:strP];

			//[statusLabelP performSelectorOnMainThread : @ selector(setText: ) withObject:strP waitUntilDone:YES];
		}
		if(strtypeP)
		{
			callingstringtypeP = [[NSString alloc] initWithString:strtypeP];
		}	
	}
		//[statusLabelP drawRect];
	self->status = lstatus;
	self->subStatus = lsubStatus;
	[self setButton:nil];
	//[self performSelectorOnMainThread : @ selector(setButton: ) withObject:nil waitUntilDone:YES];
	//numberFieldP.text = strP;
	

}


@end
