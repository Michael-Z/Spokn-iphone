
//  Created on 01/07/09.

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
#import "spokncalladd.h"
#import "callviewcontroller.h"
#import "dialviewcontroller.h"
#import "Ltptimer.h"
#import "LtpInterface.h"
#import "SpoknAppDelegate.h"
#import "spoknalert.h"
#include "time.h"
#import "keypadview.h"
#import "callviewcontroller.h"
#import <AudioToolbox/AudioToolbox.h>
#include "alertmessages.h"
#import "GEventTracker.h"
#import "contactlookup.h"
@implementation UILabel (Clipboard)

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

@end
@implementation DialviewController
const static char _keyValues[] = {0, '1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'};
//static SystemSoundID sounds[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

@synthesize currentView;
@synthesize addcallDelegate;

-(CallViewController*)getCallViewController
{
	
	return self->callViewControllerP;
	
}
- (void)keyPressedDown:(NSString *)stringkey keycode:(int)keyVal
{
		
	NSString *curText = [numberlebelP text];
	int length = [curText length];
	
	if(length==0)
	{	
		//if(addcallDelegate==nil)
		{	
			statusLabel1P.hidden = YES;
			statusLabel2P.hidden = YES;
		}	
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
#ifdef MAX_TONE
-(void)destroyDTMF
{
	int i;
	for(i=0;i<MAX_TONE;++i)
	{
		if(dtmfTone[i])
		[SpoknAudio destorySoundUrl:&dtmfTone[i]];
			
	}
		
}
 -(void)makeDTMF
{
	int i;
	NSBundle *mainBundle = [NSBundle mainBundle];
	for(i=0;i<MAX_TONE;++i)
	{
		NSString *filename = [NSString stringWithFormat:@"dtmf-%c", (i == 10 ? 's' : _keyValues[i])];
		NSString *path = [mainBundle pathForResource:filename ofType:@"aif"];
		if (path)
		{
			dtmfTone[i]=[SpoknAudio createSoundPlaybackUrl:path play:false];
		
		}
		
	
	}
	prvKey = -1;
}
- (void)playSoundForKey:(int)key
{
	
	if(prvKey>=0)
	{
		if(dtmfTone[prvKey])
		{
			[dtmfTone[prvKey] stopSoundUrl]; 
		}
	}
	if(dtmfTone[key])
	{
		[dtmfTone[key] playSoundUrl];
	}
	prvKey = key;
	//[path release];
}

#else
- (void)playSoundForKey:(int)key
{
	
	//if (!sounds[key])
	//{
		NSBundle *mainBundle = [NSBundle mainBundle];
		NSString *filename = [NSString stringWithFormat:@"dtmf-%c", (key == 10 ? 's' : _keyValues[key])];
		NSString *path = [mainBundle pathForResource:filename ofType:@"aif"];
		if (!path)
			return;
		
	[ownerobject playUrlPath:path];
	
	//[path release];
}
#endif
- (void)keyPressedUp:(NSString *)stringkey keycode:(int)keyVal
{

}

-(void)setIncreaseHeight:(int)lheight
{
	increaseheight = lheight;
}
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		[self.tabBarItem initWithTitle:@"Keypad" image:[UIImage imageNamed:_TAB_KEYPAD_PNG_] tag:3];
		callingstringP = nil;
		callingstringtypeP = nil;
		increaseheight = 0;
    }
    return self;
}

- (IBAction)valueChanged: (id)sender
{
	
}



