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
#import  "AddeditcellController.h"

@implementation ContactDetailsViewController

 

-(void)setObject:(id) object 
{
	self->ownerobject = object;
}

/*
 *   Table Data Source
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
/*	if(section == 0)
		return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"spokn.png"]];
	else
		return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"spokn.png"]];*/
	return nil;
}
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int row = [indexPath row];
	int section = [indexPath section];
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
			[self addRow:section :row sectionObject:&secLocP];
			
		}	
	}	
	else
	{	
		secLocP = cell.spoknSubCellP.userData;
		[secLocP release];
		
		[self addRow:section :row sectionObject:&secLocP];
		//secLocP = [self->cellofvmsP getObjectAtIndex: [ indexPath indexAtPosition: 1 ]];
	}
	if(secLocP==0) return nil;
	cell.spoknSubCellP.userData = secLocP;
	cell.spoknSubCellP.dataArrayP = secLocP->elementP;
	cell.spoknSubCellP.ownerDrawB = true;
	cell.spoknSubCellP.rowHeight = 50;
	if(editableB)
	{
	//	cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;//UITableViewCellAccessoryDetailDisclosureButton; 
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.hidesAccessoryWhenEditing = NO;
	}
	else
	{
		cell.accessoryType = UITableViewCellAccessoryNone;
		//cell.editingAccessoryType = UITableViewCellAccessoryNone;//UITableViewCellAccessoryDetailDisclosureButton; 

	}
	//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	[CellIdentifier release];
	//cell.hidesAccessoryWhenEditing = YES;
	return cell;
	
	
}
-(void)tableView:(UITableView *)ltableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath 
   {
	       // If row is deleted, remove it from the list.
	       if (editingStyle == UITableViewCellEditingStyleDelete) 
		       {
			          // [dataController removeDataAtIndex:indexPath.row-1];
			           [ltableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
										  withRowAnimation:UITableViewRowAnimationFade];
		       }
	       else if(editingStyle == UITableViewCellEditingStyleInsert)
		       {
			         //  [dataController addData:@"New Row Added"];
				   printf("\n add clicked");
			          // [tableView reloadData];        
		       }
   }
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:
(NSIndexPath *)indexPath
  {
	  int row = [indexPath row];
	  int section = [indexPath section];
	  if(editableB)
	  {	
		  if(sectionArray[section].dataforSection[row].addNewB)
		  {
			  return UITableViewCellEditingStyleInsert;
		  }
		  else
		  {
			  return UITableViewCellEditingStyleDelete;
		  }
	  }	

	  return UITableViewCellEditingStyleDelete;
  }
/*
 *   Table Delegate
 */
