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
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[[self navigationController] setNavigationBarHidden:NO animated:NO];
	[self navigationController].navigationBar.barStyle = UIBarStyleBlack;


}
- (void)viewDidAppear:(BOOL)animated;     // Called when the view has been fully transitioned onto the screen. Default does nothing
{
	[super viewDidAppear:animated];
	if(firstB)
	{	
		firstB = 0;
		[tableView reloadData];
		
	
	}	
	
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//self.view.backgroundColor =  [[UIColor blackColor] autorelease];
	/*[self.view setBackgroundColor:[[[UIColor alloc] 
									initWithPatternImage:[UIImage imageNamed:_CALL_WATERMARK_PNG_]]
								   autorelease]];*/
	[self giveOrder];
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
	tableView.scrollEnabled = NO;
	[tableView reloadData];
	firstB = 1;
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
}/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(cell.tag<1000)
	{	
		CGRect frame;
		cell.tag+=1000;
		frame = cell.textLabel.frame ;
		frame.origin.x+=50;
		cell.textLabel.frame = frame;
	}	
	else {
		[cell.textLabel setNeedsDisplay];
	}

	//[button1 release];
	
}
*/
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
-(void)endNewClicked:(UIButton *)buttonP
{
	UITableViewCell *lsuperView;
	UIView *tempP;
	NSIndexPath *inSectionP;
	tempP = [buttonP superview]; 
	lsuperView =(UITableViewCell *) [tempP superview]; 
	/*int row;
	row = lsuperView.tag-1000;
	inSectionP = [tableView indexPathForCell:lsuperView];
	
	
	NSMutableArray *array = [ [ NSMutableArray alloc ] init ];
	[ array addObject: inSectionP ];
	[ self->tableView deleteRowsAtIndexPaths: array withRowAnimation: UITableViewRowAnimationFade ];
	
	[array release];
	*/
	
	inSectionP = [tableView indexPathForCell:lsuperView];
	int row = [inSectionP row];
	
	[addCallP endSelectedCall:row];
	callRow[row].selected = 0;
	callRow[row].order = 100;
	[self sortByOrder];	
	if([addCallP totalCallActive])
	{	
		
		
		/*inSectionP = [tableView indexPathForCell:(UITableViewCell*)lsuperView];
		
		
		NSMutableArray *array = [ [ NSMutableArray alloc ] init ];
		[ array addObject:[ NSIndexPath indexPathForRow:row inSection:0]];;
		[tableView beginUpdates];
		[ self->tableView deleteRowsAtIndexPaths: array withRowAnimation: UITableViewRowAnimationFade ];
		[tableView endUpdates];
		[array release];
		*/
		[tableView reloadData];
	}	
	else {
			[[self navigationController] popViewControllerAnimated:YES];
	}

}

-(void)endClicked:(UIButton *)buttonP
{
	
	UITableViewCell *lsuperView;
	UIView *tempP;
	tempP = [buttonP superview]; 
	lsuperView =(UITableViewCell *) [tempP superview]; 
		
	NSIndexPath *inSectionP;
	inSectionP = [tableView indexPathForCell:(UITableViewCell*)lsuperView];
	int row = [inSectionP row];
	callRow[row].selected = 1;
		
	[tableView reloadData];
	//lsuperView.textLabel.textAlignment = UITextAlignmentLeft;
}

