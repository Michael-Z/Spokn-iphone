//
//  addressBookContact.m
//  spokn
//
//  Created by Mukesh Sharma on 11/08/09.//////printf
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import "addressBookContact.h"
#import "contactviewcontroller.h"
#import "SpoknAppDelegate.h"
#import "customcell.h"
#import "OverlayViewController.h"
#include "ua.h"
@implementation AddressBookContact
-(void)setObject:(id) object 
{
	self->ownerobject = object;
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section 
{ 
	sectionType *setTypeP;
	
	////printf("\nsdbarman %d",sectionArray.count);
	if(section<sectionArray.count)
	{	
		setTypeP = [sectionArray objectAtIndex:section];
		if(setTypeP->elementP.count)
		{	
				////printf("%d data ",setTypeP->index);
			return [NSString stringWithFormat:@"%@", 
					[ALPHA_ARRAY objectAtIndex:setTypeP->index]];
		}	
	}
	return nil;
} 

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
  //  [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
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

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView 
{ 
	return ALPHA_ARRAY; 
} 


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	////printf("shankarjaikishan");
	if(sectionArray.count)
		return [sectionArray count];
	return 1;
}



- (NSString *) getName: (ABRecordRef) person
{
	NSString *firstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
	NSString *lastName = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
	NSString *biz = (NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty);
	
	
	if ((!firstName) && !(lastName)) 
	{
		if (biz) return biz;
		return @" ";
	}
	
	if (!lastName) lastName = @"";
	if (!firstName) firstName = @"";
	
	firstName = [firstName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	lastName =  [lastName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	return [NSString stringWithFormat:@"%@ %@", firstName, lastName] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
		
		int row = [indexPath row];
	int section = [indexPath section];
	// Create a cell if one is not already available
	//////printf("mukesh sharma");
	
	UITableViewCell *cell =(UITableViewCell *) [self->tableView dequeueReusableCellWithIdentifier:@"any-cell"];
	if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"any-cell"] autorelease];
		
		
	}
	sectionType *setTypeP;
	setTypeP = [sectionArray objectAtIndex:section] ;
	
		
	// Set up the cell by coloring its text
	//NSArray *dataP = [[setTypeP->elementP objectAtIndex:row] componentsSeparatedByString:@"#"];
	//////printf("mukesh");
	//secP = (sectionData*)[dataP objectAtIndex:0];
	id person = [setTypeP->elementP objectAtIndex:row];
	cell.text = [self getName:person];

	//cell.textColor = [self getColor:[crayon objectAtIndex:1]];
	
	return cell;
	
	
	
	
	
	
	
	
	//////printf("\n where are u");
	/*
	if (ABPersonHasImageData(person))
	{
		UIImage *img = createImage([[UIImage imageWithData:(NSData *)ABPersonCopyImageData(person)] CGImage]);
		[cell setImage:img];
	}
	else */
		//[cell setImage:NULL];
	
	}

- (void) deselect
{	
	[self->tableView deselectRowAtIndexPath:[self->tableView indexPathForSelectedRow] animated:YES];
}

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
	
	ABMultiValueRef name1 =(NSString*)ABRecordCopyValue(person,property);
	//NSString* mobile=@"";
	NSString* numberStringP;
	char *numbercharP;
printf("\nidentifire = %ld\n",property);
	for(CFIndex i=0;i<ABMultiValueGetCount(name1);i++)
	{
		
		if(i==identifier)
		{
			numberStringP=(NSString*)ABMultiValueCopyValueAtIndex(name1,i);
			//now check whether it contain @ or not
			numbercharP = (char*)[numberStringP  cStringUsingEncoding:1];

			if(strstr(numbercharP,"@")==0)
			{	
				[self->ownerobject makeCall:numbercharP];
				[self->ownerobject changeView];
			}	
			else
			{
				[ownerobject vmsShowRecordScreen:numbercharP];
			}
			[numberStringP release];
			
		}
		/*mobileLabel=(NSString*)ABMultiValueCopyLabelAtIndex(name1, i);
		NSLog(@"\n all = %@\n",mobileLabel);
		if([mobileLabel isEqualToString:@"_$!<Mobile>!$_"])
		{
			mobile=(NSString*)ABMultiValueCopyValueAtIndex(name1,i);
			NSLog(@"\n%@",mobile);
			[mobile release];
			
		}
		[mobileLabel release];*/
	}
	[name1 release];
	
