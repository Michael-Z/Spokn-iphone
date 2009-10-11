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
#define ALPHA @"123"
#import  "AddeditcellController.h"
#import "WebViewController.h"
#include "ua.h"
@implementation SpoknViewController
// Build a section/row list 
- (void) createSectionList: (id) wordArray
{
	// Build an array with 4 sub-array sections
	listOfItems = [[[NSMutableArray alloc] init] retain];
	for (int i = 0; i < 3; i++)
	{
		[listOfItems addObject:[[[NSMutableArray alloc] init] retain]];
	}
	// Add each word to its alphabetical section
	for (NSString *word in wordArray)
	{
		if ([word length] == 0) continue;
		
		// determine which letter starts the name
		NSRange range = [ALPHA rangeOfString:[[word substringToIndex:1] uppercaseString]];
		
		// Add the name to the proper array
		[[listOfItems objectAtIndex:range.location] addObject:[word substringFromIndex:1]];
	}
}

-(void)setObject:(id) object 
{
	self->ownerobject = object;
}
- (IBAction)switchChange:(UISwitch*)sender {
	if(sender.on)
	{

		AddeditcellController     *AddeditcellControllerviewP;	
		AddeditcellControllerviewP = [[AddeditcellController alloc]init];
		[AddeditcellControllerviewP SetkeyBoardType:UIKeyboardTypePhonePad :NUMBER_RANGE buttonType:0];
		[AddeditcellControllerviewP setObject:self->ownerobject];
		viewResult = 0;
		[AddeditcellControllerviewP setData:forwardNoCharP value:"Enter forward no" placeHolder:"Enter forward no" returnValue:&viewResult];
		
		[ [self navigationController] pushViewController:AddeditcellControllerviewP animated: NO ];
		
			[AddeditcellControllerviewP release];
	}
	else
	{
		SetOrReSetForwardNo(false,forwardNoCharP);
		profileResync();

	}
	NSLog(@"togging  %s", sender.on ? "on" : "off");

	
	//return;
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		CGRect LabelFrame2 = CGRectMake(165, 0, 117, 40);
		[self.tabBarItem initWithTitle:@"My Spokn" image:[UIImage imageNamed:@"spokntab.png"] tag:5];
		labelBalance = [[UILabel alloc] initWithFrame:LabelFrame2];
		labelBalance.textAlignment = UITextAlignmentRight;
		labelBalance.tag = 1;
		labelStatus = [[UILabel alloc] initWithFrame:LabelFrame2];
		labelStatus.textAlignment = UITextAlignmentRight;
		labelStatus.tag = 2;
		labelForword = [[UILabel alloc] initWithFrame:LabelFrame2];
		labelForword.textAlignment = UITextAlignmentRight;
		labelForword.tag = 4;
		labelSpoknNo = [[UILabel alloc] initWithFrame:LabelFrame2];
		labelSpoknNo.textAlignment = UITextAlignmentRight;
		labelSpoknNo.tag = 5;
		switchView = [[UISwitch alloc] initWithFrame: CGRectMake(210.0f, 10, 20.0f, 28.0f)]; 
		[switchView setTag:3]; 
		[switchView addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
		//[switchView addTarget:self action:@selector(switchChange) forControlEvents:UIControlEventValueChanged];
		//cell.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spoknlog" ofType:@"png" inDirectory:@"/"]];
		
	//	[uiImageViewP = [UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spoknlog" ofType:@"png" inDirectory:@"/"]]];
		
		
    }
    return self;
}

