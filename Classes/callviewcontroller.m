
//  Created on 29/09/09.

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

#import "callviewcontroller.h"
#import "keypadview.h"
#import "spoknAppDelegate.h"
#include "playrecordpcm.h"
#include "custombutton.h"
#include "sipwrapper.h"
#include "ltpandsip.h"
#include "contactviewcontroller.h"
#import "spokncalladd.h"
#import "alertmessages.h"
#include "playrecordpcm.h"
#import "spokncalladd.h"
#include "LtpInterface.h"
#import "conferenceviewcontroller.h"
@implementation CallViewController
@synthesize showContactCallOnDelegate;
@synthesize addcallDelegate;
-(void) removeTempId
{
	[callManagmentP removeCallByID:200];
	
	if([callManagmentP getCount]>0)
	{
		[self updateTableSubView:NO];
		//[callnoLabelP setText:labelStrP];
		//[callTypeLabelP setText:labeltypeStrP];
		[self updatescreen:0 ];
		[tableView reloadData];
		
	}
}
-(void) addTempId
{
	[callManagmentP addCall:200 :@"" :@""];

}
-(int)AddIncommingCall :(int)llineID :(NSString*)llabelStrP :(NSString*)ltypeStrP
{
	SetAudioTypeLocal(0,0);
	alertNotiFication(CALL_ALERT,0,0,  (unsigned long)ownerobject,0);
	[callManagmentP addCall:llineID :llabelStrP :ltypeStrP];
	[self updateTableSubView:NO];
	//[callnoLabelP setText:labelStrP];
	//[callTypeLabelP setText:labeltypeStrP];
	[self updatescreen:0 ];
	[tableView reloadData];
	refreshViewB = 1;
	return 0;

}

-(int)isCallOn
{
	if([callManagmentP freeSlotForCall]!=0)
	{
		return 2;
	}
	if([callManagmentP isConfranceOn] &&[ callManagmentP getTotalDisplayCall]==1)
	{
		return 1;//show accept reject dialog
	}
	else {
			if([callManagmentP isConfranceOn])
			{
				return 2;
			}
			else {
					if([callManagmentP getCount]>1)
					{
						return 2;
					}
			}

	}
	return 1;//show accept reject dialog

}
-(void) objectDestroy
{
	spoknconfP = nil;
}
-(void)handupCall:(int)llineID
{
	if(llineID!=CONFERENCE_LINE_ID && llineID>=0)
		hangLtpInterface(self->ownerobject.ltpInterfacesP,llineID);
}
-(int)childWillDie
{
	if(gchildWillDie==0)
	{	
	
	
		gchildWillDie = 1;
		return 1;
	}	
	return 0;
}
-(void)makeCall:(char*)numberP
{
	int llineID=-1 ;
	char *nameP=0;
	char typeP[100];
	char typeCallint[110];
	if([callManagmentP freeSlotForCall]!=0)
	{
		return;
	}
	llineID = callLtpInterface(self->ownerobject.ltpInterfacesP,numberP);
	if(llineID>=0)
	{	
				
		
		
		
			
		nameP = [ownerobject getNameAndTypeFromNumber:numberP :typeP :0];
		if(nameP)
		{	
			[labelStrP release];
			labelStrP = [[NSString alloc] initWithUTF8String:nameP];
			[labeltypeStrP release];
			labeltypeStrP = [[NSString alloc] initWithUTF8String:typeCallint];
			
			[callManagmentP addCall:llineID :labelStrP :labeltypeStrP];
			free(nameP);
		}	
		[self updateTableSubView:NO];
		//[callnoLabelP setText:labelStrP];
		//[callTypeLabelP setText:labeltypeStrP];
		[self updatescreen:0 ];
		[tableView reloadData];
	}

}
-(int)totalCallActive
{
	return [callManagmentP totalCallActive];
}
-(NSString*)getStringByIndex:(int)index
{
	
	return [callManagmentP getStringByIndex:index];
}
-(void)endSelectedCall:(int)index
{
	int llineID = [callManagmentP getLineIdByIndex:index+1];
	[self sendLtpHang:llineID];
}
-(void) selectedCall:(int)index
{
	[callManagmentP selectedCall:index];	
	[self updateTableSubView:NO];
	int llineID;
	llineID = [callManagmentP getActiveLineID];
	if(llineID>=0)
	{
		//setHoldInterface(ownerobject.ltpInterfacesP, YES);
		setPrivateCallInterface(ownerobject.ltpInterfacesP,llineID );
		//switchReinviteInterface(ownerobject.ltpInterfacesP ,llineID);
	}
	//[callnoLabelP setText:labelStrP];
	//[callTypeLabelP setText:labeltypeStrP];
	[self updatescreen:0 ];
	[self->tableView reloadData];
	
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		addcallDelegate = nil;
		callManagmentP = [[CallManagement alloc] init];
		CGRect LabelFrame1 = CGRectMake(24, 0, 150, 50);
		name1LabelP = [[UILabel alloc] initWithFrame:LabelFrame1];
		name1LabelP.textAlignment = UITextAlignmentLeft;
		//label1.text = temp;
		name1LabelP.font = [UIFont boldSystemFontOfSize:20];
		
		name2LabelP = [[UILabel alloc] initWithFrame:LabelFrame1];
		//label1.text = temp;
		name2LabelP.font = [UIFont boldSystemFontOfSize:20];
		name1LabelP.textAlignment = UITextAlignmentLeft;
		
		CGRect LabelFrame2 = CGRectMake(180, 0, 102, 50);
		type1LabelP = [[UILabel alloc] initWithFrame:LabelFrame2];
		type1LabelP.textAlignment = UITextAlignmentRight;
		//label1.text = temp;
		type1LabelP.font = [UIFont boldSystemFontOfSize:20];
		
		type2LabelP = [[UILabel alloc] initWithFrame:LabelFrame2];
		//label1.text = temp;
		type2LabelP.font = [UIFont boldSystemFontOfSize:20];
		type2LabelP.textAlignment = UITextAlignmentRight;
		type1LabelP.backgroundColor=[UIColor clearColor];
		type2LabelP.backgroundColor=[UIColor clearColor];
		name1LabelP.backgroundColor=[UIColor clearColor];
		name2LabelP.backgroundColor=[UIColor clearColor];
		
		type1LabelP.textColor=[UIColor whiteColor];
		type2LabelP.textColor=[UIColor whiteColor];
		name1LabelP.textColor=[UIColor whiteColor];
		name2LabelP.textColor=[UIColor whiteColor];
		
		
		type1LabelP.hidden = YES;
		type2LabelP.hidden = YES;
		name1LabelP.hidden = YES;
		name2LabelP.hidden = YES;
		
				
	}
    return self;
}

