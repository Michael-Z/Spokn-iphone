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
#import "vmshowviewcontroller.h"
#include "ua.h"

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
-(void)startVmsProgress:(char*)fileNameCharP :(int) max :(struct VMail *)vmailP
{
	
#define _TEST_VMAIL_
#ifdef _TEST_VMAIL_
	struct AddressBook * addressP;
	char type[30];
	printf("\n max time %d",max);
	viewPlayResult = 0;
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"All VMSes";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release]; 
	
	addressP = getContactAndTypeCall(vmailP->userid,type);	
	if(addressP)
	{
		VmShowViewController     *vmShowViewControllerP;	
		vmShowViewControllerP = [[VmShowViewController alloc] initWithNibName:@"vmshowviewcontroller" bundle:[NSBundle mainBundle]];
		//[ContactControllerDetailsviewP setAddressBook:addressP editable:false :CONTACTDETAILVIEWENUM];
		[vmShowViewControllerP setFileName: fileNameCharP :&viewPlayResult];
		[vmShowViewControllerP setvmsDetail: vmailP->userid : addressP->title :type :VMSStatePlay :max :vmailP];
		[vmShowViewControllerP setObject:self->ownerobject];
		
		[ [self navigationController] pushViewController:vmShowViewControllerP animated: YES ];
		//UINavigationController *tmpCtl;
		//tmpCtl = [[ [ UINavigationController alloc ] initWithRootViewController: vmShowViewControllerP ] autorelease];
		//[ownerobject.tabBarController presentModalViewController:tmpCtl animated:YES];
		
				
		if([vmShowViewControllerP retainCount]>1)
			[vmShowViewControllerP release];
		printf("\n retain countact details count %d\n",[vmShowViewControllerP retainCount]);
		
	}
	else
	{
		VmShowViewController     *vmShowViewControllerP;	
		vmShowViewControllerP = [[VmShowViewController alloc] initWithNibName:@"vmshowviewcontroller" bundle:[NSBundle mainBundle]];
		[vmShowViewControllerP setFileName: fileNameCharP :&viewPlayResult];
		//[ContactControllerDetailsviewP setAddressBook:addressP editable:false :CONTACTDETAILVIEWENUM];
		[vmShowViewControllerP setvmsDetail: vmailP->userid : vmailP->userid :"mobile" :VMSStatePlay :max : vmailP];
		[vmShowViewControllerP setObject:self->ownerobject];
		
		[ [self navigationController] pushViewController:vmShowViewControllerP animated: YES ];
		//UINavigationController *tmpCtl;
		//tmpCtl = [[ [ UINavigationController alloc ] initWithRootViewController: vmShowViewControllerP ] autorelease];
		//[ownerobject.tabBarController presentModalViewController:tmpCtl animated:YES];
		
		if([vmShowViewControllerP retainCount]>1)
			[vmShowViewControllerP release];
		printf("\n retain countact details count %d\n",[vmShowViewControllerP retainCount]);	
	}
	return;
#endif
	
	
	
	
	
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
	
	//[uiActionSheetP addButtonWithTitle:@"Test" ];
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


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		//[self.tabBarItem   initWithTabBarSystemItem: 
		// UITabBarSystemItemFavorites tag:4];
		//[self.tabBarItem initWithTitle:@"Dial" image:[UIImage imageNamed:@"Dial.png"] tag:1];
	//	[self.tabBarItem initWithTitle:@"Voicemail" image:[UIImage imageNamed:@"vmstab.png"] tag:4];
		//self.tabBarItem = [UITabBarItem alloc];
		//[self.tabBarItem initWithTitle:@"Voicemail" image:[UIImage imageNamed:@"vmstab.png"] tag:4];
		//self.title = @"Voicemail";
		//[self.tabBarItem initWithTitle:@"Voicemail" image:[UIImage imageNamed:@"vmstab.png"] tag:4];
		[self setTitle:@"VMS"];
		[self.tabBarItem initWithTitle:@"VMS" image:[UIImage imageNamed:@"TB-VMS.png"] tag:4];
    }
    return self;
}