-(void)privateClicked:(UIButton *)buttonP
{
	UIView *lsuperView;
	NSIndexPath *inSectionP;
	lsuperView = [buttonP superview]; 
	inSectionP = [tableView indexPathForCell:(UITableViewCell*)lsuperView];
	int row = [inSectionP row];
	
	[addCallP selectedCall:row];
	[[self navigationController] popViewControllerAnimated:YES];
	

}
-(void)giveOrder
{
	int j;
	for(j=0;j<MAXCALL;++j)
	{
		callRow[j].order = j;
		callRow[j].selected = 0;
	}
	
}
-(void)sortByOrder
{
	int i,j;
	callRowOrder t;
	for(i=0;i<MAXCALL;++i)
	{
		
		for(j=0;j<MAXCALL-1;++j)
		{
			if(callRow[j].order>callRow[j+1].order)
			{	
				t= callRow[j];
				callRow[j]=callRow[j+1];
				callRow[j+1]=t;
			}
		}
		
	}
}
- (UITableViewCell *)tableView:(UITableView *)ltableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	int row = [indexPath row];
	int section = [indexPath section];
	NSString *resultP=0;
	resultP = [addCallP getStringByIndex:row];
	NSString *CellIdentifier = nil;
	CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",section,row];
	UITableViewCell *cell = [ltableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
//	if (cell == nil) 
	{
		
#ifdef __IPHONE_3_0
		
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
#else
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
#endif
		cell.textLabel.textColor = [[UIColor whiteColor] autorelease];
		
		if(callRow[row].selected)
		{
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			[button setBackgroundImage:[UIImage imageNamed:END_CALL_BIG_IMG_PNG] forState:UIControlStateNormal];
			[button setFrame:CGRectMake(5.0f, 18.0f, 87.0f, 28.0f)];
			
			button.tag = 2000 + row;
			[button removeTarget:self action:@selector(endClicked:)  forControlEvents:UIControlEventTouchUpInside];
			[button addTarget:self action:@selector(endNewClicked:) forControlEvents:UIControlEventTouchUpInside];
			cell.accessoryView.hidden = YES;
			cell.tag=3000+row;
			cell.accessoryView = 0;
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			//cell.imageView.image = [UIImage imageNamed:END_CALL_IMG_PNG];
			[cell.contentView addSubview:button];
			
		
		}
		
		else {
			
		

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
				[cell.contentView addSubview:button];
				//[button release];
				//cell.imageView = [UIImage imageNamed:@"11_declinecall_36_18.png"];
				
			}	
			UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
			[button1 setBackgroundImage:[UIImage imageNamed:END_CALL_IMG_PNG] forState:UIControlStateNormal];
			[button1 setFrame:CGRectMake(5.0f, 22.0f, 24.0f, 24.0f)];
			//[button setCenter:CGPointMake(40.0f, 20.0f)];
			//	[button setTitle:@"PRIVATE" forState:UIControlStateNormal];
			button1.tag = 2000 + row;
			[button1 removeTarget:self action:@selector(endNewClicked:)  forControlEvents:UIControlEventTouchUpInside];
			[button1 addTarget:self action:@selector(endClicked:) forControlEvents:UIControlEventTouchUpInside];
			
			//cell.textLabel.textAlignment = UITextAlignmentCenter;
			
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			//cell.imageView.image = [UIImage imageNamed:END_CALL_IMG_PNG];
			[cell.contentView addSubview:button1];
			
			cell.tag=1000+row;
		}
	}
	if(cell.tag>=3000)
	{
		cell.textLabel.text =[NSString stringWithFormat:@"%*c%@",SPACE_DEL,32,resultP]	;
	}
	else {
		cell.textLabel.text =[NSString stringWithFormat:@"%*c%@",SPACE_NO_DEL,32,resultP]	;
	}

	
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
	
	UITableViewCell *cell = (SpoknUITableViewCell*)[ self->tableView cellForRowAtIndexPath: indexPath ];
	if(cell)
	{
		int row = [indexPath row];
		if(cell.tag>=3000)
		{
			/*UIButton *gbutton;
			gbutton = (UIButton*)[cell viewWithTag:2000+row];
			[gbutton setBackgroundImage:[UIImage imageNamed:END_CALL_IMG_PNG] forState:UIControlStateNormal];
			[gbutton setFrame:CGRectMake(5.0f, 22.0f, 24.0f, 24.0f)];
			[gbutton removeTarget:self action:@selector(endNewClicked:)  forControlEvents:UIControlEventTouchUpInside];
			[gbutton addTarget:self action:@selector(endClicked:) forControlEvents:UIControlEventTouchUpInside];
		
			cell.accessoryView.hidden = NO;
			gbutton = nil;
			cell.tag=1000+row;
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
				//[button release];
				//cell.imageView = [UIImage imageNamed:@"11_declinecall_36_18.png"];
				
			}	*/
			callRow[row].selected = 0;
			[tableView reloadData];
		}
	
	}
	
}

@end