/*	
	if(property == kABPersonPhoneProperty)
	{
		CFStringRef *tmp;
		tmp = (CFStringRef *)ABRecordCopyValue(person, property);
		//printf("\nmukesh");
		
	}
	
	//int x = ABRecordCopyValue(person, property);
	//printf("\nPerson name");
//	NSLog(firstName);
*/
	return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
	
	int row = [newIndexPath row];
	int section = [newIndexPath section];
	struct AddressBook *addressP;
	sectionType *setTypeP;
	char *numbercharP=0;
	
	setTypeP = [sectionArray objectAtIndex:section] ;
	
	// Set up the cell by coloring its text
	//NSArray *dataP = [[setTypeP->elementP objectAtIndex:row] componentsSeparatedByString:@"#"];
	//////printf("mukesh");
	//secP = (sectionData*)[dataP objectAtIndex:0];
	id person  = [setTypeP->elementP objectAtIndex:row]; 
		
	/*
	ABPersonViewController *pvc = [[ABPersonViewController alloc] init];
	pvc.displayedPerson = person;
	pvc.personViewDelegate = self;
	[[controllerP navigationController] pushViewController:pvc animated:YES];
*/
	NSString *numberStringP;
	NSString *labelStringP;
	NSString *nameP;
	ABMultiValueRef name1 ;
	addressP = (struct AddressBook *)malloc(sizeof(struct AddressBook)+10);
	memset(addressP,0,sizeof(struct AddressBook));
	nameP = [self getName:person];
	NSLog(nameP);
	numbercharP = (char*)[nameP  cStringUsingEncoding:1];
	strncpy(addressP->title,numbercharP,98);
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
			if([labelStringP isEqualToString:@"_$!<Mobile>!$_"])
			{
				numbercharP = (char*)[numberStringP  cStringUsingEncoding:1];
				strcpy(addressP->mobile,numbercharP);
			}
			else
			{	
				if([labelStringP isEqualToString:@"_$!<Home>!$_"])
				{
					numbercharP = (char*)[numberStringP  cStringUsingEncoding:1];
					strcpy(addressP->home,numbercharP);
				}
				else
					if([labelStringP isEqualToString:@"_$!<Business>!$_"])
					{
						numbercharP = (char*)[numberStringP  cStringUsingEncoding:1];
						strcpy(addressP->business,numbercharP);
					}
					else
					{
						numbercharP = (char*)[numberStringP  cStringUsingEncoding:1];
						strcpy(addressP->other,numbercharP);

					}
			}
			NSLog(@"\n%@ %@\n",numberStringP,labelStringP);
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
			numbercharP = (char*)[numberStringP  cStringUsingEncoding:1];
			strcpy(addressP->email,numbercharP);
		//	NSLog(@"\n%@ %@\n",numberStringP,labelStringP);
			[numberStringP release];
			[labelStringP release];
		}
		[name1 release];
	}	
	
	
	 
	 
	 ContactDetailsViewController     *ContactControllerDetailsviewP;	
	 ContactControllerDetailsviewP = [[ContactDetailsViewController alloc] initWithNibName:@"contactDetails" bundle:[NSBundle mainBundle]];
	 [ContactControllerDetailsviewP setAddressBook:addressP editable:false :CONTACTPHONEDETAIL];
	 [ContactControllerDetailsviewP setObject:self->ownerobject];
	 
	 [ ownerobject.contactNavigationController pushViewController:ContactControllerDetailsviewP animated: YES ];
	 
	 if([ContactControllerDetailsviewP retainCount]>1)
	 [ContactControllerDetailsviewP release];
	free(addressP);
	 printf("\n retain countact details count %d\n",[ContactControllerDetailsviewP retainCount]);
	 
	 
}

