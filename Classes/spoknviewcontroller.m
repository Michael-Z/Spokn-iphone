
//  Created on 02/10/09.

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


#import "spoknviewcontroller.h"
#import "spoknAppDelegate.h"
#import "LtpInterface.h"
#define ALPHANUM @"12345"
#define SECTION_HEIGHT 14
#import  "AddeditcellController.h"
#import "WebViewController.h"
#include "ua.h"
#import "alertmessages.h"
#import "GEventTracker.h"
#define SPOKNCOLOR [UIColor colorWithRed:63/255.0 green:90/255.0 blue:139/255.0 alpha:1.0]
#define ROW_HEIGHT 42


@implementation SpoknViewController
// Build a section/row list 
- (void) createSectionList: (id) wordArray
{
	// Build an array with 4 sub-array sections
	self->imageName[0][0].imageNameP = _SPOKN_STATUS_PNG_;
	self->imageName[0][1].imageNameP = _SPOKN_CREDITS_PNG_;
	self->imageName[1][0].imageNameP = _SPOKN_FORWARD_PNG_;
	self->imageName[1][1].imageNameP = _SPOKN_FORWARD_TO_PNG_;
	self->imageName[2][0].imageNameP = _SPOKN_LOGO_PNG_;
	self->imageName[2][1].imageNameP = _SPOKN_LOGO_PNG_;
	//self->imageName[3][0].imageNameP =0;
	//self.imageName[1][1].imageNameP = @"";
	listOfItems = [[NSMutableArray alloc] init] ;
	for (int i = 0; i < MAXSECTION; i++)
	{
		NSMutableArray *nSMutableArrayP;
		nSMutableArrayP = [[NSMutableArray alloc] init] ;
		[listOfItems addObject:nSMutableArrayP];
		[nSMutableArrayP release];
	}
	// Add each word to its alphabetical section
	for (NSString *word in wordArray)
	{
		if ([word length] == 0) continue;
		
		// determine which letter starts the name
		NSRange range = [ALPHANUM rangeOfString:[[word substringToIndex:1] uppercaseString]];
		
		// Add the name to the proper array
		[[listOfItems objectAtIndex:range.location] addObject:[word substringFromIndex:1]];
	}
}

-(void)setObject:(id) object 
{
	self->ownerobject = object;
}
-(void)showForwardNoScreen
{
	AddeditcellController     *AddeditcellControllerviewP;	
	AddeditcellControllerviewP = [[AddeditcellController alloc]init];
	[AddeditcellControllerviewP SetkeyBoardType:UIKeyboardTypePhonePad :NUMBER_RANGE buttonType:1];
	[AddeditcellControllerviewP setObject:self->ownerobject];
	viewResult = 0;
	viewCallB = true;
	char *forwordCharP;
	forwordCharP = (char*)[[labelForword text] cStringUsingEncoding:NSUTF8StringEncoding];
	if(forwordCharP)
	{
		strcpy(forwardNoCharP,forwordCharP);
	}
	
	[AddeditcellControllerviewP setData:forwardNoCharP value:"Enter forward number." placeHolder:"Number" title:"Forward Number" returnValue:&viewResult];
	
	[ [self navigationController] pushViewController:AddeditcellControllerviewP animated: YES ];
	
	[AddeditcellControllerviewP release];
	

}

