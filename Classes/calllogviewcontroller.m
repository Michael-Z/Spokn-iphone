
//  Created on 03/08/09.

/**
 Copyright 2009,2010 Geodesic, <http://www.geodesic.com/>
 
 Spokn SIP-VoIP for iPhone and iPod Touch.
 
 This file is part of Spokn iphone.
 
 Spokn iphone is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 Spokn iphone is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Spokn iphone.  If not, see <http://www.gnu.org/licenses/>.
 */
#import "CalllogViewController.h"

#import "LtpInterface.h"
#import "SpoknAppDelegate.h"
#include "contactviewcontroller.h"
#import "contactDetailsviewcontroller.h"
#import "AddEditcontactViewController.h"
#import "customcell.h"
#include "alertmessages.h"

@implementation CalllogViewController
#pragma mark MISSEDCALL
-(int)missCallSetCount
{
	char s1[50];
	NSString *stringStrP;
	long countMiss;
	countMiss = incriseMissCallCount();
	sprintf(s1,"%ld",countMiss);
	stringStrP = [[NSString alloc] initWithUTF8String:s1 ];
	[self navigationController].tabBarItem.badgeValue= stringStrP;
	
	[stringStrP release];
	return countMiss;
}
-(int)setMissCallCount
{

	char s1[50];
	NSString *stringStrP;
	long missCount = getMissCount();
	
	if(missCount)
	{	
		sprintf(s1,"%ld",missCount);
		stringStrP = [[NSString alloc] initWithUTF8String:s1 ];
		[self navigationController].tabBarItem.badgeValue= stringStrP;
	
		[stringStrP release];
	}
	else {
		[self navigationController].tabBarItem.badgeValue= nil;

	}

	return missCount;
	
	
	
	
}
-(int)resetMissCallCount
{
	
	
	
	if(resetMissCallCount()==0)
	{
	
		[self navigationController].tabBarItem.badgeValue= nil;
		return 0;
	}
	return 1;
}
-(void) hideLeftbutton:(Boolean) lhideB
{
	hideB = lhideB;
}
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		[self.tabBarItem initWithTabBarSystemItem:UITabBarSystemItemRecents tag:2];
		hideB = false;
    }
    return self;
}

- (void)controlPressed:(id) sender {
	int index = segmentedControl.selectedSegmentIndex;
	switch(index)
	{
		case 0:
				showMisscallInt = GETCALLLOGLIST;
			
			break;
		case  2:
		{
			showMisscallInt = GETCALLLOGMISSEDLIST;
			
		}
			break;
			
	}
	[ self->tableView reloadData ];
}

-(void)setObject:(id) object 
{
	self->ownerobject = object;
	
}

/*
 *   Table Data Source
 */

