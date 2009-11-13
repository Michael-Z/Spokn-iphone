//
//  callviewcontroller.m
//  spokn
//
//  Created by Mukesh Sharma on 29/09/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import "callviewcontroller.h"
#import "keypadview.h"
#import "spoknAppDelegate.h"
#include "playrecordpcm.h"
#include "custombutton.h"
#include "sipwrapper.h"
#include "ltpandsip.h"
@implementation CallViewController

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
	NSLog(@"%@   %d",stringkey ,keyVal);
	
	NSString *curText = [dtmfLabelP text];
	[dtmfLabelP setText: [curText stringByAppendingString: stringkey]];
	char numberchar[5]={0};
	numberchar[0] = keyVal;
	[ownerobject SendDTMF:numberchar];
	
}
- (void)keyPressedUp:(NSString *)stringkey keycode:(int)keyVal
{
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	UIImage *buttonBackground;
	UIImage *buttonBackgroundPressed;
	callnoLabelP.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lcd_top_simple.png"]];

	[self.view setBackgroundColor:[[[UIColor alloc] 
									 initWithPatternImage:[UIImage defaultDesktopImage]]
									autorelease]];
	[self->viewMenuP setBackgroundColor:[UIColor clearColor]];
	[self->viewKeypadP setBackgroundColor:[UIColor clearColor]];
	callnoLabelP.numberOfLines = 2;
	[callnoLabelP setText:labelStrP];
	self->viewKeypadP.hidden = YES;
	self->hideKeypadButtonP.hidden = YES;
	self->endCallKeypadButtonP.hidden = YES;
	[viewKeypadP setImage:@"keypad.png" : @"keypad_pressed.png"];
	[viewKeypadP setElement:3 :4];
	viewKeypadP.keypadProtocolP = self;
	buttonBackground = [UIImage imageNamed:@"red.png"];
	buttonBackgroundPressed = [UIImage imageNamed:@"blueButton.png"];
	[CustomButton setImages:endCallButtonP image:buttonBackground imagePressed:buttonBackgroundPressed];
	[buttonBackground release];
	[buttonBackgroundPressed release];
	
	buttonBackground = [UIImage imageNamed:@"red.png"];
	buttonBackgroundPressed = [UIImage imageNamed:@"blueButton.png"];
	[CustomButton setImages:hideKeypadButtonP image:buttonBackground imagePressed:buttonBackgroundPressed];
	[buttonBackground release];
	[buttonBackgroundPressed release];
	
	buttonBackground = [UIImage imageNamed:@"red.png"];
	buttonBackgroundPressed = [UIImage imageNamed:@"blueButton.png"];
	[CustomButton setImages:endCallKeypadButtonP image:buttonBackground imagePressed:buttonBackgroundPressed];
	[buttonBackground release];
	[buttonBackgroundPressed release];
	
	


	
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
	calltimerP = [NSTimer scheduledTimerWithTimeInterval: 1
												  target: self
												selector: @selector(handleCallTimer:)
												userInfo: nil
												 repeats: YES];
	char *newLineP;
	char *stringP;
	char*tmpStrP;
	//timecallduration = time(0);
	timecallduration = 0;
	hour = 0;
	min = 0;
	sec = 0;
	stringP = (char*)[labelStrP cStringUsingEncoding:NSUTF8StringEncoding];
	newLineP = malloc(strlen(stringP)+4);
	strcpy(newLineP,stringP);
	tmpStrP = strstr(newLineP,"\n");
	if(tmpStrP)
	{
		*tmpStrP = 0;
		[labelStrP release];
		labelStrP = [[NSString alloc]initWithUTF8String:newLineP];
		[callnoLabelP setText:labelStrP];
		
	}
	free(newLineP);
}
-(int)  stopTimer
{
	[calltimerP invalidate];
	calltimerP = nil;
	return timecallduration;
}
- (void) handleCallTimer: (id) timer
{
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
	setMute(enable);
	#endif
	[butP setSelected:enable];
	printf("%d",enable);
	
}
-(IBAction)HoldPressed:(id)sender
{
	UIButton *butP;
	int enable;
	
	butP = (UIButton*)sender;
	
	enable = !butP.selected;
#ifndef _LTP_
	setHold(ownerobject.ltpInterfacesP->ltpObjectP, enable);
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
	printf("%d",enable);
	
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
-(void)setLabel:(NSString *)strP
{
	labelStrP = [[NSString alloc] initWithString:strP];
	[callnoLabelP setText:strP];
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
	SetSpeakerOnOrOff(0,false);
	printf("\n vmail dealloc");
	[labelStrP release];
	
    [super dealloc];
}


@end