- (IBAction)switchChange:(UISwitch*)sender {
	
	
	sender.enabled = NO;
	if(sender.on)
	{

		char *forwordCharP;
		forwordCharP = (char*)[[labelForword text] cStringUsingEncoding:NSUTF8StringEncoding];
		if(forwordCharP)
		{
			if(strlen(forwordCharP)==0)
			{
				[self showForwardNoScreen];
				return;
			}
		}
		[labelForword setTextColor:SPOKNCOLOR]; 
		SetOrReSetForwardNo(true,forwordCharP);
		#ifdef _ANALYST_
			[[GEventTracker sharedInstance] trackEvent:@"SPOKN" action:@"CALL FORWARD" label:@"ENABLE/DISABLE"];
		#endif
		[ownerobject profileResynFromApp];
		[self startforwardactivityIndicator];
 
	}
	else
	{
		SetOrReSetForwardNo(false,forwardNoCharP);
		#ifdef _ANALYST_
			[[GEventTracker sharedInstance] trackEvent:@"SPOKN" action:@"CALL FORWARD" label:@"ENABLE/DISABLE"];
		#endif
		[ownerobject profileResynFromApp];
		[labelForword setTextColor:[[UIColor lightGrayColor] autorelease]]; 	
		[self startforwardactivityIndicator];
	}


		
	
	//return;
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
      
		// Custom initialization
		//CGRect statusFrame = CGRectMake(120, 0, 170, ROW_HEIGHT-5);
		CGRect statusFrame1 = CGRectMake(112, 3, 178, ROW_HEIGHT-8);

		CGRect LabelFrame2 = CGRectMake(160, 0, 117, ROW_HEIGHT-5);
		CGRect LabelFrame3 = CGRectMake(160, 0, 130, ROW_HEIGHT-5);
		[self.tabBarItem initWithTitle:@"My Spokn" image:[UIImage imageNamed:_TAB_MY_SPOKN_PNG_] tag:5];
		labelBalance = [[UILabel alloc] initWithFrame:LabelFrame2];
		labelBalance.textAlignment = UITextAlignmentRight;
		labelBalance.tag = 1;
	//	LabelFrame2 = CGRectMake(160, 0, 117, 40);
		labelStatus = [[UILabel alloc] initWithFrame:statusFrame1];
		labelStatus.textAlignment = UITextAlignmentRight;
		labelStatus.tag = 2;
		labelForword = [[UILabel alloc] initWithFrame:LabelFrame2];
		labelForword.textAlignment = UITextAlignmentRight;
		labelForword.tag = 4;
		LabelFrame2.size.width+=10;
		labelSpoknNo = [[UILabel alloc] initWithFrame:LabelFrame3];
		labelSpoknNo.textAlignment = UITextAlignmentRight;
		labelSpoknNo.tag = 5;
		labelSpoknID = [[UILabel alloc] initWithFrame:LabelFrame3];
		labelSpoknID.textAlignment = UITextAlignmentRight;
		labelSpoknID.tag = 6;
		
		switchView = [[UISwitch alloc] initWithFrame: CGRectMake(205.0f, 7.0f, 94.0f, 27.0f)]; 
		[switchView setTag:3]; 
		[switchView addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
		
		activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
		[activityIndicator setCenter:CGPointMake(160.0f, 208.0f)];
		[activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
		activityIndicator.tag = 7;

		forwardactivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
		[forwardactivityIndicator setCenter:CGPointMake(270.0f, 21.0f)];
		[forwardactivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
		forwardactivityIndicator.tag = 8;
		
		//[switchView addTarget:self action:@selector(switchChange) forControlEvents:UIControlEventValueChanged];
		//cell.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spoknlog" ofType:@"png" inDirectory:@"/"]];
		
	//	[uiImageViewP = [UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spoknlog" ofType:@"png" inDirectory:@"/"]]];
		
		
    }
    return self;
}
-(void) cancelPressed {
	[ownerobject logOut: false];
	alertNotiFication(LOAD_VIEW,0,LOAD_LOGIN_VIEW,(unsigned long)self->ownerobject,0);
	
}

-(void) LoginPressed {
	[ownerobject logOut:true];
	alertNotiFication(LOAD_VIEW,0,LOAD_LOGIN_VIEW,(unsigned long)self->ownerobject,0);
	
	//self.navigationItem.rightBarButtonItem = nil;	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:SIGN_IN_TEXT 
											   style:UIBarButtonItemStylePlain 
											   target:self 
											   action:@selector(LoginPressed)] autorelease];
}
-(void) LogoutPressed {
	
	[ownerobject logOut:true];
	//alertNotiFication(LOAD_VIEW,0,LOAD_LOGIN_VIEW,(unsigned long)self->ownerobject,0);
	/*	[self.navigationItem.rightBarButtonItem initWithTitle: SIGN_IN_TEXT style:UIBarButtonItemStylePlain
	 target: self
	 action: @selector(LoginPressed) ] ;
	*/
	alertNotiFication(LOAD_VIEW,0,LOAD_LOGIN_VIEW,(unsigned long)self->ownerobject,0);
	
	//[activityIndicator startAnimating];
	
	
}
-(void)startforwardactivityIndicator
{
	forwardactivityIndicator.hidden = NO;
	switchView.hidden = YES;
	[forwardactivityIndicator startAnimating];
}
-(void)stopforwardactivityIndicator
{
	forwardactivityIndicator.hidden = YES;
	switchView.hidden = NO;
	[forwardactivityIndicator stopAnimating];

}

