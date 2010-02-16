
//  Created on 07/10/09.

/**
 Copyright 2009,2010 Geodesic, <http://www.geodesic.com/>
 self setButtonTitle
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

#import "vmshowviewcontroller.h"
#import "SpoknAppDelegate.h"
#import "pickerviewcontroller.h"
#import "overlayviewcontroller.h"
#include "alertmessages.h"

@implementation VmShowViewController
- (void) doneSearching_Clicked:(id)sender {
	
	
	[self->pickerviewcontrollerviewP removeKeyBoard];
	return ;
	
	
	
}

- (void)upDateScreen
{
	tableView.tableHeaderView =  pickerviewcontrollerviewP.view;
	//self.view.frame = CGSizeMake(0, pickerviewcontrollerviewP.view.frame.size.height );
	int temp;
	int temp1;
	temp = tableView.tableHeaderView.frame.size.height; 
		temp1 = pickerviewcontrollerviewP.view.frame.size.height;
	[tableView reloadData];
}
-( void)sendForwardVms:(char*)lallForwardContactP
{
	if(lallForwardContactP)
	{	
		if([ownerobject vmsForward:lallForwardContactP :fileNameCharP]!=0)
		{
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Spokn" message:_VMS_SENDING_FAILED_ delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
		
			[alert show];
		}
		
		//[ownerobject vmsSend:contactNumberP :fileNameCharP];
	
	}	
	
}	
-(void)addContact:(UIViewController*)rootP
{

	
	if(audioStartB==false)
	{	
		doNothing = 1;
	}
	openForwardNo = 0;
	if(rootP==nil)
	{
		rootP = self;
	}
	//showContactScreen:(id) navObject returnnumber:(char*) noCharP  result:(int *) resultP
	[ownerobject showContactScreen:rootP returnnumber:&forwardContact result:&openForwardNo];
}
-(int)getForwardNumber:(SelectedContctType*)  lcontactObjectP
{
	if(openForwardNo)//mean it is on
	{
		//strcpy(lforwardNoP,forwardNoChar);
		openForwardNo = 0;
		
		*lcontactObjectP = forwardContact;
		memset(&forwardContact,0,sizeof(SelectedContctType));
		
		return 0;
	}
	return 1;

}
-(int)keyBoardOnOrOff:(BOOL)onB :(CGRect*) frameP viewHeight:(float)lheight
{
	
	if(onB)
	{	
		if(ovController == nil)
		{	
			ovController = [[OverlayViewController alloc] initWithNibName:@"OverlayView" bundle:[NSBundle mainBundle]];
	
			CGFloat width = self.view.frame.size.width;
			CGFloat height = self.view.frame.size.height;
			//CGRect frame = CGRectMake(0, yaxis, width, height);
	
			//Parameters x = origion on x-axis, y = origon on y-axis.

			if(frameP==0)
			{	
				CGRect frame = CGRectMake(0, 50, width, height);
				ovController.view.frame = frame;	
			}
			else
			{
				
				CGRect frame = CGRectMake(0, frameP->size.height, width, height);
				ovController.view.frame = frame;	
			}
			//UILabel *labP;
			//labP = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, width, 50)];
			//labP.backgroundColor=[UIColor clearColor];
			//labP.text = @"mukesh";
			ovController.view.backgroundColor = [[UIColor clearColor] autorelease ];
			
			[ovController.view addSubview:msgLabelP];
			
			[ovController.view addSubview:secondLabelP];
			
			ovController.rvController = (id)self;
			self->tableView.scrollEnabled = NO;
			[self->tableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
			if(lheight>100 && frameP==nil)
			{
				msgLabelP.hidden = YES;
				secondLabelP.hidden = YES;
			}
		}	
	}	
	else
	{
		self->tableView.scrollEnabled = NO;
		
		[ovController.view removeFromSuperview];
		
		[ovController release];
		ovController = nil;
		[firstSectionviewP addSubview:msgLabelP];
		
		[firstSectionviewP addSubview:secondLabelP];
		msgLabelP.hidden = NO;
		secondLabelP.hidden = NO;
		
	}	

	return 0;
	
}

-(void)showForwardOrReplyScreen:(VMSStateType) lvmsState :(SelectedContctType *)selectedContactP
{
	//pickerviewcontroller     *pickerviewcontrollerviewP;	
	//pickerviewcontrollerviewP = [[pickerviewcontroller alloc] init];
	//[pickerviewcontrollerviewP SetkeyBoardType:UIKeyboardTypePhonePad :10 buttonType:UIKeyboardTypeNamePhonePad];
//	[pickerviewcontrollerviewP setObject:self->ownerobject];
	
	//[pickerviewcontrollerviewP setData:nil value:nil placeHolder:nil returnValue:nil];
	
//	[ [self navigationController] pushViewController:pickerviewcontrollerviewP animated: YES ];
	
	//[pickerviewcontrollerviewP release];
	if(lvmsState!=VMSStatePrevious)
	{	
		if(lvmsState==VMSStateForward)
		{	
			[ownerobject vmsShowRecordOrForwardScreen:0 VMSState : lvmsState filename:fileNameCharP duration:maxTime vmail:self->vmailP];
		}
		else
		{
			if(selectedContactP)
			{	
				[ownerobject vmsShowRecordOrForwardScreen:selectedContactP->number VMSState : lvmsState filename:"temp" duration:0 vmail:0];
			}
			else
			{
				[ownerobject vmsShowRecordOrForwardScreen:0 VMSState : lvmsState filename:"temp" duration:0 vmail:0];
				
			}
		}
	}
	else
	{	
		[pickerviewcontrollerviewP addSelectedContact:selectedContactP  ];
	
		if(selectedContactP)
		{
		
			if(self.title == @"VMS")
				[self setTitle:@"Send VMS"];
		}
	}	
	/*
	if(lvmsState!=VMSStatePrevious)
	{	
		vmstateType = lvmsState;
		if(vmstateType==VMSStateRecord)
		{	
			maxTime = 20;
			maxTimeLoc = 20;
			strcpy(fileNameCharP,"temp");
		}
		[self makeView];
		[self loadOtherView];
		[self->tableView reloadData];
	}

	[pickerviewcontrollerviewP addSelectedContact:selectedContactP  ];
	
	if(selectedContactP)
	{
		
		if(self.title == @"VMS")
			[self setTitle:@"Send VMS"];
	}	
	
	*/
	
	
}