/*
CallViewController *globalCallViewControllerP;
+(CallViewController*) callViewControllerObject
{
	if(globalCallViewControllerP==0)
	{	
		globalCallViewControllerP = [[CallViewController alloc] initWithNibName:@"callviewcontroller" bundle:[NSBundle mainBundle]];
	}	
	[globalCallViewControllerP retain];
	return globalCallViewControllerP;
}
+(void)releaseCallViewController
{
	[globalCallViewControllerP release];
}
*/
- (void)keyPressedDown:(NSString *)stringkey keycode:(int)keyVal
{
	
	if(delTextB)
	{	
		[callnoLabelP setText:@""];
		delTextB = NO;
		callnoLabelP.lineBreakMode = UILineBreakModeHeadTruncation;
	}
	NSString *curText = [callnoLabelP text];
	[callnoLabelP setText: [curText stringByAppendingString: stringkey]];
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
	//[ [UIApplication sharedApplication] setStatusBarHidden:NO];
	[super viewWillAppear:animated];
}
-(void)sendLtpHang:(int)llineID
{
	
	int activeLineId;
	
	if(llineID==CONFERENCE_LINE_ID)
	{
		activeLineId = [callManagmentP RemoveAllCallInConf:self];
		//now change merge button to add call
	}
	else {
		activeLineId = [callManagmentP removeCallByID:llineID];
		if(llineID!=CONFERENCE_LINE_ID && llineID>=0)
			hangLtpInterface(self->ownerobject.ltpInterfacesP,llineID);
		
	}

	if(activeLineId>=0)
	{	
		if([callManagmentP getActiveLineID]==CONFERENCE_LINE_ID)
		{
			shiftToConferenceCallInterface(ownerobject.ltpInterfacesP,-1);
			
			
		}
		else {
			switchReinviteInterface(ownerobject.ltpInterfacesP ,[callManagmentP getActiveLineID]);
		}

		
	}
	[self updateTableSubView:NO];
	[self updatescreen:0 ];
	[tableView reloadData];
	

}
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	self->messageviewMenuP.hidden = YES;
	[text release];
	
}
-(void)setParentObject:(id) object 
{
	self->parentObjectDelegate = object;
}
-(void)setuserMessage:(NSString*)message
{
	if(message)
	{	
		text = [[NSString alloc] initWithString:message];
	}	
}

-(void)hideMessage
{

	//http://stackoverflow.com/questions/3897279/difference-between-uiview-beginanimationscontext-and-uiview-animatewithdurat
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(fadeOut:finished:context:)];
	//UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction;
//	
//	[UIView animateWithDuration:0.2 delay:0.0 options:options animations:^
//	 {
//		 messageviewMenuP.alpha = 1.0;
//	 } completion:nil];
	messageviewMenuP.alpha = 1.0;
	[UIView commitAnimations];

	
}

-(void)showMessage
{
	if(showMessage)
	{	
		self->messageviewMenuP.hidden = YES;
	}
	else
	{
		self->messageviewMenuP.hidden = NO;
		
		if(messageTimerP==nil)
		{
			messageTimerP = [NSTimer scheduledTimerWithTimeInterval: 3
										 target: self
									   selector: @selector(hideMessage)
									   userInfo: nil
										repeats: NO];
		}	
		
	}
}

