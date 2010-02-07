
//  Created by Mukesh Sharma on 29/09/09.

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

#import "callviewcontroller.h"
#import "keypadview.h"
#import "spoknAppDelegate.h"
#include "playrecordpcm.h"
#include "custombutton.h"
#include "sipwrapper.h"
#include "ltpandsip.h"
#include "contactviewcontroller.h"
#import "spokncalladd.h"
@implementation CallViewController
@synthesize showContactCallOnDelegate;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/
- (void)keyPressedDown:(NSString *)stringkey keycode:(int)keyVal
{
	
	NSString *curText = [dtmfLabelP text];
	[dtmfLabelP setText: [curText stringByAppendingString: stringkey]];
	//char numberchar[5]={0};
	//numberchar[0] = keyVal;
	char *numbercharP;
	numbercharP = (char*)[stringkey cStringUsingEncoding:NSUTF8StringEncoding];
	[ownerobject SendDTMF:numbercharP];
	
}
- (void)keyPressedUp:(NSString *)stringkey keycode:(int)keyVal
{
	
}
-(void)viewWillAppear:(BOOL) animated
{
	if(navBarShow)
	{
		navBarShow = NO;
		[[self navigationController] setNavigationBarHidden:YES animated:NO];
	}
	[super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	loadedB = true;
	if(actualDismissB)
	{
		
		//[ownerobject.tabBarController dismissModalViewControllerAnimated:YES];
		actualDismissB = NO;
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Call";
	self->showContactCallOnDelegate = nil;
	//[ownerobject setStatusBarStyle:UIStatusBarStyleBlackTranslucent animation:NO];
	[UIApplication sharedApplication] .statusBarStyle = UIStatusBarStyleBlackTranslucent;
	SetSpeakerOnOrOff(0,false);
	UIImage *buttonBackground;
	UIImage *buttonBackgroundPressed;
	callnoLabelP.backgroundColor = [UIColor clearColor];
	[ callnoLabelP setOpaque:YES];
	/*[self.view setBackgroundColor:[[[UIColor alloc] 
									initWithPatternImage:[UIImage imageNamed:@"spokncall.png"]]
								   autorelease]];	*/
	[self.view setBackgroundColor:[[[UIColor alloc] 
									 initWithPatternImage:[UIImage imageNamed:@"320x480-watermark.png"]]
									autorelease]];
	[self->viewMenuP setBackgroundColor:[[UIColor clearColor] autorelease ] ];
	[self->viewKeypadP setBackgroundColor:[[UIColor clearColor] autorelease ] ];
	//callnoLabelP.numberOfLines = 2;
	[callnoLabelP setText:labelStrP];
	[callTypeLabelP setText:labeltypeStrP];
	callTypeLabelP.backgroundColor = [UIColor clearColor];
	

	self->viewKeypadP.hidden = YES;
	self->hideKeypadButtonP.hidden = YES;
	self->endCallKeypadButtonP.hidden = YES;
	[viewKeypadP setImage:@"keypad.png" : @"keypad.png"];
	
	[viewKeypadP setElement:3 :4];
	viewKeypadP.keypadProtocolP = self;
	
	buttonBackground = [UIImage imageNamed:@"2_endcall_270_45_normal.png"];
	buttonBackgroundPressed = [UIImage imageNamed:@"2_endcall_270_45_pressed.png"];
	[CustomButton setImages:endCallButtonP image:buttonBackground imagePressed:buttonBackgroundPressed change:NO];
	[buttonBackground release];
	[buttonBackgroundPressed release];
	endCallButtonP.backgroundColor =  [UIColor clearColor];
	
	buttonBackground = [UIImage imageNamed:@"2_hidekeypad_125_45_normal.png"];
	buttonBackgroundPressed = [UIImage imageNamed:@"2_hidekeypad_125_45_pressed.png"];
	[CustomButton setImages:hideKeypadButtonP image:buttonBackground imagePressed:buttonBackgroundPressed change:NO];
	[buttonBackground release];
	[buttonBackgroundPressed release];
	hideKeypadButtonP.backgroundColor =  [UIColor clearColor];
	buttonBackground = [UIImage imageNamed:@"2_endcall_125_45_normal.png"];
	buttonBackgroundPressed = [UIImage imageNamed:@"2_endcall_125_45_pressed.png"];
	[CustomButton setImages:endCallKeypadButtonP image:buttonBackground imagePressed:buttonBackgroundPressed change:NO];
	endCallKeypadButtonP.backgroundColor =  [UIColor clearColor];
	[buttonBackground release];
	[buttonBackgroundPressed release];
	alertNotiFication(CALL_ALERT,0,0,  (unsigned long)ownerobject,0);
	
	[[self navigationController] setNavigationBarHidden:YES animated:NO];

	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(void) startTimer
{
	if(calltimerP)
	{
		return;
	}
	calltimerP = [NSTimer scheduledTimerWithTimeInterval: 1
												  target: self
												selector: @selector(handleCallTimer:)
												userInfo: nil
												 repeats: YES];
	char *newLineP;
	char *stringP;
	char*tmpStrP;
	timecallduration = time(0);
	timecallduration = 0;
	hour = 0;
	min = 0;
	sec = 0;
	stringP = (char*)[labeltypeStrP cStringUsingEncoding:NSUTF8StringEncoding];
	newLineP = malloc(strlen(stringP)+4);
	strcpy(newLineP,stringP);
	tmpStrP = strstr(newLineP,"calling ");
	if(tmpStrP)
	{
		
		*tmpStrP = 0;
		char *newStringP;
		newStringP = malloc(strlen(stringP)+4);
		strcpy(newStringP,newLineP);
		tmpStrP = tmpStrP + strlen("calling ");
		strcat(newStringP,tmpStrP);
		[labeltypeStrP release];
		labeltypeStrP = [[NSString alloc] initWithUTF8String:newStringP];
		[callTypeLabelP setText:labeltypeStrP];
		
		free(newStringP);
		
	}
	free(newLineP);
}
-(int)  stopTimer
{
	actualDismissB = true;
	[calltimerP invalidate];
	calltimerP = nil;
	if(loadedB==false)
	{	
		NSTimer *callEndtimerP;
		callEndtimerP = [NSTimer scheduledTimerWithTimeInterval: 3
												  target: self
												selector: @selector(handleCallEndTimer:)
												userInfo: nil
												 repeats: NO];
	//[callEndtimerP autorelease];
	}
	else
	{
		
		[ownerobject.tabBarController dismissModalViewControllerAnimated:YES];

	}
	return timecallduration;
}
- (void) handleCallEndTimer: (id) timer
{
	[timer invalidate];
	[ownerobject.tabBarController dismissModalViewControllerAnimated:YES];
	actualDismissB = NO;

}
- (void) handleCallTimer: (id) timer
{
	
	if(self->showContactCallOnDelegate)
	{	
		[self->showContactCallOnDelegate upDateUI];	
	}
	self->timecallduration++;
	time_t timeP = {0};
	struct tm ;// tmLoc;
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
		[timeLabelP setText:stringStrP];
		[stringStrP release];
		
	}
	sec++;
}


-(void)setObject:(id) object 
{
	self->ownerobject = object;
	actualDismissB = NO;
}
-(IBAction)endCallPressedKey:(id)sender
{
	[self->ownerobject endCall:0];
}
-(IBAction)endCallPressed:(id)sender
{
	[self->ownerobject endCall:0];
}
-(IBAction)mutePressed:(id)sender
{
	UIButton *butP;
	int enable;

	butP = (UIButton*)sender;
	
	enable = !butP.selected;
	#ifndef _LTP_
	setMuteInterface(ownerobject.ltpInterfacesP,enable);
	#endif
	[butP setSelected:enable];
	
	
}

-(IBAction)addContactPressed:(id)sender
{
	
	
/*	ContactViewController *contactP;
	navBarShow = YES;
	self.title = @"Call";
	//[[self navigationController] setNavigationBarHidden:NO animated:NO];
	contactP = [[ContactViewController alloc] initWithNibName:@"contact" bundle:[NSBundle mainBundle]];
	[contactP hideCallAndVmailButton:YES];
	contactP.parentView = 0;
	[contactP setObject:ownerobject];
	contactP.uaObject = GETCONTACTLIST;
	[contactP setObjType:GETCONTACTLIST];
	contactP.ltpInterfacesP =ownerobject.ltpInterfacesP;
	//navBarShow = NO;
	
	
	[contactP setReturnVariable:self :0 :0];
	UINavigationController *tmpCtl;
	tmpCtl = [[ [ UINavigationController alloc ] initWithRootViewController: contactP ] autorelease];
	if(tmpCtl)
	[[self navigationController] presentModalViewController:tmpCtl animated: YES ];
	//[ [self navigationController] pushViewController:contactP animated: YES ];
	
	[contactP release];
	*/
	Spokncalladd *spoknViewCallP;
	spoknViewCallP = [[Spokncalladd alloc] initWithNibName:@"spokncalladd" bundle:[NSBundle mainBundle]];
	[spoknViewCallP setParent:self];
	[[self navigationController] presentModalViewController:spoknViewCallP animated: YES ];
	[spoknViewCallP release];
}
-(IBAction)HoldPressed:(id)sender
{
	UIButton *butP;
	int enable;
	
	butP = (UIButton*)sender;
	
	enable = !butP.selected;
#ifndef _LTP_
	setHoldInterface(ownerobject.ltpInterfacesP, enable);
#endif
	[butP setSelected:enable];
}
/*
 - (void)setMute:(BOOL)enable
 {
 
if (enable)
pjsua_conf_adjust_rx_level(0 , 0.0f);
else
pjsua_conf_adjust_rx_level(0 , 1.0f);
}

- (void)setHoldEnabled: (BOOL)enable
{
	if (enable)
	{
		if (_call_id != PJSUA_INVALID_ID)
			pjsua_call_set_hold(_call_id, NULL);
	}
	else
	{
		if (_call_id != PJSUA_INVALID_ID)
			pjsua_call_reinvite(_call_id, PJ_TRUE, NULL);
	}
}


 */
-(IBAction)speakerPressed:(id)sender
{
	UIButton *butP;
	int enable;
	
	butP = (UIButton*)sender;
	
	enable = !butP.selected;
	SetSpeakerOnOrOff(0,enable);
	[butP setSelected:enable];
	
	
}
-(IBAction)keypadPressed:(id)sender
{
	if(self->viewKeypadP.hidden==YES)
	{	
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
							   forView:self->viewKeypadP cache:YES];
		
		self->viewKeypadP.hidden = NO;
		self->hideKeypadButtonP.hidden = NO;
		self->endCallKeypadButtonP.hidden = NO;
		self->viewMenuP.hidden = YES;
		self->endCallButtonP.hidden = YES;
		 [UIView commitAnimations];
				
	}
	else
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		
		[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight
							   forView:self->viewMenuP  cache:YES];
		
		self->viewKeypadP.hidden = YES;
		self->hideKeypadButtonP.hidden = YES;
		self->endCallKeypadButtonP.hidden = YES;
		self->viewMenuP.hidden = NO;
		self->endCallButtonP.hidden = NO;
		 [UIView commitAnimations];

	}
}
-(void)setLabel:(NSString *)strP :(NSString *)strtypeP
{
	
	labelStrP = [[NSString alloc] initWithString:strP];
	[callnoLabelP setText:labelStrP];
	labeltypeStrP = [[NSString alloc] initWithString:strtypeP];
	[callTypeLabelP setText:labeltypeStrP];
}
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
  
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
		
	//[super viewDidUnload];
	
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[showContactCallOnDelegate objectDestory];
	[ownerobject playcallendTone];
	//SetSpeakerOnOrOff(0,true);
	
	[labelStrP release];
	[labeltypeStrP release];
	
    [super dealloc];
}


@end