- (void)addRow: (int)lsection:(int )row sectionObject:(sectionType **)sectionPP;
{
		char *objStrP=0;
	char *secObjStrP = 0;
	
		//int index;
	NSString *stringStrP;
	objStrP = sectionArray[lsection].dataforSection[row].nameofRow;
	secObjStrP = sectionArray[lsection].dataforSection[row].elementP;
	
	{
				
		displayData *dispP;	
		sectionType *secLocP;
		Boolean makeB = false;
		secLocP = [[sectionType alloc] init];
		secLocP->index = row;
		makeB = true;
		
		if(makeB)
		{
			secLocP->userData = 0;
			
									
			dispP = [ [displayData alloc] init];
			dispP.left = 10;
			dispP.top = 5;
			dispP.width = 100;
			if(secObjStrP)
			{	
				if(strlen(secObjStrP)>0)
					dispP.width = 40;
			}
			
			dispP.height = 50;
			
			dispP.colorP = [UIColor blueColor];
			
			
			dispP.fntSz = 16;
			//dispP.fontP =  [self->fontGloP fontWithSize:16];
			//[dispP.fontP retain];
			//[dispP.fontP release];
			stringStrP = [[NSString alloc] initWithUTF8String:objStrP ];
			dispP.dataP = stringStrP;
			[stringStrP release];
			[dispP.colorP release];
			
			[secLocP->elementP addObject:dispP];
			
			if(secObjStrP)
			{	
				dispP = [ [displayData alloc] init];
				dispP.left = 0;
				dispP.top = 0;
				dispP.width = 60;
				
				dispP.height = 100;
				stringStrP = [[NSString alloc] initWithUTF8String:secObjStrP ];
				dispP.dataP = stringStrP;
				[stringStrP release];
				if(sectionArray[lsection].dataforSection[row].selected)
				{	
					dispP.colorP = [UIColor blueColor];
					
				}
				else
				{
					dispP.colorP = [UIColor blackColor];
				}
				dispP.fntSz = 14;
				[dispP.colorP release];
				[secLocP->elementP addObject:dispP];
				
				// [cell setNeedsDisplay];
			}	
			
			
			
			*sectionPP = secLocP;//back the pointer
			
			//[self->cellofcalllogP addObjectAtIndex:secLocP :index];	
			//[self->cellofcalllogP addObjectAtIndex:cell.spoknSubCellP.dataArrayP :index];	
			
			
		}
		
		//[CellIdentifier release];
		
	}
	//return nil;
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
	//selection = [[[UIFont familyNames] objectAtIndex:[newIndexPath row]] retain];
	int row = [newIndexPath row];
	int section = [newIndexPath section];

	if(editableB==false)
	{	
		if(strstr( sectionArray[section].dataforSection[row].elementP,"@")==0)
		{	
			[self->ownerobject makeCall:sectionArray[section].dataforSection[row].elementP];
			[self->ownerobject changeView];
		}	
		else
		{
			[ownerobject vmsRecordStart:sectionArray[section].dataforSection[row].elementP];
		}
	}	
	else
	{
				
		AddeditcellController     *AddeditcellControllerviewP;	
		AddeditcellControllerviewP = [[AddeditcellController alloc]init];
		[AddeditcellControllerviewP setObject:self->ownerobject];
		viewResult = 0;
		[AddeditcellControllerviewP setData:sectionArray[section].dataforSection[row].elementP value:sectionArray[section].dataforSection[row].nameofRow returnValue:&viewResult];
		
		[ [self navigationController] pushViewController:AddeditcellControllerviewP animated: YES ];
		
	}
}




 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		loadedB = false;
	}
    return self;
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
 {
	 
	if(stringSelected[buttonIndex])
	{	
		if(callActionSheetB)
		{
			[self->ownerobject makeCall:stringSelected[buttonIndex]];
			[self->ownerobject changeView];
		 
		}
		else
		{
			// NSLog(nsNumberP);
			//printf("\n%s",callNoP);
			[ownerobject vmsShowRecordScreen:stringSelected[buttonIndex]];
		}
	} 
	[actionSheet release];
 }
/*- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString *nspP;
	NSString *nsNumberP;
	printf("User Pressed Button %d\n", buttonIndex + 1);
		nspP = [actionSheet buttonTitleAtIndex:buttonIndex];
	NSLog(nspP);
	printf("\n");

	NSArray *wordArray = [nspP componentsSeparatedByString:@" "] ;
	int countL;
	countL = [wordArray count];
	if(countL)
	{
		nsNumberP =  [wordArray objectAtIndex:countL -1];
	}
	for (NSString *word in wordArray)
	{
		if ([word length] == 0) continue;
		
		// determine which letter starts the name
		callActionSheetB
	}
	
	if(countL>1)
	{	
		char *callNoP;
		callNoP = (char*)[nsNumberP  cStringUsingEncoding:1];

		if(callActionSheetB)
		{
			[self->ownerobject makeCall:callNoP];
			[self->ownerobject changeView];

		}
		else
		{
			NSLog(nsNumberP);
			//printf("\n%s",callNoP);
			[ownerobject vmsShowRecordScreen:callNoP];
		}
	}
		//NSLog(nsNumberP);
	[actionSheet release];
}*/
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
//	printf("User Pressed Button %d\n", buttonIndex + 1);
	[actionSheet release];
}

