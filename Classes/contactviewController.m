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
	////printf("\n touch");
	[super touchesBegan:touches withEvent:event];
	[self resignFirstResponder];
}
@end
 */
@implementation ContactViewController

@synthesize ltpInterfacesP;
@synthesize  uaObject;
@synthesize parentView;

#pragma mark _ADDRESSBOOKDELEGATE_START
+(int) getNameAndType :(ABRecordID) recordID :(char*)lnumberCharP :(char **) nameStringP :(char**)typeP
{
	NSString *numberStringP;
	NSString *labelStringP;
	NSString *nameP;
	char *numbercharP;
	char *tmpcharP;
	NSString *text1;
	char *normalizeNoCharP;
	ABMultiValueRef name1 ;
	if(nameStringP==0 || typeP==0 || recordID==0)
	{
		return 1;
	}
	ABAddressBookRef addressBook = ABAddressBookCreate();
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook,
                                                            recordID);
	if(person==0)
	{
	//	[addressBook release];
		return 1;
	}
	//printf("\n recordID %d",(int)person);
	nameP = [AddressBookContact getName:person];
	//	NSLog(nameP);
	if(nameP==0)
	{
		//[addressBook release];
		return 1;
	}
	//*nameStringP = nameP;
	tmpcharP = (char*)[nameP  cStringUsingEncoding:NSUTF8StringEncoding];
	if(tmpcharP)
	{
		*nameStringP = malloc(strlen(tmpcharP)+4); 
		strcpy(*nameStringP,tmpcharP);
		
	}
	[nameP release];	
	//ABMultiValueRef name1 =(NSString*)ABRecordCopyValue(person,kABDateTimePropertyType);
	name1 =(NSString*)ABRecordCopyValue(person,kABRealPropertyType);
	if(name1)
	{	
	
		int res;
		for(CFIndex i=0;i<ABMultiValueGetCount(name1);i++)
		{
			numberStringP=(NSString*)ABMultiValueCopyValueAtIndex(name1,i);
			labelStringP=(NSString*)ABMultiValueCopyLabelAtIndex(name1,i);
			if(numberStringP==0 || labelStringP==0)
			{
				continue;
			}
			//NSLog(numberStringP);
			//NSLog(labelStringP);
			//NSLog(@"\n%@ ", numbercharP);
			//NSLog(@"\n%@ ", labelStringP);
			//text1 = [labelStringP stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
			 
				 
			text1 = [labelStringP stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_$!<>"]];
			//NSLog(text1);
			numbercharP = (char*)[numberStringP  cStringUsingEncoding:NSUTF8StringEncoding];
			normalizeNoCharP = NormalizeNumber(numbercharP,0);
			res=  strcmp(normalizeNoCharP,lnumberCharP);
			
			////printf("\n\n %s %s \n\n\n",normalizeNoCharP,lnumberCharP);
			free(normalizeNoCharP);
			if(res==0)
			{
				tmpcharP = (char*)[text1  cStringUsingEncoding:NSUTF8StringEncoding];
				if(tmpcharP)
				{
					*typeP = malloc(strlen(tmpcharP)+4); 
					strcpy(*typeP,tmpcharP);
					
				}
				
				[labelStringP release];
				[numberStringP release];
				[(NSString*)name1 release];
				//[addressBook release];
				return 0;
			}
			[numberStringP release];
			[labelStringP release];
		}
		[(NSString*)name1 release];
	}	
	
	//[addressBook release];
	return 1;


}
// Called after the user has pressed cancel
// The delegate is responsible for dismissing the peoplePicker
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
	//printf("\n search cancel");
}

// Called after a person has been selected by the user.
// Return YES if you want the person to be displayed.
// Return NO  to do nothing (the delegate is responsible for dismissing the peoplePicker).
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
	
		
		
	[self showContactDetailScreen:nil :CONTACTPHONEADDRESSBOOKDETAIL contactBook:person];
	
	//loadedNewViewB = 1;
		
	
	
	
	//printf("\n selected contact123");
	return NO;
}
// Called after a value has been selected by the user.
// Return YES if you want default action to be performed.
// Return NO to do nothing (the delegate is responsible for dismissing the peoplePicker).
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
	//printf("\n selected contact");
	return NO;
}


