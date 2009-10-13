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
	printf("\n %s %s",objStrP,secObjStrP);
	
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


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		loadedB = false;
		sectionCount = 1;
		[self setTitle:@"Info"];
		msgLabelP = 0;
		// white button:
			
		
	}
    return self;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation
{
	
//	printf("\n%d",buttonIndex);
	if(buttonIndex==0)
	{	
		if(retValP)
		{	
			*retValP = 1;
		}
	
		[ [self navigationController] popToRootViewControllerAnimated:YES ];
	}
	
	//[alertView release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
 {
	 
	if(stringSelected[buttonIndex])
	{	
		if(callActionSheetB)
		{
			printf("\nname %s\n",stringSelected[buttonIndex]);
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
			stringSelected[i++] = addressDataP->mobile;
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
			stringSelected[i++] = addressDataP->mobile;
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
			[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%-8s %-15s","Email", addressDataP->email] ];
		
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
	
	UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
													   message: [ NSString stringWithString:@"Are you sure you want to delete contact?" ]
													  delegate: self
											 cancelButtonTitle: nil
											 otherButtonTitles: @"OK", nil
						  ];
	[alert addButtonWithTitle:@"Cancel"];
	[ alert show ];
	[alert release];
	

	
}
-(IBAction)changeNamePressed:(id)sender
{
	AddeditcellController     *AddeditcellControllerviewP;	
	AddeditcellControllerviewP = [[AddeditcellController alloc]init];
	[AddeditcellControllerviewP setObject:self->ownerobject];
	viewResult = 0;
	
	[AddeditcellControllerviewP SetkeyBoardType:UIKeyboardTypeNamePhonePad :CONTACT_RANGE buttonType:0];
	

	[AddeditcellControllerviewP setData:addressDataP->title value:"Name of person" placeHolder:"First Last" returnValue:&viewResult];
	[ [self navigationController] pushViewController:AddeditcellControllerviewP animated: YES ];
	
	[AddeditcellControllerviewP release];
	
}
-(IBAction)cancelClicked
{
	NSLog(@"Cancel");
	
	
	[[self navigationController]  popViewControllerAnimated:YES];
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
	Boolean popupB = true;
	if(updatecontact)
	{	
		printf("\n udate contact");
		if(viewEnum==CONTACTADDVIEWENUM)
		{	
			if(  strlen(addressDataP->title)&&(  strlen(addressDataP->mobile) ||  strlen(addressDataP->business)|| strlen(addressDataP->home)||  strlen(addressDataP->email) ) )
				
				
				{		printf("\n add contact");									 
					addContact(addressDataP->title,addressDataP->mobile,addressDataP->home,addressDataP->business,0,addressDataP->email,addressDataP->spoknid);
					
				}
				else
				{	
						printf("\n alert contact");
					UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"Error" 
																	   message: [ NSString stringWithString:@"invalid contact" ]
																	  delegate: self
															 cancelButtonTitle: nil
															 otherButtonTitles: @"OK", nil
										  ];
					[ alert show ];
					[alert release];
					popupB = false;
					
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
		if(popupB)
		profileResync();
	}
	if(popupB)
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
		UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
													   message: [ NSString stringWithString:@"Are you sure you want to delete calllog?" ]
													  delegate: self
											 cancelButtonTitle: nil
											 otherButtonTitles: @"OK", nil
						  ];
	[alert addButtonWithTitle:@"Cancel"];
	[ alert show ];
	[alert release];
	
	//[ [self navigationController] popToRootViewControllerAnimated:YES ];
	//contactID = -1;
	//profileResync();
	
	
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
		//printf("\n erroer  ");
		[ self->tableView reloadData ];
	}
	NSIndexPath *nsP;
	nsP = [self->tableView indexPathForSelectedRow];
	if(nsP)
	{
		[self->tableView deselectRowAtIndexPath : nsP animated:NO];
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
	UIImage *buttonBackground = [UIImage imageNamed:@"bottombargreen.png"];
	UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"blueButton.png"];
	[CustomButton setImages:callButtonP image:buttonBackground imagePressed:buttonBackgroundPressed];
	[buttonBackground release];
	[buttonBackgroundPressed release];
	buttonBackground = [UIImage imageNamed:@"bottombarred_pressed.png"];
	buttonBackgroundPressed = [UIImage imageNamed:@"blueButton.png"];
	[CustomButton setImages:delButtonP image:buttonBackground imagePressed:buttonBackgroundPressed];
	
	//tableView.tag = TABLE_VIEW_TAG;
	if(self.navigationItem.rightBarButtonItem==nil)
	{	
		if(viewEnum==CONTACTDETAILVIEWENUM)
		{	
			if(editableB==false)
			{	
				self.navigationItem.rightBarButtonItem 
				= [ [ [ UIBarButtonItem alloc ]
				 initWithBarButtonSystemItem: UIBarButtonSystemItemEdit
				 target: self
				 action: @selector(editClicked) ] autorelease ];	
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
		else
		{	
			if(viewEnum==CALLLOGDETAILVIEWENUM)
			{	
				self.navigationItem.rightBarButtonItem 
				= [ [ [ UIBarButtonItem alloc ] initWithTitle:@"Delete" style:UIBarButtonItemStyleDone target:self action:@selector(deleteClicked)] autorelease];
				struct tm tmP1,*tmP=0;
				time_t timeP;
				char *month[12]={"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
				
				//char *month[12]={"January","February","March","April","May","June","July","August","September","October","November","December"};
				
			
				CGRect LabelFrame2 = CGRectMake(0, 5, 320, 40);
				msgLabelP = [[UILabel alloc] initWithFrame:LabelFrame2];
				msgLabelP.textAlignment = UITextAlignmentLeft;
				msgLabelP.tag = 1;
				msgLabelP.numberOfLines = 2;
				msgLabelP.backgroundColor = [UIColor groupTableViewBackgroundColor];
				//viewP.backgroundColor = [UIColor groupTableViewBackgroundColor];
				
				
				//[msgLabelP release];
				
				char s1[200];
				if(cdrP)
				{	
					timeP = cdrP->date;
					tmP = localtime(&timeP);
					tmP1 = *tmP;
					
					if(tmP1.tm_hour<12)
					{	
						sprintf(s1,"%02d:%02d AM on  %02d %3s %d",(tmP1.tm_hour)?tmP1.tm_hour:12,tmP1.tm_min,tmP1.tm_mday,month[tmP1.tm_mon],tmP1.tm_year+1900);
					}
					else
					{	
						sprintf(s1,"%02d:%02d PM on  %02d %3s %d",(tmP1.tm_hour-12)?(tmP1.tm_hour-12):12,tmP1.tm_min,tmP1.tm_mday,month[tmP1.tm_mon],tmP1.tm_year+1900);
					}
					if(cdrP->direction&CALLTYPE_IN)
					{	
						if(cdrP->direction&CALLTYPE_MISSED)
						{	
							[msgLabelP setText:[NSString stringWithFormat:@"Incoming call\n%s", s1]];
						}	
						else
						{
							[msgLabelP setText:[NSString stringWithFormat:@"Incoming call\n%s", s1]];
						}
					}
					else
					{
						[msgLabelP setText:[NSString stringWithFormat:@"Outgoing call\n%s", s1]];
					}
					
				}	
				
			}
			else
			{
				self.navigationItem.rightBarButtonItem 
				= [ [ [ UIBarButtonItem alloc ]
					 initWithBarButtonSystemItem: UIBarButtonSystemItemDone
					 target: self
					 action: @selector(doneClicked) ] autorelease ];
				if(viewEnum!=CONTACTFORWARDVMS)
				{	
					self.navigationItem.leftBarButtonItem = [ [ [ UIBarButtonItem alloc ]
														   initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
														   target: self
														   action: @selector(cancelClicked) ] autorelease ];	
				}	
			}	
		}	
		
		
	}	
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	viewP.backgroundColor = [UIColor groupTableViewBackgroundColor];
	if(viewEnum==CONTACTADDVIEWENUM || viewEnum == CONTACTFORWARDVMS)
	{
		viewP.hidden = YES;
		printf("\n viewEnum");
		tableView.tableFooterView = viewP;
		[viewP release];
		if(viewEnum == CONTACTFORWARDVMS)
		{
			[self setTitle:@"Select number for vms"];
		}

	}
	else
	{
		tableView.tableFooterView = viewP;
		[viewP release];
		

	}
	struct AddressBook *addressDataTmpP;
	
	
	addressDataTmpP = addressDataP;
	addressDataP = 0;
	printf("\n edit %d",self->editableB);
	[self setAddressBook:addressDataTmpP editable:self->editableB :viewEnum];
	free(addressDataTmpP);
	
	[ self->tableView reloadData ];
	
	/*
	NSString *nsp;
	nsp = [[NSString alloc] initWithUTF8String:(const char*)addressDataP->title ];
	[userNameP setText:nsp];
	[nsp release];
	//[userNameP release];
	[self setTitle:@"Info"];
	
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
*/	
	//[tableView reloadData];

}
// Add a title for each section 


#pragma mark Table view methods

/*
 *   Table Data Source
 */

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
	
	int row = [indexPath row];
	int section = [indexPath section];
	
	// If row is deleted, remove it from the list.
	if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
		sectionArray[section].count--;
		if(sectionArray[section].dataforSection[row].elementP)
		{
			strcpy(sectionArray[section].dataforSection[row].elementP,"\0");//mean row is deleted
			updatecontact = 1;
		}
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
	
	return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
	//selection = [[[UIFont familyNames] objectAtIndex:[newIndexPath row]] retain];
	int row = [newIndexPath row];
	int section = [newIndexPath section];
	
	if(editableB==false)
	{	
		if(viewEnum == CONTACTFORWARDVMS)
		{
			if(retValP)
			{
				*retValP = 1;
				strcpy(numberCharP,sectionArray[section].dataforSection[row].elementP);
				if(self->rootObjectP)
				{
					[[self navigationController]  popToViewController:self->rootObjectP animated:NO];
				}
			}
			return;
		}
		if(strstr( sectionArray[section].dataforSection[row].elementP,"@")==0)
		{	
			[self->ownerobject makeCall:sectionArray[section].dataforSection[row].elementP];
			[self->ownerobject changeView];
		}	
		else
		{
			[ownerobject vmsShowRecordScreen:sectionArray[section].dataforSection[row].elementP];
		}
	}	
	else
	{
		
		AddeditcellController     *AddeditcellControllerviewP;	
		AddeditcellControllerviewP = [[AddeditcellController alloc]init];
		[AddeditcellControllerviewP setObject:self->ownerobject];
		viewResult = 0;
		if(section==1)
		{
			[AddeditcellControllerviewP SetkeyBoardType:UIKeyboardTypeEmailAddress :EMAIL_RANGE buttonType:0];
		}
		else
		{
			if(sectionArray[section].dataforSection[row].elementP == addressDataP->spoknid)
			{
				[AddeditcellControllerviewP SetkeyBoardType:UIKeyboardTypePhonePad :SPOKN_ID_RANGE buttonType:0];
			}
			
		}
		[AddeditcellControllerviewP setData:sectionArray[section].dataforSection[row].elementP value:sectionArray[section].dataforSection[row].nameofRow placeHolder:sectionArray[section].dataforSection[row].nameofRow returnValue:&viewResult];
		
		[ [self navigationController] pushViewController:AddeditcellControllerviewP animated: YES ];
		[AddeditcellControllerviewP release];
		
	}
}




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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

	printf("\n %d",sectionCount);
	if(sectionCount)
	return  sectionCount;
	return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return sectionArray[section].sectionheight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	/*	if(section == 0)
	 return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"spokn.png"]];
	 else
	 return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"spokn.png"]];*/
	return sectionArray[section].sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	printf("\n%d",sectionArray[section].count);
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
	printf("\n %d",self->editableB);
	self->tablesz = 0;
	addressDataP = 0;
	
	for(int i=0;i<MAX_SECTION;++i)
	{
		memset(&sectionArray[i],0,sizeof(SectionContactType));
	}
	
	sectionArray[0].sectionView = msgLabelP;
	sectionArray[0].sectionheight = 50;

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
	if(tablesz==0)
	{
		sectionCount = 0;
		
	}
	if(strlen(addressDataP->email)>0)
	{
		//element[tablesz++] = addressDataP->email;
		sectionArray[sectionCount].dataforSection[0].section = 0;
		strcpy(sectionArray[sectionCount].dataforSection[0].nameofRow,"Email");
		sectionArray[sectionCount].dataforSection[0].elementP = addressDataP->email;
		sectionArray[sectionCount].count++;
		//tablesz++;
		if(sectionCount)	
			sectionCount = 2;
		else
			sectionCount = 1;
		
	}
	else
	{
		if(leditableB)
		{
			printf("\n email ");
			sectionArray[sectionCount].dataforSection[0].section = 0;
			strcpy(sectionArray[sectionCount].dataforSection[0].nameofRow,"Add email");
			sectionArray[sectionCount].dataforSection[0].elementP = addressDataP->email;
			sectionArray[sectionCount].count++;
			sectionArray[sectionCount].dataforSection[0].addNewB = true;
			if(sectionCount)	
				sectionCount = 2;
			else
				sectionCount = 1;
			
		}
	}
	if(sectionCount==0)
	{
		editableB = true;
	}
	else
	{
		if(tablesz==0) //need to display table
			tablesz = 1;
	}
	
	
		
	
	if(loadedB)
	{
		printf("\n  up to");
		nsp = [[NSString alloc] initWithUTF8String:(const char*)addressDataP->title ];
		NSLog(@"%@",nsp);
		
		[userNameP setText:nsp];
		[nsp release];
		printf("\n noerror up to");
		if(tablesz)
		{
				
			
			if(editableB)
			{	
				printf("\n edit clocked");
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
				//[changeNameButtonP release];
				
				
				self.navigationItem.leftBarButtonItem = [ [ [ UIBarButtonItem alloc ]
														   initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
														   target: self
														   action: @selector(cancelClicked) ] autorelease ];	
						
			}	
			else
			{
				self->delButtonP.hidden = YES;
				self->vmsButtonP.hidden = NO;
				self->callButtonP.hidden = NO;
				changeNameButtonP.hidden = YES;
				tableView.tableHeaderView = userNameP;
			//	[userNameP release];
				if(CONTACTPHONEDETAIL==viewEnum)
				{
					self.navigationItem.rightBarButtonItem = nil;
				}
				if(CONTACTFORWARDVMS == viewEnum)
				{
					self.navigationItem.rightBarButtonItem = nil;

				}
							
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
	
	[changeNameButtonP release];
	[userNameP release];
	[msgLabelP release];
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

-(void)setReturnValue:(int*)lretValP selectedContact:(char*)lnumberCharP rootObject:(id)lrootObjectP
{
	retValP = lretValP;
	numberCharP = lnumberCharP;
	rootObjectP = lrootObjectP;
	
}
@end