#pragma mark Table view methods
-(void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	SpoknUITableViewCell *cell = (SpoknUITableViewCell*)[ self->tableView cellForRowAtIndexPath: indexPath ];
	[cell tablecellsetEdit:YES :1];
}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	SpoknUITableViewCell *cell = (SpoknUITableViewCell*)[ self->tableView cellForRowAtIndexPath: indexPath ];
	[cell tablecellsetEdit:NO :1];
	
	
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{
		return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section 
{
	
	/*return [[UIFont	familyNames] count];*/
	count = GetTotalCount(showMisscallInt);
	if(count)
	{
		self.navigationItem.leftBarButtonItem.enabled = YES;
	}
	else
	{
		[self resetMissCallCount];
		self.navigationItem.leftBarButtonItem.enabled = NO;

	}
		return count;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
		
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
			
			cell = [ [ [ SpoknUITableViewCell alloc ] initWithCustomFrame: cellRect reuseIdentifier: CellIdentifier ] autorelease] ;
			[cell resizeFrame];
			//cell->resusableCount = [ indexPath indexAtPosition: 1 ];
			[self addRow:[ indexPath indexAtPosition: 1 ] sectionObject:&secLocP];
			
		}	
	}	
	else
	{	
		secLocP = cell.spoknSubCellP.userData;
		cell.spoknSubCellP.userData = nil;
		[secLocP release];
		secLocP = nil;
		
		[self addRow:[ indexPath indexAtPosition: 1 ] sectionObject:&secLocP];
		//secLocP = [self->cellofvmsP getObjectAtIndex: [ indexPath indexAtPosition: 1 ]];
	}
	if(secLocP)
	{	
		cell.spoknSubCellP.userData = secLocP;
		cell.spoknSubCellP.dataArrayP = secLocP->elementP;
	}
	else
	{
		
		cell.spoknSubCellP.userData = 0;
		cell.spoknSubCellP.dataArrayP = 0;
		
	}
	
	cell.spoknSubCellP.ownerDrawB = true;
	cell.spoknSubCellP.rowHeight = 50;
	[cell.spoknSubCellP setNeedsDisplay];
	
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
	char *typeCallP = 0;//"unknown";
	char *objStrP=0;
	char *secObjStrP = 0;
	struct tm *tmP=0;
	//struct tm tmP1,tmP2;
	time_t timeP;
	char disp[200];
	char s1[30];
	//int index;
	NSString *stringStrP;
	char *addressBookNameP = 0;
	char *addressBookTypeP = 0;
	char *month[12]={"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
	char *ampmCharP=0;
	char type[100];
	unsigned char findResult = NO;
	//int index;
	
	char *contactNameP=0;
	lbold = 0;
	
	objP = GetObjectAtIndex(showMisscallInt ,index);
	if(objP)
	{
	//	NSString *CellIdentifier;
		struct CDR *cdrP;
		//char tmpidentifier[50];
		cdrP =(struct CDR*) objP;
		objStrP = cdrP->userid;
		SetAddressBookDetails(ownerobject.ltpInterfacesP, cdrP->recordUId, cdrP->recordUId);
		contactNameP = [ownerobject getNameAndTypeFromNumber:objStrP :type :&findResult];
		if(findResult)
		{
			int uID;
			typeCallP = type;
			objStrP = contactNameP;
			uID = getAddressUid(ownerobject.ltpInterfacesP);
			if(uID)
			{
				cdrP->recordUId = uID;
				cdrP->isexistRecordID = 1;
			}
		}
		SetAddressBookDetails(ownerobject.ltpInterfacesP, 0, 0);
		/*
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
		else
		{
			if(cdrP->recordUId)
			{	
				
				[ContactViewController	getNameAndType:ownerobject.addressRef :cdrP->recordUId :cdrP->userid :&addressBookNameP :&addressBookTypeP];
				if(addressBookNameP)
				{	
					if(addressBookTypeP)
					{	
						typeCallP = addressBookTypeP;
					}
					char *nameP = addressBookNameP;
					if(nameP)
					{	
						while(*nameP==' '){
							nameP++;
						}
						if(*nameP!='\0')
						{
							objStrP = addressBookNameP;
						}
					}	
				}
			}		
		}
		 */
		timeP = cdrP->date;
				
		tmP = localtime(&timeP);
		
		
		if(tmP)
		{	
			char *days[7]={"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"};
			
			time_t todaytime;
			long difftime;
			struct tm tmP1,tmP2;
			tmP1 = *tmP;
			
			todaytime = time(0);
			tmP =localtime(&todaytime);
			tmP2 = *tmP;

			difftime = tmP2.tm_yday -tmP1.tm_yday;
			
			
			if(difftime<0)
			{
				difftime = difftime*(-1);
			}	
			switch(difftime)
			{
				case 0:
					if(tmP1.tm_hour<12)
					{	
						//sprintf(s1,"%02d:%02d %s",tmP1.tm_hour,tmP1.tm_min,"AM");
						if(tmP1.tm_hour==0)//mid night
						{
							tmP1.tm_hour = 12;
						}
						sprintf(s1,"%02d:%02d",tmP1.tm_hour,tmP1.tm_min);
						ampmCharP = " AM";
					}
					else
					{
						if(tmP1.tm_hour>12)//mid night
						{
							tmP1.tm_hour-= 12;
						}
						//sprintf(s1,"%02d:%02d %s",tmP1.tm_hour,tmP1.tm_min,"PM");
						sprintf(s1,"%02d:%02d",tmP1.tm_hour,tmP1.tm_min);
						ampmCharP = " PM";
					}	
					lbold = 1;
					break;
				case 1:
					sprintf(s1,"Yesterday");
					
					break;
				default:
					if(difftime<7)
					{
						sprintf(s1,days[tmP1.tm_wday]);
					}
					else
					{
						sprintf(s1,"%3s %02d",month[tmP1.tm_mon],tmP1.tm_mday);
						
					}
					break;
					
			}
			
			
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
			
			//struct CDR *lcdrP;
			//secLocP->freeUDataB = true;
			
			//lcdrP = malloc(sizeof(struct CDR)+4);
			//*lcdrP = *cdrP;
			//secLocP->userData = lcdrP;
			secLocP->userData = 0;
			secLocP->uniqueID = cdrP->uniqueID;
			
			secLocP->index = index;
			dispP = [ [displayData alloc] init];
			//dispP.boldB = YES;
			dispP.left = 0;
			dispP.top = 0;
			dispP.width = 0;
			dispP.height = 100;
			
			{
				
				if(cdrP->direction & CALLTYPE_OUT)
				{
					dispP.uiImageP = outImageP;
				}
				else
				if(cdrP->direction & CALLTYPE_IN)
				{
					if(cdrP->direction & CALLTYPE_MISSED)
					{	
						
						dispP.uiImageP = missImageP;
					}
					else
					{	
						dispP.uiImageP = inImageP;
					}	
				}
				else
				{
						dispP.uiImageP = outImageP;
				}
			}
			
			
			
			//dispP = [ [displayData alloc] init];
			dispP.left = 0;
			dispP.top = 0;
			if(secObjStrP)
			{	
				dispP.width = 57;
			}
			else
			{
				dispP.width = 100;
			}
			if(typeCallP)
			{	
				dispP.height = 32;
			}	
			else
			{
				dispP.height = 60;
				dispP.top = 6;
			}
			if((cdrP->direction & CALLTYPE_IN) && (cdrP->direction & CALLTYPE_MISSED))
			{	
				dispP.colorP = [UIColor colorWithRed:_REDCOLOR_];//[UIColor redColor];
				
			}
			else
			{
				dispP.colorP = [UIColor blackColor];
				[dispP.colorP release];
			}
			
			
			dispP.fntSz = 20;
			dispP.boldB = YES;
			//dispP.fontP =  [self->fontGloP fontWithSize:16];
			//[dispP.fontP retain];
			//[dispP.fontP release];
			
			stringStrP = [[NSString alloc] initWithUTF8String:objStrP ];
			dispP.dataP = stringStrP;
			[stringStrP release];
			dispP.showOnEditB = true;
			[secLocP->elementP addObject:dispP];
			
			if(secObjStrP)
			{	
				dispP = [ [displayData alloc] init];
				dispP.left = 10;
				dispP.top = 3;
				if(ampmCharP==NULL)
				{	
					dispP.width = 27;
					
				}
				else {
					dispP.width = 19;
				}

				if(lbold)
				{	
					dispP.boldB = YES;
				}
				else
				{
					dispP.boldB = NO;
				}	
				dispP.textAlignmentType = UITextAlignmentRight;
				dispP.height = 100;
				stringStrP = [[NSString alloc] initWithUTF8String:secObjStrP ];
				dispP.dataP = stringStrP;
				[stringStrP release];
				dispP.colorP = [[UIColor alloc] initWithRed:_TEXTCOLOR_];
				dispP.fntSz = 14;
				[dispP.colorP release];
				[secLocP->elementP addObject:dispP];
				lbold = 0;
				if(ampmCharP)
				{
					dispP = [ [displayData alloc] init];
					dispP.left = 0;
					dispP.top = 3;
					dispP.width = 11;
					dispP.boldB = NO;
					dispP.textAlignmentType = UITextAlignmentRight;
					dispP.height = 100;
					stringStrP = [[NSString alloc] initWithUTF8String:ampmCharP ];
					dispP.dataP = stringStrP;
					[stringStrP release];
					dispP.colorP = [[UIColor alloc] initWithRed:_TEXTCOLOR_];
					dispP.fntSz = 14;
					[dispP.colorP release];
					[secLocP->elementP addObject:dispP];
					
				
				}
				
				// [cell setNeedsDisplay];
			}	
			if(typeCallP)
			{	
				dispP = [ [displayData alloc] init];
				dispP.left = 15;
				dispP.top = 2;
				dispP.width = 70;
				dispP.row = 1;
				dispP.height = 45;
				stringStrP = [[NSString alloc] initWithUTF8String:typeCallP ];
				dispP.dataP = stringStrP;
				[stringStrP release];
				dispP.colorP = [UIColor lightGrayColor];
				
				dispP.fntSz = 14;
				[dispP.colorP release];
						
				dispP.showOnEditB = true;
				[secLocP->elementP addObject:dispP];
			}	
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
	
	else
	{
		if(sectionPP)
			*sectionPP = 0;
		
	}
	if(contactNameP)
	{
		free(contactNameP);
	}
	
		
	
	if(addressBookNameP)
	free(addressBookNameP);
	if(addressBookTypeP)
	free(addressBookTypeP);
	//return nil;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	SpoknUITableViewCell *cell = (SpoknUITableViewCell*)[ self->tableView cellForRowAtIndexPath: indexPath ];
	
	struct CDR *cdrP;
	sectionType *secLocP;

	secLocP = cell.spoknSubCellP.userData;
	if(secLocP==0) return ;
	cdrP = GetObjectByUniqueID(GETCALLLOGLIST, secLocP->uniqueID);
	//cdrP =(struct CDR*)  secLocP->userData;
	//gcdrP = cdrP;
	if(cdrP)
	{
		gUniqueID = cdrP->uniqueID;
		struct AddressBook *addressP;
		
		addressP = getContactOf(cdrP->userid);
		if(addressP)
		{
			/*AddEditcontactViewController     *addeditviewP;	
			addeditviewP = [[AddEditcontactViewController alloc] initWithNibName:@"addeditcontact" bundle:[NSBundle mainBundle]];
			
			[ [self navigationController] pushViewController:addeditviewP animated: YES ];
			[addeditviewP  setContactDetail:addressP];
			[addeditviewP setObject:self->ownerobject];	
			if([addeditviewP retainCount]>1)
				[addeditviewP release];*/
			ContactDetailsViewController     *ContactControllerDetailsviewP;	
			ContactControllerDetailsviewP = [[ContactDetailsViewController alloc] initWithNibName:@"contactDetails" bundle:[NSBundle mainBundle]];
			[ContactControllerDetailsviewP setObject:self->ownerobject];
			resultInt = 0;
			//selectedContact:(char*)lnumberCharP rootObject:(id)lrootObjectP
			[ContactControllerDetailsviewP setReturnValue:&resultInt selectedContactNumber:0  rootObject:0 selectedContact:0] ;
			[ContactControllerDetailsviewP setCdr:cdrP];
			[ContactControllerDetailsviewP setAddressBook:addressP editable:false :CALLLOGDETAILVIEWENUM];
			[ContactControllerDetailsviewP setSelectedNumber:cdrP->userid showAddButton:NO];
			[ContactControllerDetailsviewP setRecordID:cdrP->recordUId :cdrP->recordUId];
			[ [self navigationController] pushViewController:ContactControllerDetailsviewP animated: YES ];
			
			
			
			if([ContactControllerDetailsviewP retainCount]>1)
				[ContactControllerDetailsviewP release];
			
			
			
			return;
			
		}
		else
		{
			
			Boolean noFoundB = true;
			if(cdrP->recordUId)
			{	
				
				ABRecordRef person = ABAddressBookGetPersonWithRecordID(ownerobject.addressRef,
																		cdrP->recordUId);
				if(person)
				{	
					noFoundB = false;
					ContactDetailsViewController     *ContactControllerDetailsviewP;	
					ContactControllerDetailsviewP = [[ContactDetailsViewController alloc] initWithNibName:@"contactDetails" bundle:[NSBundle mainBundle]];
					[ContactControllerDetailsviewP setObject:self->ownerobject];
					resultInt = 0;
					[ContactControllerDetailsviewP setRecordID:cdrP->recordUId :cdrP->recordUId];
					//selectedContact:(char*)lnumberCharP rootObject:(id)lrootObjectP
					[ContactControllerDetailsviewP setReturnValue:&resultInt selectedContactNumber:0  rootObject:0 selectedContact:0] ;
					[ContactControllerDetailsviewP setCdr:cdrP];
					
					
					[ContactControllerDetailsviewP setSelectedNumber:cdrP->userid showAddButton:NO ];
					[ContactViewController addDetailsFromAddressBook :ContactControllerDetailsviewP :CALLLOGDETAILVIEWENUM contactBook:person];
					
					[ [self navigationController] pushViewController:ContactControllerDetailsviewP animated: YES ];
					
					
					
					if([ContactControllerDetailsviewP retainCount]>1)
						[ContactControllerDetailsviewP release];
					
				}	
				
			}
			if(noFoundB)
			{	
			
			
			
			
			
				addressP = (struct AddressBook *)malloc(sizeof(struct AddressBook ));
				memset(addressP,0,sizeof(struct AddressBook));
				addressP->id = -1;
				strcpy(addressP->title,cdrP->userid);
				if(strlen(cdrP->userid)==SPOKN_ID_RANGE)
				{
					strcpy(addressP->spoknid,cdrP->userid);
				}
				else
				{	
					strcpy(addressP->mobile,cdrP->userid);
				}
				
				
				ContactDetailsViewController     *ContactControllerDetailsviewP;	
				ContactControllerDetailsviewP = [[ContactDetailsViewController alloc] initWithNibName:@"contactDetails" bundle:[NSBundle mainBundle]];
				[ContactControllerDetailsviewP setObject:self->ownerobject];
				resultInt = 0;
				[ContactControllerDetailsviewP setRecordID:cdrP->recordUId :cdrP->recordUId];
				//selectedContact:(char*)lnumberCharP rootObject:(id)lrootObjectP
				[ContactControllerDetailsviewP setReturnValue:&resultInt selectedContactNumber:0  rootObject:0 selectedContact:0] ;
				[ContactControllerDetailsviewP setCdr:cdrP];
				[ContactControllerDetailsviewP setSelectedNumber:cdrP->userid showAddButton:YES ];
				
				[ContactControllerDetailsviewP setAddressBook:addressP editable:false :CALLLOGDETAILVIEWENUM];
				
				
				[ [self navigationController] pushViewController:ContactControllerDetailsviewP animated: YES ];
				
				
				
				if([ContactControllerDetailsviewP retainCount]>1)
					[ContactControllerDetailsviewP release];
								
				free(addressP);
			}	
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
	if(secLocP==0) return;
	cdrP = GetObjectByUniqueID(GETCALLLOGLIST, secLocP->uniqueID);
	//cdrP =(struct CDR*)  secLocP->userData;
	if(cdrP==0) return;
	if(self->tableView.editing==NO)
	{	
		
		SetAddressBookDetails(ownerobject.ltpInterfacesP,cdrP->recordUId,cdrP->recordUId);
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
		[cell tablecellsetEdit:NO :0];
		secLocP = cell.spoknSubCellP.userData;
		//cdrP =(struct CDR*)  secLocP->userData;
		cdrP = GetObjectByUniqueID(GETCALLLOGLIST, secLocP->uniqueID);
		if(cdrP)
		{	
			cdrRemove(cdrP);
		}
		cell.spoknSubCellP.userData = nil;
		[secLocP release];
		secLocP = nil;
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
		[array release];
	} 
}
- (void) doRefresh
{
	refreshB = 1;
	if([tableView numberOfRowsInSection:0])
	{
		NSUInteger index[] = {0,0};
		[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathWithIndexes:index length:2] atScrollPosition:UITableViewScrollPositionTop animated:NO];
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
#pragma mark ACTIONSHEET
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==0)//mean delete button
	{
		cdrRemoveAll();
		[self->tableView reloadData];

		
	}
	
	[actionSheet release];
	
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
	
	[actionSheet release];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==0)
	{
		cdrRemoveAll();
		[self->tableView reloadData];
		
	}
	
}
-(void) clearPressed {
	
/*UIAlertView	*alert = [ [ UIAlertView alloc ] initWithTitle: @"Recent calls" 
message: [ NSString stringWithString:_CLEAR_CALL_LOG_ ]
delegate: self
cancelButtonTitle: nil
										 otherButtonTitles: @"Yes", nil];
[alert addButtonWithTitle:@"No"];
	[ alert show ];
	[alert release];
*/
	UIActionSheet *uiActionSheetP;
	uiActionSheetP= [[UIActionSheet alloc] 
					 initWithTitle: @"" 
					 delegate:self
					 cancelButtonTitle:_CANCEL_
					 destructiveButtonTitle:_CLEAR_CALL_LOG_
					 otherButtonTitles:nil, nil];
	
	uiActionSheetP.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[uiActionSheetP showInView:[ownerobject tabBarController].view];
	
	
}
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	refreshB = 0;
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if(resultInt)
	{
		
		
		if(resultInt==2)//delete
		{
			if(gUniqueID)
			{	
				struct CDR  *cdrP;
				cdrP = GetObjectByUniqueID(GETCALLLOGLIST, gUniqueID);
				if(cdrP)
				{	
					cdrRemove(cdrP);
				}	
			}
			gUniqueID = 0;
		}	
		[tableView reloadData];
		resultInt = 0;		
		
	}
	NSIndexPath *nsP;
	nsP = [self->tableView indexPathForSelectedRow];
	if(nsP)
	{
		[self->tableView deselectRowAtIndexPath : nsP animated:NO];
	}
	if(refreshB)
	{
		[self->tableView reloadData];
		refreshB = 0;
		if([tableView numberOfRowsInSection:0])
		{
			NSUInteger index[] = {0,0};
			[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathWithIndexes:index length:2] atScrollPosition:UITableViewScrollPositionTop animated:NO];
		}	
	}
}	


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	showMisscallInt = GETCALLLOGLIST;
	//self.tabBarItem = [UITabBarItem alloc];
	//[self.tabBarItem initWithTitle:@"Calllog" image:nil tag:2];
	missImageP = [UIImage imageNamed:_CALL_MISS_PNG_];
	[missImageP retain];
	inImageP = [UIImage imageNamed:_CALL_IN_PNG_];
	[inImageP retain];
	outImageP = [UIImage imageNamed:_CALL_OUT_PNG_];
	[outImageP retain];
	
	 
	
	lbold = 0;
	refreshB = 0;
	
	//self->fontGloP = [UIFont systemFontOfSize:16.0];
	
	self->cellofcalllogP  = nil;	
	
	//self->tablesz = 0;
	
	tableView.delegate = self;
	tableView.dataSource = self;
