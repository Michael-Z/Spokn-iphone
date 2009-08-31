//
//  CalllogViewController.m
//  spokn
//
//  Created by Mukesh Sharma on 03/08/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import "CalllogViewController.h"

#import "LtpInterface.h"
#import "SpoknAppDelegate.h"
#include "contactviewcontroller.h"
#import "contactDetailsviewcontroller.h"
#import "AddEditcontactViewController.h"
#import "customcell.h"
@implementation CalllogViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

-(void)setObject:(id) object 
{
	self->ownerobject = object;
}

/*
 *   Table Data Source
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{
	////////printf("\n dilip sharma");
	return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section 
{
	int count;
	/*return [[UIFont	familyNames] count];*/
	count = GetTotalCount(GETCALLLOGLIST);
	//////printf("\n mukesh sharma %d\n",count);
	return count;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	////////printf("mukeshsdsdsd");
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
	
}/*
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *CellIdentifier = [[NSString alloc] initWithUTF8String:"any cell"];
	SpoknUITableViewCell *cell = (SpoknUITableViewCell *) [ tableView dequeueReusableCellWithIdentifier: CellIdentifier ];
		if (cell == nil) {
		
			CGRect cellRect = CGRectMake(0, 0, 320, 40);
		
			cell =  [ [ SpoknUITableViewCell alloc ] initWithFrame: cellRect reuseIdentifier: CellIdentifier ]  ;
		}	
	sectionType *secLocP;
	secLocP = [self->cellofcalllogP getObjectAtIndex: [ indexPath indexAtPosition: 1 ]];
	if(secLocP==0) return nil;
	cell.spoknSubCellP.userData = secLocP->userData;
	cell.spoknSubCellP.dataArrayP = secLocP->elementP;
	cell.spoknSubCellP.ownerDrawB = true;
	cell.spoknSubCellP.rowHeight = 50;
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//UITableViewCellAccessoryDetailDisclosureButton; 
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	[CellIdentifier release];
	//cell.hidesAccessoryWhenEditing = YES;
	return cell;
	
		
}
 */
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	sectionType *secLocP;
	NSString *CellIdentifier = [[NSString alloc] initWithUTF8String:"any cell"];
	SpoknUITableViewCell *cell = (SpoknUITableViewCell *) [ tableView dequeueReusableCellWithIdentifier: CellIdentifier ];
	if (cell == nil) {
		
		//	secLocP = [self->cellofvmsP getObjectAtIndex: [ indexPath indexAtPosition: 1 ]];
		//	if(secLocP)
		{	
			CGRect cellRect = CGRectMake(0, 0, 320, 50);
			
			cell = [ [ [ SpoknUITableViewCell alloc ] initWithFrame: cellRect reuseIdentifier: CellIdentifier ] autorelease] ;
			//cell->resusableCount = [ indexPath indexAtPosition: 1 ];
			[self addRow:[ indexPath indexAtPosition: 1 ] sectionObject:&secLocP];
			
		}	
	}	
	else
	{	
		secLocP = cell.spoknSubCellP.userData;
		[secLocP release];
		
		[self addRow:[ indexPath indexAtPosition: 1 ] sectionObject:&secLocP];
		//secLocP = [self->cellofvmsP getObjectAtIndex: [ indexPath indexAtPosition: 1 ]];
	}
	if(secLocP==0) return nil;
	cell.spoknSubCellP.userData = secLocP;
	cell.spoknSubCellP.dataArrayP = secLocP->elementP;
	cell.spoknSubCellP.ownerDrawB = true;
	cell.spoknSubCellP.rowHeight = 50;
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//UITableViewCellAccessoryDetailDisclosureButton; 
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	[CellIdentifier release];
	//cell.hidesAccessoryWhenEditing = YES;
	return cell;
	
	
}