-(void)fadeOut:(NSString*)animationID finished:(BOOL)finished context:(void*)context
{
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationDuration:10.0];
	messageviewMenuP.alpha = 0.0;
	[UIView commitAnimations];
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
//	[messageTextP setTitle:text forState:UIControlStateNormal];
//	[messageTextP setTitle:text forState:UIControlStateHighlighted];
//	[messageTextP setTitle:text forState:UIControlStateSelected]; 
	loadedB = true;
	gchildWillDie = 0;
		//[self setuserMessage:@"\nPASSED with a good persentage. PASSED\nPASSED\nPASSED\nPASSED\nPASSED\nPASSED\nPASSED"];
	if(firstTimeB)
	{	
	/*	[NSTimer scheduledTimerWithTimeInterval: 4
										 target: self
									   selector: @selector(makeCallTimer:)
									   userInfo: nil
										repeats: NO];*/
		SetAudioTypeLocal(0,0);
		
		ownerobject.blueTooth =  blueToothIsOn();
		if(ownerobject.blueTooth)
		{
			selectedModeB = 1;
			[self setselectedButtonImage:selectedModeB];
		}
		
		
		AudioSessionSetActive(true);
	//	printf("\n session active");
		[self->parentObjectDelegate setParentObject:self];
		int llineID =1;
		int incommingLineID = [ownerobject getIncommingLineID];
		if(incommingLineID>=0)
		{
			//Means Incoming Call 
			[callManagmentP addCall:incommingLineID :labelStrP :labeltypeStrP];
			[callManagmentP callStart:incommingLineID];
			showMessage = 1;
		}
		llineID = alertNotiFication(CALL_ALERT,0,failedCallB,  (unsigned long)ownerobject,0);
		if(llineID>=0 && incommingLineID <0)
		{	
			//Means Outgoing Call 
			[callManagmentP addCall:llineID :labelStrP :labeltypeStrP];
			showMessage = 0;
		}
		[tableView reloadData];
		firstTimeB = 0;
	}
	if(actualDismissB)
	{
		
		//[ownerobject.tabBarController dismissModalViewControllerAnimated:YES];
		actualDismissB = NO;
	}
	
	if(failedCallB)
	{
		/*[self retain];
		[ownerobject.tabBarController dismissModalViewControllerAnimated:NO];
		[self autorelease];*/
		 [NSTimer scheduledTimerWithTimeInterval: 2
														 target: self
													   selector: @selector(handleCallEndTimer:)
													   userInfo: nil
														repeats: NO];
		[calltimerP invalidate];
		calltimerP = nil;
	}
	else
	{	
		if([callManagmentP getCount]<=0)
		{
			[NSTimer scheduledTimerWithTimeInterval: 0.1
										 target: self
									   selector: @selector(handleCallEndTimer:)
									   userInfo: nil
										repeats: NO];
			[calltimerP invalidate];
			calltimerP = nil;
		
				
		
		}
	}


	if(refreshViewB)
	{
		[self updateTableSubView:NO];
		//[callnoLabelP setText:labelStrP];
		//[callTypeLabelP setText:labeltypeStrP];
		[self updatescreen:0 ];
		[tableView reloadData];
		refreshViewB = false;
		
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
//	messageTextP.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
//	messageTextP.titleLabel.adjustsFontSizeToFitWidth = TRUE;
//	[messageTextP setTitle:text forState:UIControlStateNormal];
//	[messageTextP setTitle:text forState:UIControlStateHighlighted];
//	[messageTextP setTitle:text forState:UIControlStateSelected]; 
//	UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"spokncall.png"]];
//	messageviewMenuP.backgroundColor = background;
//	[background release];
	messageTextP.text = text;
	[self showMessage];
	protocolMenuP.hidden = TRUE;
	CGRect LabelFrame2;
	LabelFrame2 = callnoLabelP.frame;
	LabelFrame2.origin.x = 0;
	LabelFrame2.origin.y = 7;
	LabelFrame2.size.height = 50;
	callnoLabelP.frame = LabelFrame2;
	LabelFrame2 = callTypeLabelP.frame;
	LabelFrame2.origin.x = 0;
	LabelFrame2.origin.y = 0;
	LabelFrame2.size.height = 44;
	callTypeLabelP.frame = LabelFrame2;
	callTypeLabelP.textColor=[UIColor whiteColor];
	tableView.editing = NO;
	tableView.delegate = self;
	tableView.dataSource = self;
	//tableView.tableFooterView = callTypeLabelP;
	//tableView.tableHeaderView = callnoLabelP;
	tableView.backgroundColor = [UIColor clearColor];
	muteOnB = false;
	speakerOnB = false;
	uiImageP = [[UIImageView alloc]initWithImage:[ UIImage imageNamed:_CALL_BLUETOOH_BG_ ]];
	self->holdOnB = false;
	[blueToothViewP insertSubview :uiImageP atIndex:0];
	blueToothViewP.hidden = YES;
	self->hideSourcesbuttonP.hidden = YES;
	blueToothViewP.backgroundColor = [UIColor clearColor];
	//[self->blueToothViewP setBackgroundColor:[[[UIColor alloc] 
	//								initWithPatternImage:[UIImage imageNamed:@"square.png"]]
	//							   autorelease]];
	failedCallB  = 0;
	firstTimeB = true;
	self.title = @"Call";
	uiActionSheetgP = nil;
	self->showContactCallOnDelegate = nil;
	//[ownerobject setStatusBarStyle:UIStatusBarStyleBlackTranslucent animation:NO];
	
	SetSpeakerOnOrOffNew(0,false);
	UIImage *buttonBackground;
	UIImage *buttonBackgroundPressed;
	callnoLabelP.backgroundColor = [UIColor clearColor];
	[ callnoLabelP setOpaque:YES];
	//prvStyle = [UIApplication sharedApplication] .statusBarStyle;
	[UIApplication sharedApplication] .statusBarStyle = UIStatusBarStyleBlackOpaque;
	[self.view setBackgroundColor:[[[UIColor alloc] 
									 initWithPatternImage:[UIImage imageNamed:_CALL_WATERMARK_PNG_]]
									autorelease]];
	
	//[testP setBackgroundColor:[[UIColor clearColor] autorelease ] ];
	[self->viewMenuP setBackgroundColor:[[UIColor clearColor] autorelease ] ];
	[self->viewKeypadP setBackgroundColor:[[UIColor clearColor] autorelease ] ];
	//callnoLabelP.numberOfLines = 2;
	[callnoLabelP setText:labelStrP];
	[callTypeLabelP setText:labeltypeStrP];
	callTypeLabelP.backgroundColor = [UIColor clearColor];
	[self->topViewP setBackgroundColor:[[[UIColor alloc] 
									initWithPatternImage:[UIImage imageNamed:_SCREEN_BORDERS_PNG_]]
								   autorelease]];	
	[self->bottomViewP setBackgroundColor:[[[UIColor alloc] 
									initWithPatternImage:[UIImage imageNamed:_SCREEN_BORDERS_PNG_]]
								   autorelease]];	

	self->viewKeypadP.hidden = YES;
	self->hideKeypadButtonP.hidden = YES;
	self->endCallKeypadButtonP.hidden = YES;
	[viewKeypadP setImage:_KEYPAD_NORMAL_PNG_ : _KEYPAD_PRESSED_PNG_];
	
	[viewKeypadP setElement:3 :4];
	viewKeypadP.keypadProtocolP = self;
	
	buttonBackground = [UIImage imageNamed:_ENDCALL_NORMAL_PNG_];
	buttonBackgroundPressed = [UIImage imageNamed:_ENDCALL_PRESSED_PNG_];
	[CustomButton setImages:endCallButtonP image:buttonBackground imagePressed:buttonBackgroundPressed change:NO];
	[buttonBackground release];
	[buttonBackgroundPressed release];
	endCallButtonP.backgroundColor =  [UIColor clearColor];
	
	buttonBackground = [UIImage imageNamed:_HIDE_KEYPAD_NORMAL_PNG_];
	buttonBackgroundPressed = [UIImage imageNamed:_HIDE_KEYPAD_PRESSED_PNG_];
	[CustomButton setImages:hideKeypadButtonP image:buttonBackground imagePressed:buttonBackgroundPressed change:NO];
	[buttonBackground release];
	[buttonBackgroundPressed release];
	hideKeypadButtonP.backgroundColor =  [UIColor clearColor];
	buttonBackground = [UIImage imageNamed:_SMALL_ENDCALL_NORMAL_PNG_];
	buttonBackgroundPressed = [UIImage imageNamed:_SMALL_ENDCALL_PRESSED_PNG_];
	[CustomButton setImages:endCallKeypadButtonP image:buttonBackground imagePressed:buttonBackgroundPressed change:NO];
	endCallKeypadButtonP.backgroundColor =  [UIColor clearColor];
	[buttonBackground release];
	[buttonBackgroundPressed release];
	
	
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	endCalledPressed = NO;
	[self setSpeakerButtonImage];
	
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(void) updatescreen:(int )time
{
	NSString *mainlableP=0;
	NSString *mainTypeP=0;
	NSString *lable1P=0;
	NSString *type1P=0;
	NSString *lable2P=0;
	NSString *type2P=0;
	int disableButton = 0;
	int lactiveLineId;
	if(time==0)
	{
		NSString *holdImageP = 0;
		NSString *addCallImageP = 0;
		[callManagmentP imageForholdAndAddCall:&holdImageP :&addCallImageP :&disableButton];
		if(holdOnB==false)
		{	
			[holdButtonP setImage:[UIImage imageNamed:holdImageP] forState:UIControlStateNormal];
			[holdButtonP setImage:[UIImage imageNamed:holdImageP] forState:UIControlStateHighlighted];
		}
		[addcallButtonP setImage:[UIImage imageNamed:addCallImageP] forState:UIControlStateNormal];
		[addcallButtonP setImage:[UIImage imageNamed:addCallImageP] forState:UIControlStateHighlighted];
		[holdImageP release];
		[addCallImageP release];
		addcallButtonP.enabled = !disableButton;
		
	
	}
	
	lactiveLineId = [callManagmentP updatescreenData:time :&mainlableP :&mainTypeP : &lable1P :&type1P :&lable2P :&type2P];
	if(mainlableP)
	{
		callnoLabelP.text = mainlableP;
		[labelStrP release];
		
		labelStrP = mainlableP;
		
	}
	if(mainTypeP)
	{
		callTypeLabelP.text = mainTypeP;
		[labeltypeStrP release];
		labeltypeStrP = mainTypeP;
	}
	if(lable1P)
	{
		name1LabelP.text = lable1P;
		[lable1P release];
	}
	if(type1P)
	{
		type1LabelP.text = type1P;
		if(time==0)
		{
			if([type1P isEqualToString:@"HOLD"] )
			{
				name1LabelP.textColor = [[UIColor grayColor] autorelease];
				type1LabelP.textColor = [[UIColor grayColor] autorelease];
				
				
			}
			else {
				name1LabelP.textColor = [[UIColor whiteColor] autorelease];
				type1LabelP.textColor = [[UIColor whiteColor] autorelease];
			}
			
		}
		
		[type1P release];
	}
	else
	{
		if(time==0)
		{
				name1LabelP.textColor = [[UIColor whiteColor] autorelease];
				type1LabelP.textColor = [[UIColor whiteColor] autorelease];
			
		}
		
	}

	if(lable2P)
	{
		name2LabelP.text = lable2P;
		[lable2P release];
	}
	if(type2P)
	{
		type2LabelP.text = type2P;
		if(time==0)
		{
			if([type2P isEqualToString:@"HOLD"] )
			{
				name2LabelP.textColor = [[UIColor grayColor] autorelease];
				type2LabelP.textColor = [[UIColor grayColor] autorelease];

				
			}
			else {
					name2LabelP.textColor = [[UIColor whiteColor] autorelease];
					type2LabelP.textColor = [[UIColor whiteColor] autorelease];
			}
			
		}
		
		
		
		[type2P release];
	}
	else
	{
		if(time==0)
		{
			name2LabelP.textColor = [[UIColor whiteColor] autorelease];
			type2LabelP.textColor = [[UIColor whiteColor] autorelease];
			
		}
		
	}
		
}
-(void) startTimer:(int) llineID
{
	
	if(calltimerP==nil)
	{
		
	
	calltimerP = [NSTimer scheduledTimerWithTimeInterval: 1
												  target: self
												selector: @selector(handleCallTimer:)
												userInfo: nil
												 repeats: YES];
	}
		[callManagmentP callStart:llineID];
	
		/*stringP = (char*)[labeltypeStrP cStringUsingEncoding:NSUTF8StringEncoding];
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
		
	}*/
	if([callManagmentP isConfranceOn])
		setPrivateCallInterface(ownerobject.ltpInterfacesP,llineID);

	//put on hold if hold button is pressed
	if(self->holdOnB)
	{	
		setHoldInterface(ownerobject.ltpInterfacesP, self->holdOnB);
	}
	
	ownerobject.blueTooth =  blueToothIsOn();
	if(ownerobject.blueTooth)
	{
		[self routeChange:2];
	}
	if(self->speakerOnB)
	{
		SetSpeakerOnOrOffNew(0,1);
	}
	if(self->muteOnB)
	{	
		setMuteInterface(ownerobject.ltpInterfacesP,1);
	}	
	ownerobject.blueTooth =  blueToothIsOn();
	if(ownerobject.blueTooth)
	{
		[self routeChange:2];
	}
	setMuteInterface(ownerobject.ltpInterfacesP,false);

	/*else
	{
		[self routeChange:1];
	}*/
	
}
-(void) dismisscontroller:(int)parentB
{
	if(parentB)
	{
		
		//if(gchildWillDie!=2)
		{	
			[self dismissModalViewControllerAnimated:YES];
		}
	}
	else {
		//if(gchildWillDie==0)
		{	
			
			gchildWillDie =2;
			[self dismissModalViewControllerAnimated:YES];
			
			
		}	
	}

		[calltimerP invalidate];
	calltimerP = nil;

}
-(int)  stopTimer:(int)llineID
{
	int lactiveLineId;
	actualDismissB = true;
	int results = 0;	
	
	refreshViewB = 1;
	if(loadedB==false || llineID==-1)
	{	
		failedCallB = true;
		[self dismisscontroller:!loadedB];
		//NSTimer *callEndtimerP;
		
		results = 1;
		return 1;
	}
	lactiveLineId = [callManagmentP getindexByLineID:llineID];
	if(lactiveLineId<0)
	{
		return 0;
	}
	lactiveLineId = [callManagmentP removeCallByID:llineID];
			
	
	
	if(lactiveLineId>=0)
	{	
		if([callManagmentP getActiveLineID]==CONFERENCE_LINE_ID)
		{
			shiftToConferenceCallInterface(ownerobject.ltpInterfacesP,-1);
			
			
		}
		else {
			switchReinviteInterface(ownerobject.ltpInterfacesP ,[callManagmentP getActiveLineID]);
		}
		
		[self updateTableSubView:NO];
		[self updatescreen:0];
		[tableView reloadData];
	}
	else
	{
		[self dismisscontroller:0];
		results = 1;

	}
	if(results==0)
	{	
		[spoknconfP reload];//again reloaded table
	}	
	return results;
} 
- (void) makeCallTimer: (id) timer
{
	[timer invalidate];
	
	SetAudioTypeLocal(0,0);
	//AudioSessionSetActive(true);
	alertNotiFication(CALL_ALERT,0,failedCallB,  (unsigned long)ownerobject,0);
}	
- (void) handleCallEndTimer: (id) timer
{
	[timer invalidate];
	timer = nil;
	[ownerobject.tabBarController dismissModalViewControllerAnimated:YES];
	actualDismissB = NO;

}
-(void)removeCallview
{
	//[ownerobject.tabBarController dismissModalViewControllerAnimated:YES];
	failedCallB = true;
}
- (void) handleCallTimer: (id) timer
{
	
	if(self->showContactCallOnDelegate)
	{	
		[self->showContactCallOnDelegate upDateUI];	
	}
	[callManagmentP upDateTime];
	if(ownerobject.inbackgroundModeB==false)
	{	
		[self updatescreen:1];
	}	
}


-(void)setObject:(id) object 
{
	self->ownerobject = object;
	actualDismissB = NO;
}
-(void)endCalled
{
	int llineID =   [callManagmentP getActiveLineID];
	[self sendLtpHang:llineID];
	if([callManagmentP getCount]<1)
	{	
		[self->ownerobject endCall:-1];
		[self->parentObjectDelegate objectDestory];
		self->parentObjectDelegate = nil;
		endCalledPressed = YES;
		
	//	[ownerobject.tabBarController dismissModalViewControllerAnimated:YES];
	}
	
	

}
-(void)hidePortocolView
{
	if(self->protocolMenuP.hidden==NO && messageviewMenuP.hidden==YES)
	{	
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
							   forView:self->messageviewMenuP cache:YES];
		[UIView commitAnimations];
		self->protocolMenuP.hidden = YES;
		self->messageviewMenuP.hidden = NO;
		//self->viewMenuP.hidden = YES;
	}
}
-(void)showPortocolView
{
	if(self->protocolMenuP.hidden==YES && messageviewMenuP.hidden==NO)
	{	
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
							   forView:self->protocolMenuP cache:YES];
		[UIView commitAnimations];
		self->protocolMenuP.hidden = NO;
		self->messageviewMenuP.hidden = YES;
		//self->viewMenuP.hidden = YES;
	}
}
-(IBAction)sipButtonPressedKey:(id)sender
{
	printf("%s","\nSIP");
	[self hidePortocolView];
	self->showMessage = 0;
	//self->viewMenuP.hidden = FALSE;
	[self showMessage];
}
-(IBAction)callthroughButtonPressedKey:(id)sender
{
	printf("%s","\nCALL THROUGH");
	[self hidePortocolView];
	self->showMessage = 0;
	//self->viewMenuP.hidden = FALSE;
	[self showMessage];
}
-(IBAction)callbackButtonPressedKey:(id)sender
{
	printf("%s","\nCALLBACK");
	[self hidePortocolView];
	self->showMessage = 0;
	//self->viewMenuP.hidden = FALSE;
	[self showMessage];
}
-(IBAction)changePortocolPressedKey:(id)sender
{
	//printf("%s","\nCHANGE PROTOCOL");
	[messageTimerP invalidate]; messageTimerP = nil;
	[self showPortocolView];
	self->showMessage = 1;
	[self showMessage];

}
-(IBAction)endCallPressedKey:(id)sender
{
	[self endCalled];
}
-(IBAction)endCallPressed:(id)sender
{
	[self endCalled];	
}
-(IBAction)mutePressed:(id)sender
{
	UIButton *butP;
	int enable;

	butP = (UIButton*)sender;
	
	enable = !butP.selected;
	muteOnB = enable;
	if(setMuteInterface(ownerobject.ltpInterfacesP,enable)==0)
	{	
		[butP setSelected:enable];
	}
	
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
	[spoknViewCallP setObject:ownerobject];
	[spoknViewCallP setParent:self];
	[[self navigationController] presentModalViewController:spoknViewCallP animated: YES ];
	[spoknViewCallP release];
}
-(IBAction)callAdded:(id)sender
{
	int confOn;
	confOn = [callManagmentP shouldStartConfrence];
	if(confOn)
	//if(count>1 && confrenceOn==0 && showDiscloser==0)
	{
		startConferenceInterface(ownerobject.ltpInterfacesP);
		if(confOn==1)
		{	
			[labelStrP release];
			labelStrP = [[NSString alloc] initWithUTF8String:"Conference"];
		
			[labeltypeStrP release];
			labeltypeStrP = [[NSString alloc] initWithUTF8String:" "];
			[callManagmentP makeconfrence:labelStrP :labeltypeStrP ];
		}
		[callManagmentP putAllCallInConfrance:YES];
		[self updateTableSubView:NO];
		[self updatescreen:0];
		[tableView reloadData];
		
		return;
	
	}
	Spokncalladd *spoknViewCallP;
	spoknViewCallP = [[Spokncalladd alloc] initWithNibName:@"spokncalladd" bundle:[NSBundle mainBundle]];
	[spoknViewCallP setObject:ownerobject];
	spoknViewCallP.addCallB = TRUE;
	[spoknViewCallP setParent:self];
	[[self navigationController] presentModalViewController:spoknViewCallP animated: YES ];
	[spoknViewCallP release];
	

}
-(IBAction)HoldPressed:(id)sender
{
	UIButton *butP;
	int enable;
	int oldID = [callManagmentP getActiveLineID];
	if([callManagmentP swapLineID])
	{
		if([callManagmentP getActiveLineID]==CONFERENCE_LINE_ID)
		{
			//startConferenceInterface(ownerobject.ltpInterfacesP);
			//showDiscloser = 1;
			shiftToConferenceCallInterface(ownerobject.ltpInterfacesP,oldID);
			[self updateTableSubView:NO];

		}
		else {
				setPrivateCallInterface(ownerobject.ltpInterfacesP,[callManagmentP getActiveLineID]);
				[self updateTableSubView:NO];
			//switchReinviteInterface(ownerobject.ltpInterfacesP ,[callManagmentP getActiveLineID]);
		}
		
		
		if([callManagmentP isConfranceOn]==YES)
		{
			[tableView reloadData];
		}
		
		[self updatescreen:0];
		return;
	}
	
	butP = (UIButton*)sender;
	
	enable = !butP.selected;
	holdOnB = enable;
	if(setHoldInterface(ownerobject.ltpInterfacesP, enable)==0)
	{
		[butP setSelected:enable];
	}
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
/*
#pragma mark ACTIONSHEET
- (void)didPresentActionSheet:(UIActionSheet *)actionSheet;  // after animation
{
	uiActionSheetgP = actionSheet;
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	uiActionSheetgP = nil;
	//printf("%d",buttonIndex);
	[actionSheet release];
	
}


- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
	uiActionSheetgP = nil;
	[actionSheet release];
}
*/
-(IBAction)speakerPressed:(id)sender
{
	UIButton *butP;
	int enable;
//	butP = (UIButton*)sender;
	
//	enable = !butP.selected;
	//AudioSessionSetActive(enable);
//	SetSpeakerOnOrOffNew(0,enable);
//	[butP setSelected:enable];
	
	if(ownerobject.blueTooth==false)
	{	
		butP = (UIButton*)sender;
	
		enable = !butP.selected;
		speakerOnB = enable;
		//AudioSessionSetActive(enable);
		SetSpeakerOnOrOffNew(0,enable);
		[butP setSelected:enable];
	}	
	else
	{
		//[butP setSelected:NO];
		if(self->blueToothViewP.hidden==YES)
		{	
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.5];
			
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
								   forView:self->blueToothViewP cache:YES];
			
			self->blueToothViewP.hidden = NO;
			[UIView commitAnimations];
			self->hideKeypadButtonP.hidden = NO;
			self->endCallKeypadButtonP.hidden = NO;
			self->viewMenuP.hidden = YES;
			self->endCallButtonP.hidden = YES;
			self->hideKeypadButtonP.hidden = YES;
			self->hideSourcesbuttonP.hidden = NO;
			
		}
		
		
		
		
		/*UIActionSheet *uiActionSheetP;
		uiActionSheetP= [[UIActionSheet alloc] 
						 initWithTitle: @"" 
						 delegate:self
						 cancelButtonTitle:_CANCEL_ 
						 destructiveButtonTitle:nil
						 otherButtonTitles:nil, nil];
		
		uiActionSheetP.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
		
		[uiActionSheetP addButtonWithTitle:@"Bluetooth Audio"  ];
		[uiActionSheetP addButtonWithTitle:@"iPhone"  ];
		[uiActionSheetP addButtonWithTitle:@"Speaker"  ];
		[uiActionSheetP showInView:self.view];*/
	
	}
	
	
}
-(void)routeChange:(int)reason
{
	
	switch(reason)
	{
		case 1://only iphone
			ownerobject.blueTooth = NO;
			bluetoothbuttonP.selected = NO;
			audiobuttonP.selected = YES;
			speakerinbluetoothbuttonP.selected = NO;
			[self hidesourcesrPressed:nil];
			
			
			break;
		case 2://blue tooth
			selectedModeB = 1;
			[self setselectedButtonImage:selectedModeB];
			[speakerButtonP setSelected:NO];
			bluetoothbuttonP.selected = YES;
			audiobuttonP.selected = NO;
			speakerinbluetoothbuttonP.selected = NO;
			ownerobject.blueTooth = YES;
			break;
	}
	[self setSpeakerButtonImage];
}
-(void)setSelectedOrUnselectedImage:(UIButton*)selectedButtonP :(UIImage*) imageP
{
		

	if(imageP)
	{
	
		[selectedButtonP setImage:imageP forState:UIControlStateNormal];
		[selectedButtonP setImage:imageP forState:UIControlStateHighlighted];
		[selectedButtonP setImage:imageP forState:UIControlStateSelected];
		
	
	}


}
-(void)setselectedButtonImage:(int) button
{
	
	[self setSelectedOrUnselectedImage:bluetoothbuttonP :0];
	[self setSelectedOrUnselectedImage:audiobuttonP :0];
	[self setSelectedOrUnselectedImage:speakerinbluetoothbuttonP :0];
	
	
	switch(button)
	{
		case 1:
		[self setSelectedOrUnselectedImage:bluetoothbuttonP :0];
			break;
		case 2:
			[self setSelectedOrUnselectedImage:audiobuttonP :0];
			break;
		case 3:
			[self setSelectedOrUnselectedImage:speakerinbluetoothbuttonP :0];
			
			break;
			
	
	}

}
-(void) changeSelectedImage
{
	UIImage *imagePressed;
	
	if(bluetoothbuttonP.selected==YES)
	{
		
		//imagePressed = [UIImage imageNamed:@"240x52-buttons-bluetoothaudio-speaker-normal.png"];
		//[bluetoothbuttonP setBackgroundImage:imagePressed forState:UIControlStateNormal];
		imagePressed = [UIImage imageNamed:_BLUETOOTH_AUDIO_SPEAKER_PRESSED_PNG_];
		
		[bluetoothbuttonP setBackgroundImage:imagePressed forState:UIControlStateNormal];	
		}
	else
	{
		imagePressed = [UIImage imageNamed:_BLUETOOTH_AUDIO_PNG_];
		
		[bluetoothbuttonP setBackgroundImage:imagePressed forState:UIControlStateNormal];	
		
		imagePressed = [UIImage imageNamed:_BLUETOOTH_AUDIO_PRESSED_PNG_];
		[bluetoothbuttonP setBackgroundImage:imagePressed forState:UIControlStateHighlighted];		
		
		
	}
	if(audiobuttonP.selected==YES)
	{
		imagePressed = [UIImage imageNamed:_BLUETOOTH_IPHONE_SPEAKER_PRESSED_PNG_];
		[audiobuttonP setBackgroundImage:imagePressed forState:UIControlStateNormal];	
		
	}
	else
	{
		imagePressed = [UIImage imageNamed:_BLUETOOTH_IPHONE_PRESSED_PNG_];
		[audiobuttonP setBackgroundImage:imagePressed forState:UIControlStateHighlighted];	
		imagePressed = [UIImage imageNamed:_BLUETOOTH_IPHONE_PNG_];
		[audiobuttonP setBackgroundImage:imagePressed forState:UIControlStateNormal];	
		
	}
	if(speakerinbluetoothbuttonP.selected==YES)
	{
		imagePressed = [UIImage imageNamed:_BLUETOOTH_SPEAKER_SPEAKER_PRESSED_PNG_];
		[speakerinbluetoothbuttonP setBackgroundImage:imagePressed forState:UIControlStateNormal];		
		
		
	}
	else
	{
		imagePressed = [UIImage imageNamed:_BLUETOOTH_SPEAKER_PRESSED_PNG_];
		[speakerinbluetoothbuttonP setBackgroundImage:imagePressed forState:UIControlStateHighlighted];	
		imagePressed = [UIImage imageNamed:_BLUETOOTH_SPEAKER_PNG_];
		[speakerinbluetoothbuttonP setBackgroundImage:imagePressed forState:UIControlStateNormal];	
		
	}
	
}