#pragma mark _ADDRESSBOOKDELEGATE_END
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	////printf("\n touch");
	[super touchesBegan:touches withEvent:event];
	[self resignFirstResponder];
}/*
- (NSTimeInterval)keyboardAnimationDurationForNotification:(NSNotification*)notification
{
	//printf("\nkey board");
	NSDictionary* info = [notification userInfo];
    NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];
    return duration;
}*/
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
	
	searchStartB = false;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{


		
	[self cancelSearch];
}
- (void) doneSearching_Clicked:(id)sender {
	
	searchStartB = false;
	[searchbar resignFirstResponder];
	CGFloat searchBarHeight = [searchbar frame].size.height;
	[searchbar setFrame:CGRectMake(0,0,294,searchBarHeight)];
	searchbar.backgroundColor = [[UIColor clearColor] autorelease];
	searchbar.tintColor = [UIColor colorWithRed:191/255.0 green:200/255.0 blue:206/255.0 alpha:1.0];
	tempview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,searchBarHeight )];
	[tempview addSubview:searchbar];
	tempview.backgroundColor = [[UIColor clearColor] autorelease];	
	tableView.tableHeaderView = tempview;
	tableView.tableHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"searchbarbackgroung.png"]];
	[tempview release];
	
#ifdef _NO_SEARCH_MOVE_
//#ifdef IPHONE_
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 30000) 
	[searchbar setShowsCancelButton:NO animated:YES];
#else
	searchbar.showsCancelButton = NO;
#endif	
	searchStartB = false;
	searchbar.text = @"";
	//[searchbar resignFirstResponder];
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
			 initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
			 target: self
			 action: @selector(cancelClicked) ] autorelease ];	
	}
	/*
	else
	{
		self.navigationItem.rightBarButtonItem 
		= [ [ [ UIBarButtonItem alloc ]
			 initWithTitle: @"Number" style:UIBarButtonItemStyleDone 
			 target: self
			 action: @selector(showNumberScreen) ] autorelease ];	
		
	}*/
	self->tableView.scrollEnabled = YES;
	
	[ovController.view removeFromSuperview];
	[ovController release];
	ovController = nil;
	if(segmentedControl.selectedSegmentIndex==0)//different view
	{	
		[self reload];
	}
	else
	{
		searchbar.text = @"";
		[addressBookTableDelegate setSearchBarAndTable:searchbar  :tableView PerentObject:self OverlayView :&ovController];
		
	}
	return ;
#endif
	

	#ifndef _HIDDEN_NAVBAR
	searchStartB = false;
	searchbar.text = @"";
	[searchbar resignFirstResponder];
	
	self->tableView.scrollEnabled = YES;
	
	[ovController.view removeFromSuperview];
	[ovController release];
	ovController = nil;
	searchbar.frame = gframe; 
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 30000) 
	[searchbar setShowsCancelButton:NO animated:NO];
#else
	searchbar.showsCancelButton = NO;