- (void)addRow: (int )index sectionObject:(sectionType **)sectionPP;
{
	struct AddressBook *addressP;
	void *objP;
	char *typeCallP = "unknown";
	char *objStrP=0;
	char *secObjStrP = 0;
	struct tm *tmP=0;
	time_t timeP;
	char disp[200];
	char s1[30];
	//int index;
	NSString *stringStrP;
	char *month[12]={"jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
	
	//////printf("\n index = %d\n",index);
	
	objP = GetObjectAtIndex(GETCALLLOGLIST ,index);
	if(objP)
	{
	//	NSString *CellIdentifier;
		struct CDR *cdrP;
		//char tmpidentifier[50];
		cdrP =(struct CDR*) objP;
		objStrP = cdrP->userid;
		addressP = getContactOf(objStrP);
		//
		if(addressP)
		{
			if (!strcmp(addressP->mobile, objStrP))
			{
				typeCallP = "mobile";
			}
			
			if (!strcmp(addressP->home, objStrP))
			{
				typeCallP = "home";
			}
			
			if (!strcmp(addressP->business, objStrP))
			{
				typeCallP = "business";
			}	
			if (!strcmp(addressP->spoknid, objStrP))
			{
				typeCallP = "spokn";
			}	
			if (!strcmp(addressP->other, objStrP))
			{
				typeCallP = "other";
			}
			
			if (!strcmp(addressP->email, objStrP))
			{
				typeCallP = "email";
			}
			
			objStrP = addressP->title;
		}
		timeP = cdrP->date;
		tmP = localtime(&timeP);
		if(tmP)
		{	
			sprintf(s1,"%02d:%02d %3s %02d",tmP->tm_hour,tmP->tm_min,month[tmP->tm_mon],tmP->tm_mday);
			//sprintf(disp,"%-20s %12s",objStrP,s1);
			//free(tmP);
			strcpy(disp,objStrP);
			//free(tmP);
			objStrP = disp;
			secObjStrP = s1;
			
		}
			
		
		displayData *dispP;	
		sectionType *secLocP;
		Boolean makeB = false;
		secLocP = [[sectionType alloc] init];
		secLocP->index = index;
		makeB = true;
		
		if(makeB)
		{
			secLocP->userData = objP;
			secLocP->index = index;
			dispP = [ [displayData alloc] init];
			dispP.left = 0;
			dispP.top = 0;
			if(secObjStrP)
			{	
				dispP.width = 60;
			}
			else
			{
				dispP.width = 100;
			}
			dispP.height = 50;
			dispP.colorP = [UIColor blackColor];
			dispP.fntSz = 16;
			//dispP.fontP =  [self->fontGloP fontWithSize:16];
			//[dispP.fontP retain];
			//[dispP.fontP release];
			stringStrP = [[NSString alloc] initWithUTF8String:objStrP ];
			dispP.dataP = stringStrP;
			[stringStrP release];
			[dispP.colorP release];
			dispP.fntSz = 16;
			[secLocP->elementP addObject:dispP];
			
			if(secObjStrP)
			{	
				dispP = [ [displayData alloc] init];
				dispP.left = 0;
				dispP.top = 0;
				dispP.width = 40;
			
				dispP.height = 100;
				stringStrP = [[NSString alloc] initWithUTF8String:secObjStrP ];
				dispP.dataP = stringStrP;
				[stringStrP release];
				dispP.colorP = [UIColor blueColor];
				dispP.fntSz = 14;
				[dispP.colorP release];
				[secLocP->elementP addObject:dispP];
				
				// [cell setNeedsDisplay];
			}	
			
			dispP = [ [displayData alloc] init];
			dispP.left = 0;
			dispP.top = 0;
			dispP.width = 70;
			dispP.row = 1;
			dispP.height = 40;
			stringStrP = [[NSString alloc] initWithUTF8String:typeCallP ];
			dispP.dataP = stringStrP;
			[stringStrP release];
			dispP.colorP = [UIColor lightGrayColor];
			
			dispP.fntSz = 14;
			[dispP.colorP release];
						//now set image
			
			
			if(cdrP->direction & CALLTYPE_OUT)
			{
				dispP.uiImageP = outImageP;
			}
			else
		//now set image
				if(cdrP->direction & CALLTYPE_IN)
				{
					dispP.uiImageP = inImageP;
				}
				else
				if(cdrP->direction & CALLTYPE_MISSED)
				{
					dispP.uiImageP = missImageP;
				}
				else
				{
					dispP.uiImageP = outImageP;
				}
			////////printf("\n retain count  image %d",[dispP.uiImageP retainCount]);
			[secLocP->elementP addObject:dispP];
			if(sectionPP==0)
			{	
				[self->cellofcalllogP addObject:secLocP];	
			}
			else
			{
				*sectionPP = secLocP;//back the pointer
			}
				//[self->cellofcalllogP addObjectAtIndex:secLocP :index];	
			//[self->cellofcalllogP addObjectAtIndex:cell.spoknSubCellP.dataArrayP :index];	
			
			 
		}
		
		//[CellIdentifier release];
				
	}
	//return nil;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	SpoknUITableViewCell *cell = (SpoknUITableViewCell*)[ self->tableView cellForRowAtIndexPath: indexPath ];
	
	struct CDR *cdrP;
	sectionType *secLocP;
	secLocP = cell.spoknSubCellP.userData;
	cdrP =(struct CDR*)  secLocP->userData;
	if(cdrP)
	{
		struct AddressBook *addressP;
		
		addressP = getContactOf(cdrP->userid);
		if(addressP)
		{
			AddEditcontactViewController     *addeditviewP;	
			addeditviewP = [[AddEditcontactViewController alloc] initWithNibName:@"addeditcontact" bundle:[NSBundle mainBundle]];
			
			[ [self navigationController] pushViewController:addeditviewP animated: YES ];
			[addeditviewP  setContactDetail:addressP];
			[addeditviewP setObject:self->ownerobject];	
			////NSLog(@"retainCount:%d", [addeditviewP retainCount]);
			if([addeditviewP retainCount]>1)
				[addeditviewP release];
			
			
			return;
			
		}
		else
		{
			addressP = (struct AddressBook *)malloc(sizeof(struct AddressBook ));
			memset(addressP,0,sizeof(struct AddressBook));
			addressP->id = -1;
			strcpy(addressP->mobile,cdrP->userid);
			AddEditcontactViewController     *addeditviewP;	
			addeditviewP = [[AddEditcontactViewController alloc] initWithNibName:@"addeditcontact" bundle:[NSBundle mainBundle]];
			[addeditviewP setObject:self->ownerobject];
			[ [self navigationController] pushViewController:addeditviewP animated: YES ];	
			[addeditviewP  setContactDetail:addressP];
			free(addressP);
			if([addeditviewP retainCount]>1)
				[addeditviewP release];
			return;
		}
		
		
	}
	
}

/*
 *   Table Delegate
 */

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//selection = [[[UIFont familyNames] objectAtIndex:[newIndexPath row]] retain];
	SpoknUITableViewCell *cell = (SpoknUITableViewCell*)[ self->tableView cellForRowAtIndexPath: indexPath ];
	
	struct CDR *cdrP;
	sectionType *secLocP;
	secLocP = cell.spoknSubCellP.userData;
	cdrP =(struct CDR*)  secLocP->userData;
	if(cdrP==0) return;
	if(self->tableView.editing==NO)
	{	
		[self->ownerobject makeCall:cdrP->userid];
		[self->ownerobject changeView];
	}
	else
	{
		struct AddressBook *addressP;
		addressP = getContactOf(cdrP->userid);
		if(addressP)
		{
			AddEditcontactViewController     *addeditviewP;	
			addeditviewP = [[AddEditcontactViewController alloc] initWithNibName:@"addeditcontact" bundle:[NSBundle mainBundle]];
			
			[ [self navigationController] pushViewController:addeditviewP animated: YES ];
			[addeditviewP  setContactDetail:addressP];
			[addeditviewP setObject:self->ownerobject];	
			////NSLog(@"retainCount:%d", [addeditviewP retainCount]);
			if([addeditviewP retainCount]>1)
				[addeditviewP release];
			
			
						return;
			
		}
		else
		{
			addressP = (struct AddressBook *)malloc(sizeof(struct AddressBook ));
			memset(addressP,0,sizeof(struct AddressBook));
			addressP->id = -1;
			strcpy(addressP->mobile,cdrP->userid);
			AddEditcontactViewController     *addeditviewP;	
			addeditviewP = [[AddEditcontactViewController alloc] initWithNibName:@"addeditcontact" bundle:[NSBundle mainBundle]];
			[addeditviewP setObject:self->ownerobject];
			[ [self navigationController] pushViewController:addeditviewP animated: YES ];	
			[addeditviewP  setContactDetail:addressP];
			free(addressP);
			if([addeditviewP retainCount]>1)
				[addeditviewP release];
			return;
		}
		
	
	}

}

- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle) editingStyle 
forRowAtIndexPath:(NSIndexPath *) indexPath 
{ 
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		SpoknUITableViewCell *cell = (SpoknUITableViewCell*)[ self->tableView cellForRowAtIndexPath: indexPath ];
		struct CDR *cdrP;
		sectionType *secLocP;
		secLocP = cell.spoknSubCellP.userData;
		cdrP =(struct CDR*)  secLocP->userData;
		if(cdrP)
		{	
			cdrRemove(cdrP);
		}
		/* Delete cell from data source */
		/*
		 UITableViewCell *cell = [ self.tableView cellForRowAtIndexPath: indexPath ];
		 for(int i = 0; i < [ fileList count ]; i++) {
		 if ([ cell.text isEqualToString: [ fileList objectAtIndex: i ] ]) {
		 [ fileList removeObjectAtIndex: i ];
		 }
		 }
		 */
		/* Delete cell from table */
		
	    NSMutableArray *array = [ [ NSMutableArray alloc ] init ];
	    [ array addObject: indexPath ];
        [ self->tableView deleteRowsAtIndexPaths: array withRowAnimation: UITableViewRowAnimationTop ];
		[self->cellofcalllogP removeObjectAtIndex: [ indexPath indexAtPosition: 1 ]];
		
	} 
}

