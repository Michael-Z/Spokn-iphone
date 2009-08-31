//
//  ContactDetailsViewController.m
//  spoknclient
//
//  Created by Mukesh Sharma on 01/07/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import "contactDetailsviewcontroller.h"

#import "Ltptimer.h"
#import "LtpInterface.h"
#import "SpoknAppDelegate.h"
#import "AddEditcontactViewController.h"

@implementation ContactDetailsViewController

-(void)setObject:(id) object 
{
	self->ownerobject = object;
}

/*
 *   Table Data Source
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{
	//printf("\n dilip sharma");
	return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section 
{
	/*return [[UIFont	familyNames] count];*/
	//printf("\n mukesh sharma");
	return self->tablesz;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *CellIdentifier;
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"any-cell"];
	if (!cell)	cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"any-cell"] autorelease];
	
	CellIdentifier = [[NSString alloc] initWithUTF8String:element[[ indexPath indexAtPosition: 1 ]]];
	cell.text = CellIdentifier;
	[CellIdentifier release];
	//cell.text = [[UIFont familyNames] objectAtIndex:[indexPath row]];
	return cell;
	return nil;
}

/*
 *   Table Delegate
 */

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
	//selection = [[[UIFont familyNames] objectAtIndex:[newIndexPath row]] retain];
	int index;
	index = [newIndexPath indexAtPosition: 1 ];
	if(index<MAX_COUNT)
	{	
		if(strstr(element[index],"@")==0)
		{	
			[self->ownerobject makeCall:element[index]];
			[self->ownerobject changeView];
		}	
		else
		{
			[ownerobject vmsRecordStart:element[index]];
		}
	}	
}



/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/
-(IBAction)editClicked
{
	AddEditcontactViewController     *addeditviewP;	
	addeditviewP = [[AddEditcontactViewController alloc] initWithNibName:@"addeditcontact" bundle:[NSBundle mainBundle]];
	
	[ [self navigationController] pushViewController:addeditviewP animated: YES ];
	[addeditviewP  setContactDetail:self->addressDataP];
	[addeditviewP setObject:self->ownerobject];
	//NSLog(@"retainCount:%d", [addeditviewP retainCount]);
	if([addeditviewP retainCount]>1)
		[addeditviewP release];
	
	
}
#define TABLE_VIEW_TAG			2000

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.tabBarItem = [UITabBarItem alloc];
	//[self.tabBarItem initWithTitle:@"ContactDetailsViewController" image:nil tag:3];
	//self->tablesz = 0;
	//printf("\n table = %d",self->tablesz);
	tableView.delegate = self;
	tableView.dataSource = self;
	//tableView.tag = TABLE_VIEW_TAG;
	if(self.navigationItem.rightBarButtonItem==nil)
	{	
		self.navigationItem.rightBarButtonItem 
		= [ [ [ UIBarButtonItem alloc ]
			 initWithBarButtonSystemItem: UIBarButtonSystemItemEdit
			 target: self
			 action: @selector(editClicked) ] autorelease ];	
		
	}	
	
	[tableView reloadData];

}

-(void)setAddressBook:( struct AddressBook *)laddressDataP
{
	NSString *nsp;
	if(addressDataP)
	{	
		free(addressDataP);
	}	
	self->tablesz = 0;
	addressDataP = 0;
	for(int i=0;i<MAX_COUNT;++i)
	{
		element[i] = 0;
	}
	if(laddressDataP)
	{
		addressDataP = malloc(sizeof(struct AddressBook)+4);//extra 4 for padding
		*addressDataP=*laddressDataP;
		if(strlen(addressDataP->home)>0)
		{
			element[tablesz++] = addressDataP->home;
		}
		if(strlen(addressDataP->business)>0)
		{
			element[tablesz++] = addressDataP->business;
		}
		if(strlen(addressDataP->mobile)>0)
		{
			element[tablesz++] = addressDataP->mobile;
		}
		if(strlen(addressDataP->other)>0)
		{
			element[tablesz++] = addressDataP->other;
		}
		if(strlen(addressDataP->email)>0)
		{
			element[tablesz++] = addressDataP->email;
		}
		if(strlen(addressDataP->spoknid)>0)
		{
			element[tablesz++] = addressDataP->spoknid;
		}
		nsp = [[NSString alloc] initWithUTF8String:(const char*)addressDataP->title ];
		[userNameP setText:nsp];
		[nsp release];
		
	}
	
	if(tablesz)
	{
				
		if(tableView)
		{	
			//printf("\n%d",tablesz);
			[tableView reloadData];
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
	//printf("\n dealloc");
	 [super dealloc];
}


@end