#pragma mark button action
-(IBAction)sendPressed:(id)sender
{
	
	if(vmstateType == VMSStatePlay)
	{
		openForwardNo = 0;
		[self showForwardOrReplyScreen:VMSStateForward :nil];
		//forwardNoChar[0] = 0;
		//showContactScreen:(id) navObject returnnumber:(char*) noCharP  result:(int *) resultP
		//[ownerobject showContactScreen:self returnnumber:forwardNoChar result:&openForwardNo];
		//[self showForwardOrReplyScreen:"" name:""];
		/*
		pickerviewcontroller     *lpickerviewcontrollerviewP;	
		lpickerviewcontrollerviewP = [[pickerviewcontroller alloc] init];
		lpickerviewcontrollerviewP.upDateProtocolP = self;
		[lpickerviewcontrollerviewP viewLoadedModal:YES];
		[lpickerviewcontrollerviewP SetkeyBoardType:UIKeyboardTypePhonePad :10 buttonType:UIKeyboardTypeNamePhonePad];
			[lpickerviewcontrollerviewP setObject:self->ownerobject];
		
		[lpickerviewcontrollerviewP setData:nil value:nil placeHolder:nil returnValue:nil];
		
			[ [self navigationController] pushViewController:lpickerviewcontrollerviewP animated: YES ];
		
		[lpickerviewcontrollerviewP release];
		*/
		
		
	}
	else
	{	char *contactNumberP;
		contactNumberP = [pickerviewcontrollerviewP getContactNumberList];
		if(contactNumberP)
		{
			if( strlen(contactNumberP)>0)
			{	
				
				if(vmstateType == VMSStateRecord)
				{
					if([ownerobject vmsSend:contactNumberP :fileNameCharP]!=0)
					{
						UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:_TITLE_ message:_VMS_SENDING_FAILED_ delegate:nil cancelButtonTitle:_OK_ otherButtonTitles: nil] autorelease];
						
						[alert show];
						
						
					}
					/*else
					{
						UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Spokn" message:@"VMS sent successfuly." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
						
						[alert show];					
					}
					 */
					
				}
				else
				{
					[self sendForwardVms:contactNumberP] ;
				
				}
				free(contactNumberP);
				[self cancelClicked];//remove dialog
				[ownerobject.vmsNavigationController popToRootViewControllerAnimated:YES];//remove upto root controller
				shiftVmailB = YES;
				return;
			}
			free(contactNumberP);
			
		}	
		
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:_TITLE_ message:_EMPTY_NUMBER_ delegate:nil cancelButtonTitle:_OK_ otherButtonTitles: nil] autorelease];
			
		[alert show];
		
		
		
	}	
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
	
	/*UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
													   message: [ NSString stringWithString:_DELETE_VMS_ ]
													  delegate: self
											 cancelButtonTitle: nil
											 otherButtonTitles: @"OK", nil
						  ];
	[alert addButtonWithTitle:@"Cancel"];
	[ alert show ];
	[alert release];*/
	
	UIActionSheet *uiActionSheetP;
	uiActionSheetP= [[UIActionSheet alloc] 
					 initWithTitle: @"" 
					 delegate:self
					 cancelButtonTitle:_CANCEL_ 
					 destructiveButtonTitle:_DELETE_VMS_
					 otherButtonTitles:nil, nil];
	
	uiActionSheetP.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[uiActionSheetP showInView:[ownerobject tabBarController].view];
	
	
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==0)//mean delete button
	{
		if(returnValLongP)
		{	
			*returnValLongP = 1;
		}
		vmsDeleteByID(vmailP->vmsid);
		[ [self navigationController] popViewControllerAnimated:YES ];
		profileResync();
		
		
	}
	
	[actionSheet release];
	
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
	
	[actionSheet release];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation
{
	
	
	if(buttonIndex==0)
	{	
		if(returnValLongP)
		{	
			*returnValLongP = 1;
		}
		vmsDeleteByID(vmailP->vmsid);
		[ [self navigationController] popViewControllerAnimated:YES ];
		profileResync();
	}
}

- (void)VmsStart
{
	
}
- (void)VmsStop
{
	if(vmstateType==VMSStatePlay)
	{
		deleteButton.enabled = YES;
	}

	if(doNothing)
	{
		//if(recordingStartB != 1)
		return;
	}
	if(audioStartB==false)
	{
		return;
	}
	audioStartB = false; 
	[nsTimerP invalidate];
	nsTimerP = 0;

	[PlayButtonP addTarget:self action:@selector(playPressed:) forControlEvents: UIControlEventTouchUpInside];
	
	if(vmstateType == VMSStatePlay ||vmstateType == VMSStateForward )
	{	
		[self setButtonTitle:@"Play" forState:UIControlStateNormal];
		[self setButtonTitle:@"Play" forState:UIControlStateHighlighted];
	}
	
	if(vmstateType == VMSStateRecord)
	{	
		
		
		if(recordingStartB == 1)
		{	
		
			if(previewPressedB==false)
			{	
				if(self->maxtimeDouble==maxTime)
				{
					recordingStartB = 0;
					[self setButtonTitle:@"Record" forState:UIControlStateNormal];
					[self setButtonTitle:@"Record" forState:UIControlStateHighlighted];

					[secondLabelP setText:[NSString stringWithFormat:@"%d", maxTime ]];
					return;
				}
				[secondLabelP setText:[NSString stringWithFormat:@"%d", maxTime - self->maxtimeDouble]];
			
			}
			else
			{
				[secondLabelP setText:[NSString stringWithFormat:@"%d", maxTimeLoc]];
			}
			[self setButtonTitle:@"Rerecord" forState:UIControlStateNormal];
			[self setButtonTitle:@"Rerecord" forState:UIControlStateHighlighted];
			
			
			previewPressedB = false;
			[msgLabelP setText:_VMS_RECORDING_MSG3_];
			recordVmsB = true;
			self->maxtimeDouble=maxTime;
			previewButtonP.enabled  = YES;
			sendButtonP.enabled  = YES;
		}	
	}
	else
	{
		self->maxtimeDouble=maxTime;
		[secondLabelP setText:[NSString stringWithFormat:@"%d", maxTime ]];
		if(vmstateType == VMSStateForward)
		{
			previewButtonP.enabled  = NO;
		}
		else
		{
			previewButtonP.enabled  = YES;
		}	
		sendButtonP.enabled  = YES;

	}
	
	amt = 0.0;
	#ifdef PROGRESS_VIEW
	[uiProgBarP setProgress: 0.0f];	
	
	#else
		sliderP.value = 0.0f;
	#endif
	

	
}
- (void) handleTimer: (id) timer
{
	
	if(amt<maxTime)
	{	
		amt += 1;
	#ifdef PROGRESS_VIEW

		[uiProgBarP setProgress: (amt / maxTimeLoc)];
	#else
		
		sliderP.value = (amt / maxTimeLoc);

	#endif	
		self->maxtimeDouble--;
		[secondLabelP setText:[NSString stringWithFormat:@"%d", self->maxtimeDouble]];
		//	if (amt > maxtime) { [timer invalidate];}
		
		
	}
	else
	{
		Boolean playB;
		if(vmstateType == VMSStatePlay ||vmstateType == VMSStateRecord )
		{
			playB = true;
		}
		else
		{
			playB = false;
		}
		
		
		[ownerobject vmsStop:!playB];
		
	}
	
}
-(void)VmsStopRequest
{
	[self stopButtonPressed:nil];
}
-(IBAction)stopButtonPressed:(id)sender
{
	Boolean playB;
	if(vmstateType==VMSStatePlay)
	{
		deleteButton.enabled = YES;
	}
	if(vmstateType == VMSStatePlay ||vmstateType == VMSStateRecord )
	{
		playB = true;
	}
	else
	{
		playB = false;
	}
	if([ownerobject vmsStop:!playB])
	{
		
		[self VmsStop];
	}
	
}

