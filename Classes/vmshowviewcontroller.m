//
//  vmshowviewcontroller.m
//  spokn
//
//  Created by Mukesh Sharma on 07/10/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import "vmshowviewcontroller.h"
#import "SpoknAppDelegate.h"

@implementation VmShowViewController
#pragma mark button action
-(IBAction)sendPressed:(id)sender
{
	printf("\n send pressed");
	if(playB)
	{
		openForwardNo = 0;
		
		forwardNoChar[0] = 0;
		//showContactScreen:(id) navObject returnnumber:(char*) noCharP  result:(int *) resultP
		[ownerobject showContactScreen:self returnnumber:forwardNoChar result:&openForwardNo];
		
		
		
	}
	else
	{	
		[ownerobject vmsSend:noCharP :fileNameCharP];
	}	
}

-(IBAction)cancelClicked
{
	[ [self navigationController] popViewControllerAnimated:YES ];
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
	if(returnValLongP)
	{	
		*returnValLongP = 1;
	}
	vmsDeleteByID(vmailP->vmsid);
	[ [self navigationController] popViewControllerAnimated:YES ];

	//[ [self navigationController] popToRootViewControllerAnimated:YES ];
	//contactID = -1;
//	profileResync();
	
	
}

- (void)VmsStart
{
	
}
- (void)VmsStop
{
	[nsTimerP invalidate];
	nsTimerP = 0;
	printf("\n stop");
	[PlayButtonP addTarget:self action:@selector(playPressed:) forControlEvents: UIControlEventTouchUpInside];
	if(playB)
	{	
		[PlayButtonP setTitle:@"Play" forState:UIControlStateNormal];
		[PlayButtonP setTitle:@"Play" forState:UIControlStateHighlighted];
	}
	else
	{
		[PlayButtonP setTitle:@"Record" forState:UIControlStateNormal];
		[PlayButtonP setTitle:@"Record" forState:UIControlStateHighlighted];
	}
	self->maxtimeDouble=maxTime;
	[secondLabelP setText:[NSString stringWithFormat:@"%d", self->maxtimeDouble]];
	amt = 0.0;
	previewButtonP.enabled  = YES;
	sendButtonP.enabled  = YES;
	sliderP.value = 0.0f;

	
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
		if(playB==false)
		{
			[ownerobject vmsStop:!playB];
		}
	}
	printf("\n timer progress count %f",amt);
	
}
-(IBAction)stopButtonPressed:(id)sender
{
	printf("\n stop pressed");
	if([ownerobject vmsStop:!playB])
	{
		printf("\n error");
		[self VmsStop];
	}
	
}