- (void) presentSheet:(bool)callB
{
	UIActionSheet *uiActionSheetP;
	callActionSheetB = callB;
	int i=0;
	if(callB)
	{	
		uiActionSheetP= [[UIActionSheet alloc] 
					 initWithTitle: @"Select a number to call" 
					 delegate:self
					 cancelButtonTitle:nil 
					 destructiveButtonTitle:nil
					 otherButtonTitles:nil, nil];
		if(strlen(addressDataP->home)>0)
		{	
			[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%-8s %-15s", "Home",addressDataP->home] ];
			stringSelected[i++] = addressDataP->home;
		}
		if(strlen(addressDataP->business)>0)
		{	
			[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%-8s %-15s","Business" ,addressDataP->business] ];
			stringSelected[i++] = addressDataP->business;
		}	
		if(strlen(addressDataP->mobile)>0)
		{	
			[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%-8s %-15s","Mobile", addressDataP->mobile] ];
			stringSelected[i++] = addressDataP->business;
		}	

		
		if(strlen(addressDataP->spoknid)>0)
		{		
			[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%-8s %-15s", "Spokn",addressDataP->spoknid] ];
			stringSelected[i++] = addressDataP->spoknid;
		}	

		
		if(strlen(addressDataP->other)>0)
		{	
			[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%-8s %-15s","Other", addressDataP->other] ];
		
			stringSelected[i++] = addressDataP->other;
		}	
	
			
	}
	else
	{
		uiActionSheetP= [[UIActionSheet alloc] 
						 initWithTitle: @"Select a number to vms" 
						 delegate:self
						 cancelButtonTitle:nil 
						 destructiveButtonTitle:nil
						 otherButtonTitles:nil, nil];
		if(strlen(addressDataP->home)>0)
		{	
			[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%-8s %-15s", "Home",addressDataP->home] ];
			stringSelected[i++] = addressDataP->home;
		}
		if(strlen(addressDataP->business)>0)
		{	
			[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%-8s %-15s","Business" ,addressDataP->business] ];
			stringSelected[i++] = addressDataP->business;
		}	
		if(strlen(addressDataP->mobile)>0)
		{	
			[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%-8s %-15s","Mobile", addressDataP->mobile] ];
			stringSelected[i++] = addressDataP->business;
		}	
		
		
		if(strlen(addressDataP->spoknid)>0)
		{		
			[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%-8s %-15s", "Spokn",addressDataP->spoknid] ];
			stringSelected[i++] = addressDataP->spoknid;
		}	
		
		
		if(strlen(addressDataP->other)>0)
		{	
			[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%-8s %-15s","Other", addressDataP->other] ];
			
			stringSelected[i++] = addressDataP->other;
		}			
		
		if(strlen(addressDataP->email)>0)
		{	
			[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%-8s -%-15s","Email", addressDataP->email] ];
		
			stringSelected[i++] = addressDataP->email;
		}	

			
		
	}
	[uiActionSheetP addButtonWithTitle:@"Cancel"];
	stringSelected[i++] = 0;
	uiActionSheetP.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[uiActionSheetP showInView:[ownerobject tabBarController].view];
	
}


-(IBAction)callPressed:(id)sender
{
	[self presentSheet:true];
}
-(IBAction)vmsPressed:(id)sender
{
	[self presentSheet:false];
}
-(IBAction)deletePressed:(id)sender
{
	
}
-(IBAction)changeNamePressed:(id)sender
{

}
-(IBAction)doneClicked
{
	/*struct AddressBook *addressDataTmpP;
	self.navigationItem.rightBarButtonItem 
	= [ [ [ UIBarButtonItem alloc ]
		 initWithBarButtonSystemItem: UIBarButtonSystemItemEdit
		 target: self
		 action: @selector(editClicked) ] autorelease ];	
	addressDataTmpP = addressDataP;
	addressDataP = 0;
	[self setAddressBook:addressDataTmpP editable:false :viewEnum];
	free(addressDataTmpP);
	 */
	struct AddressBook *addrP ;
	if(updatecontact)
	{	
		if(viewEnum==CONTACTADDVIEWENUM)
		{	
			if(  strlen(addressDataP->title)&&(  strlen(addressDataP->mobile) ||  strlen(addressDataP->business)|| strlen(addressDataP->home)||  strlen(addressDataP->email) ) )
				
				
				{										 
					addContact(addressDataP->title,addressDataP->mobile,addressDataP->home,addressDataP->business,0,addressDataP->email,addressDataP->spoknid);
					
				}
				else
				{	
					UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"Error" 
																	   message: [ NSString stringWithString:@"invalid contact" ]
																	  delegate: nil
															 cancelButtonTitle: nil
															 otherButtonTitles: @"OK", nil
										  ];
					[ alert show ];
					[alert release];
					
				}	
		}
		else
		{
			addrP = getContact(addressDataP->id);			
			if(addrP)
			{
				strcpy(addrP->title,addressDataP->title);
				strcpy(addrP->mobile,addressDataP->mobile);
				strcpy(addrP->business,addressDataP->business);
				strcpy(addrP->home,addressDataP->home);
				strcpy(addrP->email,addressDataP->email);
				addrP->dirty = true;
			
			}
		}
	//[ [self navigationController] popToRootViewControllerAnimated:YES ];
	//contactID = -1;
	//profileResync();
		profileResync();
	}
	
	[ [self navigationController] popToRootViewControllerAnimated:YES ];
	//contactID = -1;
		
	
	
}
-(IBAction)deleteClicked
{
	/*struct AddressBook *addressDataTmpP;
	 self.navigationItem.rightBarButtonItem 
	 = [ [ [ UIBarButtonItem alloc ]
	 initWithBarButtonSystemItem: UIBarButtonSystemItemEdit
	 target: self
	 action: @selector(editClicked) ] autorelease ];	
	 addressDataTmpP = addressDataP;
	 addressDataP = 0;
	 [self setAddressBook:addressDataTmpP editable:false :viewEnum];
	 free(addressDataTmpP);
	 */
	[ [self navigationController] popToRootViewControllerAnimated:YES ];
	//contactID = -1;
	profileResync();
	
	
}
-(IBAction)editClicked
{
	/*AddEditcontactViewController     *addeditviewP;	
	addeditviewP = [[AddEditcontactViewController alloc] initWithNibName:@"addeditcontact" bundle:[NSBundle mainBundle]];
	
	[ [self navigationController] pushViewController:addeditviewP animated: YES ];
	[addeditviewP  setContactDetail:self->addressDataP];
	[addeditviewP setObject:self->ownerobject];
	//NSLog(@"retainCount:%d", [addeditviewP retainCount]);
	if([addeditviewP retainCount]>1)
		[addeditviewP release];*/
	struct AddressBook *addressDataTmpP;

	self.navigationItem.rightBarButtonItem 
	= [ [ [ UIBarButtonItem alloc ]
		 initWithBarButtonSystemItem: UIBarButtonSystemItemDone
		 target: self
		 action: @selector(doneClicked) ] autorelease ];	
	addressDataTmpP = addressDataP;
	addressDataP = 0;
	[self setAddressBook:addressDataTmpP editable:true :viewEnum];
	free(addressDataTmpP);
	
	
	
}
#define TABLE_VIEW_TAG			2000
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if(viewResult)
	{
		updatecontact = 1;
		viewResult = 0;
		printf("\n make changes");
		struct AddressBook *addressDataTmpP;
		
		
		addressDataTmpP = addressDataP;
		addressDataP = 0;
		[self setAddressBook:addressDataTmpP editable:self->editableB :viewEnum];
		free(addressDataTmpP);
		
		[ self->tableView reloadData ];
	}
}	
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	// release view
	printf("\n hello view disapper");
	if(updatecontact)
	{
		printf("\n hello view disapper");
	
	}

}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.tabBarItem = [UITabBarItem alloc];
	//[self.tabBarItem initWithTitle:@"ContactDetailsViewController" image:nil tag:3];
	//self->tablesz = 0;
	//printf("\n table = %d",self->tablesz);
	updatecontact = 0;
	tableView.delegate = self;
	tableView.dataSource = self;
	loadedB = true;
	//tableView.tag = TABLE_VIEW_TAG;
	if(self.navigationItem.rightBarButtonItem==nil)
	{	
		if(viewEnum==CONTACTDETAILVIEWENUM)
		{	
			self.navigationItem.rightBarButtonItem 
			= [ [ [ UIBarButtonItem alloc ]
				 initWithBarButtonSystemItem: UIBarButtonSystemItemEdit
				 target: self
				 action: @selector(editClicked) ] autorelease ];	
		}
		else
		{	
			if(viewEnum==CALLLOGDETAILVIEWENUM)
			{	
				self.navigationItem.rightBarButtonItem 
				= [ [ [ UIBarButtonItem alloc ] initWithTitle:@"Delete" style:UIBarButtonItemStyleDone target:self action:@selector(deleteClicked)] autorelease];
		
			}
			else
			{
				self.navigationItem.rightBarButtonItem 
				= [ [ [ UIBarButtonItem alloc ]
					 initWithBarButtonSystemItem: UIBarButtonSystemItemDone
					 target: self
					 action: @selector(doneClicked) ] autorelease ];	
			}	
		}	
		
		
	}	
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	viewP.backgroundColor = [UIColor groupTableViewBackgroundColor];
	if(viewEnum==CONTACTADDVIEWENUM)
	{
		viewP.hidden = YES;
		tableView.tableFooterView = viewP;

	}
	else
	{
		tableView.tableFooterView = viewP;

	}
	NSString *nsp;
	nsp = [[NSString alloc] initWithUTF8String:(const char*)addressDataP->title ];
	[userNameP setText:nsp];
	[nsp release];
	//[userNameP release];
	[self setTitle:@"Info"];
	sectionCount = 1;
	printf("\n secion  %d",sectionCount);
	if(editableB)
	{	
		[ self->tableView setEditing: YES animated: YES ];
		self->tableView.allowsSelectionDuringEditing = YES;
		self->delButtonP.hidden = NO;
		self->vmsButtonP.hidden = YES;
		self->callButtonP.hidden = YES;
		changeNameButtonP.hidden = NO;
		if([[userNameP text] length]==0)
		{
			[userNameP setTextColor:[UIColor grayColor]];
			[userNameP setText:@"First Last"];
		}
		else
		{
			[userNameP setTextColor:[UIColor blackColor]];
		}
		userNameP.hidden = YES;
		//	[changeNameButtonP addSubview:userNameP];
		//[userNameP release];
		//setTitle:(NSString *)title forState:(UIControlState)state
		[changeNameButtonP setTitle:userNameP.text forState:UIControlStateNormal];
		tableView.tableHeaderView = changeNameButtonP;
		
	}	
	else
	{
		self->delButtonP.hidden = YES;
		self->vmsButtonP.hidden = NO;
		self->callButtonP.hidden = NO;
		changeNameButtonP.hidden = YES;
		tableView.tableHeaderView = userNameP;
		
	}
	
	//[tableView reloadData];

}
// Add a title for each section 

- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section 
{ 
	return nil;
} 
/*
 - (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView 
 { 
 return ALPHA_ARRAY; 
 
 } 
 */

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

	if(sectionCount)
	return  sectionCount;
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return sectionArray[section].count;
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
-(void)setCdr:(struct CDR *)lcdrP
{
	if(self->cdrP)
	{
		free(self->cdrP);
	}
	self->cdrP = 0;
	if(lcdrP)
	{	
		self->cdrP = (struct CDR *)malloc(sizeof(struct CDR )+4);
		*self->cdrP=*lcdrP;
	}	
}
-(void)setAddressBook:( struct AddressBook *)laddressDataP editable:(Boolean)leditableB :(ViewTypeEnum) lviewEnum
{
	NSString *nsp;
	if(addressDataP)
	{	
		free(addressDataP);
		addressDataP = 0;
	}	
	self->viewEnum = lviewEnum;
	self->editableB = leditableB;
	self->tablesz = 0;
	addressDataP = 0;
	
	for(int i=0;i<MAX_SECTION;++i)
	{
		memset(&sectionArray[i],0,sizeof(SectionContactType));
	}
	sectionCount = 1;
	addressDataP = malloc(sizeof(struct AddressBook)+4);//extra 4 for padding
	memset(addressDataP,0,sizeof(struct AddressBook));
	if(laddressDataP)
	{
		*addressDataP=*laddressDataP;
	
	}
	if(strlen(addressDataP->home)>0)
	{
		if(self->cdrP)
			if(!strcmp(self->cdrP->userid,addressDataP->home ))
			{
				sectionArray[0].dataforSection[tablesz].selected = 1;
			}
		//element[tablesz++] = addressDataP->home;
		sectionArray[0].dataforSection[tablesz].section = 0;
		strcpy(sectionArray[0].dataforSection[tablesz].nameofRow,"Home");
		sectionArray[0].dataforSection[tablesz].elementP = addressDataP->home;
		sectionArray[0].count++;
		tablesz++;
	}
	else
	{
		if(leditableB)
		{
			sectionArray[0].dataforSection[tablesz].section = 0;
			strcpy(sectionArray[0].dataforSection[tablesz].nameofRow,"Add home number");
			sectionArray[0].dataforSection[tablesz].elementP = addressDataP->home;
			sectionArray[0].count++;
			sectionArray[0].dataforSection[tablesz].addNewB = true;
			tablesz++;
				
				
		}
	}
	if(strlen(addressDataP->business)>0)
	{
		if(self->cdrP)
			if(!strcmp(self->cdrP->userid,addressDataP->business ))
			{
				sectionArray[0].dataforSection[tablesz].selected = 1;
			}
		//element[tablesz++] = addressDataP->business;
		sectionArray[0].dataforSection[tablesz].section = 0;
		strcpy(sectionArray[0].dataforSection[tablesz].nameofRow,"Business");
		sectionArray[0].dataforSection[tablesz].elementP = addressDataP->business;
		sectionArray[0].count++;
		tablesz++;
		
	}
	else
	{
		if(leditableB)
		{
			sectionArray[0].dataforSection[tablesz].section = 0;
			strcpy(sectionArray[0].dataforSection[tablesz].nameofRow,"Add business number");
			sectionArray[0].dataforSection[tablesz].elementP = addressDataP->business;
			sectionArray[0].count++;
			sectionArray[0].dataforSection[tablesz].addNewB = true;
				tablesz++;
			
		}
	}
	if(strlen(addressDataP->mobile)>0)
	{
		if(self->cdrP)
			if(!strcmp(self->cdrP->userid,addressDataP->mobile ))
			{
				sectionArray[0].dataforSection[tablesz].selected = 1;
			}
		//element[tablesz++] = addressDataP->mobile;
		sectionArray[0].dataforSection[tablesz].section = 0;
		strcpy(sectionArray[0].dataforSection[tablesz].nameofRow,"Mobile");
		sectionArray[0].dataforSection[tablesz].elementP = addressDataP->mobile;
		sectionArray[0].count++;
		
		tablesz++;
	}
	else
	{
		if(leditableB)
		{
			sectionArray[0].dataforSection[tablesz].section = 0;
			strcpy(sectionArray[0].dataforSection[tablesz].nameofRow,"Add mobile number");
			sectionArray[0].dataforSection[tablesz].elementP = addressDataP->mobile;
			sectionArray[0].count++;
			sectionArray[0].dataforSection[tablesz].addNewB = true;
				tablesz++;
			
		}
	}
	
	if(strlen(addressDataP->other)>0)
	{
		if(self->cdrP)
			if(!strcmp(self->cdrP->userid,addressDataP->other ))
			{
				sectionArray[0].dataforSection[tablesz].selected = 1;
			}
		//element[tablesz++] = addressDataP->other;
		sectionArray[0].dataforSection[tablesz].section = 0;
		strcpy(sectionArray[0].dataforSection[tablesz].nameofRow,"Other");
		sectionArray[0].dataforSection[tablesz].elementP = addressDataP->other;
		sectionArray[0].count++;
		tablesz++;
	}
	else
	{
		if(leditableB)
		{
			sectionArray[0].dataforSection[tablesz].section = 0;
			strcpy(sectionArray[0].dataforSection[tablesz].nameofRow,"Add new number");
			sectionArray[0].dataforSection[tablesz].elementP = addressDataP->other;
			sectionArray[0].count++;
			sectionArray[0].dataforSection[tablesz].addNewB = true;
			tablesz++;
		
		}
	}
	if(strlen(addressDataP->spoknid)>0)
	{
		//element[tablesz++] = addressDataP->spoknid;
		if(self->cdrP)
		if(!strcmp(self->cdrP->userid,addressDataP->spoknid ))
		{
			sectionArray[0].dataforSection[tablesz].selected = 1;
		}
		sectionArray[0].dataforSection[tablesz].section = 0;
		strcpy(sectionArray[0].dataforSection[tablesz].nameofRow,"Spokn ID");
		sectionArray[0].dataforSection[tablesz].elementP = addressDataP->spoknid;
		sectionArray[0].count++;
		tablesz++;
		
	}
	else
	{
		if(leditableB)
		{
			sectionArray[0].dataforSection[tablesz].section = 0;
			strcpy(sectionArray[0].dataforSection[tablesz].nameofRow,"Add Spokn ID");
			sectionArray[0].dataforSection[tablesz].elementP = addressDataP->spoknid;
			sectionArray[0].count++;
			sectionArray[0].dataforSection[tablesz].addNewB = true;
			tablesz++;
			
		}
	}
	if(strlen(addressDataP->email)>0)
	{
		//element[tablesz++] = addressDataP->email;
		sectionArray[1].dataforSection[0].section = 0;
		strcpy(sectionArray[1].dataforSection[0].nameofRow,"Email");
		sectionArray[1].dataforSection[0].elementP = addressDataP->email;
		sectionArray[1].count++;
		//tablesz++;
		sectionCount = 2;
		
	}
	else
	{
		if(leditableB)
		{
			sectionArray[1].dataforSection[0].section = 0;
			strcpy(sectionArray[1].dataforSection[0].nameofRow,"Add email");
			sectionArray[1].dataforSection[0].elementP = addressDataP->email;
			sectionArray[1].count++;
			sectionArray[1].dataforSection[0].addNewB = true;
				
			sectionCount = 2;
			
		}
	}
	
	
	
		
	
	if(loadedB)
	{
		nsp = [[NSString alloc] initWithUTF8String:(const char*)addressDataP->title ];
		[userNameP setText:nsp];
		[nsp release];
		if(tablesz)
		{
				
			
			if(editableB)
			{	
				[ self->tableView setEditing: YES animated: YES ];
				self->tableView.allowsSelectionDuringEditing = YES;
				self->delButtonP.hidden = NO;
				self->vmsButtonP.hidden = YES;
				self->callButtonP.hidden = YES;
				changeNameButtonP.hidden = NO;
				if([[userNameP text] length]==0)
				{
				//	[userNameP setTextColor:[UIColor grayColor]];
					[userNameP setText:@"First Last"];
				}
				else
				{
					//[userNameP setTextColor:[UIColor blackColor]];
				}
				userNameP.hidden = YES;
			//	[changeNameButtonP addSubview:userNameP];
				//[userNameP release];
				//setTitle:(NSString *)title forState:(UIControlState)state
				[changeNameButtonP setTitle:userNameP.text forState:UIControlStateNormal];
				tableView.tableHeaderView = changeNameButtonP;
						
			}	
			else
			{
				self->delButtonP.hidden = YES;
				self->vmsButtonP.hidden = NO;
				self->callButtonP.hidden = NO;
				changeNameButtonP.hidden = YES;
				tableView.tableHeaderView = userNameP;
							
			}
			if(tableView)
			{	
				//printf("\n%d",tablesz);
				[tableView reloadData];
			}	
						
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
	loadedB = false;
	printf("\n dealloc called");
	if(addressDataP)
		free(addressDataP);
	addressDataP = 0;
}


- (void)dealloc {
	
	if(self->cdrP)
	{
		free(self->cdrP);
	}
	self->cdrP = 0;
	printf("\n dealloc");
	if(addressDataP)
		free(addressDataP);
	addressDataP = 0;
	
	 [super dealloc];
}


@end