- (void)showMenu {
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(reset) name:UIMenuControllerWillHideMenuNotification object:nil];
	
	// bring up editing menu.
	UIMenuController *theMenu = [UIMenuController sharedMenuController];
	theMenu.arrowDirection = UIMenuControllerArrowUp;
	CGRect myFrame = [[numberlebelP superview] frame];
	CGRect selectionRect = CGRectMake(holdPoint.x, myFrame.origin.y+50, 0, 0);
	
	[numberlebelP setNeedsDisplayInRect:selectionRect];
	[theMenu setTargetRect:selectionRect inView:numberlebelP];
	[theMenu setMenuVisible:YES animated:YES];
	
	// do a bit of highlighting to clarify what will be copied, specifically
	//_bgColor = [UIColor greenColor];//[self backgroundColor];
	//[_bgColor retain];
	//[self setBackgroundColor:[UIColor blackColor]];
}
- (void)reset {
	//[self setBackgroundColor:_bgColor];
	// unsubscribe!
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
	
}
- (void)copy:(id)sender {
    //UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
	//NSLog(@"SENDER : copied : %@",gpBoard.string);
	[[UIPasteboard generalPasteboard] setString:numberlebelP.text];
	//[gpBoard setValue:[self text] forPasteboardType:@"public.utf8-plain-text"];
}