-(IBAction)blueToothViewAudio:(id)sender
{
	
	if(bluetoothbuttonP.selected==YES)
		return;
	RouteAudio(0,1);
	selectedModeB = 1;
	[speakerButtonP setSelected:NO];
	bluetoothbuttonP.selected = YES;
	speakerinbluetoothbuttonP.selected = NO;
	audiobuttonP.selected = NO;
	[self changeSelectedImage];
/*	
	if(bluetoothbuttonP.selected)
	{	
		UIImage *buttonBackground;
		UIImage *buttonBackgroundPressed;
	
		buttonBackground = [UIImage imageNamed:@"240x52-buttons-bluetoothaudio-speaker-normal.png"];
		buttonBackgroundPressed = [UIImage imageNamed:@"240x52-buttons-bluetoothaudio-speaker-pressed.png"];
		[CustomButton setImages:bluetoothbuttonP image:buttonBackground imagePressed:buttonBackgroundPressed change:NO];
		[buttonBackground release];
		[buttonBackgroundPressed release];
		
	}
 */
}
-(IBAction)blueToothViewiphone:(id)sender
{
	if(audiobuttonP.selected==YES)
		return;
	RouteAudio(0,2);
	selectedModeB = 2;
	[speakerButtonP setSelected:NO];
	bluetoothbuttonP.selected = NO;
	speakerinbluetoothbuttonP.selected = NO;
	audiobuttonP.selected = YES;
	[self changeSelectedImage];
	
/*	
	UIImage *buttonBackground;
	UIImage *buttonBackgroundPressed;
	
	buttonBackground = [UIImage imageNamed:@"240x52-buttons-bluetoothaudio-normal.png"];
	buttonBackgroundPressed = [UIImage imageNamed:@"240x52-buttons-bluetoothaudio-normal.png"];
	[CustomButton setImages:bluetoothbuttonP image:buttonBackground imagePressed:buttonBackgroundPressed change:NO];
	[buttonBackground release];
	[buttonBackgroundPressed release];
*/	
	
}
-(IBAction)blueToothViewspeaker:(id)sender
{
	if(speakerinbluetoothbuttonP.selected==YES)
		return;
	RouteAudio(0,3);
	selectedModeB = 3;
	[speakerButtonP setSelected:YES];
	bluetoothbuttonP.selected = NO;
	speakerinbluetoothbuttonP.selected = YES;
	audiobuttonP.selected = NO;
	[self changeSelectedImage];
}