//	tableView.tag = TABLE_VIEW_TAG;
	[tableView reloadData];
	[self setTitle:@"Recents"];
	segmentedControl = [ [ UISegmentedControl alloc ] initWithItems: nil ];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	
	[ segmentedControl insertSegmentWithTitle: _ALL_ atIndex: 0 animated: NO ];
	[ segmentedControl insertSegmentWithTitle: @"" atIndex: 1 animated: NO ];
	[ segmentedControl insertSegmentWithTitle: _MISSED_ atIndex: 2 animated: NO ];
	[segmentedControl setWidth:0.1 forSegmentAtIndex:1];  
	[segmentedControl setEnabled:NO forSegmentAtIndex:1];
	
	[ segmentedControl addTarget: self action: @selector(controlPressed:) forControlEvents:UIControlEventValueChanged ];
	
	self.navigationItem.titleView = segmentedControl;
	segmentedControl.selectedSegmentIndex = 0;
	if(hideB==false)
	{	
		self.navigationItem.leftBarButtonItem 
		= [ [ [ UIBarButtonItem alloc ]
			 initWithTitle: _CLEAR_ style:UIBarButtonItemStylePlain
			 target: self
			 action: @selector(clearPressed) ] autorelease ];
		if(count)
		{
			self.navigationItem.leftBarButtonItem.enabled = YES;
		}
		else
		{
			self.navigationItem.leftBarButtonItem.enabled = NO;
			
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
	//[self->fontGloP release];
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