-(IBAction)playPressed:(id)sender
{
	
	unsigned long sz;
	recordingStartB = 1;
	audioStartB = true;
	[ownerobject setVmsDelegate:self];
	
	if(vmstateType==VMSStatePlay || vmstateType==VMSStateForward)
	{
		if([ownerobject vmsPlayStart:fileNameCharP :&sz])
			return;
		if([ownerobject VmsStreamStart:false])
		{
			UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: _TITLE_ 
															   message: [ NSString  stringWithString:_NO_VMS_PLAY_]
															  delegate: nil
													 cancelButtonTitle: nil
													 otherButtonTitles: _OK_, nil
								  ];
			[ alert show ];
			[alert release];
			return;
			
		}
	}
	else
	{
		if([ownerobject vmsRecordStart:fileNameCharP])
		{
			return;
		}
		if([ownerobject VmsStreamStart:true])
		{
			UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: _TITLE_
															   message: [ NSString  stringWithString:_NO_VMS_PLAY_]
															  delegate: nil
													 cancelButtonTitle: nil
													 otherButtonTitles: _OK_, nil
								  ];
			[ alert show ];
			[alert release];
			return;
		}
		[msgLabelP setText:_VMS_RECORDING_MSG2_];
	}
	maxTimeLoc = maxTime;
	
	nsTimerP = [NSTimer scheduledTimerWithTimeInterval: 1.0
				
												target: self
				
											  selector: @selector(handleTimer:)
				
											  userInfo: nil
				
											   repeats: YES];
	[PlayButtonP addTarget:self action:@selector(stopButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
	[self setButtonTitle:@"Stop" forState:UIControlStateNormal];
	[self setButtonTitle:@"Stop" forState:UIControlStateHighlighted];
	previewButtonP.enabled  = NO;
	sendButtonP.enabled  = NO;
	previewButtonP.imageEdgeInsets = UIEdgeInsetsMake (0., 0., 0., 5.);
	//previewButtonP.titleShadowOffset = CGSizeMake(0,-1);
	[previewButtonP setTitleShadowColor:[[UIColor darkGrayColor] autorelease] forState:UIControlStateNormal];
	[previewButtonP setTitleShadowColor:[UIColor colorWithWhite:0. alpha:0.2]  forState:UIControlStateDisabled];
	[previewButtonP setTitleColor:[[UIColor grayColor] autorelease] forState:UIControlStateHighlighted];
	//[previewButtonP setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5]  forState:UIControlStateDisabled];
	[previewButtonP setTitleColor:[[UIColor grayColor] autorelease]  forState:UIControlStateDisabled];
	
	sendButtonP.imageEdgeInsets = UIEdgeInsetsMake (0., 0., 0., 5.);
	//[sendButtonP setTitle:@"Send" forState:UIControlStateNormal];
	//sendButtonP.titleShadowOffset = CGSizeMake(0,-1);
	[sendButtonP setTitleShadowColor:[[UIColor darkGrayColor] autorelease ] forState:UIControlStateNormal];
	[sendButtonP setTitleShadowColor:[UIColor colorWithWhite:0. alpha:0.2]  forState:UIControlStateDisabled];
	[sendButtonP setTitleColor:[[UIColor grayColor] autorelease ] forState:UIControlStateHighlighted];
	//[sendButtonP setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5]  forState:UIControlStateDisabled];
	[sendButtonP setTitleColor:[[UIColor grayColor] autorelease]  forState:UIControlStateDisabled];
	if(vmstateType==VMSStatePlay)
	{
		deleteButton.enabled = NO;
	}
	

}
-(IBAction)previewPressed:(id)sender
{

	
	[ownerobject setVmsDelegate:self];
	if(vmstateType==VMSStateRecord)
	{
		char *nameP=0;
		unsigned long sz;
		makeVmsFileName(fileNameCharP,&nameP);
		if([ownerobject vmsPlayStart:nameP :&sz])
		{
			free(nameP);
			return;
		}
		if(nameP)
		{	
			free(nameP);
		}
		if(sz>20)
		{
			sz = 20;
		}
		previewPressedB = true;
		audioStartB = true;
		[ownerobject VmsStreamStart:false];
		self->maxtimeDouble=sz;
		maxTimeLoc = sz;
		nsTimerP = [NSTimer scheduledTimerWithTimeInterval: 1.0
				
												target: self
				
											  selector: @selector(handleTimer:)
				
											  userInfo: nil
				
											   repeats: YES];
		[PlayButtonP addTarget:self action:@selector(stopButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
		[self setButtonTitle:@"Stop" forState:UIControlStateNormal];
		[self setButtonTitle:@"Stop" forState:UIControlStateHighlighted];
		previewButtonP.enabled  = NO;
		sendButtonP.enabled  = NO;
		previewButtonP.imageEdgeInsets = UIEdgeInsetsMake (0., 0., 0., 5.);
		//previewButtonP.titleShadowOffset = CGSizeMake(0,-1);
		[previewButtonP setTitleShadowColor:[[UIColor darkGrayColor] autorelease ] forState:UIControlStateNormal];
		[previewButtonP setTitleShadowColor:[UIColor colorWithWhite:0. alpha:0.2]  forState:UIControlStateDisabled];
		[previewButtonP setTitleColor:[[UIColor grayColor] autorelease ] forState:UIControlStateHighlighted];
		//[previewButtonP setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5]  forState:UIControlStateDisabled];
		[previewButtonP setTitleColor:[[UIColor grayColor] autorelease]  forState:UIControlStateDisabled];
		
		sendButtonP.imageEdgeInsets = UIEdgeInsetsMake (0., 0., 0., 5.);
		//[sendButtonP setTitle:@"Send" forState:UIControlStateNormal];
		//sendButtonP.titleShadowOffset = CGSizeMake(0,-1);
		[sendButtonP setTitleShadowColor:[[UIColor grayColor] autorelease ]  forState:UIControlStateNormal];
		[sendButtonP setTitleShadowColor:[UIColor colorWithWhite:0. alpha:0.2]  forState:UIControlStateDisabled];
		[sendButtonP setTitleColor:[[UIColor grayColor] autorelease ]  forState:UIControlStateHighlighted];
		//[sendButtonP setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5]  forState:UIControlStateDisabled];
		[sendButtonP setTitleColor:[[UIColor grayColor] autorelease]  forState:UIControlStateDisabled];
		
	}	
	else
	{
		/*playB = false;
		maxTime = 20;
		maxTimeLoc = 20;
		strcpy(fileNameCharP,"temp");
		[self loadOtherView];*/
		SelectedContctType *lselectP;
		lselectP = malloc(sizeof(SelectedContctType));
		strcpy(lselectP->number,noCharP);
		strcpy(lselectP->nameChar,nameCharP);
		strcpy(lselectP->type,typeCharP);
		[self showForwardOrReplyScreen:VMSStateRecord :lselectP];
		//modalB = true;
		//self.navigationItem.hidesBackButton = YES;
		free(lselectP);
		//[self showForwardOrReplyScreen:noCharP name:nameCharP];
	}
	


}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int row = [indexPath row];
	int section = [indexPath section];

	if(sectionArray[section].dataforSection[row].customViewP)
	{
		if(sectionArray[section].dataforSection[row].rowHeight)
			return sectionArray[section].dataforSection[row].rowHeight;
		return 30;
	}	
	
	return 50;
	
}
/*
 *   Table Data Source
 */
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
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int row = [indexPath row];
	int section = [indexPath section];
	sectionType *secLocP;
	char *tmpCellP;
	if(sectionArray[section].dataforSection[row].customViewP)
	{
		tmpCellP = "any-cell";
	}
	else
	{
		tmpCellP = "any-cell1";
	}
	NSString *CellIdentifier = [[NSString alloc] initWithUTF8String:tmpCellP];
	SpoknUITableViewCell *cell = (SpoknUITableViewCell *) [ tableView dequeueReusableCellWithIdentifier: CellIdentifier ];
	if (cell == nil) {
		
		//	secLocP = [self->cellofvmsP getObjectAtIndex: [ indexPath indexAtPosition: 1 ]];
		//	if(secLocP)
		{	
			if(sectionArray[section].dataforSection[row].customViewP)
			{
				#ifdef __IPHONE_3_0
				
					cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				#else
					cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
				
				#endif
				//cell.backgroundColor =[UIColor viewFlipsideBackgroundColor];
				[cell.contentView addSubview:sectionArray[section].dataforSection[row].customViewP];
				[sectionArray[section].dataforSection[row].customViewP release];
				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			}
			else
			{
				CGRect cellRect = CGRectMake(0, 0, 320, 50);
				
				cell = [ [ [ SpoknUITableViewCell alloc ] initWithCustomFrame: cellRect reuseIdentifier: CellIdentifier ] autorelease] ;
				//cell->resusableCount = [ indexPath indexAtPosition: 1 ];
				[cell setAutoResize:YES];
				[self addRow:section :row sectionObject:&secLocP];
				
			}
						
		}	
	}	
	else
	{	
		if(sectionArray[section].dataforSection[row].customViewP==0)
		{	
			secLocP = cell.spoknSubCellP.userData;
			[secLocP release];
		
			[self addRow:section :row sectionObject:&secLocP];
		//secLocP = [self->cellofvmsP getObjectAtIndex: [ indexPath indexAtPosition: 1 ]];
		}	
	}
		
	if(sectionArray[section].dataforSection[row].customViewP==0)
	{	
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
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		[cell.spoknSubCellP setNeedsDisplay];
	}	
	else
	{
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
	//[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	/*if(editableB)
	{
		//	cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;//UITableViewCellAccessoryDetailDisclosureButton; 
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	}
	else
	{
		cell.accessoryType = UITableViewCellAccessoryNone;
		//cell.editingAccessoryType = UITableViewCellAccessoryNone;//UITableViewCellAccessoryDetailDisclosureButton; 
		
	}*/
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
		    
	}
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:
(NSIndexPath *)indexPath
{
	//int row = [indexPath row];
	//int section = [indexPath section];
	/*if(editableB)
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
	*/
	return UITableViewCellEditingStyleNone;
}
/*
 *   Table Delegate
 */
- (void)addRow: (int)lsection:(int )row sectionObject:(sectionType **)sectionPP
{
	char *objStrP=0;
	char *secObjStrP = 0;
	char *typeCallP = 0;
	
	//int index;
	NSString *stringStrP;
	objStrP = sectionArray[lsection].dataforSection[row].elementP;
	typeCallP = sectionArray[lsection].dataforSection[row].secRowP;
	
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
			dispP.top = 0;
			dispP.width = 100;
			if(secObjStrP)
			{	
				if(strlen(secObjStrP)>0)
					dispP.width = 40;
			}
			if(contactFindB)
			{	
				dispP.height = 0;
			}
			else
			{
				dispP.height = 52;
			}
			dispP.colorP = [UIColor colorWithRed:40/255.0 green:108/255.0 blue:214/255.0 alpha:1.0];
			
			dispP.boldB = YES;
			dispP.fntSz = 20;
			//dispP.fontP =  [self->fontGloP fontWithSize:16];
			//[dispP.fontP retain];
			//[dispP.fontP release];
			stringStrP = [[NSString alloc] initWithUTF8String:objStrP ];
			dispP.dataP = stringStrP;
			[stringStrP release];
			//[dispP.colorP release];
			
			[secLocP->elementP addObject:dispP];
			
			if(secObjStrP)
			{	
				dispP = [ [displayData alloc] init];
				dispP.left = 10;
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
				dispP.boldB = YES;
				[dispP.colorP release];
				[secLocP->elementP addObject:dispP];
				
				// [cell setNeedsDisplay];
			}	
			if(typeCallP && contactFindB)
			{	
				dispP = [ [displayData alloc] init];
				dispP.left = 5;
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
				[secLocP->elementP addObject:dispP];
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
	
	int row = [newIndexPath row];
	int section = [newIndexPath section];
	if(sectionArray[section].dataforSection[row].customViewP==0)
	{
		[self->tableView deselectRowAtIndexPath : newIndexPath animated:NO];
		[self loadContactDetails:noCharP];
	}
	//selection = [[[UIFont familyNames] objectAtIndex:[newIndexPath row]] retain];
/*	int row = [newIndexPath row];
	int section = [newIndexPath section];
	
	if(sectionArray[section].dataforSection[row].customViewP==0)
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
	}	*/
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	if(sectionCount)
		return  sectionCount;
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return sectionArray[section].count;
	//return [ fileList count ];
}
#ifndef PROGRESS_VIEW
CGContextRef MyCreateBitmapContext (int pixelsWide,
									int pixelsHigh)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
	
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
	
    colorSpace = CGColorSpaceCreateDeviceRGB();
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        return NULL;
    }
    context = CGBitmapContextCreate (bitmapData,
									 pixelsWide,
									 pixelsHigh,
									 8,
									 bitmapBytesPerRow,
									 colorSpace,
									 kCGImageAlphaPremultipliedLast);
    if (context== NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
        return NULL;
    }
    CGColorSpaceRelease( colorSpace );
	
    return context;
}

// Build a thumb image based on the grayscale percentage
id createImage(float percentage)
{
	CGRect aRect = CGRectMake(0.0f, 0.0f, 48.0f, 48.0f);
	CGContextRef context = MyCreateBitmapContext(48, 48);
	CGContextClearRect(context, aRect);
	
	// Outer gray circle
	CGContextSetFillColorWithColor(context, [[[UIColor lightGrayColor] autorelease ]  CGColor]);
	CGContextFillEllipseInRect(context, aRect);
	
	// Inner circle with feedback levels
	CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:percentage green:0.0f blue:0.0f alpha:1.0f] CGColor]);
	CGContextFillEllipseInRect(context, CGRectInset(aRect, 4.0f, 4.0f));
	
	// Inner gray circle
	CGContextSetFillColorWithColor(context, [[[UIColor lightGrayColor] autorelease ]  CGColor]);
	CGContextFillEllipseInRect(context, CGRectInset(aRect, 16.0f, 16.0f));
	
	CGImageRef myRef = CGBitmapContextCreateImage (context);
	free(CGBitmapContextGetData(context));
	CGContextRelease(context);
	
	return [UIImage imageWithCGImage:myRef];
}