- (void) reload {
	//sectionType *secP;
	
	/*self.navigationItem.rightBarButtonItem 
	= [ [ [ UIBarButtonItem alloc ]
		 initWithBarButtonSystemItem: UIBarButtonSystemItemEdit
		 target: self
		 action: @selector(startEditing) ] autorelease ];	*/
	/*
	[self->cellofcalllogP release];
	self->cellofcalllogP = [[CellObjectContainer alloc] init];
	int i,noObj;
	noObj = GetTotalCount(GETCALLLOGLIST);
	
	for(i=0;i<noObj;++i)
	{	
		[self addRow:i];
	}	
	
	
	 */
	[ self->tableView reloadData ];
	
}/*
- (void) startEditing {
	
		//self->tableView 
	[ self->tableView setEditing: YES animated: YES ];
	self->tableView.allowsSelectionDuringEditing = YES;
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

*/
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */
#define TABLE_VIEW_TAG			2010

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.tabBarItem = [UITabBarItem alloc];
	//[self.tabBarItem initWithTitle:@"Calllog" image:nil tag:2];
	missImageP = [UIImage imageNamed:@"missed.png"];
	inImageP = [UIImage imageNamed:@"callin.png"];
	outImageP = [UIImage imageNamed:@"callout.png"];
	
	 
	
	
	
	
	//self->fontGloP = [UIFont systemFontOfSize:16.0];
	//////printf("\n my font count %d",[self->fontGloP  retainCount]);
	self->cellofcalllogP  = nil;	
	
	//self->tablesz = 0;
	////////printf("\n table = %d",self->tablesz);
	tableView.delegate = self;
	tableView.dataSource = self;
//	tableView.tag = TABLE_VIEW_TAG;
	[tableView reloadData];
	[self setTitle:@"Calllog"];
	
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
	[self->fontGloP release];
}


- (void)dealloc {
	
	[missImageP release];
	[inImageP release];
	[outImageP release];


    [super dealloc];
}

-(void)setObjType:(UAObjectType)luaObj
{
	switch(luaObj)
	{
		case GETCONTACTLIST:
			[self setTitle:@"Contact"];
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