-(IBAction)playPressed:(id)sender
{
	printf("\n playPressed pressed");
	unsigned long sz;
	if(playB)
	{
		if([ownerobject vmsPlayStart:fileNameCharP :&sz])
			return;
		if([ownerobject VmsStreamStart:false])
		{
			UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"Error" 
															   message: [ NSString  stringWithFormat:@" can not play vms", forwardNoChar]
															  delegate: nil
													 cancelButtonTitle: nil
													 otherButtonTitles: @"OK", nil
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
			UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"Error" 
															   message: [ NSString  stringWithFormat:@" can not play vms", forwardNoChar]
															  delegate: nil
													 cancelButtonTitle: nil
													 otherButtonTitles: @"OK", nil
								  ];
			[ alert show ];
			[alert release];
			return;
		}
	}
	nsTimerP = [NSTimer scheduledTimerWithTimeInterval: 1.0
				
												target: self
				
											  selector: @selector(handleTimer:)
				
											  userInfo: nil
				
											   repeats: YES];
	[PlayButtonP addTarget:self action:@selector(stopButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
	[PlayButtonP setTitle:@"Stop" forState:UIControlStateNormal];
	[PlayButtonP setTitle:@"Stop" forState:UIControlStateHighlighted];
	previewButtonP.enabled  = NO;
	sendButtonP.enabled  = NO;

	

}
-(IBAction)previewPressed:(id)sender
{

	printf("\n previewPressed pressed");
	if(playB==false)
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
		[ownerobject VmsStreamStart:false];
		self->maxtimeDouble=sz;
		maxTimeLoc = sz;
		nsTimerP = [NSTimer scheduledTimerWithTimeInterval: 1.0
				
												target: self
				
											  selector: @selector(handleTimer:)
				
											  userInfo: nil
				
											   repeats: YES];
		[PlayButtonP addTarget:self action:@selector(stopButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
		[PlayButtonP setTitle:@"Stop" forState:UIControlStateNormal];
		[PlayButtonP setTitle:@"Stop" forState:UIControlStateHighlighted];
		previewButtonP.enabled  = NO;
		sendButtonP.enabled  = NO;
	}	
	else
	{
		playB = false;
		maxTime = 20;
		maxTimeLoc = 20;
		strcpy(fileNameCharP,"temp");
		[self loadOtherView];
	}
	


}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
				
			
				[cell.contentView addSubview:sectionArray[section].dataforSection[row].customViewP];
				[sectionArray[section].dataforSection[row].customViewP release];
				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			}
			else
			{
				CGRect cellRect = CGRectMake(0, 0, 320, 50);
				
				cell = [ [ [ SpoknUITableViewCell alloc ] initWithFrame: cellRect reuseIdentifier: CellIdentifier ] autorelease] ;
				//cell->resusableCount = [ indexPath indexAtPosition: 1 ];
				
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
	if(secLocP==0)
	{
		[CellIdentifier release];
		return cell;
	}	
	if(sectionArray[section].dataforSection[row].customViewP==0)
	{	
		cell.spoknSubCellP.userData = secLocP;
		cell.spoknSubCellP.dataArrayP = secLocP->elementP;
		cell.spoknSubCellP.ownerDrawB = true;
		cell.spoknSubCellP.rowHeight = 50;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
		//  [dataController addData:@"New Row Added"];
		printf("\n add clicked");
		// [tableView reloadData];        
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
	printf("\nsection %d %d \n",lsection,row);
	//objStrP = sectionArray[lsection].dataforSection[row].nameofRow;
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
				[dispP.colorP release];
				[secLocP->elementP addObject:dispP];
				
				// [cell setNeedsDisplay];
			}	
			if(typeCallP)
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
			}	
			
			
			[secLocP->elementP addObject:dispP];
			
			
			
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
	printf("\n preeesed select");
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
	CGContextSetFillColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
	CGContextFillEllipseInRect(context, aRect);
	
	// Inner circle with feedback levels
	CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:percentage green:0.0f blue:0.0f alpha:1.0f] CGColor]);
	CGContextFillEllipseInRect(context, CGRectInset(aRect, 4.0f, 4.0f));
	
	// Inner gray circle
	CGContextSetFillColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
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


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
	#ifdef PROGRESS_VIEW
		uiProgBarP = [[UIProgressView alloc] initWithFrame:
					  			   
					   CGRectMake(10.0f, 17.0f, 280.0f, 20.0f)];
		//[uiProgBarP backgroundColor:[UIColor redColor]];
		uiProgBarP.progressViewStyle = UIProgressViewStyleBar;
		//uiProgBarP.backgroundColor = uiActionSheetP.backgroundColor;//[UIColor blueColor];
		uiProgBarP.progressViewStyle= UIProgressViewStyleBar;
		uiProgBarP.tag = 12;
	#else
		sliderP = [[UISlider alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 280.0f, 30.0f)];
		sliderP.backgroundColor = [UIColor clearColor];
		//activeImageP=[UIImage imageNamed:@"vms_out_Active.png"];
		//dileverImageP=[UIImage imageNamed:@"vmail_out_newHigh.png"];
		
		sliderP.minimumValueImage = [UIImage imageNamed:@"vmsprogressleft.png"];
		[sliderP.minimumValueImage release];
		sliderP.maximumValueImage = [UIImage imageNamed:@"vmsprogressleft.png"];
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
		
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if(openForwardNo)
	{
		printf("\n make changes");
		openForwardNo = 0;
		[ownerobject vmsForward:forwardNoChar :fileNameCharP];		
		UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
														   message: [ NSString  stringWithFormat:@" vmail is sent to %s", forwardNoChar]
														  delegate: nil
												 cancelButtonTitle: nil
												 otherButtonTitles: @"OK", nil
							  ];
		[ alert show ];
		[alert release];
		
		
		forwardNoChar[0] = 0;
	}
	if(returnValueInt)
	{
		if(playB==false)
		{	
			printf("\n selected no %s",forwardNoChar);
			//forwardNoChar[0]=0;
			returnValueInt = 0;
			if(selectP)
			{
				struct VMail* lvmailP;
				lvmailP = vmailP;
				vmailP =0;
				printf("\n selected type %s %s %s",forwardNoChar,selectP->nameChar,selectP->type);
				[self setvmsDetail: forwardNoChar : selectP->nameChar :selectP->type :playB :maxTime :lvmailP];
				free(selectP);
				if(lvmailP)
				{
					free(lvmailP);
				}
				selectP = 0;
			}
			forwardNoChar[0]=0;
			[self loadOtherView];
			[self makeView];
			[self->tableView reloadData];
		}	
	
	}
}	