-(void)setSpeakerButtonImage
{
	UIImage *buttonImage;
	
	
	

	if(ownerobject.blueTooth)
	{
		buttonImage = [UIImage imageNamed:_BLUETOOTH_SOURCE_PNG_];
		[self setSelectedOrUnselectedImage:speakerButtonP :buttonImage];
		bluetoothbuttonP.selected = YES;
		audiobuttonP.selected = NO;
		speakerinbluetoothbuttonP.selected = NO;
		
		
	}
	else
	{
		buttonImage = [UIImage imageNamed:_CALL_SPEAKER_PNG_];
		[self setSelectedOrUnselectedImage:speakerButtonP :buttonImage];
		bluetoothbuttonP.selected = NO;
		audiobuttonP.selected = YES;
		speakerinbluetoothbuttonP.selected = NO;
		

	
	}
	[self changeSelectedImage];


}
-(IBAction)hidesourcesrPressed:(id)sender
{
	if(self->blueToothViewP.hidden==NO)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		
		[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight
							   forView:self->viewMenuP  cache:YES];
		
		[UIView commitAnimations];
		self->blueToothViewP.hidden = YES;
		self->viewMenuP.hidden = NO;
		self->viewKeypadP.hidden = YES;
		self->endCallKeypadButtonP.hidden = YES;
		self->hideKeypadButtonP.hidden = YES;
		self->endCallButtonP.hidden = NO;
		self->hideSourcesbuttonP.hidden = YES;
		if(ownerobject.blueTooth)
		{
			[speakerButtonP setSelected:NO];
		}
	}
}
-(void)updateTableSubView:(Boolean)hideB
{
	//if(count==1 || showDiscloser)
	if([callManagmentP upDateView]==1)
	{
		hideB = YES;
	}
	if(hideB)
	{
		type1LabelP.hidden = YES;
		type2LabelP.hidden = YES;
		name1LabelP.hidden = YES;
		name2LabelP.hidden = YES;
		callnoLabelP.hidden = NO;
		callTypeLabelP.hidden = NO;
	}
	else {
		if([callManagmentP getCount]>1)//more then one call
		{
			type1LabelP.hidden = NO;
			type2LabelP.hidden = NO;
			name1LabelP.hidden = NO;
			name2LabelP.hidden = NO;
			callnoLabelP.hidden = YES;
			callTypeLabelP.hidden = YES;
		
		}
	}

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
		 [UIView commitAnimations];
		self->hideKeypadButtonP.hidden = NO;
		self->endCallKeypadButtonP.hidden = NO;
		self->viewMenuP.hidden = YES;
		self->endCallButtonP.hidden = YES;
		delTextB = YES;
		self->hideSourcesbuttonP.hidden = YES;
		[self updateTableSubView:1];
				
	}
	else
	{
		delTextB = NO;
		[callnoLabelP setText:labelStrP];
		callnoLabelP.lineBreakMode = UILineBreakModeTailTruncation;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		
		[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight
							   forView:self->viewMenuP  cache:YES];
		
		self->viewMenuP.hidden = NO;
		
		 [UIView commitAnimations];
		self->viewKeypadP.hidden = YES;
		self->hideKeypadButtonP.hidden = YES;
		self->endCallKeypadButtonP.hidden = YES;
		self->endCallButtonP.hidden = NO;
		self->hideSourcesbuttonP.hidden = YES;
		[self updateTableSubView:0];
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
	
	closeSoundInterface(ownerobject.ltpInterfacesP);
	[callManagmentP release];
	callManagmentP = 0;
	if(uiActionSheetgP)
	{	
		[uiActionSheetgP dismissWithClickedButtonIndex:[uiActionSheetgP cancelButtonIndex] animated:NO];
		uiActionSheetgP = 0;
	}
	[self->parentObjectDelegate objectDestory];
	self->parentObjectDelegate = nil;

	[UIApplication sharedApplication] .statusBarStyle = UIStatusBarStyleDefault ;
	[showContactCallOnDelegate objectDestory];
	[ownerobject playcallendTone];
	//SetSpeakerOnOrOff(0,true);
	
	[labelStrP release];
	[labeltypeStrP release];
	[viewMenuP release];
	[bottomViewP release];
	[callTypeLabelP release];
	[viewKeypadP release];
	[endCallButtonP release];
	[hideKeypadButtonP release];
	[endCallKeypadButtonP release];
	[speakerButtonP release];
	[topViewP release];
	[blueToothViewP release];
	[hideSourcesbuttonP release];
	[audiobuttonP release];
	[speakerinbluetoothbuttonP release];
	[bluetoothbuttonP release];
	[uiImageP release];
	
    [super dealloc];
	//NSLog(@"\n retaincount %d %d %d %d",[blueToothViewP retainCount],[uiImageP retainCount],[speakerinbluetoothbuttonP retainCount],[audiobuttonP retainCount]);
	
}
#pragma mark Table view methods

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Detemine if it's in editing mode
	
    return UITableViewCellEditingStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	//if([listOfItems count])
	//	return [listOfItems count];
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
		return 2;
	//return [[listOfItems objectAtIndex:section] count];
	//return [ fileList count ];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
	
}
/*
 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
 {
 return 32.0;
 }
 - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
 {
 return 32.0;
 }
 */
