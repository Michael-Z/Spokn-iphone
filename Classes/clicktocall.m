//
//  clicktocall.m
//  spokn
//
//  Created by Rishi Saxena on 12/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "clicktocall.h"
#import  "AddeditcellController.h"
#import "alertmessages.h"
#import "spoknAppDelegate.h"
#define SPOKNCOLOR [UIColor colorWithRed:63/255.0 green:90/255.0 blue:139/255.0 alpha:1.0]
#define ROW_HEIGHT 42

@implementation clicktocall
@synthesize tableView;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		
		CGRect LabelFrame1 = CGRectMake(20, 6, 117, ROW_HEIGHT-5);
		labelconnectionType = [[UILabel alloc] initWithFrame:LabelFrame1];
		labelconnectionType.textAlignment = UITextAlignmentLeft;
		labelconnectionType.tag = 1;
		
		CGRect LabelFrame3 = CGRectMake(20, 6, 117, ROW_HEIGHT-5);
		number = [[UILabel alloc] initWithFrame:LabelFrame3];
		number.textAlignment = UITextAlignmentLeft;
		number.tag = 3;
		
		CGRect LabelFrame2 = CGRectMake(160, 6, 117, ROW_HEIGHT-5);
		labelAparty = [[UILabel alloc] initWithFrame:LabelFrame2];
		labelAparty.textAlignment = UITextAlignmentRight;
		labelAparty.tag = 2;
		

    }
    return self;
}

-(char*) gecallbackNumber
{
	
	NSString *nsP;
	nsP=(NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"callbacknumber"]; 
	NSLog(@"NUMBER=%@",nsP);
	//nsP = [[NSUserDefaults standardUserDefaults] stringForKey:@"callbacknumber"];
	if(nsP)
		return (char*)([nsP  cStringUsingEncoding:NSUTF8StringEncoding]);
	else return nil;
}

-(void)setObject:(id) object 
{
	self->ownerobject = object;
}

-(IBAction)donePressed
{
	
	NSString *num;
	num = [[labelAparty text] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" _$!<>+."]];
	NSLog(@" num = %@",num);
	if(num){
	[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithString:num] forKey:@"callbacknumber"]; 
	//[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithUTF8String:apartyNoCharP] forKey:@"callbacknumber"]; 
	[[NSUserDefaults standardUserDefaults] synchronize];
	}
	[self  dismissModalViewControllerAnimated:YES];
}

-(void)modelViewB:(Boolean)lmodalB
{
	modalB = lmodalB;
	
}

-(void)addCallbacknumber
{
	AddeditcellController     *AddeditcellControllerviewP;	
	AddeditcellControllerviewP = [[AddeditcellController alloc]init];
	[AddeditcellControllerviewP SetkeyBoardType:UIKeyboardTypePhonePad :NUMBER_RANGE buttonType:1];
	[AddeditcellControllerviewP setObject:self->ownerobject];
	viewResult = 0;
	char *apartyCharP;
	apartyCharP = (char*)[[labelAparty text] cStringUsingEncoding:NSUTF8StringEncoding];
	if(apartyCharP)
	{
		strcpy(apartyNoCharP,apartyCharP);
	}
	
	[AddeditcellControllerviewP setData:apartyNoCharP value:"Enter forward number." placeHolder:"Number" title:"Aparty" returnValue:&viewResult];
	printf("result %d ",viewResult);
	
	[ [self navigationController] pushViewController:AddeditcellControllerviewP animated: YES ];
	
	[AddeditcellControllerviewP release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setTitle:@"Spokn Settings"];
	tableView.delegate = self;
	tableView.dataSource = self;
	protocolType = 0;
	apartyNoCharP = malloc(100);
	memset(apartyNoCharP,0,100);
	sectionHeaders = [[NSMutableArray alloc] initWithObjects:@"Protocol",@"Callback Number",nil];
	
	
	if(modalB)
	{
		self.navigationItem.rightBarButtonItem = [ [ [ UIBarButtonItem alloc ]
													initWithBarButtonSystemItem: UIBarButtonSystemItemDone
													target: self
													action: @selector(donePressed) ] autorelease ];
		
		
	}
	NSString *nsP;
	nsP = [[NSUserDefaults standardUserDefaults] stringForKey:@"callbacknumber"];
	if(nsP)
	{
		[labelAparty setText:nsP];
	}
	

	[tableView reloadData];		
}