- (void) buildSearchArrayFrom: (NSString *) matchString
{
	sectionType *setTypeP;
	int i;
	
	NSString *upString = [matchString uppercaseString];
	//if (searchArray) [searchArray release];
	while(sectionArray.count)
	{
		setTypeP = [sectionArray objectAtIndex:0];
		//lsz = setTypeP->elementP.count;
		/*while(setTypeP->elementP.count)
			//for(j = 0;j<lsz;++j)
			[setTypeP->elementP removeObjectAtIndex:0];*/
		[setTypeP release];
		[sectionArray removeObjectAtIndex:0];
	}
	
			for (i = 0; i < MAXSEC; i++){
		
		setTypeP = [[sectionType alloc] init];
		setTypeP->index = i;
		[sectionArray addObject: setTypeP] ;
	}
	
	
	//searchArray = [[NSMutableArray alloc] init];
	for (NSString *person in peopleArray)
	{
	
		
		NSRange range = [ALPHA rangeOfString:[[[self getName:person] substringToIndex:1] uppercaseString]];
		
		
		if (range.location == NSNotFound || range.location >=MAXSEC )
		{
			continue;
		}
		setTypeP = [sectionArray objectAtIndex:range.location];
		if(matchString)
		{	
			if([matchString length]>1)
			{	
				NSRange range1 = [[[self getName:person] uppercaseString] rangeOfString:upString];//[[[self getName:person] uppercaseString] rangeOfString:upString];
				if (range1.location != NSNotFound) 
				{	
					//////printf("\n%s %ld %d",addressP->title,addressP->id ,i);
					[ setTypeP->elementP addObject:person];
				}	
			}	
			else
			{
				////printf("\n find str");
				[ setTypeP->elementP addObject:person];
				
			}
		}
		else
		{
			////printf("\n find str");
			[ setTypeP->elementP addObject:person];
			
		}
		
	/*	
		// Add everyone when there's nothing to match to
		if ([matchString length] == 0)
		{
			[searchArray addObject:person];
			continue;
		}
		
		// Add the person if the string matches
		NSRange range = [[[self getName:person] uppercaseString] rangeOfString:upString];
		if (range.location != NSNotFound) [searchArray addObject:person];*/
	}
	////printf("count %d",sectionArray.count);
	[self->tableView reloadData];
}
- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
	//This method is called again when the user clicks back from the detail view.
	//So the overlay is displayed on the results, which is something we do not want to happen.
	UITextField *searchField = [[theSearchBar subviews] lastObject];
	if(searchField.text.length>0)
		return;
	
	//Add the overlay view.
	if(*ovControllerP == nil)
	{	
		*ovControllerP = [[OverlayViewController alloc] initWithNibName:@"OverlayView" bundle:[NSBundle mainBundle]];
	}
	CGFloat yaxis = controllerP.navigationController.navigationBar.frame.size.height;
	CGFloat width = controllerP.view.frame.size.width;
	CGFloat height = controllerP.view.frame.size.height;
	
	//Parameters x = origion on x-axis, y = origon on y-axis.
	CGRect frame = CGRectMake(0, yaxis, width, height);
	(*ovControllerP).view.frame = frame;	
	(*ovControllerP).view.backgroundColor = [UIColor grayColor];
	(*ovControllerP).view.alpha = 0.5;
	
	(*ovControllerP).rvController = controllerP;
	
	[self->tableView insertSubview:(*ovControllerP).view aboveSubview:controllerP.parentViewController.view];
	
	
	self->tableView.scrollEnabled = NO;
	
}

// When the search text changes, update the array
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if ([searchText length] == 0){
		
		
		[self->tableView insertSubview: (*ovControllerP).view aboveSubview:controllerP.parentViewController.view];
		
		return;
	}
	else
	{
		[(*ovControllerP).view removeFromSuperview];
		self->tableView.scrollEnabled = YES;
	}
	[self buildSearchArrayFrom:searchText]; 
}

// When the search button (i.e. "Done") is clicked, hide the keyboard
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
}
-(void)setSearchBarAndTable:(UISearchBar *)lBarP :(UITableView *)tableP PerentObject:(UIViewController *)lcontrollerP OverlayView:(OverlayViewController **)lovController;


{
	ovControllerP = lovController;
	controllerP = lcontrollerP;
	searchBarP = lBarP;
	searchBarP.delegate = self;
	self->tableView = tableP;
	tableView.delegate = self;
	tableView.dataSource = self;
	if(peopleArray=0)
	{	
		[self loadViewLoc];
		[self->tableView reloadData];
		
		if(peopleArray)
		{
			//now move head on top
			//[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:NO];

		}
	}
	else
	{
		[self loadViewLoc];
		[self->tableView reloadData];
	}
	if(tableP)
	{	
		////printf("\n mukesh");
	}
	else
	{
		////printf("\n dilip");
	}
}
// Prepare the Table View
- (void)loadViewLoc
{

	//[super loadView];
	self->tableView.rowHeight = 40;
	if(peopleArray==nil)
	{	
		sectionArray = [[[NSMutableArray alloc] init] retain];
		peopleArray = (NSMutableArray *)ABAddressBookCopyArrayOfAllPeople(ABAddressBookCreate());
		
		
		//for (int i = 0; i < 26; i++) [sectionArray addObject:[[[NSMutableArray alloc] init] retain]];

	}
	[self buildSearchArrayFrom:nil];
	// "Search" is the wrong key usage here. Replacing it with "Done"
	//UITextField *searchField = [[search subviews] lastObject];
	//[searchField setReturnKeyType:UIReturnKeyDone];
}

