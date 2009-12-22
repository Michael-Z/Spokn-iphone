//
//  spoknviewcontroller.m
//  spokn
//
//  Created by Mukesh Sharma on 02/10/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import "spoknviewcontroller.h"
#import "spoknAppDelegate.h"
#import "LtpInterface.h"
#define ALPHANUM @"123"
#import  "AddeditcellController.h"
#import "WebViewController.h"
#include "ua.h"
#define SPOKNCOLOR [UIColor colorWithRed:63/255.0 green:90/255.0 blue:139/255.0 alpha:1.0]
#define ROW_HEIGHT 42


@implementation SpoknViewController
// Build a section/row list 
- (void) createSectionList: (id) wordArray
{
	// Build an array with 4 sub-array sections
	self->imageName[0][0].imageNameP = @"AS-status";
	self->imageName[0][1].imageNameP = @"AS-credits";
	self->imageName[1][0].imageNameP = @"AS-callforward";
	self->imageName[1][1].imageNameP = @"AS-forward-to";
	self->imageName[2][0].imageNameP = @"AS-spokn";
	self->imageName[2][1].imageNameP = @"AS-spokn";
	//self.imageName[1][1].imageNameP = @"";
	listOfItems = [[NSMutableArray alloc] init] ;
	for (int i = 0; i < 3; i++)
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
	
	[AddeditcellControllerviewP setData:forwardNoCharP value:"Enter forward no" placeHolder:"Enter forward no" returnValue:&viewResult];
	
	[ [self navigationController] pushViewController:AddeditcellControllerviewP animated: YES ];
	
	[AddeditcellControllerviewP release];
	

}

- (IBAction)switchChange:(UISwitch*)sender {
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
		profileResync();

	}
	else
	{
		SetOrReSetForwardNo(false,forwardNoCharP);
		profileResync();
		[labelForword setTextColor:[[UIColor lightGrayColor] autorelease]]; 	

	}
	NSLog(@"togging  %s", sender.on ? "on" : "off");

	
	//return;
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		CGRect statusFrame = CGRectMake(120, 0, 170, ROW_HEIGHT-5);
		CGRect LabelFrame2 = CGRectMake(160, 0, 117, ROW_HEIGHT-5);
		[self.tabBarItem initWithTitle:@"My Spokn" image:[UIImage imageNamed:@"TB-Spokn.png"] tag:5];
		labelBalance = [[UILabel alloc] initWithFrame:LabelFrame2];
		labelBalance.textAlignment = UITextAlignmentRight;
		labelBalance.tag = 1;
	//	LabelFrame2 = CGRectMake(160, 0, 117, 40);
		labelStatus = [[UILabel alloc] initWithFrame:statusFrame];
		labelStatus.textAlignment = UITextAlignmentRight;
		labelStatus.tag = 2;
		labelForword = [[UILabel alloc] initWithFrame:LabelFrame2];
		labelForword.textAlignment = UITextAlignmentRight;
		labelForword.tag = 4;
		labelSpoknNo = [[UILabel alloc] initWithFrame:LabelFrame2];
		labelSpoknNo.textAlignment = UITextAlignmentRight;
		labelSpoknNo.tag = 5;
		labelSpoknID = [[UILabel alloc] initWithFrame:LabelFrame2];
		labelSpoknID.textAlignment = UITextAlignmentRight;
		labelSpoknID.tag = 6;
		
		switchView = [[UISwitch alloc] initWithFrame: CGRectMake(210.0f, 10, 20.0f, 28.0f)]; 
		[switchView setTag:3]; 
		[switchView addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
		activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
		[activityIndicator setCenter:CGPointMake(160.0f, 208.0f)];
		[activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
		activityIndicator.tag = 7;
		
		//[switchView addTarget:self action:@selector(switchChange) forControlEvents:UIControlEventValueChanged];
		//cell.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spoknlog" ofType:@"png" inDirectory:@"/"]];
		
	//	[uiImageViewP = [UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spoknlog" ofType:@"png" inDirectory:@"/"]]];
		
		
    }
    return self;
}
-(void) cancelPressed {
	[ownerobject logOut: false];
	[self LoginPressed ];
}