-(void)setObject:(id) object 
{
	self->ownerobject = object;
}



-(void)loadOtherView
{
	if(playB)
	{
		char s1[50];
		char *month[12]={"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
		
		//char *month[12]={"January","February","March","April","May","June","July","August","September","October","November","December"};
		[PlayButtonP setTitle:@"Play" forState:UIControlStateNormal];
		[PlayButtonP setTitle:@"Play" forState:UIControlStateHighlighted];
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
				sprintf(s1,"%02d:%02d AM on  %02d %3s %d",(tmP1.tm_hour)?tmP1.tm_hour:12,tmP1.tm_min,tmP1.tm_mday,month[tmP1.tm_mon],tmP1.tm_year+1900);
			}
			else
			{	
				sprintf(s1,"%02d:%02d PM on  %02d %3s %d",(tmP1.tm_hour-12)?(tmP1.tm_hour-12):12,tmP1.tm_min,tmP1.tm_mday,month[tmP1.tm_mon],tmP1.tm_year+1900);
			}
			if(vmailP->direction&VMAIL_IN)
			{	
				[msgLabelP setText:[NSString stringWithFormat:@"Incoming VMS\n%s", s1]];
			}
			else
			{
				[msgLabelP setText:[NSString stringWithFormat:@"Outgoing VMS\n%s", s1]];
			}
			
		}	
		[secondLabelP setText:[NSString stringWithFormat:@"%d", self->maxTime]];
		
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
		
		
		[deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
		
		[deleteButton addTarget:self action:@selector(deleteClicked) forControlEvents:UIControlEventTouchUpInside];
		
		UIBarButtonItem *navButton = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
		
		self.navigationItem.rightBarButtonItem = navButton;
		
		[navButton release];
		[deleteButton release];
		
		
	//	self.navigationItem.rightBarButtonItem = [ [ [ UIBarButtonItem alloc ] initWithTitle:@"Delete" style:UIBarButtonItemStyleDone target:self action:@selector(deleteClicked)] autorelease];
		
		
	}
	else
	{
		
		
		[msgLabelP setText:@"Press the record button to record a\n20 second long VMS "];
		[secondLabelP setText:[NSString stringWithFormat:@"%d", self->maxTime]];
		previewButtonP.enabled  = NO;
		sendButtonP.enabled  = NO;
		[PlayButtonP setTitle:@"Record" forState:UIControlStateNormal];
		[PlayButtonP setTitle:@"Record" forState:UIControlStateHighlighted];
		[sendButtonP setTitle:@"Send" forState:UIControlStateNormal];
		[sendButtonP setTitle:@"Send" forState:UIControlStateHighlighted];
		[previewButtonP setTitle:@"Preview" forState:UIControlStateNormal];
		[previewButtonP setTitle:@"Preview" forState:UIControlStateHighlighted];
		self.navigationItem.rightBarButtonItem  = nil;
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
		
	}
	
	amt = 0.0;
	maxtimeDouble = maxTime;
	[ownerobject setVmsDelegate:self];
//	printf("\n maxtime download %d",self->maxTime);
	



}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	firstSectionviewP.backgroundColor = [UIColor groupTableViewBackgroundColor];
	secondSectionviewP.backgroundColor = [UIColor groupTableViewBackgroundColor];

	tableView.delegate = self;
	tableView.dataSource = self;
	loadedB = true;
	[self loadOtherView];	
	[self makeView];
	[tableView reloadData];
	self.navigationItem.leftBarButtonItem = [ [ [ UIBarButtonItem alloc ]
											   initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
											   target: self
											   action: @selector(cancelClicked) ] autorelease ];
	
}

-(void) loadContactDetails : (char*) numberCharP 

