//
//  VmailViewController.m
//  spokn
//
//  Created by Mukesh Sharma on 03/08/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import "vmailviewcontroller.h"

#import "LtpInterface.h"
#import "SpoknAppDelegate.h"
#include "contactviewcontroller.h"
#import "customcell.h"
@implementation VmailViewController
@synthesize ltpInterfacesP;

- (void) handleTimer: (id) timer
{
   
	if(amt<maxtime)
	{	
		amt += 1;
		[uiProgressP setProgress: (amt / maxtime)];
		//	if (amt > maxtime) { [timer invalidate];}
		//printf("\n timer progress count %d",[uiProgressP retainCount]);

	}
		
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	////printf("User Pressed Button %d\n", buttonIndex + 1);
	if(uiActionSheetP)
	{	
		[ownerobject vmsStop:false];
	}
}
-(void)stopvmsPlay
{
	
	[uiActionSheetP dismissWithClickedButtonIndex:0 animated:YES ];
	//[uiActionSheetP release];
	
	
	[uiProgressP release];
	[nsTimerP invalidate];
	nsTimerP = nil;
	uiProgressP = nil;
	uiActionSheetP = nil;
	

}
-(void)startVmsProgress:(int) max
{
	amt = 0.0;
	maxtime = max*2;
	//CGRect rectSheet;
	uiActionSheetP = [[UIActionSheet alloc] 
			initWithTitle: @"" 
			delegate:self
			cancelButtonTitle:@"Cancel"
			destructiveButtonTitle:nil
			otherButtonTitles:nil, nil, nil];
	//rectSheet = uiActionSheetP.bounds;
	//rectSheet.size.height = 50;
	uiProgressP = [[UIProgressView alloc] initWithFrame:
			   
			   CGRectMake(10.0f, 10.0f, 300.0f, 10.0f)];
	
	uiProgressP.backgroundColor = uiActionSheetP.backgroundColor;//[UIColor blueColor];
	uiProgressP.progressViewStyle= UIProgressViewStyleBar;
	
	//UIView *contentView1 = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 100.0f, 200.0f, 50.0f)];
	
	//uiProgressP.backgroundColor = [UIColor blueColor];
    
	// [contentView1 addSubview:progbar];
    [uiActionSheetP addSubview:uiProgressP];
	[uiProgressP release];//need to release because addsubview increse counter by one
		
    //[menu setStyle: 0];
	uiActionSheetP.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[uiActionSheetP showInView:[ownerobject tabBarController].view];
//	[uiProgressP release];//need to release because addsubview increse counter by o
		
	
	
	//[menu release];
		
    nsTimerP = [NSTimer scheduledTimerWithTimeInterval: 0.5
				
												target: self
				
											  selector: @selector(handleTimer:)
				
											  userInfo: nil
				
											   repeats: YES];
	
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

-(void)setObject:(id) object 
{
	self->ownerobject = object;
}

/*
 *   Table Data Source
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{
	//////printf("\n dilip sharma");
	return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section 
{
	int count;
	/*return [[UIFont	familyNames] count];*/
	count = GetTotalCount(GETVMAILLIST);
	//printf("\n mukesh sharma %d",count);
		return count;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	//////printf("mukeshsdsdsd");
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
	
}
- (void)addRow: (int )index sectionObject:(sectionType **)sectionPP
{
	struct AddressBook *addressP;
	void *objP;
	
	char *objStrP=0;
	char *secObjStrP = 0;
	struct tm *tmP=0;
	time_t timeP;
	char disp[200];
	char s1[30];
	//int index;
	NSString *stringStrP;
	char *month[12]={"jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
	
	////printf("\n index = %d\n",index);
	
	objP = GetObjectAtIndex(GETVMAILLIST ,index);
	if(objP)
	{
		//	NSString *CellIdentifier;
		struct VMail *vmailP;
		vmailP =(struct VMail*) objP;
		objStrP = vmailP->userid;
		addressP = getContactOf(objStrP);
		if(addressP)
		{
			objStrP = addressP->title;
		}
		timeP = vmailP->date;
		tmP = localtime(&timeP);
		if(tmP)
		{	
			
			sprintf(s1,"%02d:%02d %3s %02d",tmP->tm_hour,tmP->tm_min,month[tmP->tm_mon],tmP->tm_mday);
			//sprintf(disp,"%-20s %12s",objStrP,s1);
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
			if (vmailP->direction == VMAIL_OUT) 
			{
				/*
				 UIImage  *activeImageP;
				 UIImage  *dileverImageP;
				 UIImage  *failedImageP;
				 UIImage  *vnewImageP;
				 UIImage  *readImageP;
				 
				 */
				switch(vmailP->status)
				{
					case VMAIL_DELIVERED:
						dispP.uiImageP =  dileverImageP;
						break;
					case VMAIL_FAILED:
						dispP.uiImageP =  failedImageP;
						break;
					case VMAIL_ACTIVE:
						dispP.uiImageP =  activeImageP;
						break;
					case VMAIL_NEW:
						dispP.uiImageP =  vnewImageP;
						break;
				}
			}
			if (vmailP->direction == VMAIL_IN) 
			{
				switch(vmailP->status)
				{
					case VMAIL_ACTIVE:
						dispP.uiImageP =  vnewImageP;
						break;
					case VMAIL_DELIVERED:
						dispP.uiImageP =  readImageP;
						break;
					case VMAIL_NEW:
						dispP.uiImageP =  vnewImageP;
						break;
					case VMAIL_FAILED:
						dispP.uiImageP =  failedImageP;
						break;
						
						
						

				}
			}
			if(vmailP->status==VMAIL_FAILED)
			{
				dispP.colorP = [UIColor redColor];
			}
			else
			{
				dispP.colorP = [UIColor blackColor];
				
			}
			[dispP.colorP release];
			dispP.fntSz = 16;
			//dispP.fontP =  [self->fontGloP fontWithSize:16];
			//[dispP.fontP retain];
			//[dispP.fontP release];
			stringStrP = [[NSString alloc] initWithUTF8String:objStrP ];
			dispP.dataP = stringStrP;
			[stringStrP release];
			
			
			
			dispP.fntSz = 16;
			[secLocP->elementP addObject:dispP];
			
			if(secObjStrP)
			{	
				dispP = [ [displayData alloc] init];
				dispP.left = 0;
				dispP.top = 0;
				dispP.width = 40;
				
				dispP.height = 100;
				if(vmailP->status==VMAIL_FAILED)
				{
					dispP.colorP = [UIColor redColor];
				}
				else
				{
					dispP.colorP = [UIColor blackColor];
					
				}
				
				stringStrP = [[NSString alloc] initWithUTF8String:secObjStrP ];
				dispP.dataP = stringStrP;
				[stringStrP release];
				dispP.colorP = [UIColor blueColor];
				dispP.fntSz = 14;
				[dispP.colorP release];
				[secLocP->elementP addObject:dispP];
				
				// [cell setNeedsDisplay];
			}	
			
			if(sectionPP==0)//mean we dont need to return section object
			{
				[self->cellofvmsP addObject:secLocP];	
			}
			else
			{
				*sectionPP = secLocP;
			}
			//[self->cellofcalllogP addObjectAtIndex:secLocP :index];	
			//[self->cellofcalllogP addObjectAtIndex:cell.spoknSubCellP.dataArrayP :index];	
			
			
		}
		
		//[CellIdentifier release];
		
	}
	//return nil;
}
/*
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	sectionType *secLocP;
	NSString *CellIdentifier = [[NSString alloc] initWithUTF8String:"any cell"];
	SpoknUITableViewCell *cell = (SpoknUITableViewCell *) [ tableView dequeueReusableCellWithIdentifier: CellIdentifier ];
	if (cell == nil) {
		
		secLocP = [self->cellofvmsP getObjectAtIndex: [ indexPath indexAtPosition: 1 ]];
		if(secLocP)
		{	
			CGRect cellRect = CGRectMake(0, 0, 320, 40);
		
			cell =  [ [ SpoknUITableViewCell alloc ] initWithFrame: cellRect reuseIdentifier: CellIdentifier ]  ;
			cell->resusableCount = [ indexPath indexAtPosition: 1 ];
		}	
	}	
	else
	{	
		secLocP = [self->cellofvmsP getObjectAtIndex: [ indexPath indexAtPosition: 1 ]];
	}
	if(secLocP==0) return nil;
	cell.spoknSubCellP.userData = secLocP;
	cell.spoknSubCellP.dataArrayP = secLocP->elementP;
	cell.spoknSubCellP.ownerDrawB = true;
	cell.spoknSubCellP.rowHeight = 50;
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//UITableViewCellAccessoryDetailDisclosureButton; 
	//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
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
			
			cell =  [[ [ SpoknUITableViewCell alloc ] initWithFrame: cellRect reuseIdentifier: CellIdentifier ] autorelease] ;
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
	//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	[CellIdentifier release];
	//cell.hidesAccessoryWhenEditing = YES;
	return cell;
	
	
}



/*
 *   Table Delegate
 */

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//selection = [[[UIFont familyNames] objectAtIndex:[newIndexPath row]] retain];
	sectionType *secLocP;
	SpoknUITableViewCell *cell = (SpoknUITableViewCell*)[ self->tableView cellForRowAtIndexPath: indexPath ];
	
	struct VMail *vmailP;
	char fName[200];
	unsigned long timeTotal=0;
	secLocP = cell.spoknSubCellP.userData;
	vmailP =(struct VMail*) secLocP->userData;
	if(GetVmsFileName(vmailP,fName)==0)
	{
		int er;
		UIAlertView *alert;
		
		er = [ownerobject vmsPlayStart:fName :&timeTotal];
		switch(er)
		{
			case 0:
				if(vmailP->direction==VMAIL_IN && vmailP->status==VMAIL_ACTIVE)		
				{
					vmailP->status=VMAIL_DELIVERED;
					vmailP->dirty=1;
					
					
					profileResync();
				}
				[self navigationController].tabBarItem.badgeValue= nil;
				[self startVmsProgress:timeTotal];
				

				break;
			case 2:
				alert = [ [ UIAlertView alloc ] initWithTitle: @"Error" 
													  message: [ NSString stringWithString:@"vms is already playing" ]
																  delegate: nil
														 cancelButtonTitle: nil
														 otherButtonTitles: @"OK", nil
									  ];
				[ alert show ];
				
				break;
			case 1:
								
				alert = [ [ UIAlertView alloc ] initWithTitle: @"The voice mail is still not downloaded." 
																   message: [ NSString stringWithString:@"This can be due to slow Internet access.\r\nDo you want to try downloading now?" ]
																  delegate: self
														 cancelButtonTitle: @"cancel"
														 otherButtonTitles: @"OK", nil
									  ];
				
				[ alert show ];
			//	

				
				break;
			
		}
		
		
		
	}	
		

}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
	switch(buttonIndex)
	{
		case 1:
			profileResync();
			break;
	}
	//printf("\n%d",buttonIndex);
}
- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle) editingStyle 
forRowAtIndexPath:(NSIndexPath *) indexPath 
{ 
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		SpoknUITableViewCell *cell = (SpoknUITableViewCell*)[ self->tableView cellForRowAtIndexPath: indexPath ];
		sectionType *secLocP;
		
		struct VMail *vmailP;
		
		secLocP = cell.spoknSubCellP.userData;
		vmailP =(struct VMail*) secLocP->userData;
		vmsDelete(vmailP);
		profileResync();
		
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
		[self->cellofvmsP removeObjectAtIndex: [ indexPath indexAtPosition: 1 ]];
		
	} 
}