-(void)setObject:(id) object 
{
	self->ownerobject = object;
}

/*
 *   Table Data Source
 */

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{
	//////printf("\n dilip sharma");
	return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section 
{
	int count;
	/*return [[UIFont	familyNames] count];*/
	count = GetTotalCount(showFailInt);
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
	char *typeCallP = 0;
	char *objStrP=0;
	char *secObjStrP = 0;
	struct tm *tmP=0;
	time_t timeP;
	char disp[200];
	char s1[30];
	//int index;
	NSString *stringStrP;
	char *month[12]={"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
	
	////printf("\n index = %d\n",index);
	
	objP = GetObjectAtIndex(showFailInt ,index);
	if(objP)
	{
		//	NSString *CellIdentifier;
		struct VMail *vmailP;
		vmailP =(struct VMail*) objP;
		objStrP = vmailP->userid;
		printf("\n %s\n",objStrP);
		addressP = getContactOf(objStrP);
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
		timeP = vmailP->date;
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
			
			if(difftime==0)
			{
				sprintf(s1,"%02d:%02d",tmP1.tm_hour,tmP1.tm_min);
				
			}
			if(difftime==1)
			{
				sprintf(s1,"Yesterday");
			}
			else
			{
				if(difftime<7)
				{
					sprintf(s1,days[tmP1.tm_wday]);
				}
				else
				{
					sprintf(s1,"%3s %02d",month[tmP1.tm_mon],tmP1.tm_mday);
				}
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
			secLocP->userData = objP;
			secLocP->index = index;
			dispP = [ [displayData alloc] init];
			dispP.boldB = YES;
			dispP.left = 0;
			dispP.top = 0;
			if(secObjStrP)
			{	
				dispP.width = 65;
			}
			else
			{
				dispP.width = 100;
			}
			if(typeCallP)
			dispP.height = 60;
			else
			dispP.height = 100;	
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
				dispP.top = 5;
				dispP.width = 25;
				dispP.textAlignmentType = UITextAlignmentRight;
				dispP.height = 70;
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
				dispP.colorP = [[UIColor alloc] initWithRed:63/255.0 green:90/255.0 blue:139/255.0 alpha:1.0];
				dispP.fntSz = 14;
				[dispP.colorP release];
				[secLocP->elementP addObject:dispP];
				
				// [cell setNeedsDisplay];
			}	
			if(typeCallP)
			{	
				dispP = [ [displayData alloc] init];
				dispP.left = 18;
				dispP.top = 2;
				dispP.width = 70;
				dispP.row = 1;
				dispP.height = 40;
				stringStrP = [[NSString alloc] initWithUTF8String:typeCallP ];
				dispP.dataP = stringStrP;
				[stringStrP release];
				dispP.colorP = [UIColor lightGrayColor];
			
				dispP.fntSz = 14;
				[dispP.colorP release];
				[secLocP->elementP addObject:dispP];
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
			[cell resizeFrame];
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
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//UITableViewCellAccessoryDetailDisclosureButton; 
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
	char *fNameP=0;
	unsigned long timeTotal=0;
	secLocP = cell.spoknSubCellP.userData;
	vmailP =(struct VMail*) secLocP->userData;
	if(GetVmsFileName(vmailP,&fNameP)==0)
	{
		int er;
		UIAlertView *alert;
	//	er = [ownerobject vmsPlayStart:fName :&timeTotal];
		er = [ownerobject getFileSize:fNameP :&timeTotal];
		switch(er)
		{
			case 0:
				if(vmailP->direction==VMAIL_IN && vmailP->status==VMAIL_ACTIVE)		
				{
					vmailP->status=VMAIL_DELIVERED;
					vmailP->dirty=1;
					newVMailCountdecrease();
					
					profileResync();
				}
				NSString *stringStrP;
				char s1[30];
				int count;
				
				count = newVMailCount();
				if(count)
				{	
					sprintf(s1,"%d",count);
					stringStrP = [[NSString alloc] initWithUTF8String:s1 ];
					[self navigationController].tabBarItem.badgeValue= stringStrP;
				
					[stringStrP release];
				}
				else
				{
					[self navigationController].tabBarItem.badgeValue= nil;
				}
				
				[self startVmsProgress:fNameP :timeTotal :vmailP];
				

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
	if(fNameP)
	{
		free(fNameP);
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
	printf("\n%d",buttonIndex);
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
- (void) ComposeVmailPressed {
/*	NSIndexPath * indexPath;
	sectionType *secLocP;
	indexPath = self->tableView.indexPathForSelectedRow;
	if(indexPath)
	{	
		SpoknUITableViewCell *cell = (SpoknUITableViewCell*)[ self->tableView cellForRowAtIndexPath: indexPath ];
	
		struct VMail *vmailP;
		//char *fNameP=0;
		//unsigned long timeTotal=0;
		if(cell)
		{	
			secLocP = cell.spoknSubCellP.userData;
			vmailP =(struct VMail*) secLocP->userData;
			[ownerobject vmsShowRecordScreen:vmailP->userid];
		}
	}	
	
	*/
	openVmsCompose = 0;
	VmShowViewController     *vmShowViewControllerP;	
	vmShowViewControllerP = [[VmShowViewController alloc] initWithNibName:@"vmshowviewcontroller" bundle:[NSBundle mainBundle]];
	[vmShowViewControllerP setFileName: "temp" :0];
	//[ContactControllerDetailsviewP setAddressBook:addressP editable:false :CONTACTDETAILVIEWENUM];
	[vmShowViewControllerP setvmsDetail: "" : "" :"" :VMSStateRecord :20 : 0];
	[vmShowViewControllerP setObject:self->ownerobject];
	//[[self navigationController] popToRootViewControllerAnimated:NO];
	//[ [self navigationController] pushViewController:vmShowViewControllerP animated: YES ];
	UINavigationController *tmpCtl;
	tmpCtl = [[ [ UINavigationController alloc ] initWithRootViewController: vmShowViewControllerP ] autorelease];
	[ownerobject.tabBarController presentModalViewController:tmpCtl animated:YES];
	
	if([vmShowViewControllerP retainCount]>1)
		[vmShowViewControllerP release];
	printf("\n retain countact details count %d\n",[vmShowViewControllerP retainCount]);	
	vmsNoChar[0] = 0;
	
	//openVmsCompose = 0;
	
	//vmsNoChar[0] = 0;
	//showContactScreen:(id) navObject returnnumber:(char*) noCharP  result:(int *) resultP
	//[ownerobject showContactScreen:self returnnumber:vmsNoChar result:&openVmsCompose];
	//[ownerobject changeView];
	

}

- (void) stopEditing {
/*	[ self->tableView setEditing: NO animated: YES ];
	
	self.navigationItem.rightBarButtonItem  
	= [ [ [ UIBarButtonItem alloc ]
		 initWithBarButtonSystemItem: UIBarButtonSystemItemEdit
		 target: self
		 action: @selector(startEditing) ] autorelease ];*/
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==0)
	{
		vmailDeleteAll();
		profileResync();
		[self->tableView reloadData];
		
	}
	printf("\n button %d",buttonIndex);
	
}
-(void) clearPressed {
	
	UIAlertView	*alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
													   message: [ NSString stringWithString:@"Are u sure u want to clear vmail?" ]
													  delegate: self
											 cancelButtonTitle: nil
											 otherButtonTitles: @"OK", nil];
	[alert addButtonWithTitle:@"Cancel"];
	[ alert show ];
	
}

- (void)controlPressed:(id) sender {
	int index = segmentedControl.selectedSegmentIndex;
	switch(index)
	{
		case 0:
			showFailInt = GETVMAILLIST;
			
			break;
		case  2:
		{
			showFailInt = GETVMAILUNDILEVERD;
			
		}
			break;
			
	}
	[ self->tableView reloadData ];
}

#define TABLE_VIEW_TAG			2000
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if(viewPlayResult)
	{
		viewPlayResult = 0;
		printf("\n make changes");
		[ self->tableView reloadData ];
	}
	if(openVmsCompose)
	{
			printf("\n make changes 123");
		openVmsCompose = 0;
		[ownerobject vmsShowRecordScreen:vmsNoChar];
		vmsNoChar[0] = 0;
	
	}
	NSIndexPath *nsP;
	nsP = [self->tableView indexPathForSelectedRow];
	if(nsP)
	{
		[self->tableView deselectRowAtIndexPath : nsP animated:NO];
	}
	if(onLine)
	{
		self.navigationItem.rightBarButtonItem.enabled =YES;
	}	
	else
	{
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}	
}	
-(void)setcomposeStatus:(int)lstatus
{
	onLine = lstatus;
	if(onLine)
	{
		self.navigationItem.rightBarButtonItem.enabled =YES;
	}	
	else
	{
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}	
	
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	activeImageP=[UIImage imageNamed:@"vms_out_Active.png"];
	dileverImageP=[UIImage imageNamed:@"vmail_out_newHigh.png"];
	failedImageP=[UIImage imageNamed:@"vm_icons_outgoing_undelivered.png"];
	vnewImageP=[UIImage imageNamed:@"vm_icons_incoming_new.png"];
	readImageP=[UIImage imageNamed:@"vm_icons_incoming_read.png"];
	//[self.tabBarItem initWithTitle:@"Voicemail" image:[UIImage imageNamed:@"vmstab.png"] tag:4];
	
	//self.tabBarItem = [UITabBarItem alloc];
	//[self.tabBarItem initWithTitle:@"Voicemail" image:[UIImage imageNamed:@"vmstab.png"] tag:4];
	//self->tablesz = 0;
	//////printf("\n table = %d",self->tablesz);
	tableView.delegate = self;
	tableView.dataSource = self;
	self->cellofvmsP  = nil;
	//tableView.tag = TABLE_VIEW_TAG;
	tableView.clearsContextBeforeDrawing = YES;
	[tableView reloadData];
	//[self setTitle:@"vmail"];
	nsTimerP = nil;
	uiProgressP = nil;
	uiActionSheetP = nil;
	[self setTitle:@"VMS"];
	segmentedControl = [ [ UISegmentedControl alloc ] initWithItems: nil ];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	
	[ segmentedControl insertSegmentWithTitle: @"All" atIndex: 0 animated: NO ];
	[ segmentedControl insertSegmentWithTitle: @"" atIndex: 1 animated: NO ];
	[ segmentedControl insertSegmentWithTitle: @"Undelivered" atIndex: 2 animated: NO ];
	[segmentedControl setWidth:0.1 forSegmentAtIndex:1];  
	[segmentedControl setEnabled:NO forSegmentAtIndex:1];
	showFailInt = GETVMAILLIST;
	[ segmentedControl addTarget: self action: @selector(controlPressed:) forControlEvents:UIControlEventValueChanged ];
	
	self.navigationItem.titleView = segmentedControl;
	segmentedControl.selectedSegmentIndex = 0;
	/*
	self.navigationItem.leftBarButtonItem 
	= [ [ [ UIBarButtonItem alloc ]
		 initWithTitle: @"Clear" style:UIBarButtonItemStylePlain
		 target: self
		 action: @selector(clearPressed) ] autorelease ];*/
	self.navigationItem.rightBarButtonItem 
	= [ [ [ UIBarButtonItem alloc ]
		 initWithBarButtonSystemItem: UIBarButtonSystemItemCompose
		 target: self
		 action: @selector(ComposeVmailPressed) ] autorelease ];
	if(onLine)
	{
		self.navigationItem.rightBarButtonItem.enabled =YES;
	}	
	else
	{
		self.navigationItem.rightBarButtonItem.enabled = NO;
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
	[activeImageP release];
	[dileverImageP release];
	[failedImageP release];
	[vnewImageP release];
	[readImageP release];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	printf("\n vmail dealloc");
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
