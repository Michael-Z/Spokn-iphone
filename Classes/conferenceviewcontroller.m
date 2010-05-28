//
//  confrenceviewcontroller.m
//  spokn
//
//  Created by Mukesh Sharma on 03/05/10.
//  Copyright 2010 Geodesic Ltd. All rights reserved.
//

#import "conferenceviewcontroller.h"

#import "callviewcontroller.h"
#import "alertmessages.h"
@implementation ConferenceViewController


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
	showB = YES;
    return self;
}
-(void)setObject:(id)ownerObjP

{

}
-(void)setDelegate:(CallViewController *)lcallViewCtlP
{
	addCallP = lcallViewCtlP;

}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//self.view.backgroundColor =  [[UIColor blackColor] autorelease];
	/*[self.view setBackgroundColor:[[[UIColor alloc] 
									initWithPatternImage:[UIImage imageNamed:_CALL_WATERMARK_PNG_]]
								   autorelease]];*/
	[[self navigationController] setNavigationBarHidden:NO animated:NO];
	[self navigationController].navigationBar.barStyle = UIBarStyleBlack;
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.separatorColor = [[UIColor darkGrayColor] autorelease];
	//tableView.alpha = 0.5;
	//tableView.tableFooterView = callTypeLabelP;
	//tableView.tableHeaderView = callnoLabelP;
	tableView.backgroundColor = [[UIColor blackColor] autorelease];
	//uiImageP = [[UIImageView alloc]initWithImage:[ UIImage imageNamed:_CALL_BLUETOOH_BG_ ]];
	self.title = @"Conference";
	tableView.editing = NO;
	[tableView reloadData];
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	[self navigationController].navigationBar.barStyle = UIBarStyleDefault;
}
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
	[addCallP objectDestroy];
    [super dealloc];
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
	if(addCallP==0) return 0;
	return [addCallP totalCallActive];
	//return [[listOfItems objectAtIndex:section] count];
	//return [ fileList count ];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 70;
	
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
-(void)privateClicked:(UIButton *)buttonP
{
	UIView *lsuperView;
	lsuperView = [buttonP superview]; 
	[addCallP selectedCall:lsuperView.tag-1000];
	[[self navigationController] popViewControllerAnimated:YES];

}
- (UITableViewCell *)tableView:(UITableView *)ltableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	int row = [indexPath row];
	int section = [indexPath section];
	NSString *resultP=0;
	resultP = [addCallP getStringByIndex:row];
	NSString *CellIdentifier = nil;
	CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",section,row];
	UITableViewCell *cell = [ltableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) 
	{
		
#ifdef __IPHONE_3_0
		
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
#else
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
#endif
		cell.textLabel.textColor = [[UIColor whiteColor] autorelease];
		
		if(showB)
		{	
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			[button setBackgroundImage:[UIImage imageNamed:PRIVATE_CALL_IMG_PNG] forState:UIControlStateNormal];
			[button setFrame:CGRectMake(160.0f, 0.0f, 76.0f, 23.0f)];
			//[button setCenter:CGPointMake(40.0f, 20.0f)];
		//	[button setTitle:@"PRIVATE" forState:UIControlStateNormal];
			button.tag = 1000 + row;
			[button addTarget:self action:@selector(privateClicked:) forControlEvents:UIControlEventTouchUpInside];
			cell.accessoryView = button;
			[button release];
			//cell.imageView = [UIImage imageNamed:@"11_declinecall_36_18.png"];
			
		}	
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		cell.imageView.image = [UIImage imageNamed:END_CALL_IMG_PNG];
		//[cell addSubview:button];
	}
	cell.tag = 1000 + row;
	cell.textLabel.text = resultP;
	return cell;
	
	
}
- (void)tableView:(UITableView *)tableView 
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath 
{ 

	
	//[[self navigationController] pushViewController:[[ImageController alloc] init] 
	//animated:YES]; 
} 
-(void)reload
{
	 if([addCallP totalCallActive]==0)//mean no call
	 {
		 [[self navigationController] popViewControllerAnimated:YES];
	 }
	else
	{	
		[tableView reloadData];
	}
}
-(void)showPrivate:(int)lshowB
{
	showB = lshowB; 
}
- (void)tableView:(UITableView *)ltableView 
commitEditingStyle:(UITableViewCellEditingStyle) editingStyle 
forRowAtIndexPath:(NSIndexPath *) indexPath 
{ 
	
		int row = [indexPath row];
	[addCallP selectedCall:row];
	[[self navigationController] popViewControllerAnimated:YES];

	
}

- (void)tableView:(UITableView *)ltableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//int row = [indexPath row];
	//int section = [indexPath section];
	
}

@end