- (void) reload {
	self.navigationItem.rightBarButtonItem 
	= [ [ [ UIBarButtonItem alloc ]
		 initWithBarButtonSystemItem: UIBarButtonSystemItemEdit
		 target: self
		 action: @selector(startEditing) ] autorelease ];	
	
		//sectionType *secP;
		
		/*self.navigationItem.rightBarButtonItem 
		 = [ [ [ UIBarButtonItem alloc ]
		 initWithBarButtonSystemItem: UIBarButtonSystemItemEdit
		 target: self
		 action: @selector(startEditing) ] autorelease ];	*/
		/*
		[self->cellofvmsP release];
		self->cellofvmsP = [[CellObjectContainer alloc] init];
		int i,noObj;
		noObj = GetTotalCount(GETVMAILLIST);
	//printf("\n%d",noObj);
		for(i=0;i<noObj;++i)
		{	
			[self addRow:i sectionObject:0];
		}	
		
		
		
	*/
	[ self->tableView reloadData ];
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


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */
#define TABLE_VIEW_TAG			2000

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	activeImageP=[UIImage imageNamed:@"vms_out_Active.png"];
	dileverImageP=[UIImage imageNamed:@"vmail_out_newHigh.png"];
	failedImageP=[UIImage imageNamed:@"vm_icons_outgoing_undelivered.png"];
	vnewImageP=[UIImage imageNamed:@"vm_icons_incoming_new.png"];
	readImageP=[UIImage imageNamed:@"vm_icons_incoming_read.png"];
	//self.tabBarItem = [UITabBarItem alloc];
	//[self.tabBarItem initWithTitle:@"vmail" image:nil tag:2];
	//self->tablesz = 0;
	//////printf("\n table = %d",self->tablesz);
	tableView.delegate = self;
	tableView.dataSource = self;
	self->cellofvmsP  = nil;
	//tableView.tag = TABLE_VIEW_TAG;
	tableView.clearsContextBeforeDrawing = YES;
	[tableView reloadData];
	[self setTitle:@"vmail"];
	nsTimerP = nil;
	uiProgressP = nil;
	uiActionSheetP = nil;
	
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
	[activeImageP release];
	[dileverImageP release];
	[failedImageP release];
	[vnewImageP release];
	[readImageP release];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
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