-(void)disclouserClicked:(UIButton *)buttonP
{
	//UIView *lsuperView;
	//lsuperView = [buttonP superview]; 
	//printf("super %d",lsuperView.tag);
	//[addCallP selectedCall:lsuperView.tag-1000];
	//[[self navigationController] popViewControllerAnimated:YES];
	int dispRow;
	//[[self navigationController] pushViewController:[[ImageController alloc] init] 
	//animated:YES]; 
	dispRow = [callManagmentP getTotalDisplayCall];
	
	[callManagmentP setConfCallIndex];
	spoknconfP = [[ConferenceViewController alloc] initWithNibName:@"conferenceviewcontroller" bundle:[NSBundle mainBundle]];
	[spoknconfP setDelegate:self];
	
	if(dispRow==2)
	{
		[spoknconfP showPrivate:NO];
	}
	else {
		[spoknconfP showPrivate:YES];
	}
	
	[[self navigationController] pushViewController:spoknconfP animated: YES ];
	[spoknconfP release];
	
	
}

- (UITableViewCell *)tableView:(UITableView *)ltableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	int row = [indexPath row];
	int section = [indexPath section];
	NSString *CellIdentifier = nil;
	CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",section,row];
	UITableViewCell *cell = [ltableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
	  if (cell == nil) {
		
		#ifdef __IPHONE_3_0
				
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		#else
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		#endif
				switch(row)
				{
					case 0:
						[cell.contentView addSubview:callnoLabelP];
						[cell.contentView addSubview:name1LabelP];
						[cell.contentView addSubview:type1LabelP];
						//callnoLabelP.hidden = YES;
						
						
						break;
					case 1:
						//callTypeLabelP.text = @"mukesh";
						[cell.contentView addSubview:callTypeLabelP];
						
						[cell.contentView addSubview:name2LabelP];
						[cell.contentView addSubview:type2LabelP];
						break;
				}
						
				
	}
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	if([callManagmentP isConfranceOnForIndex:row] )
	{
		
		//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setBackgroundImage:[UIImage imageNamed:DISCOUSURE_CALL_IMG_PNG] forState:UIControlStateNormal];
		[button setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 29.0f)];
		//[button setCenter:CGPointMake(40.0f, 20.0f)];
		//	[button setTitle:@"PRIVATE" forState:UIControlStateNormal];
		button.tag = 1000 + row;
		[button addTarget:self action:@selector(disclouserClicked:) forControlEvents:UIControlEventTouchUpInside];
		cell.accessoryView = button;
		//[button release];
		//cell.imageView = [UIImage imageNamed:@"11_declinecall_36_18.png"];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
	}
	else {
		cell.accessoryView = nil;
		cell.accessoryType = UITableViewCellAccessoryNone;
	}

	return cell;	
	
}
- (void)tableView:(UITableView *)tableView 
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath 
{ 
	int dispRow;
	//[[self navigationController] pushViewController:[[ImageController alloc] init] 
	//animated:YES]; 
	dispRow = [callManagmentP getTotalDisplayCall];
	[callManagmentP setConfCallIndex];
	
	spoknconfP = [[ConferenceViewController alloc] initWithNibName:@"conferenceviewcontroller" bundle:[NSBundle mainBundle]];
	[spoknconfP setDelegate:self];
	if(dispRow==2)
	{
		[spoknconfP showPrivate:NO];
	}
	else {
		[spoknconfP showPrivate:YES];
	}

	[[self navigationController] pushViewController:spoknconfP animated: YES ];
	[spoknconfP release];
	
} 

- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle) editingStyle 
forRowAtIndexPath:(NSIndexPath *) indexPath 
{ 
	
	//int row = [indexPath row];
	//int section = [indexPath section];
	
	
	
}

- (void)tableView:(UITableView *)ltableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	int row = [indexPath row];
	
	//int section = [indexPath section];
	if([callManagmentP swapRow:row])
	{	
		/*if(rowTable[row]!=activeLineId)
		{
			
			//switchReinviteInterface(ownerobject.ltpInterfacesP ,callID[row].lineID);

			//activeLineId = row;
			//[self updatescreen:0];
			
		}*/
		[self HoldPressed:nil];//swap the call
		
	}	
	
	
}


@end