-(void)startProgress
{
	self.navigationItem.titleView = activityIndicator;
	[activityIndicator startAnimating];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:_CANCEL_ 
											   style:UIBarButtonItemStylePlain 
											   target:self 
											   action:@selector(cancelPressed)] autorelease];
	
	[labelStatus setText:_STATUS_CONNECTING_];
	stopProgressB = false;


}

-(void)cancelProgress
{
	stopProgressB = true;
	
	self.navigationItem.titleView = 0;
	[activityIndicator stopAnimating];
	/*self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:SIGN_IN_TEXT 
											   style:UIBarButtonItemStylePlain 
											   target:self 
											   action:@selector(LoginPressed)] autorelease];*/
	

		
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	nameInt = 0;
	statusInt = 0;
	//[buybuttonCtlP retain];
	//[aboutbuttonCtlP retain];
//	tableView.scrollEnabled = NO;
	buybuttonCtlP.exclusiveTouch = YES;
	aboutbuttonCtlP.exclusiveTouch = YES;
	tableView.scrollsToTop = YES;
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.sectionHeaderHeight = SECTION_HEIGHT;//(tableView.sectionHeaderHeight+4)/2;
	
	tableView.sectionFooterHeight = 0;//(tableView.sectionFooterHeight+4)/2;   	
	
	forwardNoCharP = malloc(100);
	memset(forwardNoCharP,0,100);
	if(stopProgressB==false)
	[self startProgress];
	
	//[buttonCtlP setBackgroundColor:[UIColor greenColor]];
	NSString *wordstring = @"1Status""\n"@"1Account Balance""\n"@"2Call Forwarding""\n"@"2Forwarding to""\n"@"3Spokn ID""\n"@"3Spokn Number";//Spokn Number
	NSArray *wordArray = [wordstring componentsSeparatedByString:@"\n"] ;
	// [self->tableView initWithStyle :UITableViewStyleGrouped];
	self->tableView.rowHeight = ROW_HEIGHT;
	//self->tableView.backgroundColor = [UIColor whiteColor];
	
		// Build the sorted section array
	[self createSectionList:wordArray];
	//[wordArray release];
	
	subviewAboutP = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, ROW_HEIGHT + 2*SECTION_HEIGHT)];
	[buybuttonCtlP setFrame:CGRectMake(10,SECTION_HEIGHT,145,ROW_HEIGHT)];
	[subviewAboutP addSubview:buybuttonCtlP];
	
	[aboutbuttonCtlP setFrame:CGRectMake(165,SECTION_HEIGHT,145,ROW_HEIGHT)];
	[subviewAboutP addSubview:aboutbuttonCtlP];
	
	self->tableView.tableFooterView = subviewAboutP;
	
	
//	buybuttonCtlP.enabled = NO;
//	aboutbuttonCtlP.enabled = NO;
	if(switchView.on==YES)
	{	
		//switchView.on = NO;
		[switchView setOn:NO animated:NO];
	}	
	switchView.enabled = NO;
	//[self startforwardactivityIndicator];
	if(statusInt)
	{
		buybuttonCtlP.enabled = YES;
	
	}
	else
	{	
		buybuttonCtlP.enabled = NO;
	}