- (void)paste:(id)sender {
	UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
	//NSLog(@"%@",gpBoard.string);
	NSString *tempText;
	tempText =  gpBoard.string;
	if(tempText != nil)
	{	
		statusLabel1P.hidden = YES;
		statusLabel2P.hidden = YES;
		[numberlebelP setText:tempText];
		//[[UIPasteboard generalPasteboard] setString:@""];
	}
	
}	

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
	BOOL answer = NO;
	
	if (action == @selector(copy:))
		answer = YES;
	if (action == @selector(paste:))
		answer = YES;
	return answer;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showMenu) object:nil];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showMenu) object:nil];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showMenu) object:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	if ([numberlebelP canBecomeFirstResponder])
	{
		[numberlebelP becomeFirstResponder];
		UITouch *touch = [touches anyObject];
		holdPoint = [touch locationInView:self.view];
		//NSLog(@"[%@] touchesBegan (%i,%i)",  [self class],(NSInteger) holdPoint.x, (NSInteger) holdPoint.y);
		NSInteger y = (NSInteger) holdPoint.y;
		if(y<75)
		{	
			[self performSelector:@selector(showMenu) withObject:nil afterDelay:0.8f];
		}	
	}
	
	/*	
	 for (UITouch *touch in [touches allObjects])
	 {
	 //	UITouch *touch = [touches anyObject];
	 //GET THE FINGER LOCATION ON THE SCREEN
	 CGPoint location = [touch locationInView:self.view];
	 
	 //REPORT THE TOUCH
	 NSLog(@"[%@] touchesBegan (%i,%i)",  [self class],(NSInteger) location.x, (NSInteger) location.y);
	 
	 //SEND TOUCH TO THE SURVEYED viewController
	 [self touchesBegan:touches withEvent:event];  
	 
	 }
	 */	
}	

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
	if(currentView==1)//mean call is on, send dtmp tone
	{
		char *numbercharP;
		numbercharP = (char*)[string cStringUsingEncoding:NSUTF8StringEncoding];
		SendDTMF(ownerobject.ltpInterfacesP,0,numbercharP);
	
	}
	return YES;
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	buttonPressedB = NO;
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	if(increaseheight)
	{
		CGRect rectFrame;
		rectFrame = self.view.frame;
		//rectFrame.origin.y-=20;
		rectFrame.size.height-=increaseheight;
		self.view.frame = rectFrame;
		
	
	
	}
	if(addcallDelegate)//deasible vmail button
	{
#define YSIZE 20
		hangUpButtonP.hidden = YES;
		//statusLabel1P.hidden = YES;
		//statusLabel2P.hidden = YES;
		//backgroundButtonP.hidden = YES;
		CGRect x;
		x = statusLabel2P.frame;
		x.origin.y-=5;
		x.size.height-=5;
		statusLabel2P.frame = x;
		
		
		x = backgroundButtonP.frame;
		x.size.height-=YSIZE;
		backgroundButtonP.frame = x;
	
		x = numberlebelP.frame;
		x.origin.y-=10;
		
		numberlebelP.frame = x;
		x = keypadmain.frame;
		x.origin.y-=YSIZE;
		keypadmain.frame = x;
		
		x = callButtonP.frame;
		x.origin.y-=YSIZE;
		callButtonP.frame = x;
		x = hangUpButtonP.frame;
		x.origin.y-=YSIZE;
		hangUpButtonP.frame = x;
		x = backButtonP.frame;
		x.origin.y-=YSIZE;
		backButtonP.frame = x;
		
	}
	
	
	//[ownerobject startRutine];
	buttonPressedB = NO;
	#ifdef MAX_TONE
	//[self makeDTMF];
	#endif
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
	[keypadmain setImage:_DIALPAD_NORMAL_PNG_ : _DIALAD_PRESSED_PNG_];
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
	activityIndicator.hidesWhenStopped = YES;
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
	
	logOut(ownerobject.ltpInterfacesP,true);
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
	#ifdef MAX_TONE
		[self destroyDTMF];
	#endif	
	
	[activityIndicator release];
	[mainstatusLabelP release];	
	[calltimerP release];
	[callingstringP release];
	if(callingstringtypeP != nil)
	{	
		[callingstringtypeP release];
	}
	if(textMessageP)
	{	
		[textMessageP release];
	}
	//printf("\n dial view dealloc");
	//[statusLabelP release];
	//[numberFieldP release];
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
    [super dealloc];
}
-(void)setObject:(id) object 
{
	self->ownerobject = object;
}
-(void)setViewButton:(int)viewButton
{
	currentView = viewButton;
	/*switch(currentView)
	{
		case 0:
			[hangUpButtonP setTitle:@"VMS" forState:UIControlStateNormal];
			break;
		case 1:
			[hangUpButtonP setTitle:@"Hang" forState:UIControlStateNormal];
			break;
	}
	*/

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
-(void) setAddCall:(id) laddcallDelegate
{
	addcallDelegate = laddcallDelegate;
	if(laddcallDelegate)
	{	
		//onLineB = true;
	}	
}
-(IBAction)callLtp:(id)sender
{
	//if(buttonPressedB)
	//	return;
	
	
	
	//if(ownerObject.onLineB)
	{	
		#ifdef _ANALYST_
			[[GEventTracker sharedInstance] trackEvent:@"SPOKN" action:@"CALL" label:@"OUT-CALL"];
		#endif
		
		char *numbercharP;
		numbercharP = (char*)[[numberlebelP text] cStringUsingEncoding:NSUTF8StringEncoding];
		if(numbercharP==NULL || strlen(numbercharP)==0)
		{
			
			
			if(strlen(lastTypeNo))
			{
				numberlebelP.text = [NSString stringWithUTF8String:lastTypeNo];
				statusLabel1P.hidden = YES;
				statusLabel2P.hidden = YES;
			}
			return;
		}
		NSString *text1 = [[numberlebelP text] stringByRemovingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" +_()-.,*#$!<>1234567890"]] ;
		
		if(text1!=0 && [text1 length]!=0)
		{
			numberlebelP.text = @"";
			statusLabel1P.hidden = NO;
			statusLabel2P.hidden = NO;
			return;
		}
		strcpy(lastTypeNo,numbercharP);
		SetAddressBookDetails(ownerobject.ltpInterfacesP,0,0);
		
		if(addcallDelegate==nil)
		{	
		
			
			if([ownerobject makeCall:numbercharP])
			{	
				currentView = 1;
				
				numberlebelP.text = @"";
				statusLabel1P.hidden = NO;
				statusLabel2P.hidden = NO;
				buttonPressedB = YES;
			}	
		}	
		else {
				
				[addcallDelegate makeCall:numbercharP];
				currentView = 1;
				numberlebelP.text = @"";
				statusLabel1P.hidden = NO;
				statusLabel2P.hidden = NO;
				buttonPressedB = YES;
		}

	}
	/*else
	{
		char *numbercharP;
		numbercharP = (char*)[[numberlebelP text] cStringUsingEncoding:NSUTF8StringEncoding];
		if(numbercharP==NULL || strlen(numbercharP)==0)
		{
			
			if(strlen(lastTypeNo))
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
			alert = [ [ UIAlertView alloc ] initWithTitle: _USER_OFFLINE_ 
														   message: [ NSString stringWithString:_USER_OFFLINE_MESSAGE_ ]
														  delegate: nil
												 cancelButtonTitle: nil
												 otherButtonTitles: _OK_, nil
							  ];
			[ alert show ];
			
		}
		else
		{
			UIAlertView *lalert = [ [ UIAlertView alloc ] initWithTitle: _NO_NETWORK_ 
															   message: [ NSString stringWithString:_CHECK_NETWORK_SETTINGS_ ]
															  delegate: nil
													 cancelButtonTitle: nil
													 otherButtonTitles: _OK_, nil
								  ];
			[ lalert show ];
		
		}
		//[self dismissKeyboard:numberFieldP];

		
	}*/
}
-(IBAction)vmsShow:(id)sender
{
#ifdef _ANALYST_
	[[GEventTracker sharedInstance] trackEvent:@"VMS" action:@"INITIATED" label:@"DIALPAD"];
#endif
	//if(buttonPressedB)
		//return;
	//if(onLineB)
	//{
		
		if(currentView==1)
		{	
			hangLtpInterface(ownerobject.ltpInterfacesP,0);
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
					
					if(strlen(lastTypeNo))
					{
						numberlebelP.text = [NSString stringWithUTF8String:lastTypeNo];
						statusLabel1P.hidden = YES;
						statusLabel2P.hidden = YES;
					}
					return;
				}
				strcpy(lastTypeNo,numbercharP);
				
				SetAddressBookDetails(ownerobject.ltpInterfacesP,0,0);
				[ownerobject vmsShowRecordOrForwardScreen:numbercharP VMSState : VMSStateRecord filename:"temp" duration:0 vmail:0];
				
				
				
				numberlebelP.text = @"";
				statusLabel1P.hidden = NO;
				statusLabel2P.hidden = NO;
				buttonPressedB = YES;
			}	
		}
	//}
	/*else
	{
		UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
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
	
	hangLtpInterface(ownerobject.ltpInterfacesP,0);
	timecallduration = 0;
	[(NSTimer*)timer invalidate];
	

}
- (void) handleCallTimerEnd: (id) timer
{
	//[statusLabelP setText:@"end call"];
	
	hangLtpInterface(ownerobject.ltpInterfacesP,0);
	timecallduration = 0;
	[(NSTimer*)timer invalidate];
	[ownerobject profileResynFromApp];
}
- (void)didPresentAlertView:(UIAlertView *)alertView;  // after animation
{
	alert = alertView;
}
- (void)alertViewCancel:(UIAlertView *)alertView
{
	[ownerobject retianThisObject:alertView];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation
{
	
	
	if(buttonIndex==0 && invalidUserB)
	{	
		alertNotiFication(LOAD_VIEW,0,LOAD_LOGIN_VIEW,(unsigned long)self->ownerobject,0);
		invalidUserB = false;
	}
	[alertView release];
	alert = nil;
	
	//[alertView release];
}
#pragma mark PROTOCAL_METHOD
-(void)objectDestory
{
	callViewControllerP = nil;
}
-(void)setParentObject:(id)parentP
{
	callViewControllerP = parentP;
}
-(int)isCallOn
{
	if(callViewControllerP==nil) return 0;
	return  [callViewControllerP isCallOn];
}
-(int)callDisconnected:(int )llineID
{
	if(callViewControllerP == nil)
		return 0;
		
	timecallduration = [callViewControllerP stopTimer:llineID]; 
	if(timecallduration)//mean no call is active
	{
		callViewControllerP = 0;
		return 0;
		
	}
	return 1;
}
-(void) setButton:(id) sender
{
	switch(self->status)
	{
		case START_LOGIN:
			//statusLabelP. textAlignment=UITextAlignmentLeft;
			#ifdef _SHOW_ANIMATION_
				statusLabel1P.hidden = YES;
				statusLabel2P.hidden = YES;
				mainstatusLabelP.hidden = NO;
				mainstatusLabelP.text = callingstringP;
				[activityIndicator startAnimating];
			#endif
			/*[self.navigationItem.leftBarButtonItem initWithTitle: @"Cancel" style:UIBarButtonItemStylePlain
			 target: self
			 action: @selector(LogoutPressed) ] ;*/
			

			break;
		case ALERT_ONLINE:	
			{
				NSString *stringStrP;
				char *unameP;
				[alert dismissWithClickedButtonIndex:0 animated:NO]	;
				//[alert release];
				alert = nil;
				#ifdef _SHOW_ANIMATION_
					statusLabel1P.hidden = NO;
					statusLabel2P.hidden = NO;
					mainstatusLabelP.hidden = YES;
					mainstatusLabelP.text = callingstringP;
					[activityIndicator stopAnimating];
				#endif
				unameP = getLtpUserName(ownerobject.ltpInterfacesP);
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
				
				
				
				
			}	
			break;
		case ALERT_OFFLINE:
		#ifdef _SHOW_ANIMATION_
			mainstatusLabelP.hidden = YES;
			//mainstatusLabelP.text = callingstringP;
			[activityIndicator stopAnimating];
		#endif			
			
		//	statusLabelP. textAlignment=UITextAlignmentCenter;
			if(alert)
			{	
				if(alert.tag!=self->subStatus && alert.tag!=LOGIN_STATUS_FAILED)
				{	
					[alert dismissWithClickedButtonIndex:0 animated:NO]	;
					//[alert release];
					alert = nil;
				}
				
			}	
			//[alert]
			switch(self->subStatus)
			{
				
				case HOST_NAME_NOT_FOUND_ERROR:
					alert = [ [ UIAlertView alloc ] initWithTitle: _SERVER_UNREACHABLE_ 
														  message: [ NSString stringWithString:_SERVER_UNREACHABLE_MESSAGE_ ]
														 delegate: self
												cancelButtonTitle: nil
												otherButtonTitles: _OK_, nil
							 ];
					invalidUserB = true;
					alert.tag=self->subStatus;
					
					//[alert addButtonWithTitle:@"Cancel"];
					[ alert show ];
					break;
				case LOGIN_STATUS_OFFLINE:
					if(alert==nil)
					{	

						alert = [ [ UIAlertView alloc ] initWithTitle: _SERVER_UNREACHABLE_ 
															  message: [ NSString stringWithString:_SERVER_UNREACHABLE_MESSAGE_ ]
															 delegate: self
													cancelButtonTitle: nil
													otherButtonTitles: _OK_, nil
								 ];
						//invalidUserB = true;
						alert.tag=self->subStatus;
						
						//[alert addButtonWithTitle:@"Cancel"];
						[ alert show ];
					}	
					break;
				case LOGIN_STATUS_TIMEDOUT:
					if(alert==nil)
					{	
						alert = [ [ UIAlertView alloc ] initWithTitle: _SERVER_UNREACHABLE_ 
															  message: [ NSString stringWithString:_STATUS_TIMEOUT2_ ]
															 delegate: self
													cancelButtonTitle: nil
													otherButtonTitles: _OK_, nil
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
							alert = [ [ UIAlertView alloc ] initWithTitle: _SIGN_IN_FAILED_ 
									   message: [ NSString stringWithString:_AUTHENTICATION_FAILED_ ]
									  delegate: self
				 					 cancelButtonTitle: nil
									 otherButtonTitles: _OK_, nil
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
						alert = [ [ UIAlertView alloc ] initWithTitle: _NO_NETWORK_ 
															  message: [ NSString stringWithString:_CHECK_NETWORK_SETTINGS_ ]
															 delegate: self
													cancelButtonTitle: nil
													otherButtonTitles: _OK_, nil
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
						alert = [ [ UIAlertView alloc ] initWithTitle: _TITLE_ 
																	   message: [ NSString stringWithString:_CONNECTION_FAILED_ ]
																	  delegate: self
															 cancelButtonTitle: nil
															 otherButtonTitles: _OK_, nil
										  ];
					//[alert addButtonWithTitle:@"Cancel"];
						alert.tag=self->subStatus;
						[ alert show ];
						
						
					}	
					
					break;
					
				}
					
					
			}
			
			[self setViewButton:0];
			
			
			
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
					
										//hangLtpInterface(ownerobject.ltpInterfacesP);
					calltimerP = [NSTimer scheduledTimerWithTimeInterval: 0.5
																  target: self
																selector: @selector(handleCallTimerHang:)
																userInfo: nil
																 repeats: YES];
					
										//dont get panic it will release in handleCallTimerend
					calltimerP = nil;
					
					break;
				
				}
			
				[callViewControllerP startTimer:self->lineID];
			}	
			break;
		case ROUTE_CHANGE:
			[callViewControllerP routeChange:self->subStatus];
			
			break;
		case INCOMMING_CALL_REJECT:
			[callViewControllerP removeTempId];
			break;
		case INCOMMING_CALL_ACCEPTED:
			if(callViewControllerP)
			{
				[callViewControllerP removeTempId];
				[callViewControllerP AddIncommingCall:self->lineID:callingstringP :callingstringtypeP];
				
				break;
			}
		case TRYING_CALL:
			
			//[self setViewButton:1];
			
			if(callViewControllerP==0)
			{	
				
				AudioSessionSetActive(true);
				//SetAudioTypeLocal(self,0);

				//setHoldInterface(ownerobject.ltpInterfacesP, 0);
				//callViewControllerP = [CallViewController callViewControllerObject];
				callViewControllerP = [[CallViewController alloc] initWithNibName:@"callviewcontroller" bundle:[NSBundle mainBundle]];
				[callViewControllerP setObject:self->ownerobject];
				[callViewControllerP setParentObject:self];
				//NSLog(@"%@",textMessageP);
				[callViewControllerP setuserMessage:textMessageP];
				//callViewControllerP.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;

				[callViewControllerP setLabel:callingstringP :callingstringtypeP];

				UINavigationController *tmpCtl;
				tmpCtl = [[ [ UINavigationController alloc ] initWithRootViewController: callViewControllerP ] autorelease];
				if(tmpCtl)
				{	
					if(self->subStatus)
					{
						[ownerobject.tabBarController presentModalViewController:tmpCtl animated:NO];//incomming call
					}
					else
					{	
						[ownerobject.tabBarController presentModalViewController:tmpCtl animated:YES];
					}	
					buttonPressedB = NO;
					if([callViewControllerP retainCount]>1)
						[callViewControllerP release];
					
				}
				else
				{
					
					[callViewControllerP release];
					callViewControllerP = nil;
					
				}
				callViewControllerP = nil;
			}	
			[numberlebelP setText:@""];
			statusLabel1P.hidden = NO;
			statusLabel2P.hidden = NO;

			

			break;
		case END_CALL_PRESSED:
				[self setViewButton:0];
			[callViewControllerP stopTimer:self->lineID];
				callViewControllerP = 0;
			break;
		case ALERT_CALL_NOT_START:
			[callViewControllerP removeCallview];
			break;
			
		case ALERT_DISCONNECTED:
			[self setViewButton:0];
			[calltimerP invalidate];
			timecallduration = [callViewControllerP stopTimer:self->lineID];
			if(timecallduration)//mean no call is active
			{
				callViewControllerP = 0;
			
			}
			
			timecallduration = 0;
			//[ownerobject.tabBarController dismissModalViewControllerAnimated:YES];
			
			
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
					
									//dont get panic it will release in handleCallTimerend
					calltimerP = nil;
					timecallduration = -1;
					
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

-(void)setStatusText:(NSString *)strP :(NSString *)strtypeP :(int)lstatus :(int)lsubStatus :(int)llineID
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
	self->lineID = llineID;
	[self setButton:nil];
	//[self performSelectorOnMainThread : @ selector(setButton: ) withObject:nil waitUntilDone:YES];
	//numberFieldP.text = strP;
	

}
-(void)setStatusTextMessage:(NSString *)strP
{
	textMessageP = [[NSString alloc] initWithString:strP];
}

@end