#endif	
	
		//[searchbar setShowsCancelButton:NO animated:NO];
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
	/*
	else
	{
		self.navigationItem.rightBarButtonItem 
		= [ [ [ UIBarButtonItem alloc ]
			 initWithTitle: @"Number" style:UIBarButtonItemStyleDone 
			 target: self
			 action: @selector(showNumberScreen) ] autorelease ];	
		
	}
	*/
	#else
		//printf("\n mukesh");
		searchbar.text = @"";
		[searchbar resignFirstResponder];
	
		self->tableView.scrollEnabled = YES;
	
		[ovController.view removeFromSuperview];
		[ovController release];
		ovController = nil;
		[self navigationController].navigationBarHidden =NO;
		//sectionNSArrayP = ALPHA_ARRAY;
	
		#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 30000) 
			[searchbar setShowsCancelButton:NO animated:NO];
		#else
			searchbar.showsCancelButton = NO;
		#endif	
		searchStartB = false;
	
	#endif
	//[self->tableView reloadData];
	


	
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	//("\nkeyboard");
	
	#ifdef _NO_SEARCH_MOVE_
	CGFloat searchBarHeight = [searchbar frame].size.height;
	[searchbar setFrame:CGRectMake(0,0,320,searchBarHeight)];
	#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 30000) 
		[searchBar setShowsCancelButton:YES animated:YES];

	#else
		searchbar.showsCancelButton = YES;
	#endif	
		//self.navigationItem.rightBarButtonItem = nil;
	searchStartB = true;
	[self->tableView reloadData];

	return YES;
	#endif
	#ifndef _HIDDEN_NAVBAR
	CGRect lframe;
	lframe = gframe;
	lframe.size.width-=4;
	searchBar.frame = lframe; 
	searchStartB = true;
	tableView.tableHeaderView = 0;
	self.navigationItem.titleView = searchBar;
	#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 30000) 
		[searchBar setShowsCancelButton:YES animated:YES];
		
	#else
		searchbar.showsCancelButton = YES;
	#endif	
	
	self.navigationItem.rightBarButtonItem = nil;
	#else
	//CGRect lframe;
	//lframe = gframe;
	//lframe.size.width-=40;
	//searchBar.frame = lframe; 
	#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 30000) 
		[searchBar setShowsCancelButton:YES animated:YES];
		
	#else
		searchbar.showsCancelButton = YES;
	#endif	
	//[searchBar setShowsCancelButton:YES animated:YES];
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
	[[self navigationController] setNavigationBarHidden:YES animated:YES];
	//[self navigationController].navigationBarHidden =YES;
	
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

	//Parameters x = origion on x-axis, y = origon on y-axis.
	#ifndef _HIDDEN_NAVBAR
	//CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
	
	CGRect frame = CGRectMake(0, searchbar.frame.size.height, width, height);
	#else
	CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
	
	CGRect frame = CGRectMake(0, yaxis, width, height);
	
	#endif
	ovController.view.frame = frame;	
	ovController.view.backgroundColor = [[UIColor grayColor] autorelease];
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
	if(searchStartB==false)
		return ALPHA_ARRAY; 
	#else
	if(searchStartB==false)
		return ALPHA_ARRAY; 
	return nil;
	#endif
	return nil;
	
	//return sectionNSArrayP;
	
	
} 

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	
	////////printf("\nmukesh");
	return nil;
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	refreshB = 0;
	searchbar = [[UISearchBar alloc] init];
	searchbar.delegate = self;
	searchStartB = false;
	[searchbar sizeToFit];
	
	CGFloat searchBarHeight = [searchbar frame].size.height;
	[searchbar setFrame:CGRectMake(0,0,294,searchBarHeight)];
	searchbar.backgroundColor = [[UIColor clearColor] autorelease];
	searchbar.tintColor = [UIColor colorWithRed:191/255.0 green:200/255.0 blue:206/255.0 alpha:1.0];
	tempview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,searchBarHeight )];
	[tempview addSubview:searchbar];
	tempview.backgroundColor = [[UIColor clearColor] autorelease];

	//CGRect cellFrame ;
	//cellFrame = searchbar.bounds;
	//cellFrame.size.width-=30;
	//searchbar.bounds = cellFrame;
	
	#ifdef _NEW_ADDRESS_BOOK_
	addressBookP = [[ABPeoplePickerNavigationController alloc] init];
	[addressBookP setNavigationBarHidden:YES animated:NO];
	[addressBookP setPeoplePickerDelegate:self];
	//addressBookP.view.frame = self.view.frame;
	addressBookP.view.hidden=YES;
	mainViewP = self.view;
	[mainViewP retain];
	
	//[self.view addSubview:addressBookP.view];
	
	//[addressBookP.view release];
	#endif
	
	searchbar.placeholder = @"Search";
	searchbar.autocorrectionType = UITextAutocorrectionTypeNo;
	searchbar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	//searchbar.alpha = 0.6;
	//searchbar.tintColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:20/255.0 alpha:1.0];
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

	tableView.tableHeaderView = tempview;
	tableView.tableHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"searchbarbackgroung.png"]];
	[tempview release];
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
		
	/*	UIView * tempview = [[UIView alloc] initWithFrame:CGRectMake(120, 0, 200, 150)];
        
		UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:12.0];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
		label.text = NSLocalizedString(@"Choose contact or input a Number", @"");
        //self.navigationItem.titleView = label;
       
		[tempview addSubview:label];
		CGRect imgFrame = segmentedControl.frame;
		imgFrame.origin = CGPointMake(90,15);
		segmentedControl.frame = imgFrame;
		[viewP addSubview:segmentedControl];
		[viewP setBackgroundColor:[UIColor clearColor]];
		self.navigationItem.titleView =  viewP;
		viewP.hidden = NO;*/