/*	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"Buy Credits" 
											   style:UIBarButtonItemStylePlain 
											   target:self 
											   action:@selector(buyCredit:)] autorelease];*/
	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/*buyCreditsButton = [[UIButton alloc] init];
	// The default size for the save button is 49x30 pixels
	buyCreditsButton.frame = CGRectMake(0, 0, 50, 30.0);
	
	// Center the text vertically and horizontally
	buyCreditsButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	buyCreditsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	UIImage *buttonBackground;
	UIImage *buttonBackgroundPressed;
	
	
	buttonBackground = [UIImage imageNamed:_TAB_DEL_NORMAL_PNG_];
	buttonBackgroundPressed = [UIImage imageNamed:_TAB_DEL_PRESSED_PNG_];
	[CustomButton setImages:buyCreditsButton image:buttonBackground imagePressed:buttonBackgroundPressed change:NO];
	[buttonBackground release];
	[buttonBackgroundPressed release];
	buyCreditsButton.backgroundColor =  [UIColor clearColor];	
	
	
	//[buyCreditsButton setTitle:@"BUY" forState:UIControlStateNormal];
	
	[buyCreditsButton addTarget:self action:@selector(buyCredit:) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *navButton = [[UIBarButtonItem alloc] initWithCustomView:buyCreditsButton];
	
	self.navigationItem.leftBarButtonItem = navButton;
	
	[navButton release];
	[buyCreditsButton release];*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	[ownerobject updateSpoknView:self];
	
	
}
- (void)viewWillAppear:(BOOL)animated
{

	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
		[super viewDidAppear:animated];
	//[switchView setNeedsDisplay];
	if(viewResult)
	{
		//updatecontact = 1;
		viewResult = 0;
		
		if(strlen(forwardNoCharP)>0)
		{
			NSString *nsP;
			nsP = [[NSString alloc] initWithUTF8String:forwardNoCharP];
			[labelForword setText:nsP];
			[nsP release];
			if(switchView.on)
			{	
				SetOrReSetForwardNo(true,forwardNoCharP);
				#ifdef _ANALYST_
					[[GEventTracker sharedInstance] trackEvent:@"SPOKN" action:@"CALL FORWARD" label:@"ENABLE/DISABLE"];
				#endif
				[ownerobject profileResynFromApp];
				switchView.enabled = NO;
				[self startforwardactivityIndicator];
			}
			memset(forwardNoCharP,0,100);
		}
		else
		{
			//switchView.on = NO;
			//switchView.enabled = YES;
			NSString *nsP;
			nsP = [[NSString alloc] initWithUTF8String:forwardNoCharP];
			[labelForword setText:nsP];
			[nsP release];
			//if(switchView.on)
			{	
				SetOrReSetForwardNo(false,forwardNoCharP);
				#ifdef _ANALYST_
					[[GEventTracker sharedInstance] trackEvent:@"SPOKN" action:@"CALL FORWARD" label:@"ENABLE/DISABLE"];
				#endif
				[ownerobject profileResynFromApp];
			}
			switchView.enabled = NO;
			[self startforwardactivityIndicator];
			if(switchView.on==YES)
			{	
				//switchView.on = NO;
				[switchView setOn:NO animated:NO];
			}	
			
			memset(forwardNoCharP,0,100);
			
		}
		//[ self->tableView reloadData ];
	}
	else
	{
		if(viewCallB)
		{
			switchView.enabled = YES;
			[self stopforwardactivityIndicator];
			if([labelForword.text length]==0)//mean off
			{
				if(switchView.on==YES)
				{	
					//switchView.on = NO;
					[switchView setOn:NO animated:NO];
				}	
			}
			viewCallB = false;
			//[switchView setOn:NO animated:NO]; 
		}
	}
	BOOL switchB;
	switchB = switchView.on;
	[switchView setOn:!switchB animated:NO];
	[switchView setOn:switchB animated:NO];
	//[tableView reloadData];
	
}	

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
	if(uiActionSheetgP)
	{	
		[uiActionSheetgP dismissWithClickedButtonIndex:[uiActionSheetgP cancelButtonIndex] animated:NO];
		uiActionSheetgP = 0;
	}
	[labelBalance release];
	[labelStatus release];
	[labelForword release];
	[labelSpoknNo release];
	[labelSpoknID release];
	[switchView release];
	
	[listOfItems release];
	//[label release];
	if(forwardNoCharP)
	{
		free(forwardNoCharP);
	}
	[activityIndicator release];
	[forwardactivityIndicator release];
	[subviewAboutP release];
	subviewAboutP = 0;
	[buybuttonCtlP release];
	buybuttonCtlP = 0;
	[aboutbuttonCtlP release];
	aboutbuttonCtlP = 0;
    [super dealloc];
}
// Add a title for each section 

- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section 
{ 
		return nil;
} 
/*
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView 
{ 
	return ALPHA_ARRAY; 
	
} 
 */

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	
		return nil;
}
#pragma mark Table view methods

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Detemine if it's in editing mode
   
    return UITableViewCellEditingStyleNone;
}
 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if([listOfItems count])
	return [listOfItems count];
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
		 return [[listOfItems objectAtIndex:section] count];
	//return [ fileList count ];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return ROW_HEIGHT;
	
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
-(void)setDetails:(char *)titleCharP :(int )lstatusInt :(int)subStatus :(float) balance :(char *)lforwardNoCharP :(char *)spoknCharP forwardOn:(int)forward spoknID:(char*)spoknLoginId
{
	balance = balance/100;
	char s1[20];
	NSString *stringStrP;
	stringStrP = [[NSString alloc] initWithUTF8String:titleCharP ];
	
	if(stringStrP.length >0)
	{	
		self.navigationItem.title = stringStrP;
		nameInt = 1;
	}
	else
	{
		self.navigationItem.title = nil;
		nameInt = 0;
	}
	[stringStrP release];
	
	
	
	
	sprintf(s1,"USD %.2f",balance);
	stringStrP = [[NSString alloc] initWithUTF8String:s1 ];
	[labelBalance setText:stringStrP];
	[stringStrP release];
	/*switch(statusInt)
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
	*/
	
	if(statusInt!=lstatusInt)
	{
		statusInt = lstatusInt;
		[self->tableView reloadData];
		
	}
	
		
	
	switch(lstatusInt)
	{
		case 0:
			self.navigationItem.titleView = 0;
			[activityIndicator stopAnimating];
			switch(subStatus)
			{
				case LOGIN_STATUS_TIMEDOUT:
					[labelStatus setText:_STATUS_TIMEOUT1_];
					break;
				case LOGIN_STATUS_FAILED:
					[labelStatus setText:_STATUS_OFFLINE_];
					//[labelStatus setText:@"Authentication failed"];
					break;
				case LOGIN_STATUS_NO_ACCESS:
					[labelStatus setText:_STATUS_NO_NETWORK_];
					break;
				default:
					[labelStatus setText:_STATUS_OFFLINE_];	
			}
			//[self stopforwardactivityIndicator];
			self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
													   initWithTitle:SIGN_IN_TEXT 
													   style:UIBarButtonItemStylePlain 
													   target:self 
													   action:@selector(LoginPressed)] autorelease];
			
			
			buybuttonCtlP.enabled = NO;
			break;
		case 1:
			buybuttonCtlP.enabled = YES;
			//self.navigationItem.titleView = 0;
			//[activityIndicator stopAnimating];
			switch(subStatus)
			{
				case NO_WIFI_AVAILABLE:
				[labelStatus setText:_STATUS_NO_WIFI_];
				break;
				default:
				[labelStatus setText:_STATUS_ONLINE_];
			}
			//[labelStatus setText:@"Online  "];
			self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
													   initWithTitle:SIGN_OUT_TEXT 
													   style:UIBarButtonItemStylePlain 
													   target:self 
													   action:@selector(LogoutPressed)] autorelease];
			
			break;
			
	
	}
	if(lforwardNoCharP)
	{	
		stringStrP = [[NSString alloc] initWithUTF8String:lforwardNoCharP ];
		[labelForword setText:stringStrP];
		[stringStrP release];
		//if(strlen(lforwardNoCharP)>0)
		if(forward && strlen(lforwardNoCharP)>0)
		{
			if(switchView.on==NO)
			{	
				//switchView.on = YES;
				[switchView setOn:YES animated:NO];
			}	
			//switchView.on = YES;
			[labelForword setTextColor:SPOKNCOLOR]; 
		}
		else
		{
			if(switchView.on==YES)
			{	
				//switchView.on = NO;
				[switchView setOn:NO animated:NO];
			}	
			[labelForword setTextColor:[[UIColor lightGrayColor] autorelease]]; 	
		}
//		switchView.enabled = YES;
		if(statusInt)
		{
			if(nameInt)
			{	
				switchView.enabled = YES;
			}
			else
			{
				switchView.enabled = NO;
			}	
			[self stopforwardactivityIndicator];
			
		}
		else
		{
			nameInt = 0;
			switchView.enabled = NO;
			[self stopforwardactivityIndicator];
		}
	}
	
	if(spoknCharP)
	{	
		
		if(strlen(spoknCharP)>0)
		{
			stringStrP = [[NSString alloc] initWithFormat:@"+%s",(const char*)spoknCharP ];

		}
		else
		{	
		//	stringStrP = [[NSString alloc] initWithUTF8String:spoknCharP ];
			stringStrP = [[NSString alloc] initWithString:@"None"];
		}	
		[labelSpoknNo setText:stringStrP];
		[stringStrP release];
	}
	else
	{
		[labelSpoknNo setText:@""];
	}
	if(spoknLoginId)
	{	
		stringStrP = [[NSString alloc] initWithUTF8String:spoknLoginId ];
		[labelSpoknID setText:stringStrP];
		[stringStrP release];
	}
	else
	{
		[labelSpoknID setText:@""];
	}
	
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)ltableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = [indexPath row];
	NSInteger section = [indexPath section];
    
	NSString *CellIdentifier = nil;
    UILabel *label1;
	UILabel *label2;
	CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",section,row];
	NSArray *mycell = [[[listOfItems objectAtIndex:section] objectAtIndex:row] componentsSeparatedByString:@"\n"];
	NSString *temp =[mycell objectAtIndex:0];
	
    UITableViewCell *cell = [ltableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		UIImageView *uiImageViewP;
		#ifdef __IPHONE_3_0
				
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		#else
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		#endif
        
		
		if([temp isEqualToString:@"Buy Credits"]==0  && [temp isEqualToString:@"About"]==0)
		{	
    
			[uiImageViewP = [UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self->imageName[section][row].imageNameP ofType:@"png" inDirectory:@"/"]]];
		
			uiImageViewP.frame = CGRectMake(4, 8, 25, 25);
			[cell.contentView addSubview:uiImageViewP];
			//cell.text = [mycell objectAtIndex:0];
			//cell.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spoknlog" ofType:@"png" inDirectory:@"/"]];
			CGRect LabelFrame1 = CGRectMake(32, 0, 150, ROW_HEIGHT-2);
			label1 = [[UILabel alloc] initWithFrame:LabelFrame1];
			label1.text = temp;
			label1.font = [UIFont boldSystemFontOfSize:15];
			[cell.contentView addSubview:label1];
			[label1 release];
		}
		else
		{
			
			if([temp isEqualToString:@"Buy Credits"])
			{	
				#ifdef __IPHONE_3_0
					cell.textLabel.text = @"Buy Credits";
				#else
					cell.text = @"Buy Credits";
				#endif
				if(statusInt)
				{	
					[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
				}
				else
				{
					[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
					
				}	
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			else
			{
				#ifdef __IPHONE_3_0
								cell.textLabel.text = @"About";
				#else
								cell.text = @"About";
				#endif
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			#ifdef __IPHONE_3_0
				
				cell.textLabel.textAlignment = UITextAlignmentCenter;
				cell.textLabel.textColor = SPOKNCOLOR;
			#else
				
				cell.textAlignment = UITextAlignmentCenter;
				cell.textColor = SPOKNCOLOR;
			#endif	
			
			
			
			
			//[cell setSelectionStyle:UITableViewCellSelectionStyleNone];

		}
		//CGRect LabelFrame2 = CGRectMake(200, 0, 100, 40);
		//label2 = [[UILabel alloc] initWithFrame:LabelFrame2];
		//label2.textAlignment = UITextAlignmentRight;
		//label.font = [UIFont boldSystemFontOfSize:12];
		//label.textColor = [UIColor lightGrayColor];
	
		if([temp isEqualToString:@"Status"])
		{
			
			//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			label2 = labelStatus ;
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
		}
		else if([temp isEqualToString:@"Account Balance"])
		{
			
			label2 = labelBalance ;
			if(statusInt)
			{	
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			else
			{
				cell.accessoryType = UITableViewCellAccessoryNone;
				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			}
		}
		else if([temp isEqualToString:@"Forwarding to"])
		{
			
			label2 = labelForword ;
			if(statusInt)
			{	
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			else
			{
				cell.accessoryType = UITableViewCellAccessoryNone;
				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			}
			//[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		}
		else if([temp isEqualToString:@"Spokn Number"])
		{
			
			label2 = labelSpoknNo ;
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		}
		else if([temp isEqualToString:@"Spokn ID"])
		{
			
			label2 = labelSpoknID ;
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		}
				
	
		if([temp isEqualToString:@"Call Forwarding"])
		{
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			[cell addSubview:switchView];
			[cell addSubview:forwardactivityIndicator];
			if(statusInt)
			{	
				if(nameInt)
				{	
					switchView.enabled = YES;
				}
				else
				{
					switchView.enabled = NO;
				}
				[self stopforwardactivityIndicator];
			}
			else
			{
				nameInt = 0;
				switchView.enabled = NO;
				//[self startforwardactivityIndicator];
			}
			//[switchView release];
		}
		else
		{
			if([temp isEqualToString:@"Buy Credits"]==0  && [temp isEqualToString:@"About"]==0)

			{
				label2.textColor = SPOKNCOLOR;
				[cell.contentView addSubview:label2];
			}
				//[label2 release];
		}
	}	
	else
	{
		
		if([temp isEqualToString:@"Status"])
		{
			
			//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			//label2 = labelStatus ;
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			
		}
		else if([temp isEqualToString:@"Account Balance"])
		{
			
			//label2 = labelBalance ;
			if(statusInt)
			{	
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			else
			{
				cell.accessoryType = UITableViewCellAccessoryNone;
				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			}
		}
		else if([temp isEqualToString:@"Forwarding to"])
		{
			
			//label2 = labelForword ;
			if(statusInt)
			{	
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			else
			{
				cell.accessoryType = UITableViewCellAccessoryNone;
				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			}
			//[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		}
		else if([temp isEqualToString:@"Spokn Number"])
		{
			
			//label2 = labelSpoknNo ;
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		}
		else if([temp isEqualToString:@"Spokn ID"])
		{
			
			//label2 = labelSpoknID ;
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		}
		
		
		if([temp isEqualToString:@"Call Forwarding"])
		{
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			//[cell addSubview:switchView]; 
			if(statusInt)
			{	
				if(nameInt)
				{	
					switchView.enabled = YES;
				}
				else
				{
					switchView.enabled = NO;
				}
				[self stopforwardactivityIndicator];
			}
			else
			{
				nameInt = 0;
				switchView.enabled = NO;
				//[self startforwardactivityIndicator];
			}
			//[switchView release];
		}
		if([temp isEqualToString:@"Buy Credits"] )//|| [temp isEqualToString:@"About"])
		{
			if(statusInt)
			{	
				[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
			}
			else
			{
				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
				
			}
		
		}
		
		
	}
	 return cell;
}
- (void)tableView:(UITableView *)tableView 
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath 
{ 
	//[[self navigationController] pushViewController:[[ImageController alloc] init] 
	//animated:YES]; 
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
	int section = [indexPath section];
	if(section==0 && row==1 && statusInt)
	{	
		
		WebViewController     *WebViewControllerviewP;	
		NSString *urlAddress;
		WebViewControllerviewP = [[WebViewController alloc] init];
		
		
		[WebViewControllerviewP setObject:self->ownerobject];
		char * tempurl;
		tempurl = getAccountPage();
		urlAddress = [[NSString alloc] initWithUTF8String:tempurl];
		free(tempurl);
		[WebViewControllerviewP setData:urlAddress web:YES];
		
		[ [self navigationController] pushViewController:WebViewControllerviewP animated: YES ];
		[WebViewControllerviewP release];	
		[urlAddress release];
	
	}
	if(section==1 && row==1 && statusInt)
	{
		if(switchView.enabled)
		{	
			[self showForwardNoScreen];
		}	
	}
	[ltableView deselectRowAtIndexPath : indexPath animated:YES];
	if(section==3 && row==0 && statusInt)
	{
		[self buyCredit:nil];
	}
	if(section==4 && row==0 )
	{
		//[self buyCredit:nil];
		NSString *urlAddress = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
		if(urlAddress)
		{	
			WebViewController     *WebViewControllerviewP;	
			WebViewControllerviewP = [[WebViewController alloc] init];
		
			[WebViewControllerviewP setObject:self->ownerobject];
			//-(void)setData:(NSString*)urlP noweb:(Boolean)lwebB;
		
			[WebViewControllerviewP setData:urlAddress web:NO];
			[ [self navigationController] pushViewController:WebViewControllerviewP animated: YES ];
			[WebViewControllerviewP release];	
			[urlAddress release];
		}
	}
	
}

-(void)buyCredit:(id)sender
{
#ifdef _ANALYST_
	[[GEventTracker sharedInstance] trackEvent:@"SPOKN" action:@"BUY CREDIT" label:@"CREDITS"];
#endif
/*	char *tmp;
	NSString *srtrP;
	tmp = getCreditsPage();
	if(tmp)
	{
		srtrP = [[NSString alloc] initWithUTF8String:tmp];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:srtrP]];
		free(tmp);
		[ srtrP release];
	}*/
	
	uiActionSheetgP= [[UIActionSheet alloc] 
					 initWithTitle: @"Please select payment option" 
					 delegate:self
					 cancelButtonTitle:_CANCEL_ 
					 destructiveButtonTitle:nil
					 otherButtonTitles:@"Paypal",@"Credit Card", nil];
	
	uiActionSheetgP.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[uiActionSheetgP showInView:[ownerobject tabBarController].view];
}

-(void)aboutPage:(id)sender
{
#ifdef _ANALYST_
	[[GEventTracker sharedInstance] trackEvent:@"SPOKN" action:@"SUPPORT" label:@"SUPPORT"];
#endif
	
	char *tmp;
	NSString *srtrP;
	tmp = getSupportPage();
	if(tmp)
	{
		srtrP = [[NSString alloc] initWithUTF8String:tmp];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:srtrP]];
		free(tmp);
		[ srtrP release];
	}	
	
	/*NSString *urlAddress = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
	if(urlAddress)
	{	
		WebViewController     *WebViewControllerviewP;	
		WebViewControllerviewP = [[WebViewController alloc] init];
		
		[WebViewControllerviewP setObject:self->ownerobject];
		//-(void)setData:(NSString*)urlP noweb:(Boolean)lwebB;
		
		[WebViewControllerviewP setData:urlAddress web:NO];
		[WebViewControllerviewP modelViewB:YES];
		//[ [self navigationController] presentModalViewController:WebViewControllerviewP animated: YES ];
		
		//[urlAddress release];
		
		 UINavigationController *tmpCtl;
		 tmpCtl = [[ [ UINavigationController alloc ] initWithRootViewController: WebViewControllerviewP ] autorelease];
		 if(tmpCtl)
		 {	
		
			 [ownerobject.tabBarController presentModalViewController:tmpCtl animated:YES];
		 }	
		 
         [WebViewControllerviewP release];	
		
		
	}
	*/
}
#pragma mark ACTIONSHEET

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
	[actionSheet release];
	uiActionSheetgP = nil;
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch(buttonIndex)//mean Paypal button
	{
		case 0:
			break;
		case 1:
		{	
			char *tmp;
			NSString *srtrP;
			tmp = getCreditsPage();
			if(tmp)
			{
				srtrP = [[NSString alloc] initWithUTF8String:tmp];
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:srtrP]];
				free(tmp);
				[ srtrP release];
			}
		}	
		break;
		
		default:
			break;
	}
	[actionSheet release];
	

}
@end