{
	
	struct AddressBook *addressP;
	char type[30];
	forwardNoChar[0] = 0;
	addressP = getContactAndTypeCall(numberCharP,type);	
	selectP = 0;
	if(addressP)
	{
		ContactDetailsViewController     *ContactControllerDetailsviewP;	
		if(playB==false)
		{	
			selectP = (SelectedContctType*)malloc(sizeof(SelectedContctType)+4);
		}
		ContactControllerDetailsviewP = [[ContactDetailsViewController alloc] initWithNibName:@"contactDetails" bundle:[NSBundle mainBundle]];
		returnValueInt = 0;
		[ContactControllerDetailsviewP setReturnValue:&returnValueInt selectedContact:forwardNoChar  rootObject:self selectedContact:selectP] ;
	
		[ContactControllerDetailsviewP setAddressBook:addressP editable:false :CONTACTFORWARDVMS];
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
		if(strlen(numberCharP)==SPOKN_ID_RANGE)
		{
			strcpy(addressP->spoknid,numberCharP);
		}
		else
		{	
			strcpy(addressP->other,numberCharP);
		}
		ContactDetailsViewController     *ContactControllerDetailsviewP;	
		ContactControllerDetailsviewP = [[ContactDetailsViewController alloc] initWithNibName:@"contactDetails" bundle:[NSBundle mainBundle]];
		returnValueInt = 0;
		[ContactControllerDetailsviewP setReturnValue:&returnValueInt selectedContact:forwardNoChar  rootObject:self selectedContact:0]  ;
		
		[ContactControllerDetailsviewP setAddressBook:addressP editable:false :CONTACTFORWARDVMS];
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

-(void)setvmsDetail:(char*)lnoCharP :(char*)lnameCharP :(char*)ltypeCharP :(Boolean)lplayB :(int)lmaxTime :(struct VMail*) lvmailP
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
	if(lvmailP)
	{
		vmailP = malloc(sizeof(struct VMail)+4);
		*vmailP = *lvmailP;
	}
	tablesz = 0;
	//noCharP =[ [NSString alloc] initWithUTF8String:lnoCharP];
	//nameCharP =[ [NSString alloc] initWithUTF8String:lnameCharP];
	//typeCharP = [[NSString alloc] initWithUTF8String:ltypeCharP];
	playB = lplayB;
	maxTime = lmaxTime;
	maxTimeLoc = maxTime;
		printf("\n maxtime set %d",self->maxTime);
	for(int i=0;i<MAX_SECTION;++i)
	{
		memset(&sectionArray[i],0,sizeof(SectionContactType));
	}
}	
-(void)makeView
{
	sectionArray[0].dataforSection[tablesz].section = 0;
	//strcpy(sectionArray[0].dataforSection[tablesz].nameofRow,"Add home number");
	sectionArray[0].dataforSection[tablesz].elementP = nameCharP;//addressDataP->home;
	sectionArray[0].dataforSection[tablesz].secRowP = typeCharP;
	sectionArray[0].count++;
	sectionArray[0].dataforSection[tablesz].addNewB = true;
	
	sectionArray[1].dataforSection[tablesz].elementP = 0;//addressDataP->home;
	sectionArray[1].dataforSection[tablesz].secRowP = 0;
	sectionArray[1].sectionheight = 100;
	sectionArray[1].sectionView = firstSectionviewP;
	
	sectionArray[1].count=0;
	#ifdef PROGRESS_VIEW
	sectionArray[2].dataforSection[tablesz].customViewP = uiProgBarP;//addressDataP->home;
	#else
	sectionArray[2].dataforSection[tablesz].customViewP = sliderP;//addressDataP->home;

	#endif
	sectionArray[2].dataforSection[tablesz].secRowP = 0;
	sectionArray[2].sectionheight = 30;
	sectionArray[2].sectionView = 0;
	sectionArray[2].count++;
	
	sectionArray[3].dataforSection[tablesz].customViewP = 0;//addressDataP->home;
	sectionArray[3].dataforSection[tablesz].secRowP = 0;
	sectionArray[3].sectionheight = 150;
	sectionArray[3].sectionView = secondSectionviewP;
	
	sectionCount = 4;
	
	sectionArray[1].count=0;
	
	
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
	[ownerobject setVmsDelegate:nil];
}


- (void)dealloc {
	if(nsTimerP)
	{	
		[nsTimerP invalidate];
		[ownerobject vmsStop:!playB];
	}
	if(fileNameCharP)
	{
		free(fileNameCharP);
	}
	if(selectP)
	{
		free(selectP);
		selectP = 0;
	}
	
	if(noCharP)
	free(noCharP);
	if(nameCharP)
	free(nameCharP);
	if(typeCharP)
	free(typeCharP);
	if(vmailP)
		free(vmailP);	
	
    [super dealloc];
}


@end
