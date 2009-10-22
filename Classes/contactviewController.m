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
- (NSTimeInterval)keyboardAnimationDurationForNotification:(NSNotification*)notification
{
	printf("\nkey board");
	NSDictionary* info = [notification userInfo];
    NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];
    return duration;
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
-(IBAction)cancelClicked
{
	[ [self navigationController] popViewControllerAnimated:YES ];
}
-(void)cancelSearch
{
	[self doneSearching_Clicked:nil];
	if(segmentedControl.selectedSegmentIndex==0)//different view
	{	
		[self reload];
	}
	else
	{
		searchbar.text = @"";
		[addressBookTableDelegate setSearchBarAndTable:searchbar  :tableView PerentObject:self OverlayView :&ovController];
		
	}
	searchStartB = false;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
	[self cancelSearch];
}
- (void) doneSearching_Clicked:(id)sender {
	
	#ifndef _HIDDEN_NAVBAR
	searchStartB = false;
	searchbar.text = @"";
	[searchbar resignFirstResponder];
	
	self->tableView.scrollEnabled = YES;
	
	[ovController.view removeFromSuperview];
	[ovController release];
	ovController = nil;
	searchbar.frame = gframe; 
	
		[searchbar setShowsCancelButton:NO animated:NO];
		tableView.tableHeaderView = searchbar;
		self.navigationItem.titleView = segmentedControl;
		
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
	
	#else
		printf("\n mukesh");
		searchbar.text = @"";
		[searchbar resignFirstResponder];
	
		self->tableView.scrollEnabled = YES;
	
		[ovController.view removeFromSuperview];
		[ovController release];
		ovController = nil;
		[self navigationController].navigationBarHidden =NO;
		//sectionNSArrayP = ALPHA_ARRAY;
		[searchbar setShowsCancelButton:NO animated:NO];
		searchStartB = false;
	
	#endif
	//[self->tableView reloadData];
	


	
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	//("\nkeyboard");
	#ifndef _HIDDEN_NAVBAR
	CGRect lframe;
	lframe = gframe;
	lframe.size.width-=4;
	searchBar.frame = lframe; 
	searchStartB = true;
	tableView.tableHeaderView = 0;
	self.navigationItem.titleView = searchBar;
	[searchBar setShowsCancelButton:YES animated:YES];
	self.navigationItem.rightBarButtonItem = nil;
	#else
	//CGRect lframe;
	//lframe = gframe;
	//lframe.size.width-=40;
	//searchBar.frame = lframe; 
	[searchBar setShowsCancelButton:YES animated:YES];
	//[searchBar setActive : YES animated:YES];
	//+ (void)beginAnimations:(NSString *)animationID context:(void *)context;  // additional context info passed to will start/did stop selectors. begin/commit can be nested
	//+ (void)commitAnimations;                                                 // starts up any animations when the top level animation is commited
	
	/*[UIView beginAnimations:nil context:nil];
	 [UIView setAnimationDuration:0.75];
	 [UIView setAnimationBeginsFromCurrentState:YES];
	 [UIView setAnimationTransition: UIViewAnimationTransitionCurlUp
	 forView:self.view  cache:YES];
	 tableView.tableHeaderView = 0;
	 self.navigationItem.titleView = searchBar;
	 
	 [UIView commitAnimations];*/
	//tableView.tableHeaderView = 0;
	//self.navigationItem.titleView = searchBar;
	
	/*self.navigationItem.rightBarButtonItem 
	 = [ [ [ UIBarButtonItem alloc ]
	 initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
	 target: self
	 action: @selector(cancelSearch) ] autorelease ];*/
	[self navigationController].navigationBarHidden =YES;
	
	//[self navigationController].navigationBarHidden =NO;
	
	searchStartB = true;
	[self->tableView reloadData];
	
	#endif	
	return YES;
}
- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
	//This method is called again when the user clicks back from the detail view.
	//So the overlay is displayed on the results, which is something we do not want to happen.
	//UITextField *searchField = [[theSearchBar subviews] lastObject];
	
	if(theSearchBar.text.length>0)
		return;
	
	//Add the overlay view.
	if(ovController == nil)
		ovController = [[OverlayViewController alloc] initWithNibName:@"OverlayView" bundle:[NSBundle mainBundle]];
	
	CGFloat width = self.view.frame.size.width;
	CGFloat height = self.view.frame.size.height;
	//CGRect frame = CGRectMake(0, yaxis, width, height);

	//Parameters x = origion on x-axis, y = origon on y-axis.
	#ifndef _HIDDEN_NAVBAR
	//CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
	
	CGRect frame = CGRectMake(0, 0, width, height);
	#else
	CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
	
	CGRect frame = CGRectMake(0, yaxis, width, height);
	
	#endif
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
		sectionArray = [[NSMutableArray alloc] init] ;
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
	#ifndef _HIDDEN_NAVBAR
		return ALPHA_ARRAY;
	#else
	if(searchStartB==false)
		return ALPHA_ARRAY; 
	return nil;
	#endif
	
	
	//return sectionNSArrayP;
	
	
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
	searchStartB = false;

	//CGRect cellFrame ;
	//cellFrame = searchbar.bounds;
	//cellFrame.size.width-=30;
	//searchbar.bounds = cellFrame;
	searchbar.placeholder = @"Search";
	searchbar.autocorrectionType = UITextAutocorrectionTypeNo;
	searchbar.autocapitalizationType = UITextAutocapitalizationTypeNone;		
	gframe = searchbar.frame;
		
	UITextField *searchField = [[searchbar subviews] lastObject];
	[searchField setReturnKeyType:UIReturnKeyDone];

	//self.tabBarItem = [UITabBarItem alloc];
	//[self.tabBarItem initWithTitle:@"Contact" image:nil tag:3];

	
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
	  [ segmentedControl insertSegmentWithTitle: @"Spokn" atIndex: 0 animated: NO ];
	
	 [ segmentedControl insertSegmentWithTitle: @"" atIndex: 1 animated: NO ];
	 [ segmentedControl insertSegmentWithTitle: @"Phone" atIndex: 2 animated: NO ];
	
	[segmentedControl setWidth:0.1 forSegmentAtIndex:1];  
	[segmentedControl setEnabled:NO forSegmentAtIndex:1];
	 
	 [ segmentedControl addTarget: self action: @selector(controlPressed:) forControlEvents:UIControlEventValueChanged ];
	 
	 self.navigationItem.titleView = segmentedControl;
	 segmentedControl.selectedSegmentIndex = 0;
	if(parentView)
	{	
		self.navigationItem.leftBarButtonItem = [ [ [ UIBarButtonItem alloc ]
											   initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
											   target: self
											   action: @selector(cancelClicked) ] autorelease ];
	}
	[ self reload ];
		

}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	if(searchStartB)
	{	
	#ifdef _HIDDEN_NAVBAR
		[self navigationController].navigationBarHidden =NO;
	#endif	
	}
	
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if(resultInt)
	{
		//("\nhello view deleted\n");
		resultInt = 0;
		if(segmentedControl.selectedSegmentIndex==0)//different view
		{	
			deleteContactLocal(contactID);
			profileResync();
		}	
		NSIndexPath *nsP;
		nsP = [self->tableView indexPathForSelectedRow];
		if(nsP)
		{
			[self->tableView deselectRowAtIndexPath : nsP animated:NO];
		}	
		[self reload];
		
		
	}
	else
	{	
		NSIndexPath *nsP;
		nsP = [self->tableView indexPathForSelectedRow];
		if(nsP)
		{
			[self->tableView deselectRowAtIndexPath : nsP animated:NO];
		}	
	}
	if(firstSection>=0)
	{	
		NSIndexPath *nsP;
		nsP = [NSIndexPath indexPathForRow:0 inSection:firstSection] ;
		if(nsP)
		{	
			UITableViewCell *uicellP;
			uicellP =[tableView cellForRowAtIndexPath:nsP];
			if(uicellP)
			{	
				[tableView scrollToRowAtIndexPath:nsP atScrollPosition:UITableViewScrollPositionTop animated:NO];
			}	
		}	
		firstSection = -1;
	}	
	#ifdef _HIDDEN_NAVBAR
	[self navigationController].navigationBarHidden =searchStartB;
	#else
		if(searchStartB)
		{
			self.navigationItem.rightBarButtonItem = nil;
		}
		
		
	#endif
	
	

}	

 - (void)controlPressed:(id) sender {
 	 int index = segmentedControl.selectedSegmentIndex;
	 switch(index)
	 {
		 case 2:
			searchbar.text = @"";
			 self.navigationItem.rightBarButtonItem.enabled = NO;
			 [addressBookTableDelegate setSearchBarAndTable:searchbar  :tableView PerentObject:self OverlayView :&ovController];
			 
			
			 break;
		 case  0:
		 {
			 tableView.delegate = self;
			 tableView.dataSource = self;
			 searchbar.delegate = self;
			 searchbar.text = @"";
			  self.navigationItem.rightBarButtonItem.enabled = YES;
			//[ self->tableView reloadData ];
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
	sectionType *setTypeP;
	while(sectionArray.count)
	{
		setTypeP = [sectionArray objectAtIndex:0];
				while(setTypeP->elementP.count)
			//for(j = 0;j<lsz;++j)
			[setTypeP->elementP removeObjectAtIndex:0];
		[setTypeP release];
		[sectionArray removeObjectAtIndex:0];
	}
	[sectionArray release];
    
	[super dealloc];
}
-(void) setReturnVariable:(id) rootObject :(char *) lnumberCharP : (int *)lvalP
{
	numberCharP = lnumberCharP;
	returnPtr = lvalP;
	rootControllerObject = rootObject;
	
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return 1;

	if(sectionArray.count)
	return [sectionArray count];
	return 1;

}



-(int)  showContactDetailScreen: (struct AddressBook * )addressP :(ViewTypeEnum) viewEnum
{
	
	if(addressP)
	{
		
		
		ContactDetailsViewController     *ContactControllerDetailsviewP;	
		ContactControllerDetailsviewP = [[ContactDetailsViewController alloc] initWithNibName:@"contactDetails" bundle:[NSBundle mainBundle]];
		if(parentView)
		{	
			if(returnPtr)
			{
				*returnPtr = 0;
			}
			[ContactControllerDetailsviewP setReturnValue:returnPtr selectedContact:numberCharP  rootObject:rootControllerObject selectedContact:0] ;
			
			[ContactControllerDetailsviewP setAddressBook:addressP editable:false :CONTACTFORWARDVMS];
		}
		else
		{
			resultInt = 0;
			//selectedContact:(char*)lnumberCharP rootObject:(id)lrootObjectP
			contactID = addressP->id;
			[ContactControllerDetailsviewP setReturnValue:&resultInt selectedContact:0  rootObject:0 selectedContact:0] ;
			
			[ContactControllerDetailsviewP setAddressBook:addressP editable:false :viewEnum];
			
		}
		[ContactControllerDetailsviewP setObject:self->ownerobject];
		
		[ [self navigationController] pushViewController:ContactControllerDetailsviewP animated: YES ];
		
		if([ContactControllerDetailsviewP retainCount]>1)
			[ContactControllerDetailsviewP release];
		//printf("\n retain countact details count %d\n",[ContactControllerDetailsviewP retainCount]);
		
		
		
		
		
		return 0;
		
	}
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
	[ AddeditcellControllerviewP  shiftToRoot:rootControllerObject :true];
	[AddeditcellControllerviewP SetkeyBoardType:UIKeyboardTypePhonePad :CONTACT_RANGE buttonType:1];

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
	//printf("\n retain countact details count %d\n",[ContactControllerDetailsviewP retainCount]);
	
	
	//[ ownerobject.ContactControllerController pushViewController:ownerobject->addeditviewP animated: YES ];
	//[ownerobject->addeditviewP setContactDetail:nil];
}
-(void) reload
{
	//int firstSection = 1;
	firstSection = 1;
//	printf("\nreload called");
	NSString *searchStrP;
	searchStrP = searchbar.text;
	if([searchStrP length]==0 ||searchStrP == 0)
	{	
		if([self reloadLocal:nil :&firstSection])
		{	
			//- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;
		//	printf("\n section%d",firstSection);
			//	[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:firstSection] atScrollPosition:UITableViewScrollPositionTop animated:NO];
		}
		else
		{
			firstSection = -1;
		}
	}	
	else
	{
		firstSection = -1;
	}
	
}
- (int) reloadLocal:(NSString *)searchStrP : (int*) firstSectionP {
	int count = 0; 
	int fIndexfindInt = -1;
	if(segmentedControl.selectedSegmentIndex==2)//different view
	{
		return 0;
	}
	//////////printf("\nmukesh");
	if(uaObject==GETCONTACTLIST)
	{
		if(self.navigationItem.rightBarButtonItem==nil && searchStartB==false)
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
			//("\n%d",i);
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
					if(setTypeP)
					{	
						[ setTypeP->elementP addObject:secP];
					}
					else
					{
					//	printf("\n error");
					}

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
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	
	if (index == 0) {
		// search item
		[self->tableView scrollRectToVisible:[[self->tableView tableHeaderView] bounds] animated:NO];
		return -1;
	}	
	return index;
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
	
	[self showContactDetailScreen :addressP :CONTACTDETAILVIEWENUM];
		


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