#ifdef _NO_SEARCH_MOVE_
		self.navigationItem.hidesBackButton = YES;
		self.navigationItem.rightBarButtonItem = [ [ [ UIBarButtonItem alloc ]
													initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
													target: self
													action: @selector(cancelClicked) ] autorelease ];
#endif	

	}
	else
	{
		self.navigationItem.rightBarButtonItem = [ [ [ UIBarButtonItem alloc ]
													initWithBarButtonSystemItem: UIBarButtonSystemItemAdd
													target: self
													action: @selector(addContactUI) ] autorelease ];
		
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
	if(loadedNewViewB)
	{
		[addressBookP release];
		addressBookP = [[ABPeoplePickerNavigationController alloc] init];
		[addressBookP setNavigationBarHidden:YES animated:NO];
		[addressBookP setPeoplePickerDelegate:self];
		//addressBookP.view.frame = self.view.frame;
		addressBookP.view.hidden=YES;
		[self controlPressed:nil];
		loadedNewViewB = 0;
		
	}
	
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
	
	if(refreshB)
	{
		[self->tableView reloadData];
		refreshB = 0;
	}

}	

- (void) doRefresh
{
	refreshB = 1;
}
 - (void)controlPressed:(id) sender {
 	 int index = segmentedControl.selectedSegmentIndex;
	 switch(index)
	 {
		 case 2:
			//searchbar.text = @"";
			  if(parentView==0)
			  {	  
				  self.navigationItem.rightBarButtonItem=nil;
			  }		
			 			 //[self presentModalViewController:ab animated:YES];
		#ifdef _NEW_ADDRESS_BOOK_
			  addressBookP.view.hidden=NO;
			 self.view = addressBookP.view;
			 //addressBookP.sc
			#else
			 [addressBookTableDelegate setSearchBarAndTable:searchbar  :tableView PerentObject:self OverlayView :&ovController];
			 
		#endif
			 
			 
			
			 break;
		 case  0:
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
				 self.navigationItem.rightBarButtonItem = [ [ [ UIBarButtonItem alloc ]
				  initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
				  target: self
				  action: @selector(cancelClicked) ] autorelease ];
			 }
			#ifdef _NEW_ADDRESS_BOOK_
				self.view = mainViewP;
				addressBookP.view.hidden=YES;
		/*	 self.navigationItem.rightBarButtonItem = [ [ [ UIBarButtonItem alloc ]
														 initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
														 target: self
														 action: @selector(cancelClicked) ] autorelease ];*/
				
			#else
				tableView.delegate = self;
				tableView.dataSource = self;
				searchbar.delegate = self;
				searchbar.text = @"";

			 //[ self->tableView reloadData ];
				[self reloadLocal:nil :0];
			 
			 
			#endif
						 
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
	#ifdef _NEW_ADDRESS_BOOK_
		[addressBookP release];
	#endif
	//printf("\n contact dealloc");
	[mainViewP retain]; 
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
-(void) setReturnVariable:(id) rootObject :(SelectedContctType *)lselectedContactP: (int *)lvalP
{
	selectedContactP = lselectedContactP;
	returnPtr = lvalP;
	rootControllerObject = rootObject;
	
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return 1;

	if(sectionArray.count)
	return [sectionArray count];
	return 1;

}
+(int) addDetailsFromAddressBook :(ContactDetailsViewController     *)ContactControllerDetailsviewP :(ViewTypeEnum) viewEnum contactBook:(ABRecordRef)person;

{
	NSString *numberStringP;
	NSString *labelStringP;
	NSString *nameP;
	char *numbercharP;
	NSString *text1;
	char *typeCharP;
	ABMultiValueRef name1 ;
	struct AddressBook *addressP;
	SelectedContctType *secContactP;
	BOOL alleastOneB = FALSE;	
	nameP = [AddressBookContact getName:person];
	//	NSLog(nameP);
	numbercharP = (char*)[nameP  cStringUsingEncoding:NSUTF8StringEncoding];
	if(numbercharP==0)
	{
		return 1;
	}
	secContactP = (SelectedContctType *)malloc(sizeof(SelectedContctType));
	memset(secContactP,0,sizeof(SelectedContctType));
	addressP = (struct AddressBook *)malloc(sizeof(struct AddressBook)+10);
	memset(addressP,0,sizeof(struct AddressBook));
	strncpy(addressP->title,numbercharP,98);
	
	[nameP release];
	
		
	[ ContactControllerDetailsviewP setRecordID:(int)ABRecordGetRecordID(person) : 0];
		
	//ABMultiValueRef name1 =(NSString*)ABRecordCopyValue(person,kABDateTimePropertyType);
	name1 =(NSString*)ABRecordCopyValue(person,kABRealPropertyType);
	if(name1)
	{	
		
		for(CFIndex i=0;i<ABMultiValueGetCount(name1);i++)
		{
			numberStringP=(NSString*)ABMultiValueCopyValueAtIndex(name1,i);
			labelStringP=(NSString*)ABMultiValueCopyLabelAtIndex(name1,i);
			if(numberStringP==0 || labelStringP==0)
			{
				continue;
			}
			//NSLog(numberStringP);
			//NSLog(labelStringP);
			//NSLog(@"\n%@ ", numbercharP);
			//NSLog(@"\n%@ ", labelStringP);
			//text1 = [labelStringP stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
			text1 = [labelStringP stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_$!<>"]];
			//NSLog(text1);
			numbercharP = (char*)[numberStringP  cStringUsingEncoding:NSUTF8StringEncoding];
			typeCharP = (char*)[text1  cStringUsingEncoding:NSUTF8StringEncoding];
			
			strcpy(secContactP->number,numbercharP);
			strcpy(secContactP->type,typeCharP);
			//printf("\ntest123  %s %s",secContactP->number,secContactP->type);
			alleastOneB = TRUE;
			[ContactControllerDetailsviewP addContactDetails:secContactP];
			
			/*if([labelStringP isEqualToString:@"_$!<Mobile>!$_"])
			 {
			 numbercharP = (char*)[numberStringP  cStringUsingEncoding:NSUTF8StringEncoding];
			 strcpy(addressP->mobile,numbercharP);
			 }
			 else
			 {	
			 if([labelStringP isEqualToString:@"_$!<Home>!$_"])
			 {
			 numbercharP = (char*)[numberStringP  cStringUsingEncoding:NSUTF8StringEncoding];
			 strcpy(addressP->home,numbercharP);
			 }
			 else
			 if([labelStringP isEqualToString:@"_$!<Business>!$_"])
			 {
			 numbercharP = (char*)[numberStringP  cStringUsingEncoding:NSUTF8StringEncoding];
			 strcpy(addressP->business,numbercharP);
			 }
			 else
			 {
			 numbercharP = (char*)[numberStringP  cStringUsingEncoding:NSUTF8StringEncoding];
			 strcpy(addressP->other,numbercharP);
			 
			 }
			 }*/
			//	NSLog(@"\n%@ %@\n",numberStringP,labelStringP);
			[numberStringP release];
			[labelStringP release];
		}
		[name1 release];
	}	
	name1 =(NSString*)ABRecordCopyValue(person,kABDateTimePropertyType);
	if(name1)
	{	
		for(CFIndex i=0;i<ABMultiValueGetCount(name1);i++)
		{
			numberStringP=(NSString*)ABMultiValueCopyValueAtIndex(name1,i);
			labelStringP=(NSString*)ABMultiValueCopyLabelAtIndex(name1,i);
			if(numberStringP==0 || labelStringP==0)
			{
				continue;
			}
			text1 = [labelStringP stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_$!<>"]];
			
			
			numbercharP = (char*)[numberStringP  cStringUsingEncoding:NSUTF8StringEncoding];
			typeCharP = (char*)[text1  cStringUsingEncoding:NSUTF8StringEncoding];
			//printf("\ntest123  %s %s",numbercharP,typeCharP);
			strcpy(secContactP->number,numbercharP);
			strcpy(secContactP->type,typeCharP);
			if(strstr(numbercharP,"@"))//only email allowed
			{	
				alleastOneB = TRUE;
				[ContactControllerDetailsviewP addContactDetails:secContactP];				//	NSLog(@"\n%@ %@\n",numberStringP,labelStringP);
			}
			[numberStringP release];
			[labelStringP release];
		}
		[name1 release];
	}	
	
		[ContactControllerDetailsviewP setAddressBook:addressP editable:false :viewEnum];
	
	/* 
	 ContactDetailsViewController     *ContactControllerDetailsviewP;	
	 ContactControllerDetailsviewP = [[ContactDetailsViewController alloc] initWithNibName:@"contactDetails" bundle:[NSBundle mainBundle]];
	 [ContactControllerDetailsviewP setAddressBook:addressP editable:false :CONTACTPHONEDETAIL];
	 [ContactControllerDetailsviewP setObject:self->ownerobject];
	 
	 [ ownerobject.contactNavigationController pushViewController:ContactControllerDetailsviewP animated: YES ];
	 
	 if([ContactControllerDetailsviewP retainCount]>1)
	 [ContactControllerDetailsviewP release];
	 */
	
	//[self showContactDetailScreen:addressP :CONTACTPHONEADDRESSBOOKDETAIL contactBook:nil];
	
	free(secContactP);
	free(addressP);
	
	if(alleastOneB==FALSE)
	{
		return 1;
	}
	
	
	
	return 0;

}


-(int)  showContactDetailScreen: (struct AddressBook * )addressP :(ViewTypeEnum) viewEnum contactBook:(ABRecordRef)person
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
			[ContactControllerDetailsviewP setReturnValue:returnPtr selectedContactNumber:0  rootObject:rootControllerObject selectedContact:selectedContactP] ;
			
			[ContactControllerDetailsviewP setAddressBook:addressP editable:false :CONTACTFORWARDVMS];
		}
		else
		{
			resultInt = 0;
			//selectedContact:(char*)lnumberCharP rootObject:(id)lrootObjectP
			contactID = addressP->id;
			[ContactControllerDetailsviewP setReturnValue:&resultInt selectedContactNumber:0  rootObject:0 selectedContact:0] ;
			
			[ContactControllerDetailsviewP setAddressBook:addressP editable:false :viewEnum];
			
		}
		[ContactControllerDetailsviewP setObject:self->ownerobject];
		
		[ [self navigationController] pushViewController:ContactControllerDetailsviewP animated: YES ];
		
		if([ContactControllerDetailsviewP retainCount]>1)
			[ContactControllerDetailsviewP release];
		////printf("\n retain countact details count %d\n",[ContactControllerDetailsviewP retainCount]);
		
		
		
		
		
		return 0;
		
	}
	else
	{
		
		NSString *nameP;
		char *numbercharP;
		BOOL alleastOneB = FALSE;	
		struct AddressBook *addressP;
		SelectedContctType *secContactP;
		
		nameP = [AddressBookContact getName:person];
		//	NSLog(nameP);
		numbercharP = (char*)[nameP  cStringUsingEncoding:NSUTF8StringEncoding];
		if(numbercharP==0)
		{
			return 1;
		}
		secContactP = (SelectedContctType *)malloc(sizeof(SelectedContctType));
		memset(secContactP,0,sizeof(SelectedContctType));
		addressP = (struct AddressBook *)malloc(sizeof(struct AddressBook)+10);
		memset(addressP,0,sizeof(struct AddressBook));
		strncpy(addressP->title,numbercharP,98);
		
		[nameP release];
		
		ContactDetailsViewController     *ContactControllerDetailsviewP;	
		ContactControllerDetailsviewP = [[ContactDetailsViewController alloc] initWithNibName:@"contactDetails" bundle:[NSBundle mainBundle]];
		
		//[ ContactControllerDetailsviewP setRecordID:(int)ABRecordGetRecordID(person) : 0];
		if(parentView)
		{	
			if(returnPtr)
			{
				*returnPtr = 0;
			}
			[ContactControllerDetailsviewP setReturnValue:returnPtr selectedContactNumber:0  rootObject:rootControllerObject selectedContact:selectedContactP] ;
			
			//[ContactControllerDetailsviewP setAddressBook:addressP editable:false :CONTACTFORWARDVMS];
		}
		else
		{
			resultInt = 0;
			//selectedContact:(char*)lnumberCharP rootObject:(id)lrootObjectP
			contactID = addressP->id;
			[ContactControllerDetailsviewP setReturnValue:&resultInt selectedContactNumber:0  rootObject:0 selectedContact:0] ;
			
			//[ContactControllerDetailsviewP setAddressBook:addressP editable:false :viewEnum];
			
		}
		if(parentView)
		{
			viewEnum = CONTACTFORWARDVMS;
		}
		
		if([ContactViewController addDetailsFromAddressBook :ContactControllerDetailsviewP :viewEnum contactBook:person]==0)
		{	
			[ContactControllerDetailsviewP setObject:self->ownerobject];
			[ [self navigationController] pushViewController:ContactControllerDetailsviewP animated: YES ];
		}
		else
		{
		UIAlertView*	alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn." 
												  message: [ NSString stringWithString:@"This contact does not have any number or email address." ]
												 delegate: nil
										cancelButtonTitle: nil
										otherButtonTitles: @"OK", nil
					 ];
			
			[ alert show ];
			[alert release];
			
		
		}
		//if([ContactControllerDetailsviewP retainCount]>1)
			[ContactControllerDetailsviewP release];
		free(addressP);
		//ABMultiValueRef name1 =(NSString*)ABRecordCopyValue(person,kABDateTimePropertyType);

	return NO;
	}
	
	return 1;
	
}
/*
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
 */
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
	UINavigationController *tmpCtl;
	tmpCtl = [[ [ UINavigationController alloc ] initWithRootViewController: ContactControllerDetailsviewP ] autorelease];
	//[tmpCtl release];
	
	//[ [self navigationController] pushViewController:ContactControllerDetailsviewP animated: YES ];
		
	[ownerobject.tabBarController presentModalViewController:tmpCtl animated:YES];
	
	if([ContactControllerDetailsviewP retainCount]>1)
		[ContactControllerDetailsviewP release];
	//[self presentModalViewController:self animated:YES];
	//ownerobject.tabBarController.view.hidden = YES;
	////printf("\n retain countact details count %d\n",[ContactControllerDetailsviewP retainCount]);
	
	
	//[ ownerobject.ContactControllerController pushViewController:ownerobject->addeditviewP animated: YES ];
	//[ownerobject->addeditviewP setContactDetail:nil];
}
-(void) reload
{
	//int firstSection = 1;
	firstSection = 1;
//	//printf("\nreload called");
	NSString *searchStrP;
	searchStrP = searchbar.text;
	if([searchStrP length]==0 ||searchStrP == 0)
	{	
		if([self reloadLocal:nil :&firstSection])
		{	
			//- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;
		//	//printf("\n section%d",firstSection);
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
	////////////printf("\nmukesh");
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
			/*else
			{
				self.navigationItem.rightBarButtonItem 
				= [ [ [ UIBarButtonItem alloc ]
					 initWithTitle: @"Number" style:UIBarButtonItemStyleDone 
					 target: self
					 action: @selector(showNumberScreen) ] autorelease ];	
			
			}*/
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
	////////////printf("removed");
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
			//printf("\n %s   %d",addressP->title,i);
			while(*ignoreSpaceStrP==' ')
			{
				ignoreSpaceStrP++;
			}
			if(strlen(ignoreSpaceStrP)==0)
			{
			//	ignoreSpaceStrP = " ";
				CellIdentifier = [[NSString alloc] initWithUTF8String:" "] ;
			}
			else
			{	
				CellIdentifier = [[NSString alloc] initWithUTF8String:ignoreSpaceStrP] ;
			}
			//NSLog(CellIdentifier);
			secP = [[sectionData alloc] init];
			secP->recordid = addressP->id;
			/*
			// determine which letter starts the name
			if(i==0)//first letter add find
			{
				sectionData *secP;
				secP = [[sectionData alloc] init];
				secP->recordid = -1;
				//////printf("dummy aded");
				setTypeP = [sectionArray objectAtIndex:0];
				[ setTypeP->elementP addObject:secP];
			}*/
			if(strlen(ignoreSpaceStrP)==0 || (!isalpha(*ignoreSpaceStrP)))
			{
				rangeStringP = @"#";//this for avoiding crash when only blank is there
			}
			else
			{	
				rangeStringP = 	[[CellIdentifier substringToIndex:1] uppercaseString];
			}
			//printf("\n range ");
			//NSLog(rangeStringP);
			//printf(" end");
			NSRange range = [ALPHA rangeOfString:rangeStringP];
			if (range.location != NSNotFound && range.location <MAXSEC) 
			{	
				//NSLog(@"range location %d %@\n",range.location,CellIdentifier);
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
					////////printf("\n%s %ld %d",addressP->title,addressP->id ,i);
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
					//	//printf("\n error");
					}

				}
			}	
			// Add the name to the proper array
			[secP release];
			
			[CellIdentifier release];
		}
		
	//////printf("\n session count %d",sectionArray.count);
		for(i=0;i<sectionArray.count;++i)
		{
			setTypeP = [sectionArray objectAtIndex:i];
		//	//////////////printf("\n count %d %d ",tmp.count,i);
			if(setTypeP->elementP.count==0)
			{
				
				//[setTypeP release];
				//[sectionArray removeObjectAtIndex:i];
				//--i;
			}	
		}
			////////printf("\n session count after remove %d",sectionArray.count);

		
		
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
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Detemine if it's in editing mode
	
    return UITableViewCellEditingStyleNone;
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
//	//////////////printf("\n drawing...");

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
	////////////////printf("mukesh sharma");
	sectionType *setTypeP;
	setTypeP = [sectionArray objectAtIndex:section] ;
	
	// Set up the cell by coloring its text
	//NSArray *dataP = [[setTypeP->elementP objectAtIndex:row] componentsSeparatedByString:@"#"];
	////////////////printf("mukesh");
	//secP = (sectionData*)[dataP objectAtIndex:0];
	secP = (sectionData*)[setTypeP->elementP objectAtIndex:row]; 
	//////printf("\n %ld",secP->recordid);
	UITableViewCell *cell =(UITableViewCell *) [self->tableView dequeueReusableCellWithIdentifier:@"any-cell"];
	if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"any-cell"] autorelease];
		
		
	}
		
	addressP = (struct AddressBook *)getContact( secP->recordid);
	if(addressP)
	{	
		CellIdentifier = [[NSString alloc] initWithUTF8String:addressP->title ] ;
		//////////////printf("\n table %s  %ld %d",addressP->title ,secP->recordid,section);
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
	//////////////printf("mukesh shastri");
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
	////////////////printf("mukesh");
	//secP = (sectionData*)[dataP objectAtIndex:0];
	secP = (sectionData*)[setTypeP->elementP objectAtIndex:row]; 
	addressP = (struct AddressBook *)getContact( secP->recordid);
	#ifdef TEST_CALL_ID
		if(addressP->id==TEST_CALL_ID)
		{
			[self showContactDetailScreen :addressP :CONTACTPHONEADDRESSBOOKDETAIL contactBook:nil];//dont allowed edit
		}
		else
		{
			[self showContactDetailScreen :addressP :CONTACTDETAILVIEWENUM contactBook:nil];
		}
	#else
		[self showContactDetailScreen :addressP :CONTACTDETAILVIEWENUM contactBook:nil];
	#endif	


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