-(void) LoginPressed {
	alertNotiFication(LOAD_VIEW,0,LOAD_LOGIN_VIEW,(unsigned long)self->ownerobject,0);
	//self.navigationItem.rightBarButtonItem = nil;	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"Sign-in" 
											   style:UIBarButtonItemStylePlain 
											   target:self 
											   action:@selector(LoginPressed)] autorelease];
}
-(void) LogoutPressed {
	
	[ownerobject logOut:true];
	//alertNotiFication(LOAD_VIEW,0,LOAD_LOGIN_VIEW,(unsigned long)self->ownerobject,0);
	/*	[self.navigationItem.rightBarButtonItem initWithTitle: @"Sign-in" style:UIBarButtonItemStylePlain
	 target: self
	 action: @selector(LoginPressed) ] ;
	*/
	[self LoginPressed];
	//[activityIndicator startAnimating];
	
	
}	
-(void)startProgress
{
	self.navigationItem.titleView = activityIndicator;
	[activityIndicator startAnimating];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"Cancel" 
											   style:UIBarButtonItemStylePlain 
											   target:self 
											   action:@selector(cancelPressed)] autorelease];
	//printf("\n startProcess");
	stopProgressB = false;

}

-(void)cancelProgress
{
	stopProgressB = true;
	//printf("\n stop progress");
	self.navigationItem.titleView = 0;
	[activityIndicator stopAnimating];
	/*self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"Sign-in" 
											   style:UIBarButtonItemStylePlain 
											   target:self 
											   action:@selector(LoginPressed)] autorelease];*/
	

		
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	statusInt = 0;
	tableView.scrollsToTop = YES;
	tableView.delegate = self;
	tableView.dataSource = self;
	   	
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
	
	UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 74.0f)];
	[buttonCtlP setFrame:CGRectMake(60,0,200,40)];
	[subview addSubview:buttonCtlP];
	[buttonCtlP release];
	self->tableView.tableFooterView = subview;
	[subview release];
	// Build the sorted section array
	[self createSectionList:wordArray];
	//[wordArray release];
	
		buttonCtlP.enabled = NO;
	
	switchView.on = NO;
	
	
	
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if(viewResult)
	{
		//updatecontact = 1;
		viewResult = 0;
		//printf("\n make changes");
		if(strlen(forwardNoCharP)>0)
		{
			NSString *nsP;
			nsP = [[NSString alloc] initWithUTF8String:forwardNoCharP];
			[labelForword setText:nsP];
			[nsP release];
			if(switchView.on)
			{	
				SetOrReSetForwardNo(true,forwardNoCharP);
				profileResync();
			}
			memset(forwardNoCharP,0,100);
		}
		else
		{
			switchView.on = NO;
			
		}
		//[ self->tableView reloadData ];
	}
	else
	{
		if(viewCallB)
		{
			if([labelForword.text length]==0)//mean off
			{
				switchView.on = NO;
			}
			////printf("\n control on");
			viewCallB = false;
			//[switchView setOn:NO animated:NO]; 
		}
	}
	
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
	//printf("\n controller release called");
	
	[labelBalance release];
	[labelStatus release];
	[labelForword release];
	[labelSpoknNo release];
	[labelSpoknID release];
	[switchView release];
	
	[buttonCtlP release];
	[listOfItems release];
	//[label release];
	if(forwardNoCharP)
	{
		free(forwardNoCharP);
	}
	[activityIndicator release];
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
	
	////////printf("\nmukesh");
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
	//	//////////////printf("\n drawing...");
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return ROW_HEIGHT;
	
}
-(void)setDetails:(char *)titleCharP :(int )lstatusInt :(int)subStatus :(float) balance :(char *)lforwardNoCharP :(char *)spoknCharP forwardOn:(int)forward spoknID:(char*)spoknLoginId
{
	balance = balance/100;
	char s1[20];
	NSString *stringStrP;
	stringStrP = [[NSString alloc] initWithUTF8String:titleCharP ];
	
	if(stringStrP.length >0)
	{	
		self.navigationItem.title = stringStrP;
	}
	else
	{
		self.navigationItem.title = nil;
	}
	[stringStrP release];
	
	
	
	//printf("\n bal %f",balance);
	sprintf(s1,"$%.2f",balance);
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
		if(statusInt)
		{
			buttonCtlP.enabled = YES;
		}
		else
		{
			buttonCtlP.enabled = NO;
		}
		[self->tableView reloadData];
		
	}
	
	switch(lstatusInt)
	{
		case 0:
			self.navigationItem.titleView = 0;
			[activityIndicator stopAnimating];
			switch(subStatus)
			{
				case LOGIN_STATUS_FAILED:
					[labelStatus setText:@"Offline  "];
					//[labelStatus setText:@"Authentication failed"];
					break;
				case LOGIN_STATUS_NO_ACCESS:
					[labelStatus setText:@"No Network "];
					break;
				default:
					[labelStatus setText:@"Offline  "];	
			}
			self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
													   initWithTitle:@"Sign-in" 
													   style:UIBarButtonItemStylePlain 
													   target:self 
													   action:@selector(LoginPressed)] autorelease];
			
			
			
			break;
		case 1:
			self.navigationItem.titleView = 0;
			[activityIndicator stopAnimating];
			switch(subStatus)
			{
				case NO_WIFI_AVAILABLE:
				[labelStatus setText:@"No wifi available"];
				break;
				default:
				[labelStatus setText:@"Online  "];
			}
			//[labelStatus setText:@"Online  "];
			self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
													   initWithTitle:@"Sign-out" 
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
			switchView.on = YES;
			[labelForword setTextColor:SPOKNCOLOR]; 
		}
		else
		{
			switchView.on = NO;
			[labelForword setTextColor:[[UIColor lightGrayColor] autorelease]]; 	
		}
	}
	
	if(spoknCharP)
	{	
		stringStrP = [[NSString alloc] initWithUTF8String:spoknCharP ];
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
    
	static NSString *CellIdentifier = @"Cell";
    UILabel *label1;
	UILabel *label2;
	printf("\nmystatus %d",statusInt);
	NSArray *mycell = [[[listOfItems objectAtIndex:section] objectAtIndex:row] componentsSeparatedByString:@"\n"];
	NSString *temp =[mycell objectAtIndex:0];
	
    UITableViewCell *cell = [ltableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		UIImageView *uiImageViewP;
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    
    
		[uiImageViewP = [UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self->imageName[section][row].imageNameP ofType:@"png" inDirectory:@"/"]]];
		
		uiImageViewP.frame = CGRectMake(4, 8, 25, 25);
		[cell.contentView addSubview:uiImageViewP];
		//cell.text = [mycell objectAtIndex:0];
		//cell.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spoknlog" ofType:@"png" inDirectory:@"/"]];
		CGRect LabelFrame1 = CGRectMake(32, 0, 150, 40);
		label1 = [[UILabel alloc] initWithFrame:LabelFrame1];
		label1.text = temp;
		label1.font = [UIFont boldSystemFontOfSize:15];
		[cell.contentView addSubview:label1];
		[label1 release];
		
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
			if(statusInt)
			{	
				switchView.enabled = YES;
			}
			else
			{
				switchView.enabled = NO;
			}
			//[switchView release];
		}
		else
		{
			label2.textColor = SPOKNCOLOR;
			[cell.contentView addSubview:label2];
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
				switchView.enabled = YES;
			}
			else
			{
				switchView.enabled = NO;
			}
			//[switchView release];
		}
		
		
		//printf("\n error ");
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
		WebViewControllerviewP = [WebViewController alloc];
		[WebViewControllerviewP setObject:self->ownerobject];
		[ [self navigationController] pushViewController:WebViewControllerviewP animated: YES ];
		[WebViewControllerviewP release];	
	
	}
	if(section==1 && row==1 && statusInt)
	{
		[self showForwardNoScreen];
	}
	[ltableView deselectRowAtIndexPath : indexPath animated:YES];
	
	
}

-(IBAction)buyCredit:(id)sender
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

@end
