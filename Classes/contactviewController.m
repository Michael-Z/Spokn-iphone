//
//  contact.m
//  spoknclient
//
//  Created by Mukesh Sharma on 05/07/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//
//#define ORANGE [UIColor colorWithRed:1.0f green:0.522f blue:0.03f alpha:1.0f]
#import "contactviewcontroller.h"
#import "Ltptimer.h"
#import "LtpInterface.h"
#include "ua.h"
#import "SpoknAppDelegate.h"
#import "contactDetailsviewcontroller.h"
#import "AddEditcontactViewController.h"
#import "addressBookContact.h"
#import "OverlayViewController.h"
#import "AddeditcellController.h"
//#import <UITableViewIndex.h>
#import "customcell.h"
/*
@interface MyNavControler : UINavigationBar 

//-(void)ytest;
@end


@implementation MyNavControler 

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//printf("\n touch");
	[super touchesBegan:touches withEvent:event];
	[self resignFirstResponder];
}
@end
 */
@implementation ContactViewController

@synthesize ltpInterfacesP;
@synthesize  uaObject;
@synthesize parentView;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//printf("\n touch");
	[super touchesBegan:touches withEvent:event];
	[self resignFirstResponder];
}

-(void)setObject:(id) object 
{
	self->ownerobject = object;
	
}
- (void) buildSearchArrayFrom: (NSString *) matchString
{
	NSString *upString = [matchString uppercaseString];
	if ([matchString length] == 0)
	{
		return;
	}
	[self reloadLocal:upString :0];
}
- (void) doneSearching_Clicked:(id)sender {
	
	searchbar.text = @"";
	[searchbar resignFirstResponder];
	
	self->tableView.scrollEnabled = YES;
	
	[ovController.view removeFromSuperview];
	[ovController release];
	ovController = nil;
	
	
}
- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
	//This method is called again when the user clicks back from the detail view.
	//So the overlay is displayed on the results, which is something we do not want to happen.
	UITextField *searchField = [[theSearchBar subviews] lastObject];
	if(searchField.text.length>0)
		return;
	
	//Add the overlay view.
	if(ovController == nil)
		ovController = [[OverlayViewController alloc] initWithNibName:@"OverlayView" bundle:[NSBundle mainBundle]];
	
	CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
	CGFloat width = self.view.frame.size.width;
	CGFloat height = self.view.frame.size.height;
	
	//Parameters x = origion on x-axis, y = origon on y-axis.
	CGRect frame = CGRectMake(0, yaxis, width, height);
	ovController.view.frame = frame;	
	ovController.view.backgroundColor = [UIColor grayColor];
	ovController.view.alpha = 0.5;
	
	ovController.rvController = self;
	
	[self->tableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
	
	
	self->tableView.scrollEnabled = NO;
		
}

//add search bar delegate
// When the search text changes, update the array 
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText 
{ 
	if ([searchText length] == 0){
		
		[self reload];
		[self->tableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
		
		return;
	}
	else
	{
		[ovController.view removeFromSuperview];
		self->tableView.scrollEnabled = YES;
	}
	[self buildSearchArrayFrom:searchText]; 
	
} 
// When the search ("done") button is clicked, hide the keyboard 
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar 
{ 
	[searchBar resignFirstResponder]; 
} 


	


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		[self.tabBarItem   initWithTabBarSystemItem: 
												  UITabBarSystemItemContacts tag:1];
		parentView = 0;

    }
    return self;
}


// Add a title for each section 

- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section 
{ 
	sectionType *setTypeP;
	
	if(section<sectionArray.count)
	{	
		setTypeP = [sectionArray objectAtIndex:section];
		if(setTypeP->elementP.count)
		{	
			
				if(setTypeP->index)
			return [NSString stringWithFormat:@"%@", 
					[ALPHA_ARRAY objectAtIndex:setTypeP->index]];
		}	
	}
	return nil;
} 
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView 
{ 
	return ALPHA_ARRAY; 
	
} 

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	
	//////printf("\nmukesh");
	return nil;
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
		searchbar.delegate = self;
	
	//CGRect cellFrame ;
	//cellFrame = searchbar.bounds;
	//cellFrame.size.width-=30;
	//searchbar.bounds = cellFrame;
	searchbar.placeholder = @"Search";
	searchbar.autocorrectionType = UITextAutocorrectionTypeNo;
	searchbar.autocapitalizationType = UITextAutocapitalizationTypeNone;		
		
	UITextField *searchField = [[searchbar subviews] lastObject];
	[searchField setReturnKeyType:UIReturnKeyDone];

	//self.tabBarItem = [UITabBarItem alloc];
	//[self.tabBarItem initWithTitle:@"Contact" image:nil tag:3];

	sectionArray = [[[NSMutableArray alloc] init] retain];
	//tableView.backgroundColor = [UIColor blueColor];
	tableView.scrollsToTop = YES;
	tableView.delegate = self;
	tableView.dataSource = self;
	//tableView.tag = 2001;
	
	tableView.tableHeaderView = searchbar;
	addressBookTableDelegate = [[AddressBookContact alloc] init];
	[addressBookTableDelegate setObject:ownerobject];
	
	 segmentedControl = [ [ UISegmentedControl alloc ] initWithItems: nil ];
	 segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	 
	 [ segmentedControl insertSegmentWithTitle: @"Phone" atIndex: 0 animated: YES ];
	 [ segmentedControl insertSegmentWithTitle: @"" atIndex: 1 animated: YES ];
	 [ segmentedControl insertSegmentWithTitle: @"Spokn" atIndex: 2 animated: YES ];
	[segmentedControl setWidth:0.1 forSegmentAtIndex:1];  
	[segmentedControl setEnabled:NO forSegmentAtIndex:1];
	 
	 [ segmentedControl addTarget: self action: @selector(controlPressed:) forControlEvents:UIControlEventValueChanged ];
	 
	 self.navigationItem.titleView = segmentedControl;
	 segmentedControl.selectedSegmentIndex = 2;
		
	
	[ self reload ];
	

}

 - (void)controlPressed:(id) sender {
 	 int index = segmentedControl.selectedSegmentIndex;
	 switch(index)
	 {
		 case 0:
			searchbar.text = @"";
			 [addressBookTableDelegate setSearchBarAndTable:searchbar  :tableView PerentObject:self OverlayView :&ovController];
			 
			
			 break;
		 case  2:
		 {
			 tableView.delegate = self;
			 tableView.dataSource = self;
			 searchbar.delegate = self;
			 searchbar.text = @"";
			
			 [self reloadLocal:nil :0];
			 
		 }
			 break;
 
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
	printf("\n contact dealloc");
	[ovController release];	
	[addressBookTableDelegate release];
    [super dealloc];
}
-(void) setReturnVariable :(char *) lnumberCharP : (int *)lvalP
{
	numberCharP = lnumberCharP;
	returnPtr = lvalP;
	
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return 1;

	if(sectionArray.count)
	return [sectionArray count];
	return 1;

}
- (void) showNumberScreen {
	
	AddeditcellController     *AddeditcellControllerviewP;	
	AddeditcellControllerviewP = [[AddeditcellController alloc]init];
	[AddeditcellControllerviewP setObject:self->ownerobject];
	//viewResult = 0;
	if(returnPtr)
	{	
		*returnPtr = 0;
	}
	[AddeditcellControllerviewP setData:numberCharP value:"Type a 7-digit Spokn ID or phone number\n with the country code" placeHolder:"Spokn ID or Phone number" returnValue:returnPtr];
	[ AddeditcellControllerviewP shiftToRoot:true];
	[  [self navigationController]  pushViewController:AddeditcellControllerviewP animated: YES ];
	
	[AddeditcellControllerviewP release];
	
}
- (void) addContactUI {

	/*AddEditcontactViewController     *addeditviewP;	
	addeditviewP = [[AddEditcontactViewController alloc] initWithNibName:@"addeditcontact" bundle:[NSBundle mainBundle]];
	[ [self navigationController] pushViewController:addeditviewP animated: YES ];
	[addeditviewP setContactDetail:nil];
	[addeditviewP setObject:self->ownerobject];
	//NSLog(@"retainCount:%d", [addeditviewP retainCount]);
	if([addeditviewP retainCount]>1)
		[addeditviewP release];
	 */
	ContactDetailsViewController     *ContactControllerDetailsviewP;	
	ContactControllerDetailsviewP = [[ContactDetailsViewController alloc] initWithNibName:@"contactDetails" bundle:[NSBundle mainBundle]];
	[ContactControllerDetailsviewP setObject:self->ownerobject];
	[ContactControllerDetailsviewP setAddressBook:0 editable:true :CONTACTADDVIEWENUM];
	

	[ [self navigationController] pushViewController:ContactControllerDetailsviewP animated: YES ];
		
	
	
	if([ContactControllerDetailsviewP retainCount]>1)
		[ContactControllerDetailsviewP release];
	printf("\n retain countact details count %d\n",[ContactControllerDetailsviewP retainCount]);
	
	
	//[ ownerobject.ContactControllerController pushViewController:ownerobject->addeditviewP animated: YES ];
	//[ownerobject->addeditviewP setContactDetail:nil];
}
-(void) reload
{
	int firstSection = 1;
	if([self reloadLocal:nil :&firstSection])
	{	
	//- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;
		//printf("\n section%d",firstSection);
		[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:firstSection] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	}	
}
- (int) reloadLocal:(NSString *)searchStrP : (int*) firstSectionP {
	int count = 0; 
	int fIndexfindInt = -1;
	if(segmentedControl.selectedSegmentIndex==0)//different view
	{
		return 0;
	}
	//////////printf("\nmukesh");
	if(uaObject==GETCONTACTLIST)
	{
		if(self.navigationItem.rightBarButtonItem==nil)
		{	
			if(parentView==0)
			{	
				self.navigationItem.rightBarButtonItem 
				= [ [ [ UIBarButtonItem alloc ]
					 initWithBarButtonSystemItem: UIBarButtonSystemItemAdd
					 target: self
					 action: @selector(addContactUI) ] autorelease ];	
			}
			else
			{
				self.navigationItem.rightBarButtonItem 
				= [ [ [ UIBarButtonItem alloc ]
					 initWithTitle: @"Number" style:UIBarButtonItemStyleDone 
					 target: self
					 action: @selector(showNumberScreen) ] autorelease ];	
			
			}
		}	

		struct AddressBook *addressP;
		//added group element
		
		int i;
		//int j;
		sectionType *setTypeP;
		char *ignoreSpaceStrP = 0;
		NSString *CellIdentifier,*rangeStringP;
		//NSMutableArray *tmp;
		int sz,lsz;
		sz = sectionArray.count;
		//for(i=0;i<sz;++i)
		while(sectionArray.count)
		{
			setTypeP = [sectionArray objectAtIndex:0];
			lsz = setTypeP->elementP.count;
			while(setTypeP->elementP.count)
			//for(j = 0;j<lsz;++j)
			[setTypeP->elementP removeObjectAtIndex:0];
			[setTypeP release];
			[sectionArray removeObjectAtIndex:0];
		}
	//////////printf("removed");
		for (i = 0; i < MAXSEC; i++){
			
			setTypeP = [[sectionType alloc] init];
			setTypeP->index = i;
			[sectionArray addObject: setTypeP] ;
		}
		count = GetTotalCount(uaObject);
		//for(int i=0;i<sectionArray)
		for (i=0;i<count;++i)
		{
			sectionData *secP;
			addressP = GetObjectAtIndex(uaObject ,i);		
			ignoreSpaceStrP = addressP->title;
			while(*ignoreSpaceStrP==' ')
			{
				ignoreSpaceStrP++;
			}
			CellIdentifier = [[NSString alloc] initWithUTF8String:ignoreSpaceStrP] ;
			////NSLog(CellIdentifier);
			secP = [[sectionData alloc] init];
			secP->recordid = addressP->id;
			/*
			// determine which letter starts the name
			if(i==0)//first letter add find
			{
				sectionData *secP;
				secP = [[sectionData alloc] init];
				secP->recordid = -1;
				////printf("dummy aded");
				setTypeP = [sectionArray objectAtIndex:0];
				[ setTypeP->elementP addObject:secP];
			}*/
			rangeStringP = 	[[CellIdentifier substringToIndex:1] uppercaseString];
			////NSLog(rangeStringP);
			NSRange range = [ALPHA rangeOfString:rangeStringP];
			if (range.location != NSNotFound && range.location <MAXSEC) 
			{	
				if(fIndexfindInt==-1)
				{
					fIndexfindInt = range.location;
				}
				setTypeP = [sectionArray objectAtIndex:range.location];
				if(searchStrP)
				{	
					if([searchStrP length]>0)
					{	
						NSRange range1 = [[CellIdentifier uppercaseString] rangeOfString:searchStrP];//[[[self getName:person] uppercaseString] rangeOfString:upString];
						if (range1.location != NSNotFound) 
						{	
					//////printf("\n%s %ld %d",addressP->title,addressP->id ,i);
							[ setTypeP->elementP addObject:secP];
						}	
					}
					else
					{
						[ setTypeP->elementP addObject:secP];
					}
				}
				else
				{
					[ setTypeP->elementP addObject:secP];

				}
			}	
			// Add the name to the proper array
			[secP release];
			
			[CellIdentifier release];
		}
		
	////printf("\n session count %d",sectionArray.count);
		for(i=0;i<sectionArray.count;++i)
		{
			setTypeP = [sectionArray objectAtIndex:i];
		//	////////////printf("\n count %d %d ",tmp.count,i);
			if(setTypeP->elementP.count==0)
			{
				
				//[setTypeP release];
				//[sectionArray removeObjectAtIndex:i];
				//--i;
			}	
		}
			//////printf("\n session count after remove %d",sectionArray.count);

		
		
	}
	else
	{	
		self.navigationItem.rightBarButtonItem 
	= [ [ [ UIBarButtonItem alloc ]
		 initWithBarButtonSystemItem: UIBarButtonSystemItemEdit
		 target: self
	    action: @selector(startEditing) ] autorelease ];	
	}
		[ self->tableView reloadData ];
	if(firstSectionP)
	{
		*firstSectionP = fIndexfindInt;
	}
	return count;
}
- (void) startEditing {
	[ self->tableView setEditing: YES animated: YES ];
	
	self.navigationItem.rightBarButtonItem 
	= [ [ [ UIBarButtonItem alloc ]
		 initWithBarButtonSystemItem: UIBarButtonSystemItemDone
		 target: self
		 action: @selector(stopEditing) ] autorelease ];	
}

- (void) stopEditing {
	[ self->tableView setEditing: NO animated: YES ];
	
	self.navigationItem.rightBarButtonItem  
	= [ [ [ UIBarButtonItem alloc ]
		 initWithBarButtonSystemItem: UIBarButtonSystemItemEdit
		 target: self
		 action: @selector(startEditing) ] autorelease ];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
		if(sectionArray.count)
		{	
			sectionType *setTypeP;
			setTypeP = [sectionArray objectAtIndex:section];
			return [setTypeP->elementP count];
		}
	return 0;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   

	struct AddressBook *addressP;
	NSString *CellIdentifier;
	sectionData *secP;
	int row = [indexPath row];
	int section = [indexPath section];
	// Create a cell if one is not already available
	//////////////printf("mukesh sharma");
	sectionType *setTypeP;
	setTypeP = [sectionArray objectAtIndex:section] ;
	
	// Set up the cell by coloring its text
	//NSArray *dataP = [[setTypeP->elementP objectAtIndex:row] componentsSeparatedByString:@"#"];
	//////////////printf("mukesh");
	//secP = (sectionData*)[dataP objectAtIndex:0];
	secP = (sectionData*)[setTypeP->elementP objectAtIndex:row]; 
	////printf("\n %ld",secP->recordid);
	UITableViewCell *cell =(UITableViewCell *) [self->tableView dequeueReusableCellWithIdentifier:@"any-cell"];
	if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"any-cell"] autorelease];
		
		
	}
		
	addressP = (struct AddressBook *)getContact( secP->recordid);
	if(addressP)
	{	
		CellIdentifier = [[NSString alloc] initWithUTF8String:addressP->title ] ;
		////////////printf("\n table %s  %ld %d",addressP->title ,secP->recordid,section);
		cell.text = CellIdentifier;
		[CellIdentifier release];
	}
	
	//cell.textColor = [self getColor:[crayon objectAtIndex:1]];
	
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
	sectionData *secP;
	sectionType *setTypeP;
	//struct AddressBook *addressP;
	setTypeP = [sectionArray objectAtIndex:section] ;
	
	// Set up the cell by coloring its text
	//NSArray *dataP = [[setTypeP->elementP objectAtIndex:row] componentsSeparatedByString:@"#"];
	////////////printf("mukesh shastri");
	//secP = (sectionData*)[dataP objectAtIndex:0];
	secP = (sectionData*)[setTypeP->elementP objectAtIndex:row]; 
	deleteContactLocal(secP->recordid);
	profileResync();
	[setTypeP->elementP removeObjectAtIndex:row];
	NSMutableArray *array = [ [ NSMutableArray alloc ] init ];
	[ array addObject: indexPath ];
	[ self->tableView deleteRowsAtIndexPaths: array withRowAnimation: UITableViewRowAnimationTop ];
	
	
	

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	int row = [indexPath row];
	int section = [indexPath section];
	sectionData *secP;
	sectionType *setTypeP;
	struct AddressBook *addressP;
	setTypeP = [sectionArray objectAtIndex:section] ;
	
	// Set up the cell by coloring its text
	//NSArray *dataP = [[setTypeP->elementP objectAtIndex:row] componentsSeparatedByString:@"#"];
	//////////////printf("mukesh");
	//secP = (sectionData*)[dataP objectAtIndex:0];
	secP = (sectionData*)[setTypeP->elementP objectAtIndex:row]; 
	addressP = (struct AddressBook *)getContact( secP->recordid);
	if(addressP)
	{
		
		ContactDetailsViewController     *ContactControllerDetailsviewP;	
		ContactControllerDetailsviewP = [[ContactDetailsViewController alloc] initWithNibName:@"contactDetails" bundle:[NSBundle mainBundle]];
		[ContactControllerDetailsviewP setAddressBook:addressP editable:false :CONTACTDETAILVIEWENUM];
		[ContactControllerDetailsviewP setObject:self->ownerobject];

		[ [self navigationController] pushViewController:ContactControllerDetailsviewP animated: YES ];
				
		if([ContactControllerDetailsviewP retainCount]>1)
			[ContactControllerDetailsviewP release];
		printf("\n retain countact details count %d\n",[ContactControllerDetailsviewP retainCount]);
		
		
		
				
		return;
		
	}
	
		


}


- (void)loadView {
    [ super loadView ];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES; 
}

-(void)setObjType:(UAObjectType)luaObj
{
	switch(luaObj)
	{
		case GETCONTACTLIST:
			[self setTitle:@"Contacts"];
			break;
		case GETVMAILLIST:
			[self setTitle:@"VMail"];
			break;
		case GETCALLLOGLIST:
			[self setTitle:@"Calllog"];

			break;
	
	}
	uaObject = luaObj;

}
@end