-(void) LoginPressed {
	alertNotiFication(LOAD_VIEW,0,LOAD_LOGIN_VIEW,(unsigned long)self->ownerobject,0);
	[self.navigationItem.rightBarButtonItem initWithTitle: @"Sign-out" style:UIBarButtonItemStylePlain
	 target: self
	 action: @selector(LogoutPressed) ] ;
	
}
-(void) LogoutPressed {
	
	[ownerobject logOut];
		[self.navigationItem.rightBarButtonItem initWithTitle: @"Sign-in" style:UIBarButtonItemStylePlain
	 target: self
	 action: @selector(LoginPressed) ] ;
	
	//[activityIndicator startAnimating];
	
	
}	
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	tableView.scrollsToTop = YES;
	tableView.delegate = self;
	tableView.dataSource = self;
	forwardNoCharP = malloc(100);
	memset(forwardNoCharP,0,100);
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"Sign-out" 
											   style:UIBarButtonItemStylePlain 
											   target:self 
											   action:@selector(LogoutPressed)] autorelease];
	//[buttonCtlP setBackgroundColor:[UIColor greenColor]];
	NSString *wordstring = @"1Status""\n"@"1Account Balance""\n"@"2Call Forwarding""\n"@"2Forwarding to""\n"@"3Spokn Number";
	NSArray *wordArray = [wordstring componentsSeparatedByString:@"\n"] ;
	// self->tableView initWithStyle:UITableViewStyleGrouped];
	self->tableView.rowHeight = 50.0f;
	self->tableView.backgroundColor = [UIColor whiteColor];
	
	self->tableView.tableFooterView = buttonCtlP;
	[buttonCtlP release];
	// Build the sorted section array
	[self createSectionList:wordArray];
	//[wordArray release];
	
	
	
	
	
	
	
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if(viewResult)
	{
		//updatecontact = 1;
		viewResult = 0;
		printf("\n make changes");
		if(strlen(forwardNoCharP)>0)
		{
			NSString *nsP;
			nsP = [[NSString alloc] initWithUTF8String:forwardNoCharP];
			[labelForword setText:nsP];
			[nsP release];
			
			SetOrReSetForwardNo(true,forwardNoCharP);
			profileResync();
			memset(forwardNoCharP,0,100);
		}
		//[ self->tableView reloadData ];
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
	printf("\n controller release called");
	[buttonCtlP release];
	[listOfItems release];
	//[label release];
	if(forwardNoCharP)
	{
		free(forwardNoCharP);
	}
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
	
	//////printf("\nmukesh");
	return nil;
}
#pragma mark Table view methods

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
	//	////////////printf("\n drawing...");
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
	
}
-(void)setDetails:(char *) titleCharP :(int )statusInt :(float) balance :(char *)lforwardNoCharP :(char *)spoknCharP
{
	balance = balance/100;
	char s1[20];
	NSString *stringStrP;
	stringStrP = [[NSString alloc] initWithUTF8String:titleCharP ];
	self.navigationItem.title = stringStrP;
	[stringStrP release];
	
	
	
	printf("\n bal %f",balance);
	sprintf(s1,"$ %.2f  ",balance);
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
	switch(statusInt)
	{
		case 0:
			[labelStatus setText:@"Offline  "];
			[self.navigationItem.rightBarButtonItem initWithTitle: @"Sign-in" style:UIBarButtonItemStylePlain
			 target: self
			 action: @selector(LoginPressed) ] ;
			
			break;
		case 1:
			[labelStatus setText:@"Online  "];
			break;
			
	
	}
	if(lforwardNoCharP)
	{	
		stringStrP = [[NSString alloc] initWithUTF8String:lforwardNoCharP ];
		[labelForword setText:stringStrP];
		[stringStrP release];
		if(strlen(lforwardNoCharP)>0)
		{
			switchView.on = YES;
		}
		else
		{
			switchView.on = NO;
		}
	}
	
	if(spoknCharP)
	{	
		stringStrP = [[NSString alloc] initWithUTF8String:spoknCharP ];
		[labelSpoknNo setText:stringStrP];
		[stringStrP release];
	}
	
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)ltableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = [indexPath row];
	NSInteger section = [indexPath section];
    
	static NSString *CellIdentifier = @"Cell";
    UILabel *label1;
	UILabel *label2;
	
    UITableViewCell *cell = [ltableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		UIImageView *uiImageViewP;
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    
    
		NSArray *mycell = [[[listOfItems objectAtIndex:section] objectAtIndex:row] componentsSeparatedByString:@"\n"];
		[uiImageViewP = [UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spoknlog" ofType:@"png" inDirectory:@"/"]]];
		
		uiImageViewP.frame = CGRectMake(4, 8, 32, 32);
		[cell.contentView addSubview:uiImageViewP];
		//cell.text = [mycell objectAtIndex:0];
		NSString *temp =[mycell objectAtIndex:0];
		//cell.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spoknlog" ofType:@"png" inDirectory:@"/"]];
		CGRect LabelFrame1 = CGRectMake(35, 0, 150, 40);
		label1 = [[UILabel alloc] initWithFrame:LabelFrame1];
		label1.text = temp;
		[cell.contentView addSubview:label1];
		[label1 release];
		
		CGRect LabelFrame2 = CGRectMake(200, 0, 100, 40);
		//label2 = [[UILabel alloc] initWithFrame:LabelFrame2];
		//label2.textAlignment = UITextAlignmentRight;
		//label.font = [UIFont boldSystemFontOfSize:12];
		//label.textColor = [UIColor lightGrayColor];
	
		if([temp isEqualToString:@"Status"])
		{
			
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			label2 = labelStatus ;
		
		}
		else if([temp isEqualToString:@"Account Balance"])
		{
			
			label2 = labelBalance ;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		else if([temp isEqualToString:@"Forwarding to"])
		{
			
			label2 = labelForword ;
		}
		else if([temp isEqualToString:@"Spokn Number"])
		{
			
			label2 = labelSpoknNo ;
		}
		
				
	
		if([temp isEqualToString:@"Call Forwarding"])
		{
			
			[cell addSubview:switchView]; 
			[switchView release];
		}
		else
		{
			label2.textColor = [UIColor blueColor];
			[cell.contentView addSubview:label2];
			[label2 release];
		}
	}	
	else
	{
		printf("\n error ");
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
	
	int row = [indexPath row];
	int section = [indexPath section];
		
	
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	int row = [indexPath row];
	int section = [indexPath section];
	if(section==0 && row==1 )
	{	
		WebViewController     *WebViewControllerviewP;	
		WebViewControllerviewP = [WebViewController alloc];
		[WebViewControllerviewP setObject:self->ownerobject];
		[ [self navigationController] pushViewController:WebViewControllerviewP animated: YES ];
		[WebViewControllerviewP release];	
	
	}
	
}

-(IBAction)buyCredit:(id)sender
{

}

@end