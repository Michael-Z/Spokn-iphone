//
//  DialviewController.m
//  spoknclient
//
//  Created by Mukesh Sharma on 01/07/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import "dialviewcontroller.h"
#import "Ltptimer.h"
#import "LtpInterface.h"
#import "SpoknAppDelegate.h"
#import "spoknalert.h"
#include "time.h"
#import "keypadview.h"
#import "callviewcontroller.h"
@implementation DialviewController

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
	[numberlebelP setText: [curText stringByAppendingString: stringkey]];

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
		numbercharP = (char*)[string cStringUsingEncoding:1];
		SendDTMF(ltpInterfacesP,0,numbercharP);
	
	}
	//NSLog(string);
	//////printf("\n mukesh");
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
	self.navigationItem.leftBarButtonItem 
	= [ [ [ UIBarButtonItem alloc ]
		 initWithTitle: @"Login" style:UIBarButtonItemStylePlain
		 target: self
		 action: @selector(LoginPressed) ] autorelease ];
	currentView = 0;
	
	//[statusLabelP setText:@"not logged in"];
	[activityIndicator stopAnimating]; 
	//statusLabelP.textAlignment=UITextAlignmentCenter;
	keypadmain.objectId = 0;
	//keypadmain.dataStringP = @"mukesh\nsharma";
	[keypadmain setImage:@"dialerkeypad.png" : @"dialerkeypad_pressed.png"];
	[keypadmain setElement:3 :4];
	keypadmain.keypadProtocolP = self;
	
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
	
	logOut(ltpInterfacesP);
	//statusLabelP. textAlignment=UITextAlignmentCenter;
	//[statusLabelP setText:@""];
	[self.navigationItem.leftBarButtonItem initWithTitle: @"Login" style:UIBarButtonItemStylePlain
	 target: self
	 action: @selector(LoginPressed) ] ;
	[activityIndicator stopAnimating]; 
	//[activityIndicator startAnimating];
	
	
}	
/*
- (void)controlPressed:(id) sender {
	//[ self setPage ];
	int index = segmentedControl.selectedSegmentIndex;
	//////printf("%d",index);
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
	printf("\n dialview dealloc");
	[calltimerP release];
	[callingstringP release]; 
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
			[hangUpButtonP setTitle:@"Vms" forState:UIControlStateNormal];
			break;
		case 1:
			[hangUpButtonP setTitle:@"Hang" forState:UIControlStateNormal];
			break;
	}
	

}
-(IBAction)backkeyPressed:(id)sender
{
	NSString *curText = [numberlebelP text];
	int length = [curText length];
	if(length > 0)
	{
		[numberlebelP setText: [curText substringToIndex:(length-1)]];
		length = [curText length];
	}
	if(length==0)
	{
		statusLabel1P.hidden = NO;
		statusLabel2P.hidden = NO;
	}
	
}
-(IBAction)callLtp:(id)sender
{
	//[self->ownerobject->navigationController pushViewController: ownerobject.inCommingCallViewP animated: YES ];
	printf("\n %d %d",onLineB,self->onLineB);
	if(onLineB)
	{	
		char *numbercharP;
		numbercharP = (char*)[[numberlebelP text] cStringUsingEncoding:1];
		[ownerobject makeCall:numbercharP];
		currentView = 1;
		[hangUpButtonP setTitle:@"Hang" forState:UIControlStateNormal];
	}
	else
	{
		UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"Error" 
														   message: [ NSString stringWithString:@"user not online" ]
														  delegate: nil
												 cancelButtonTitle: nil
												 otherButtonTitles: @"OK", nil
							  ];
		[ alert show ];
		[alert release];
		//[self dismissKeyboard:numberFieldP];

		
	}
}
-(IBAction)hangLtp:(id)sender
{
	if(onLineB)
	{
		
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
			numbercharP = (char*)[[numberlebelP text] cStringUsingEncoding:1];
			if(strlen(numbercharP)>5)
			{	
				//char *numcharP;
				//numcharP = malloc(strlen(numbercharP)+10);
				//strcpy(numcharP,numbercharP);
				[ownerobject vmsShowRecordScreen:numbercharP];
			}	
		}
	}
	else
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

		
	
	}
}
-(IBAction)dismissKeyboard: (id)sender {
	[sender resignFirstResponder];
}
- (void) handleCallTimer: (id) timer
{
	self->timecallduration++;
	time_t timeP = {0};
	struct tm  tmLoc;
	struct tm *tmP=0;
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
- (void) handleCallTimerEnd: (id) timer
{
	//[statusLabelP setText:@"end call"];
	timecallduration = 0;
	[(NSTimer*)timer invalidate];
	profileResync();//to get balance
}
-(void) setButton:(id) sender
{
	switch(self->status)
	{
		case START_LOGIN:
			//statusLabelP. textAlignment=UITextAlignmentLeft;

			[activityIndicator startAnimating];
			[self.navigationItem.leftBarButtonItem initWithTitle: @"Cancel" style:UIBarButtonItemStylePlain
			 target: self
			 action: @selector(LogoutPressed) ] ;
			

			break;
		case ALERT_ONLINE:	
			{
				NSString *stringStrP;
				char *unameP;
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
				[self->ownerobject popLoginView];
				printf("\n online code");
				onLineB = true;
				printf("\n %d",self->onLineB);
				[activityIndicator stopAnimating];
			}	
			break;
		case ALERT_OFFLINE:
		//	statusLabelP. textAlignment=UITextAlignmentCenter;
						

			[self.navigationItem.leftBarButtonItem initWithTitle: @"Login" style:UIBarButtonItemStylePlain
			 target: self
			 action: @selector(LoginPressed) ] ;
			[self->ownerobject popLoginView];
			[self setViewButton:0];
			[activityIndicator stopAnimating];
			printf("\n offline code");
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
				[callViewControllerP startTimer];
			}	
			
		case TRYING_CALL:
		
			[self setViewButton:1];
			if(callViewControllerP==0)
			{	
				callViewControllerP = [[CallViewController alloc] initWithNibName:@"callviewcontroller" bundle:[NSBundle mainBundle]];
				[callViewControllerP setObject:self->ownerobject];
				[callViewControllerP setLabel:callingstringP];
				[self presentModalViewController:callViewControllerP animated:YES];
				if([callViewControllerP retainCount]>1)
					[callViewControllerP release];
			}	
			[numberlebelP setText:@""];

			break;
		case ALERT_DISCONNECTED:
			
			[self setViewButton:0];
			[calltimerP invalidate];
			timecallduration = [callViewControllerP stopTimer];
			[self dismissModalViewControllerAnimated:NO];
			callViewControllerP = 0;
			//printf("\ndisconnected");
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

-(void)setStatusText:(NSString *)strP :(int)lstatus :(int)lsubStatus
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
	}
		//[statusLabelP drawRect];
	self->status = lstatus;
	self->subStatus = lsubStatus;
	[self performSelectorOnMainThread : @ selector(setButton: ) withObject:nil waitUntilDone:YES];
	//numberFieldP.text = strP;
	

}


@end