- (void)viewWillAppear:(BOOL)animated  
{  
	[super viewWillAppear:animated];
	if(viewResult)
	{
		 if(strlen(apartyNoCharP)==0)
		 {
			 [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithUTF8String:apartyNoCharP] forKey:@"callbacknumber"]; 
			 [[NSUserDefaults standardUserDefaults] synchronize];
		 }
	}
	printf("new result %d ",viewResult);
	if(strlen(apartyNoCharP)>0)
	{
		NSString *stringStrP;
		[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithUTF8String:apartyNoCharP] forKey:@"callbacknumber"]; 
		[[NSUserDefaults standardUserDefaults] synchronize];
		stringStrP = [[NSString alloc] initWithUTF8String:apartyNoCharP ];
		[labelAparty setText:stringStrP];
		[stringStrP release];
	}
	else 
	{
		NSString *nsP;
		nsP = [[NSUserDefaults standardUserDefaults] stringForKey:@"callbacknumber"];
		if(nsP)
		{
			[labelAparty setText:nsP];
			[tableView reloadData];
		}
	}
	
	if(protocolType)
	{	[[NSUserDefaults standardUserDefaults] setInteger:protocolType  forKey:@"protocoltypeIndex"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[self setprotocolType:protocolType];
		
		
	}
	else 
	{
		int setIndex;
		setIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"protocoltypeIndex"];
		if(setIndex)
		{
			[self setprotocolType:setIndex];
		}
		else {
			[self setprotocolType:1];
		}
		
	}
	
	[tableView reloadData];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	
	[sectionHeaders release];
	[labelconnectionType release];
	[number release];
	[labelAparty release];
	if(apartyNoCharP)
	{	
		free(apartyNoCharP);
	}
}
#pragma mark Actionsheet methods
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
	[actionSheet release];
	uiActionSheetgP = nil;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (actionSheet == uiActionSheetgP)
	{
		[self setprotocolType:buttonIndex+1];
		[actionSheet release];
	}
}

- (void)setprotocolType:(int)index
{
	switch(index)
	{
		case 1://mean SIP
		{	
			NSLog(@"sip");
			[labelconnectionType setText:@"SIP"];
			[ownerobject setoutCallTypeProtocol:index];
		}	
			break;
		case 2://mean CallBack
		{	
			NSLog(@"CallBack");
			[labelconnectionType setText:@"CALLBACK"];
			[ownerobject setoutCallTypeProtocol:index];
		}	
			break;
			
		case 3://mean Both
		{	
			[labelconnectionType setText:@"BOTH"];
			[ownerobject setoutCallTypeProtocol:index];
		}	
			break;	
			
		default:
			break;
	}	
	[[NSUserDefaults standardUserDefaults] setInteger:index  forKey:@"protocoltypeIndex"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[tableView reloadData];
}
#pragma mark Table view methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [sectionHeaders objectAtIndex:section];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Detemine if it's in editing mode
	
    return UITableViewCellEditingStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
	
}
- (UITableViewCell *)tableView:(UITableView *)ltableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = [indexPath row];
	NSInteger section = [indexPath section];
	
	UILabel *templabel;
    
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
#ifdef __IPHONE_3_0
		
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
#else
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
#endif
		
		if(section==0 && row==0 )
		{
			templabel = labelconnectionType;
			templabel.textColor = SPOKNCOLOR;
			[cell addSubview:templabel];
		}
		if(section==1 && row==0 )
		{
			
			templabel = number;
			templabel.textColor = SPOKNCOLOR;
			templabel.text = @"NUMBER";
			[cell addSubview:templabel];
			
			templabel = labelAparty;
			templabel.textColor = SPOKNCOLOR;
			[cell addSubview:templabel];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			
		}
	}	
	else
	{
	}
	return cell;
	
}
- (void)tableView:(UITableView *)ltableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	int row = [indexPath row];
	int section = [indexPath section];
	if(section==0 && row==0)
	{
		
		uiActionSheetgP= [[UIActionSheet alloc] 
						  initWithTitle: @"Please select your prefrences" 
						  delegate:self
						  cancelButtonTitle:_CANCEL_ 
						  destructiveButtonTitle:nil
						  otherButtonTitles:@"Sip",@"CallBack",@"Both", nil];
		
		uiActionSheetgP.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
		[uiActionSheetgP showInView:[ownerobject tabBarController].view];
	}
	if(section==1 && row==0)
	{
		[self addCallbacknumber];
	}
	[ltableView deselectRowAtIndexPath : indexPath animated:YES];
}
@end