- (void) updateValue: (UISlider *) slider
{
	//[valueLabel setText:[NSString stringWithFormat:@"%3.1f", [slider value]]];
	
	//CGImageRef oldknobref = [knob CGImage];
	//knob = createImage([slider value] / 100.0f);
//	[slider setThumbImage:knob forState:UIControlStateNormal];
	//[slider setThumbImage:knob forState:UIControlStateHighlighted];
//	CFRelease(oldknobref);
}
#endif

#define ROW_PLAY_PAD 2
#define LEFT_BOUND 11
#define RIGHT_BOUND 274
#define ROW_PLAY_HEIGHT 84
#define ROW_PLAY_WIDTH 300
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
	#ifdef PROGRESS_VIEW
		int y = ROW_PLAY_HEIGHT-60;
		y = y/3;
		progressandplayviewP = [[UIView alloc] initWithFrame:CGRectMake(ROW_PLAY_PAD, ROW_PLAY_PAD, ROW_PLAY_WIDTH-ROW_PLAY_PAD, ROW_PLAY_HEIGHT-ROW_PLAY_PAD)];
		uiProgBarP = [[UIProgressView alloc] initWithFrame:
					  			   
					   CGRectMake(LEFT_BOUND, y, RIGHT_BOUND, 10.0f)];
		//[uiProgBarP backgroundColor:[UIColor redColor]];
		//uiProgBarP.progressViewStyle = UIProgressViewStyleBar;
		//uiProgBarP.backgroundColor = uiActionSheetP.backgroundColor;//[UIColor blueColor];
		uiProgBarP.progressViewStyle= UIProgressViewStyleDefault;
		uiProgBarP.tag = 12;
		[uiProgBarP setProgress:0.0f];
		[progressandplayviewP addSubview:uiProgBarP];
		
		PlayButtonP = [[UIButton alloc] init];
		// The default size for the save button is 49x30 pixels
		PlayButtonP.frame = CGRectMake(LEFT_BOUND, 2*y+10, RIGHT_BOUND, 45.0);
		
		// Center the text vertically and horizontally
		PlayButtonP.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		PlayButtonP.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		[PlayButtonP addTarget:self action:@selector(playPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		[progressandplayviewP insertSubview:PlayButtonP belowSubview:uiProgBarP];
		
	#else
		sliderP = [[UISlider alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 280.0f, 30.0f)];
		sliderP.backgroundColor = [[UIColor clearColor] autorelease ] ;
		//activeImageP=[UIImage imageNamed:@"vms_out_Active.png"];
		//dileverImageP=[UIImage imageNamed:@"vmail_out_newHigh.png"];
	//	[sliderP setThumbImage:[UIImage imageNamed:@"speaker.png"] forState:UIControlStateNormal];
		//[sliderP setMinimumTrackImage:[UIImage imageNamed:@"thumb_blue.png"] forState:UIControlStateNormal];
		//[sliderP setMaximumTrackImage:[UIImage imageNamed:@"bg.png"] forState:UIControlStateNormal];
		
		sliderP.minimumValueImage = [UIImage imageNamed:_VMS_PROGRESS_LEFT_PNG_];
		[sliderP.minimumValueImage release];
		sliderP.maximumValueImage = [UIImage imageNamed:_VMS_PROGRESS_LEFT_PNG_];
		[sliderP.maximumValueImage release];
		sliderP.minimumValue = 0.0f;
		sliderP.maximumValue = 1.0f;
		sliderP.continuous = NO;
		sliderP.value = 0.0f;
		//sliderP.enabled  = NO;
		
		// Add the custom knob
	//	knob = createImage(0.5);
	//	[sliderP setThumbImage:knob forState:UIControlStateNormal];
		//[sliderP setThumbImage:knob forState:UIControlStateHighlighted];
		
		[sliderP addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
				//[contentView addSubview: slider];
		//[sliderP release];
		
	#endif		
		pickerviewcontrollerviewP = [[pickerviewcontroller alloc] init];
		[pickerviewcontrollerviewP SetkeyBoardType:UIKeyboardTypeEmailAddress :10 buttonType:UIKeyboardTypeEmailAddress];
		[pickerviewcontrollerviewP setObject:self->ownerobject];
		
		[pickerviewcontrollerviewP setData:nil value:nil placeHolder:nil returnValue:nil];
		
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
	if(openForwardNo)
	{
		
		openForwardNo = 0;
		[self showForwardOrReplyScreen:VMSStatePrevious :&forwardContact];
		
		
		//forwardNoChar[0] = 0;
	}
	
	[super viewWillAppear:animated];

}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	doNothing = 0;
	
	if(openForwardNo)
	{
		
		openForwardNo = 0;
		[self showForwardOrReplyScreen:VMSStatePrevious :&forwardContact];
		
		
		//forwardNoChar[0] = 0;
	}
	
	if(returnValueInt)
	{
		
		//if(vmstateType!=VMSStatePlay)
		{	
			returnValueInt = 0;
			char type[40];
			struct AddressBook * addressP;
			if(selectP)
			{
				free(selectP);
				
				selectP = 0;
			}
			//now get address book
				addressP = getContactAndTypeCall(noCharP,type);	
			if(addressP)
			{
				struct VMail* lvmailP;
				lvmailP = vmailP;
				char*lnoCharP;
				vmailP =0;
				lnoCharP = noCharP;
				noCharP = 0;
				[self setvmsDetail: lnoCharP : addressP->title :type :vmstateType :maxTime :lvmailP];
				if(lnoCharP)
				{
					free(lnoCharP);
				}
				if(lvmailP)
				{
					free(lvmailP);
				}
				
			}
			
			//forwardNoChar[0]=0;
			[self loadOtherView];
			[self makeView];
			[self->tableView reloadData];
			//tableView.tableHeaderView =  
			//pickerviewcontrollerviewP.view.hidden = YES;

		}	
	
	}
	//pickerviewcontrollerviewP.view.hidden = YES;
}	

-(void)setObject:(id) object 
{
	self->ownerobject = object;
}



-(void)loadOtherView
{
	if(vmstateType==VMSStatePlay || vmstateType==VMSStateForward)
	{
		
		if(vmstateType==VMSStateForward)
		{	
			[self setTitle:@"Forward VMS"];
		}
		char s1[50];
		char *month[12]={"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
		
		//char *month[12]={"January","February","March","April","May","June","July","August","September","October","November","December"};
		[self setButtonTitle:@"Play" forState:UIControlStateNormal];
		[self setButtonTitle:@"Play" forState:UIControlStateHighlighted];
		[sendButtonP setTitle:@"Forward" forState:UIControlStateNormal];
		[sendButtonP setTitle:@"Forward" forState:UIControlStateHighlighted];
		[previewButtonP setTitle:@"Reply" forState:UIControlStateNormal];
		[previewButtonP setTitle:@"Reply" forState:UIControlStateHighlighted];
			
		struct tm tmP1,*tmP=0;
		time_t timeP;
		if(vmailP)
		{	
			timeP = vmailP->date;
			tmP = localtime(&timeP);
			tmP1 = *tmP;
			
			if(tmP1.tm_hour<12)
			{	
				sprintf(s1,"%02d:%02d AM on %02d %3s %d",(tmP1.tm_hour)?tmP1.tm_hour:12,tmP1.tm_min,tmP1.tm_mday,month[tmP1.tm_mon],tmP1.tm_year+1900);
			}
			else
			{	
				sprintf(s1,"%02d:%02d PM on %02d %3s %d",(tmP1.tm_hour-12)?(tmP1.tm_hour-12):12,tmP1.tm_min,tmP1.tm_mday,month[tmP1.tm_mon],tmP1.tm_year+1900);
			}
			if(vmailP->direction==VMAIL_IN)
			{	
				[msgLabelP setText:[NSString stringWithFormat:@"Incoming VMS\n%s", s1]];
			}
			else
			{
				[msgLabelP setText:[NSString stringWithFormat:@"Outgoing VMS\n%s", s1]];
			}
			
		}	
		[secondLabelP setText:[NSString stringWithFormat:@"%d", self->maxTime]];
		if(vmstateType==VMSStatePlay)
		{	
			deleteButton = [[UIButton alloc] init];
		// The default size for the save button is 49x30 pixels
			deleteButton.frame = CGRectMake(0, 0, 50, 30.0);
		
		// Center the text vertically and horizontally
			deleteButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
			deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
			UIImage *buttonBackground;
			UIImage *buttonBackgroundPressed;
			
			
			buttonBackground = [UIImage imageNamed:_TAB_DEL_NORMAL_PNG_];
			buttonBackgroundPressed = [UIImage imageNamed:_TAB_DEL_PRESSED_PNG_];
			[CustomButton setImages:deleteButton image:buttonBackground imagePressed:buttonBackgroundPressed change:NO];
			[buttonBackground release];
			[buttonBackgroundPressed release];
			deleteButton.backgroundColor =  [UIColor clearColor];	
			
			
			//[deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
			
			[deleteButton addTarget:self action:@selector(deleteClicked) forControlEvents:UIControlEventTouchUpInside];
			
			[deleteButton addTarget:self action:@selector(deleteClicked) forControlEvents:UIControlEventTouchUpInside];
		
			UIBarButtonItem *navButton = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
		
			self.navigationItem.rightBarButtonItem = navButton;
		
			[navButton release];
			[deleteButton release];
			tableView.tableHeaderView = 0;
			/*self.navigationItem.leftBarButtonItem = [ [ [ UIBarButtonItem alloc ]
													   initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
													   target: self
													   action: @selector(cancelClicked) ] autorelease ];	*/
		}
		else
		{
			pickerviewcontrollerviewP.upDateProtocolP = self;
			tableView.tableHeaderView =  pickerviewcontrollerviewP.view;
			[sendButtonP setTitle:@"Send" forState:UIControlStateNormal];
			[sendButtonP setTitle:@"Send" forState:UIControlStateHighlighted];
			
			self.navigationItem.hidesBackButton = YES;
			//self.navigationItem.rightBarButtonItem  = nil;
			self.navigationItem.rightBarButtonItem = [ [ [ UIBarButtonItem alloc ]
													   initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
													   target: self
													   action: @selector(cancelClicked) ] autorelease ];
			if(vmstateType==VMSStateForward)
			{
				previewButtonP.enabled = NO;
				previewButtonP.imageEdgeInsets = UIEdgeInsetsMake (0., 0., 0., 5.);
				[previewButtonP setTitleShadowColor:[[UIColor darkGrayColor] autorelease ]  forState:UIControlStateNormal];
				[previewButtonP setTitleShadowColor:[UIColor colorWithWhite:0. alpha:0.2]  forState:UIControlStateDisabled];
				[previewButtonP setTitleColor:[[UIColor grayColor] autorelease ]  forState:UIControlStateHighlighted];
				[previewButtonP setTitleColor:[[UIColor grayColor] autorelease]  forState:UIControlStateDisabled];
			}	
			
		
		}
		
	//	self.navigationItem.rightBarButtonItem = [ [ [ UIBarButtonItem alloc ] initWithTitle:@"Delete" style:UIBarButtonItemStyleDone target:self action:@selector(deleteClicked)] autorelease];
		
		
	}
	else
	{
		
		pickerviewcontrollerviewP.upDateProtocolP = self;
		tableView.tableHeaderView =  pickerviewcontrollerviewP.view;
		if(recordVmsB==false)
		{	
			[msgLabelP setText:_VMS_RECORDING_MSG1_];
			[secondLabelP setText:[NSString stringWithFormat:@"%d", self->maxTime]];
			previewButtonP.enabled  = NO;
			sendButtonP.enabled  = NO;
			sendButtonP.imageEdgeInsets = UIEdgeInsetsMake (0., 0., 0., 5.);
			//[sendButtonP setTitle:@"Send" forState:UIControlStateNormal];
			//sendButtonP.titleShadowOffset = CGSizeMake(0,-1);
			[sendButtonP setTitleShadowColor:[[UIColor darkGrayColor] autorelease ] forState:UIControlStateNormal];
			[sendButtonP setTitleShadowColor:[UIColor colorWithWhite:0. alpha:0.2]  forState:UIControlStateDisabled];
			[sendButtonP setTitleColor:[[UIColor grayColor] autorelease ]  forState:UIControlStateHighlighted];
			[sendButtonP setTitleColor:[[UIColor grayColor] autorelease ]  forState:UIControlStateDisabled];
			
			//[sendButtonP setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5]  forState:UIControlStateDisabled];
			previewButtonP.imageEdgeInsets = UIEdgeInsetsMake (0., 0., 0., 5.);
			//[sendButtonP setTitle:@"Send" forState:UIControlStateNormal];
			//previewButtonP.titleShadowOffset = CGSizeMake(0,-1);
			[previewButtonP setTitleShadowColor:[[UIColor darkGrayColor] autorelease ]  forState:UIControlStateNormal];
			[previewButtonP setTitleShadowColor:[UIColor colorWithWhite:0. alpha:0.2]  forState:UIControlStateDisabled];
			[previewButtonP setTitleColor:[[UIColor grayColor] autorelease ]  forState:UIControlStateHighlighted];
			[previewButtonP setTitleColor:[[UIColor grayColor] autorelease ]  forState:UIControlStateDisabled];
			
			//[previewButtonP setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5]  forState:UIControlStateDisabled];
			
			[self setButtonTitle:@"Record" forState:UIControlStateNormal];
			[self setButtonTitle:@"Record" forState:UIControlStateHighlighted];
			[sendButtonP setTitle:@"Send" forState:UIControlStateNormal];
			[sendButtonP setTitle:@"Send" forState:UIControlStateHighlighted];
			[previewButtonP setTitle:@"Preview" forState:UIControlStateNormal];
			[previewButtonP setTitle:@"Preview" forState:UIControlStateHighlighted];
		}
		self.navigationItem.leftBarButtonItem = nil;
		self.navigationItem.rightBarButtonItem = [ [ [ UIBarButtonItem alloc ]
													initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
													target: self
													action: @selector(cancelClicked) ] autorelease ];	
		/*
		deleteButton = [[UIButton alloc] init];
		// The default size for the save button is 49x30 pixels
		deleteButton.frame = CGRectMake(0, 0, 60, 30.0);
		
		// Center the text vertically and horizontally
		deleteButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		UIImage *image = [UIImage imageNamed:@"bottombarred_pressed.png"];
		
		// Make a stretchable image from the original image
		UIImage *stretchImage = [image stretchableImageWithLeftCapWidth:15.0 topCapHeight:0.0];
		
		// Set the background to the stretchable image
		[deleteButton setBackgroundImage:stretchImage forState:UIControlStateNormal];
		
		// Make the background color clear
		deleteButton.backgroundColor = [UIColor clearColor];
		
		// Set the font properties
		[deleteButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
		deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
		
		
		[deleteButton setTitle:@"Cancel" forState:UIControlStateNormal];
		
		[deleteButton addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
		
		UIBarButtonItem *navButton = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
		
		self.navigationItem.rightBarButtonItem = navButton;
		
		[navButton release];
		[deleteButton release];
		*/
	}
	
	amt = 0.0;
	maxtimeDouble = maxTime;
	[ownerobject setVmsDelegate:self];
	



}
#pragma mark NAVIGATIONOBJECT
// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
	
	if(viewController !=self)
	{
	//	[self->ownerobject setVmsDelegate:nil];
		[self->ownerobject setVmsDelegate:nil];
		[self stopButtonPressed:nil];
		[self VmsStop];
		
		
	}
	else
	{
		[self->ownerobject setVmsDelegate:self];
	}
}
- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item
{
	
}
#pragma mark NAVIGATIONEND
- (void)setButtonTitle : (NSString *)ltitle forState: (UIControlState)state
{
	NSString *title;
	title = [ltitle uppercaseString ];
	if([title isEqualToString:@"PLAY"])
	{
		UIImage *buttonBackground;
		UIImage *buttonBackgroundPressed;
		
		buttonBackground = [UIImage imageNamed:_PLAY_NORMAL_PNG_];
		buttonBackgroundPressed = [UIImage imageNamed:_PLAY_PRESSED_PNG_];
		[CustomButton setImages:PlayButtonP image:buttonBackground imagePressed:buttonBackgroundPressed change:NO];
		[buttonBackground release];
		[buttonBackgroundPressed release];
		PlayButtonP.backgroundColor =  [UIColor clearColor];
		
		
	}
	if([title isEqualToString:@"RECORD"])
	{
		UIImage *buttonBackground;
		UIImage *buttonBackgroundPressed;
		
		buttonBackground = [UIImage imageNamed:_RECORD_NORMAL_PNG_];
		buttonBackgroundPressed = [UIImage imageNamed:_RECORD_PRESSED_PNG_];
		[CustomButton setImages:PlayButtonP image:buttonBackground imagePressed:buttonBackgroundPressed change:NO];
		[buttonBackground release];
		[buttonBackgroundPressed release];
		PlayButtonP.backgroundColor =  [UIColor clearColor];
		
		
	}
	if([title isEqualToString:@"STOP"])
	{
		
		UIImage *buttonBackground;
		UIImage *buttonBackgroundPressed;
		
		buttonBackground = [UIImage imageNamed:_DONE_NORMAL_PNG_];
		buttonBackgroundPressed = [UIImage imageNamed:_DONE_PRESSED_PNG_];
		[CustomButton setImages:PlayButtonP image:buttonBackground imagePressed:buttonBackgroundPressed change:NO];
		[buttonBackground release];
		[buttonBackgroundPressed release];
		PlayButtonP.backgroundColor =  [UIColor clearColor];
		
	}
	if([title isEqualToString:@"RERECORD"])
	{
		
		UIImage *buttonBackground;
		UIImage *buttonBackgroundPressed;
		
		buttonBackground = [UIImage imageNamed:_RERECORD_NORMAL_PNG_];
		buttonBackgroundPressed = [UIImage imageNamed:_RERECORD_PRESSED_PNG_];
		[CustomButton setImages:PlayButtonP image:buttonBackground imagePressed:buttonBackgroundPressed change:NO];
		[buttonBackground release];
		[buttonBackgroundPressed release];
		PlayButtonP.backgroundColor =  [UIColor clearColor];
		
		
	}
	
	
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	doNothing = 0;
	
#ifdef PROGRESS_VIEW
	uiProgBarP.userInteractionEnabled = NO;
	
#else
	sliderP.userInteractionEnabled = NO;
#endif
	
	recordVmsB = false;
	[ownerobject setVmsDelegate:self];
	if(vmstateType==VMSStateRecord)
	{
		[self setTitle:@"Compose VMS"];
	}
	else
	{	
		[self setTitle:@"VMS"];
	}
	
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	firstSectionviewP.backgroundColor = [[UIColor clearColor] autorelease ] ;
	secondSectionviewP.backgroundColor = [[UIColor clearColor] autorelease ] ;

	tableView.delegate = self;
	tableView.dataSource = self;
	//tableView.sectionHeaderHeight = tableView.sectionHeaderHeight-7;
	tableView.sectionFooterHeight = tableView.sectionFooterHeight+2;   	
	tableView.scrollEnabled = NO;
	UIImage *buttonBackground;
	UIImage *buttonBackgroundPressed;
	
	buttonBackground = [UIImage imageNamed:@"5_play_270_45_normal.png"];
	buttonBackgroundPressed = [UIImage imageNamed:@"5_play_270_45_pressed.png"];
	[CustomButton setImages:PlayButtonP image:buttonBackground imagePressed:buttonBackgroundPressed change:NO];
	[buttonBackground release];
	[buttonBackgroundPressed release];
	PlayButtonP.backgroundColor =  [UIColor clearColor];
	[PlayButtonP addTarget:self action:@selector(playPressed:) forControlEvents: UIControlEventTouchUpInside];

	loadedB = true;
	[self loadOtherView];	
	[self makeView];
	[tableView reloadData];
	[self navigationController].delegate = self;
	/*self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"All VMSes" 
											   style:UIBarButtonItemStylePlain 
											   target:self 
											   action:@selector(cancelClicked)] autorelease];*/

	
		/*self.navigationItem.leftBarButtonItem = [ [ [ UIBarButtonItem alloc ]
											   initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
											   target: self
											   action: @selector(cancelClicked) ] autorelease ];*/
	
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	
		
}	
-(IBAction)cancelClicked
{
	
	//[self stopButtonPressed:nil];
	if(vmstateType==VMSStatePlay)// || vmstateType==VMSStateForward || modalB==true)
	{	
		[ [self navigationController] popViewControllerAnimated:YES ];
	}
	else
	{	
		
		[self stopButtonPressed:nil];
		//[ ownerobject.vmsNavigationController popViewControllerAnimated:NO ];
		[ownerobject.tabBarController dismissModalViewControllerAnimated:YES];
		
	}	
	
}

-(void) loadContactDetails : (char*) numberCharP 

{
	
	struct AddressBook *addressP;
	char type[30];
	//forwardNoChar[0] = 0;
	addressP = getContactAndTypeCall(numberCharP,type);	
	selectP = 0;
	if(addressP)
	{
		
		ContactDetailsViewController     *ContactControllerDetailsviewP;	
		if(vmstateType==VMSStateRecord)
		{	
			selectP = (SelectedContctType*)malloc(sizeof(SelectedContctType)+4);
		}
		ContactControllerDetailsviewP = [[ContactDetailsViewController alloc] initWithNibName:@"contactDetails" bundle:[NSBundle mainBundle]];
		returnValueInt = 0;
		[ContactControllerDetailsviewP setReturnValue:&returnValueInt selectedContactNumber:0  rootObject:self selectedContact:selectP] ;
	
		[ContactControllerDetailsviewP setAddressBook:addressP editable:false :CONTACTDETAILFROMVMS];
		[ContactControllerDetailsviewP setTitlesString:@"Contact details"];
		[ContactControllerDetailsviewP setSelectedNumber:numberCharP showAddButton:NO ];
		[ContactControllerDetailsviewP setObject:self->ownerobject];
		
		[ [self navigationController] pushViewController:ContactControllerDetailsviewP animated: YES ];
		
		if([ContactControllerDetailsviewP retainCount]>1)
			[ContactControllerDetailsviewP release];
	}
	else
	{
		addressP = (struct AddressBook *)malloc(sizeof(struct AddressBook ));
		memset(addressP,0,sizeof(struct AddressBook));
		addressP->id = -1;
		strcpy(addressP->title,numberCharP);
		if(strstr(numberCharP,"@")==0)
		{	
			if(strlen(numberCharP)==SPOKN_ID_RANGE)
			{
				strcpy(addressP->spoknid,numberCharP);
			}
			else
			{	
				strcpy(addressP->mobile,numberCharP);
			}
		}
		else
		{
				strcpy(addressP->email,numberCharP);//it is email address
		}
		ContactDetailsViewController     *ContactControllerDetailsviewP;	
		ContactControllerDetailsviewP = [[ContactDetailsViewController alloc] initWithNibName:@"contactDetails" bundle:[NSBundle mainBundle]];
		returnValueInt = 0;
		[ContactControllerDetailsviewP setReturnValue:&returnValueInt selectedContactNumber:0  rootObject:self selectedContact:0]  ;
		
		[ContactControllerDetailsviewP setAddressBook:addressP editable:false :CONTACTDETAILFROMVMS];
		[ContactControllerDetailsviewP setTitlesString:@"Contact details"];
		[ContactControllerDetailsviewP setSelectedNumber:numberCharP showAddButton:YES ];
		[ContactControllerDetailsviewP setObject:self->ownerobject];
		
		[ [self navigationController] pushViewController:ContactControllerDetailsviewP animated: YES ];
		
		if([ContactControllerDetailsviewP retainCount]>1)
			[ContactControllerDetailsviewP release];
		free(addressP);
		addressP = 0;
		
	
	
	}
		
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void)setvmsDetail:(char*)lnoCharP :(char*)lnameCharP :(char*)ltypeCharP :(VMSStateType)lVMSStateType :(int)lmaxTime :(struct VMail*) lvmailP
{
	//NSString *nsp;
	if(noCharP) free(noCharP);
	if(nameCharP) free(nameCharP);
	if(typeCharP) free(typeCharP);
	if(vmailP) free(vmailP);
	noCharP = malloc(strlen(lnoCharP)+4);
	strcpy(noCharP,lnoCharP);
	nameCharP = malloc(strlen(lnameCharP)+4);
	strcpy(nameCharP,lnameCharP);
	typeCharP = malloc(strlen(ltypeCharP)+4);
	strcpy(typeCharP,ltypeCharP);
	vmailP = 0;
	contactFindB = 1;
	if(strcmp(lnoCharP, lnameCharP)==0)
	{
		contactFindB = 0;
	
	}
	if(lvmailP)
	{
		vmailP = malloc(sizeof(struct VMail)+4);
		*vmailP = *lvmailP;
	}
	tablesz = 0;
	if(lVMSStateType==VMSStateRecord)
	{
		if(strlen(lnoCharP)>0)
		{	
			openForwardNo = true;
			strcpy(forwardContact.nameChar,lnameCharP);
			strcpy(forwardContact.number,lnoCharP);
			strcpy(forwardContact.type,ltypeCharP);
		}	
	}
	//noCharP =[ [NSString alloc] initWithUTF8String:lnoCharP];
	//nameCharP =[ [NSString alloc] initWithUTF8String:lnameCharP];
	//typeCharP = [[NSString alloc] initWithUTF8String:ltypeCharP];
	vmstateType = lVMSStateType;
	if(lmaxTime>20 && lmaxTime<22)
	{
		lmaxTime = 20;
	}
	maxTime = lmaxTime;
	maxTimeLoc = maxTime;
	for(int i=0;i<MAX_SECTION;++i)
	{
		memset(&sectionArray[i],0,sizeof(SectionContactType));
	}
}	
-(void)makeView
{
	int secIndex=0;
	for(int i=0;i<MAX_SECTION;++i)
	{
		memset(&sectionArray[i],0,sizeof(SectionContactType));
	}
	if(vmstateType==VMSStatePlay)
	{	
		sectionArray[secIndex].dataforSection[tablesz].section = 0;
	//strcpy(sectionArray[0].dataforSection[tablesz].nameofRow,"Add home number");
		sectionArray[secIndex].dataforSection[tablesz].elementP = nameCharP;//addressDataP->home;
		sectionArray[secIndex].dataforSection[tablesz].secRowP = typeCharP;
		sectionArray[secIndex].count++;
		sectionArray[secIndex].dataforSection[tablesz].addNewB = true;
		secIndex++;
	}
	
	sectionArray[secIndex].dataforSection[tablesz].elementP = 0;//addressDataP->home;
	sectionArray[secIndex].dataforSection[tablesz].secRowP = 0;
	sectionArray[secIndex].sectionheight = 120;
	sectionArray[secIndex].sectionView = 0;
	//if(playB)
	sectionArray[secIndex].sectionView = firstSectionviewP;
	
	sectionArray[secIndex].count=0;
	secIndex++;
	#ifdef PROGRESS_VIEW
	sectionArray[secIndex].dataforSection[tablesz].customViewP = progressandplayviewP;//addressDataP->home;
	sectionArray[secIndex].dataforSection[tablesz].rowHeight = ROW_PLAY_HEIGHT;
	#else
	sectionArray[secIndex].dataforSection[tablesz].customViewP = sliderP;//addressDataP->home;

	#endif
	sectionArray[secIndex].dataforSection[tablesz].secRowP = 0;
	sectionArray[secIndex].sectionheight = 30;
	sectionArray[secIndex].sectionView = 0;
	sectionArray[secIndex].count++;
	secIndex++;
	sectionArray[secIndex].dataforSection[tablesz].customViewP = 0;//addressDataP->home;
	sectionArray[secIndex].dataforSection[tablesz].secRowP = 0;
	sectionArray[secIndex].sectionheight = 150;
	sectionArray[secIndex].sectionView = secondSectionviewP;
	secIndex++;
	sectionCount = secIndex;
	
	
	
	
	//sectionArray[1].dataforSection[tablesz].addNewB = true;
	
	
	
	//tablesz++;
	
}	
-(void)setFileName:(char*)lfileNameCharP :(int*) lreturnValLongP
{
	fileNameCharP = malloc(strlen(lfileNameCharP)+2);
	strcpy(fileNameCharP,lfileNameCharP);
	returnValLongP = lreturnValLongP;
}
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
	//[self navigationController].delegate = nil;
	[ownerobject setVmsDelegate:nil];
	ownerobject.vmsNavigationController.delegate = nil;
	if(shiftVmailB)
	{	
		ownerobject.tabBarController.selectedViewController = ownerobject.vmsNavigationController;
	}
		
	
	
	if(nsTimerP)
	{	
		[nsTimerP invalidate];
		if(vmstateType==VMSStateRecord)
		{
			[ownerobject vmsStop:true];
		}
		else
		{
			[ownerobject vmsStop:false];
		}
		nsTimerP =nil;
	}
	if(fileNameCharP)
	{
		free(fileNameCharP);
		fileNameCharP = 0;
	}
	if(selectP)
	{
		free(selectP);
		selectP = 0;
	}

	[pickerviewcontrollerviewP release];
	
	if(noCharP)
	free(noCharP);
	
	if(nameCharP)
	free(nameCharP);
	if(typeCharP)
	free(typeCharP);
	if(vmailP)
		free(vmailP);	
	
	pickerviewcontrollerviewP  = nil;
	ownerobject = 0;
	noCharP = 0;
	nameCharP = 0;
	typeCharP = 0;
	vmailP = 0;
	
	[super dealloc];
	
	//self = nil;
	
	
    
}


@end