// Clean up
-(void) dealloc
{
	[peopleArray release];
	//[searchArray release];
	[sectionArray release];
	[super dealloc];
}
@end


@implementation UIAddressBook
- (id)init
{
	if (!(self = [super init])) return self;
	//self.title = @"People Picker";
	return self;
}

- (NSString *) getName: (ABRecordRef) person
{
	NSString *firstName = [(NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty) autorelease];
	NSString *lastName = [(NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty) autorelease];
	NSString *biz = [(NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty) autorelease];
	
	if ((!firstName) && !(lastName)) 
	{
		if (biz) return biz;
		return @"[No name supplied]";
	}
	
	if (!lastName) lastName = @"";
	if (!firstName) firstName = @"";
	
	return [[NSString stringWithFormat:@"%@ %@", firstName, lastName] autorelease];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
	//self.title = [self getName:person];
	return YES;
}


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
	id theProperty = (id)ABRecordCopyValue(person, property);
	int propertyType = ABPersonGetTypeOfProperty(property);
	
	if (propertyType == kABStringPropertyType)	 {
		////printf("%s\n", [theProperty UTF8String]);
	} else if (propertyType == kABIntegerPropertyType)	 {
		////printf("%d\n", [theProperty integerValue]);
	} else if (propertyType == kABRealPropertyType)	 {
		////printf("%d\n", [theProperty floatValue]);
	} else if (propertyType == kABDateTimePropertyType)	 {
		////printf("%s\n", [[theProperty description] UTF8String]);
	} else if (propertyType == kABMultiStringPropertyType)	 {
		////printf("%s\n",
			 //  [[(NSArray *)ABMultiValueCopyArrayOfAllValues(theProperty) objectAtIndex:identifier] UTF8String]);
	} else if (propertyType == kABMultiIntegerPropertyType)	 {
		////printf("%d\n",	[[(NSArray *)ABMultiValueCopyArrayOfAllValues(theProperty) objectAtIndex:identifier] integerValue]);
	} else if (propertyType == kABMultiRealPropertyType)	 {
		////printf("%f\n",	[[(NSArray *)ABMultiValueCopyArrayOfAllValues(theProperty) objectAtIndex:identifier] floatValue]);
		
	} else if (propertyType == kABMultiDateTimePropertyType)	 {
		////printf("%s\n",	[[[(NSArray *)ABMultiValueCopyArrayOfAllValues(theProperty) objectAtIndex:identifier] description] UTF8String]);
		
	} else if (propertyType == kABMultiDictionaryPropertyType)	 {
		////printf("%s\n",	[[[(NSArray *)ABMultiValueCopyArrayOfAllValues(theProperty) objectAtIndex:identifier] description] UTF8String]);
	}
	
	
	[uiControllerP dismissModalViewControllerAnimated:YES];
	CFRelease(theProperty);
	[peoplePicker release];
	ab = nil;
	uiControllerP = nil;

	
	return NO;
}

- (void) peoplePickerNavigationControllerDidCancel: (ABPeoplePickerNavigationController *)peoplePicker
{
	[uiControllerP dismissModalViewControllerAnimated:YES];
	[peoplePicker release];
	ab = nil;
	uiControllerP = nil;
	
	
}

- (void) HidePhoneContact
{
	[uiControllerP dismissModalViewControllerAnimated:YES];
	[ab release];
	ab = nil;
}

- (void) ShowPhoneContact:(UIViewController*)luiControllerP
{
	uiControllerP = luiControllerP;
	ab = [[ABPeoplePickerNavigationController alloc] init];
	[ab setPeoplePickerDelegate:self];
	[uiControllerP presentModalViewController:ab animated:YES];
}

-(void) dealloc
{		[ab release];
		[super dealloc];
}
@end

