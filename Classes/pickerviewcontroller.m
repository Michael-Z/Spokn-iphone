
//  Created on 27/10/09.


/**
  Copyright 2009, 2010 Geodesic Limited. <http://www.geodesic.com/>
 
 Spokn for iPhone.
 
 This file is part of Spokn for iPhone.
 
 Spokn for iPhone is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, version 2 of the License.
  
 Spokn for iPhone is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Spokn for iPhone.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "pickerviewcontroller.h"
#include "ua.h"
#import "GTokenField.h"
#import "GTokenFieldCell.h"
#import "Contact.h"
#import "ContactCell.h"
#import "contactviewcontroller.h"
#import "spoknAppDelegate.h"
#include "alertmessages.h"
#import "contactlookup.h"
@implementation MyLabel
@synthesize upDateProtocolP;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	[upDateProtocolP upDateScreen];
}
@end

@implementation pickerviewcontroller
@synthesize upDateProtocolP;

- (void)upDateScreen
{

	[txtDestNo becomeFirstResponder];
	
	
	txtDestNo.hidden = NO;
	toLabel.userInteractionEnabled = NO;
	toLabelStart.hidden = YES;
	toLabelStart.userInteractionEnabled = NO;
	toLabel.hidden = YES;
	_composerScrollView.hidden = NO;
	if(modalB==false)
	{	
		self.view.frame = CGRectMake(0, 0, 320,200 );
	//self.view.frame = CGRectMake(0, 0, 320,txtDestNo.frame.size.height );
		[upDateProtocolP upDateScreen];
	}	
}
-(int) addElement :(NSMutableArray *)searchedContactsP contactObject:(Contact*)lcontactP
{
	Contact* tmpContactP;
	
	for(int i=0;i<searchedContactsP.count;++i)
	{
		tmpContactP = [searchedContactsP objectAtIndex:i];
		if(tmpContactP)
		{
			NSString *nmP;
			nmP = [self remSpChar:lcontactP.Name ];
			NSString *tmpContactWhiteSpaceP;
			tmpContactWhiteSpaceP = [self remSpChar:tmpContactP.Name];
			
			if([tmpContactP.Number isEqualToString: lcontactP.Number ] && [tmpContactWhiteSpaceP  isEqualToString: nmP ])
			{
				return 1;
			}
		}
	}
	[searchedContactsP addObject:lcontactP];
	return 0;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	
	
}
-(void)addSelectedContact:(SelectedContctType*)  lcontactObjectP
{
	
	if(lcontactObjectP==0)
	{
		return;
	}
	#ifdef _NAME_IN_TABLE_
	char* nameP;
	nameP = lcontactObjectP->nameChar;
	if(nameP)
	{	
		while(*nameP==' '){
			nameP++;
		}
		if(*nameP=='\0')
		{
			strcpy(lcontactObjectP->nameChar,lcontactObjectP->number);
		}
	}	
	else
	{
		strcpy(lcontactObjectP->nameChar,lcontactObjectP->number);
	}
		[txtDestNo addCellWithString:[NSString stringWithUTF8String:lcontactObjectP->nameChar] type:[NSString stringWithUTF8String:lcontactObjectP->number] ];

	#else	
		[txtDestNo addCellWithString:[NSString stringWithUTF8String:lcontactObjectP->number] type:[NSString stringWithUTF8String:lcontactObjectP->number] ];
	
	#endif
	
	toLabel.hidden = YES;
	toLabelStart.hidden = YES;
	_composerScrollView.hidden = NO;
	if(keyBoardOnB==false)
	{
		[self removeKeyBoard];
	}
	
	//free(nameP);
}
-(char*)getContactNumberList
{
	char *numberCharP = 0;
	NSString *resultP;

	resultP = [txtDestNo commaSeparatedNumber];
	if(resultP)
	{
		char* charStringP;
		charStringP =  (char*)[resultP cStringUsingEncoding:NSUTF8StringEncoding];
		if(charStringP)
		{
			numberCharP = malloc(strlen(charStringP)+10);
			strcpy(numberCharP,charStringP);
					
		}
		
	
	}
	return numberCharP;

}
-(IBAction)addContactPressed:(id)sender
{

	if(modalB)
	[upDateProtocolP addContact:self];
	else
		[upDateProtocolP addContact:nil];	
}
-(void)setObject:(id) object 
{
	self->ownerobject = object;
}
-(void)setData:/*out parameter*/(char *)valueCharP value:(char*)fieldP placeHolder:(char*)placeHolderP/*out parameter*/returnValue:(int *)returnP
{

}
-(IBAction)cancelPressed
{

}
-(IBAction)sendPressed
{
	[self update_txtDestNo:@""];
	char *allforwardNoCharP;
	allforwardNoCharP = [self getContactNumberList];
	if(allforwardNoCharP==0)
	{
	//	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:_TITLE_ message:_EMPTY_FORWARD_NUMBER_ delegate:self cancelButtonTitle:_OK_ otherButtonTitles: nil] autorelease];
		
	//	[alert show];
	//	[alert release];
	}
	else
	{
		[self->upDateProtocolP sendForwardVms:allforwardNoCharP];//this will send vms
		[[self navigationController] popToRootViewControllerAnimated:YES];
		free(allforwardNoCharP);
	}
}
-(void) SetkeyBoardType:(UIKeyboardType) type : (int) maxCharInt buttonType:(int)lbuttonType
{
	keyboardtype = type;
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
- (pickerviewcontroller *) init
{

	keyboardtype = UIKeyboardTypePhonePad;
	searchedContacts = nil;
	txtDestNo = nil;
	uaObject = GETCONTACTLIST;
	modalB = NO;

	return self;
}
-(void) viewLoadedModal:(BOOL)lmodalB
{
	modalB = lmodalB;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	
	SelectedContctType selectedContact;
	
	if([upDateProtocolP getForwardNumber:&selectedContact]==0)
	{
		

		[self addSelectedContact:&selectedContact];
	
	}

}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	keyBoardOnB = FALSE;
	searchedContacts = [[NSMutableArray alloc] init];
	searchArray = [[NSMutableArray alloc] init];
	UIView *contentView ;
	
	if(modalB==false)
	{	
		contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,50 )];
	}
	else
	{
		contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
		self.navigationItem.rightBarButtonItem 
		= [ [ [ UIBarButtonItem alloc ]
			 initWithTitle: _SEND_ style:UIBarButtonItemStyleDone
			 target: self
			 action: @selector(sendPressed) ] autorelease ];	
	}
	contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	contentView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | 
									UIViewAutoresizingFlexibleWidth | 
									UIViewAutoresizingFlexibleTopMargin | 
									UIViewAutoresizingFlexibleLeftMargin | 
									UIViewAutoresizingFlexibleRightMargin | 
									UIViewAutoresizingFlexibleBottomMargin);
	self.view = contentView;
	[contentView release];
	
	{
		if(modalB==false)	
		{	
			_composerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
		}
		else
		{
			_composerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 368 - 44)];
			
		}
		_composerScrollView.bounces = NO;
		_composerScrollView.bouncesZoom = NO;
		{	
			
			if(modalB==false)
			{	
				txtDestNo = [[GTokenField alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
				//txtDestNo.hidden = YES;
				//myLabelP  = [[MyLabel alloc ] initWithFrame:CGRectMake(0, 0, 320, 100)];
				//myLabelP.text = @"sj ";
			}
			else
			{
				txtDestNo = [[GTokenField alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
			}
			frameRect = txtDestNo.frame;
			txtDestNo.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
			txtDestNo.backgroundColor = [[UIColor whiteColor] autorelease];
			txtDestNo.delegate = self;
			txtDestNo.autocorrectionType = UITextAutocorrectionTypeNo;
			txtDestNo.autocapitalizationType = UITextAutocapitalizationTypeNone;	
			txtDestNo.rightViewMode = UITextFieldViewModeAlways;
			txtDestNo.clearsOnBeginEditing = NO;
			//txtDestNo.placeholder = @"Numerics only";
			txtDestNo.keyboardType = keyboardtype;
			txtDestNo.returnKeyType = UIReturnKeyDefault;
			txtDestNo.font = [UIFont systemFontOfSize:16.0];
			[txtDestNo addTarget:self action:@selector(updateSearchTable:) forControlEvents:UIControlEventEditingChanged];
			
			UIButton* addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
			[addButton addTarget:self action:@selector(addFromContact:) forControlEvents:UIControlEventTouchUpInside];
			txtDestNo.rightView = addButton;
			//[_composerScrollView addSubview:myLabelP];
			[_composerScrollView addSubview:txtDestNo];
			
			//txtDestNo.hidden = YES;
			MyLabel *toLabelScroll = [[MyLabel alloc] initWithFrame:CGRectMake(5, 0, 32, 38)];
			toLabelScroll.userInteractionEnabled = NO;
			toLabelScroll.text = @"To:";
			toLabelScroll.backgroundColor = [[UIColor clearColor] autorelease];
			toLabelScroll.textColor = [[UIColor grayColor] autorelease];
			toLabelScroll.upDateProtocolP = self;
			[_composerScrollView addSubview:toLabelScroll];
			
			toLabelStart = [[MyLabel alloc] initWithFrame:CGRectMake(0, 0, 40, 42)];
			toLabelStart.userInteractionEnabled = YES;
			toLabelStart.text = @" To: ";
			toLabelStart.backgroundColor = [[UIColor whiteColor] autorelease];
			toLabelStart.textColor = [[UIColor grayColor] autorelease];
			toLabelStart.upDateProtocolP = self;
			toLabelStart.hidden = YES;
			[self.view addSubview:toLabelStart];
			
			toLabel = [[MyLabel alloc] initWithFrame:CGRectMake(40, 0, 286, 42)];
			toLabel.userInteractionEnabled = YES;
			toLabel.text = @" To: ";
			toLabel.backgroundColor = [[UIColor whiteColor] autorelease];
			toLabel.textColor = [[UIColor blackColor] autorelease];
			toLabel.upDateProtocolP = self;
			toLabel.hidden = YES;
			[self.view addSubview:toLabel];
			
			
		}
		[self.view addSubview:_composerScrollView];
		if(modalB==false)
		{	
			tbl_contacts = [[UITableView alloc] initWithFrame:CGRectMake(0, 43, 320, 160) style:UITableViewStylePlain];
			
		}
		else
		{
			tbl_contacts = [[UITableView alloc] initWithFrame:CGRectMake(0, 43, 320, 200 - 43) style:UITableViewStylePlain];
			
		}
		tbl_contacts.rowHeight = 40;
		tbl_contacts.backgroundColor = [UIColor colorWithRed:0.925 green:0.925 blue:0.925 alpha:1];
		tbl_contacts.delegate = self;
		tbl_contacts.dataSource = self;
		[self.view addSubview:tbl_contacts];
		[self hideSearchTable];
		
		[self updateLayout];
		addressBook = ABAddressBookCreate();
	}
	
}

-(IBAction)addFromContact:(id)sender
{
	NSString *temp = [txtDestNo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if( ![temp isEqualToString:@""] )
	{
		[self update_txtDestNo:@""];
	}
	
	if(modalB)
		[upDateProtocolP addContact:self];
	else
		[upDateProtocolP addContact:nil];	
	
	
	/*	NSString *temp = [txtDestNo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if( ![temp isEqualToString:@""] )
	{
		[self update_txtDestNo];
		//return;
	}
	
	// creating the picker
	ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
	
	// place the delegate of the picker to the controll
	picker.peoplePickerDelegate = self;
	
	// showing the picker
	[self presentModalViewController:picker animated:YES];
	
	// releasing
	//[picker autorelease];*/
}
- (IBAction) updateSearchTable : (id) sender
{
	[searchedContacts removeAllObjects];
	const char *ltpsSearchStringP=0;
	NSString *texttosearch = [txtDestNo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	//texttosearch = [self remSpChar:texttosearch];
	
	// input validation
	
	if([texttosearch length] > 0)
	{
		ltpsSearchStringP = [texttosearch cStringUsingEncoding:NSUTF8StringEncoding];
		CFStringRef names = (CFStringRef)texttosearch;
		
		CFArrayRef people = ABAddressBookCopyPeopleWithName (addressBook,names);
		
		if( people )
		{
			CFIndex nPeople = CFArrayGetCount(people);
			
			for (int i=0;i < nPeople;i++) 
			{
				ABRecordRef ref = CFArrayGetValueAtIndex(people, i);
				
				NSString *name = @"";
				
				NSString *firstname = (NSString*)ABRecordCopyValue(ref,kABPersonFirstNameProperty);
				NSString *lastname = (NSString*)ABRecordCopyValue(ref, kABPersonLastNameProperty);
				
				if( firstname )
				{
					name = [[[name autorelease] stringByAppendingString:firstname] retain];
					name = [[[name autorelease] stringByAppendingString:@" "] retain];
				}
				
				if( lastname )
				{
					name = [[[name autorelease] stringByAppendingString:lastname] retain];
				}
				
				ABMultiValueRef phone_Array = [(NSString *)ABRecordCopyValue(ref, kABPersonPhoneProperty) autorelease];
				
				CFArrayRef peopleMobile = ABMultiValueCopyArrayOfAllValues(phone_Array);
				
				if( peopleMobile )
				{			
					NSArray *string = (NSArray*)peopleMobile;
					Contact *object = nil;
					NSString *str;
					for(int j = 0; j < [string count]; j++)
					{
						object = [[Contact alloc] init];
						object.Name = name;
						
						CFStringRef xyz =  ABMultiValueCopyLabelAtIndex ( phone_Array, j);
						
						object.Detail = [[self remSpChar:(NSString *)xyz] lowercaseString];
						object.Number = [self remSpChar:[string objectAtIndex:j]];
						if([object.Detail length]>8)
						{
							str = [NSString stringWithString:[object.Detail substringToIndex:5]];
							str = [str stringByAppendingString:@"..."];
							object.Detail = str;
						}
						else
						{
							object.Detail = [[self remSpChar:(NSString *)xyz] lowercaseString];
						}
						
						[searchedContacts addObject:object];					
						[object release]; object = nil;
					}	
					CFRelease(peopleMobile);
				}
				[name release], name = nil;
			}//people
			CFRelease(people);
		}
		
	}
	//now search ltp
	if(ltpsSearchStringP)
	{	
		long countLong = GetTotalCount(GETCONTACTLIST);
		struct AddressBook *addressP;
		char *title;
		for(int i=0;i<countLong;++i)
		{
			addressP = GetObjectAtIndex(uaObject ,i);
			title = strcasestr(addressP->title,ltpsSearchStringP);
			if(title)
			{
				
				if(strlen(addressP->mobile)>0)
				{
					NSString *nameP;
					Contact *object = nil;
					nameP = [[NSString alloc] initWithUTF8String:addressP->title];
					NSString *numberP;
					numberP = [[NSString alloc] initWithUTF8String:addressP->mobile];
					object = [[Contact alloc] init];
					object.Name = nameP;
					
					
					
					object.Detail = _MOBILE_;
					object.Number = numberP;
					
					//object.Detail = [NSString stringWithString:(NSString *)xyz];
					//object.Number = [NSString stringWithString:[string	:j]];
					
					[searchedContacts addObject:object];					
					[object release], object = nil;
					[numberP release];
					[nameP release];
					
				
				}
				if(strlen(addressP->home)>0)
				{
					NSString *nameP;
					Contact *object = nil;
					nameP = [[NSString alloc] initWithUTF8String:addressP->title];
					NSString *numberP;
					numberP = [[NSString alloc] initWithUTF8String:addressP->home];
					object = [[Contact alloc] init];
					object.Name = nameP;
					
					
					
					object.Detail = _HOME_;
					object.Number = numberP;
					
					//object.Detail = [NSString stringWithString:(NSString *)xyz];
					//object.Number = [NSString stringWithString:[string	:j]];
					//[self addElement:searchedContacts contactObject:object];
					[searchedContacts addObject:object];					
					[object release], object = nil;
					[numberP release];
					[nameP release];
					
					
				}
				if(strlen(addressP->business)>0)
				{
					NSString *nameP;
					Contact *object = nil;
					nameP = [[NSString alloc] initWithUTF8String:addressP->title];
					NSString *numberP;
					numberP = [[NSString alloc] initWithUTF8String:addressP->business];
					object = [[Contact alloc] init];
					object.Name = nameP;
					
					
					
					object.Detail = _BUSINESS_;
					object.Number = numberP;
					
					//object.Detail = [NSString stringWithString:(NSString *)xyz];
					//object.Number = [NSString stringWithString:[string	:j]];
					//[self :searchedContacts contactObject:object];
					[searchedContacts addObject:object];					
					[object release], object = nil;
					[numberP release];
					[nameP release];
					
					
				}
				
				if(strlen(addressP->spoknid)>0)
				{
					NSString *nameP;
					Contact *object = nil;
					nameP = [[NSString alloc] initWithUTF8String:addressP->title];
					NSString *numberP;
					numberP = [[NSString alloc] initWithUTF8String:addressP->spoknid];
					object = [[Contact alloc] init];
					object.Name = nameP;
					
					
					
					object.Detail = _SPOKN_ID_;
					object.Number = numberP;
					
					//object.Detail = [NSString stringWithString:(NSString *)xyz];
					//object.Number = [NSString stringWithString:[string	:j]];
					//[self addElement:searchedContacts contactObject:object];
					[searchedContacts addObject:object];					
					[object release], object = nil;
					[numberP release];
					[nameP release];
					
					
				}
				if(strlen(addressP->other)>0)
				{
					NSString *nameP;
					Contact *object = nil;
					nameP = [[NSString alloc] initWithUTF8String:addressP->title];
					NSString *numberP;
					numberP = [[NSString alloc] initWithUTF8String:addressP->other];
					object = [[Contact alloc] init];
					object.Name = nameP;
					
					
					
					object.Detail = _OTHER_;
					object.Number = numberP;
					
					//object.Detail = [NSString stringWithString:(NSString *)xyz];
					//object.Number = [NSString stringWithString:[string	:j]];
					//[self addElement:searchedContacts contactObject:object];
					[searchedContacts addObject:object];					
					[object release], object = nil;
					[numberP release];
					[nameP release];
					
					
				}
				if(strlen(addressP->email)>0)
				{
					NSString *nameP;
					Contact *object = nil;
					nameP = [[NSString alloc] initWithUTF8String:addressP->title];
					NSString *numberP;
					numberP = [[NSString alloc] initWithUTF8String:addressP->email];
					object = [[Contact alloc] init];
					object.Name = nameP;
					
					
					
					object.Detail = _EMAIL_;
					object.Number = numberP;
					
					//object.Detail = [NSString stringWithString:(NSString *)xyz];
					//object.Number = [NSString stringWithString:[string	:j]];
					//[self addElement:searchedContacts contactObject:object];
					[searchedContacts addObject:object];					
					[object release], object = nil;
					[numberP release];
					[nameP release];
					
					
				}
				
				
			}	
							
			
			
		}
	}	
	if( [searchedContacts count] > 0 )
	{
		/*NSMutableArray *lsearchedContacts;
		Contact *locObjectP;
		lsearchedContacts = [[NSMutableArray alloc] init];
		for(int i=0;i<[searchedContacts count] ;++i)
		{
			locObjectP = [searchedContacts objectAtIndex:i];
			[self addElement:lsearchedContacts contactObject:locObjectP];
			
		}
		[searchedContacts release];
		searchedContacts = nil;
		searchedContacts = lsearchedContacts;*/
		// reload data
		[tbl_contacts reloadData];
		[self showSearchTable];
	}else
	{
		[self hideSearchTable];
	}
	
}
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    // assigning control back to the main controller
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
	ABMultiValueRef phone_Array = ABRecordCopyValue(person, kABPersonPhoneProperty);
	
	if( ABMultiValueGetCount(phone_Array) == 1 )
	{	
		NSString *contStr = (NSString*)ABMultiValueCopyValueAtIndex(phone_Array, 0);
		
		contStr = [[[contStr autorelease] stringByReplacingOccurrencesOfString:@" " withString:@""] retain];
		contStr = [[[contStr autorelease] stringByReplacingOccurrencesOfString:@"(" withString:@""] retain];
		contStr = [[[contStr autorelease] stringByReplacingOccurrencesOfString:@")" withString:@""] retain];
		contStr = [[[contStr autorelease] stringByReplacingOccurrencesOfString:@"-" withString:@""] retain];
		
		[txtDestNo addCellWithString:[NSString stringWithString:contStr] type:@""];
		
		[contStr release];
		contStr = nil;
		
		
		CFRelease(phone_Array);
		// remove the controller
		[self dismissModalViewControllerAnimated:YES];
		[peoplePicker release];
		
		return NO;
	}
	
	return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
	return TRUE;
}

- (void) showSearchTable
{
	if(modalB==false)
	{	
		self.view.frame = CGRectMake(0, 0, 320,200 );	
		//[upDateProtocolP upDateScreen];
		[self->upDateProtocolP keyBoardOnOrOff:NO :nil viewHeight:0];
	}
	/*
	if(self->txtDestNo.frame.size.height>45 && showTableB==FALSE)//mean in second row
	{	
		showTableB = TRUE;
		frameRect = self->txtDestNo.frame;
		self->txtDestNo.frame = CGRectMake(0, 0, 320,50 );
		[self updateLayout];
		[txtDestNo scrollToEditingLine:NO];
	}*/
	/*tableBound.origin.x = 0;
	tableBound.origin.y = self->txtDestNo.frame.size.height+1;
	tableBound.size.width = 320;
	tableBound.size.height = 203-(self->txtDestNo.frame.size.height-43);
	
	tbl_contacts.frame =  tableBound;
	*/
	if(!showTableB)
	{	
		[self->txtDestNo setTableOn:YES];
		showTableB = YES;
	}	
	tbl_contacts.hidden = NO;
	//_composerScrollView.scrollEnabled = NO;
}

- (void) hideSearchTable
{
	tbl_contacts.hidden = YES;
	if(modalB==false)
	{	
		//self.view.frame = CGRectMake(0, 0, 320,txtDestNo.frame.size.height );
		//[upDateProtocolP upDateScreen];
		
		/*if(showTableB)
		{	
			self->txtDestNo.frame=frameRect ;
		
			[self updateLayout];
			[txtDestNo scrollToEditingLine:NO];
			showTableB = FALSE;
		}*/
		showTableB = false;
		[self->txtDestNo setTableOn:NO];
		if(keyBoardOnB)
		{	
			
			[self->upDateProtocolP keyBoardOnOrOff:YES :nil viewHeight:self->txtDestNo.frame.size.height];
		}
	}
	//_composerScrollView.scrollEnabled = YES;	
}


- (void)textFieldDidResize:(GTokenField*)tokenField {
	//[self updateLayout];
}

- (void)updateLayout {
	//txtMssg.frame = CGRectMake(0, txtDestNo.frame.size.height + 1, 320, txtMssg.frame.size.height);
	txtDestNo.frame = CGRectMake(0, 0, 320, txtDestNo.frame.size.height);
	_composerScrollView.contentSize = CGSizeMake(txtDestNo.frame.size.width, txtDestNo.frame.size.height + 0.5);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	//return YES;
	if( textField == txtDestNo)
	{		
		BOOL try = ![string length];
		if (![txtDestNo shouldUpdate:try]) {
			[self updateLayout];
			return NO;
		}
		
		if( try ) return YES;
		
		
		
		if( [string compare:@" "] == 0 ) {
			if( [textField.text length] <= 1 ) return NO;
			
			NSString *text = [txtDestNo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			if(![text isEqualToString:@""])
			{	
				if([SpoknAppDelegate emailValidate:text]==NO)
				{	
					
					NSString *text2 = [text stringByRemovingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"+_()-.,*#<>!"]] ;
					NSString *text1 = [text2 stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
					
					if(text1!=0 && [text1 length]!=0)
					{
						//txtDestNo.text = @" ";
						return YES;
						
					}
					
				}
			}	
			
			[self update_txtDestNo:@""];
			
			return NO;
		}
		
		if( txtDestNo.selectedCell )
			txtDestNo.selectedCell = nil;
	}
	
	return YES;
}



- (void)update_txtDestNo :(NSString *)typeStrP{
	
	NSString *text = [txtDestNo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *texttype = [typeStrP stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if(![text isEqualToString:@""])
	{	
		if(typeStrP==nil || [typeStrP isEqualToString:@""])
		{
			if([SpoknAppDelegate emailValidate:text]==NO)
			{	
				
				//NSString *text1 = [text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_$!<>+1234567890"]];
				NSString *text1 = [text stringByRemovingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" +_()-.,*#$!<>1234567890"]] ;
				
				if(text1!=0 && [text1 length]!=0)
				{
					txtDestNo.text = @" ";
					return ;
				}
				else
				{
					
				}
				
			}	
			
			
			texttype = [[NSString alloc] initWithString:text];
			[txtDestNo addCellWithString:[NSString stringWithString:text] type:texttype];
			[texttype release];
		}
		else
		{
			[txtDestNo addCellWithString:[NSString stringWithString:text] type:texttype];
		}	
	}
	//[self hideSearchTable];
	
	txtDestNo.text = @" ";	
}
-(void)removeKeyBoard
{
	if(modalB==false)
	{
		

			NSString *temp = [txtDestNo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			if( ![temp isEqualToString:@""] )
			{
				[self update_txtDestNo:@""];
			}

			//[theTextField resignFirstResponder];
	
		//[txtDestNo resignFirstResponder];
		//[self->upDateProtocolP keyBoardOnOrOff:NO :nil] ;
		NSString *tmpStringP;
		NSMutableString *resultStrP;
		resultStrP = [[NSMutableString alloc] init];
		[txtDestNo resignFirstResponder];
		[self->upDateProtocolP keyBoardOnOrOff:NO :nil viewHeight:0] ;
		toLabelStart.hidden = NO;
		toLabelStart.userInteractionEnabled = YES;
		
		toLabel.userInteractionEnabled = YES;
		int i=0;
		int countObj = [txtDestNo totalObject];
		if(countObj)
		{
			[upDateProtocolP showOrHideSendButton:YES];
		}
		else
		{	
			[upDateProtocolP showOrHideSendButton:NO];	
		}	
		while(1)
		{	
			tmpStringP = [txtDestNo GetNameAtIndex:i];
			if(tmpStringP)
			{
				if(i)
				{
					[resultStrP appendString:@", "];
				}
				[resultStrP appendString:tmpStringP];
				++i;
				if(i==3)
				{
					if((countObj-i)>0)
					{	
						[resultStrP appendFormat:@" & %d more...",countObj-i];
					}
					break;
				}
				
			}
			else
			{
				break;
			}
		}	
		//txtDestNo.hidden = YES;
		toLabel.text = resultStrP;
		if(countObj)
		{	
		//toLabel.backgroundColor = [UIColor whiteColor];
			toLabel.hidden = NO;
			_composerScrollView.hidden = YES;
		}	
			//[_composerScrollView scrollRectToVisible: toLabel.frame animated:NO];
		[resultStrP release];
		if(modalB==false)
		{
			self.view.frame = CGRectMake(0, 0, 320,50 );
			[upDateProtocolP upDateScreen];
		}	
	}
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	if(modalB==false)
	{
		[self->upDateProtocolP keyBoardOnOrOff:NO :nil viewHeight:0];
	}
	keyBoardOnB = FALSE;
	return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
{
	
	if(modalB==false)
	{
		CGRect frame = txtDestNo.frame;
	
		[self->upDateProtocolP keyBoardOnOrOff:YES :&frame viewHeight:self->txtDestNo.frame.size.height];
	
		self.view.frame = CGRectMake(0, 0, 320,200 );	
		[upDateProtocolP upDateScreen];
	}	
	keyBoardOnB = TRUE;
	return YES;
}
- (void) textViewDidBeginEditing: (UITextView *) textView
{
	//self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done" 
	//																			   style:UIBarButtonItemStyleDone 
	//																			  target:self 
	//																			  action:@selector(didClickdone:)] autorelease];
	
	NSString *temp = [txtDestNo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if( ![temp isEqualToString:@""] )
	{
		[self update_txtDestNo:@""];
	}
	
	if( txtDestNo.selectedCell )
		txtDestNo.selectedCell = nil;
} 


-(NSString*)remSpChar:(NSString *)str
{
	NSString *contStr = [[NSString alloc] initWithString:str];
	
	{
		contStr = [[[contStr autorelease] stringByReplacingOccurrencesOfString:@" " withString:@""] retain];
		contStr = [[[contStr autorelease] stringByReplacingOccurrencesOfString:@"`" withString:@""] retain];
		contStr = [[[contStr autorelease] stringByReplacingOccurrencesOfString:@"(" withString:@""] retain];
		contStr = [[[contStr autorelease] stringByReplacingOccurrencesOfString:@")" withString:@""] retain];
		contStr = [[[contStr autorelease] stringByReplacingOccurrencesOfString:@"-" withString:@""] retain];
		contStr = [[[contStr autorelease] stringByReplacingOccurrencesOfString:@"+" withString:@""] retain];
	}
	
	{
		contStr = [[[contStr autorelease] stringByReplacingOccurrencesOfString:@" " withString:@""] retain];
		contStr = [[[contStr autorelease] stringByReplacingOccurrencesOfString:@"_$!<" withString:@""] retain];
		contStr = [[[contStr autorelease] stringByReplacingOccurrencesOfString:@">!$_" withString:@""] retain];
	}
	
	[contStr autorelease];
	
	return contStr;
}

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
	
	if(modalB==true)
	{
		return YES;
	}
	if(theTextField == txtDestNo) 
	{
		NSString *temp = [txtDestNo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if( ![temp isEqualToString:@""] )
		{
			NSRange range = [temp rangeOfString:@" "];
			if (range.location == NSNotFound ) 
			{	
				[self update_txtDestNo:@""];
			}	
		}
		[self removeKeyBoard];
		//[theTextField resignFirstResponder];
	}
	return YES;
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

	[tbl_contacts release];
	
	if(txtDestNo != nil)
	{
		[txtDestNo release];
		txtDestNo = nil;
	}
	[searchedContacts release];
	searchedContacts = 0;
	[searchArray release];
	searchArray = 0;
	
	
	[super dealloc];
}




#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
		return [searchedContacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell1";
    
    ContactCell *cell = (ContactCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ContactCell alloc] initWithCustomFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
	if( [searchedContacts count] > indexPath.row)
	{
		Contact *obj = [searchedContacts objectAtIndex:indexPath.row];
		[cell setCellInfo:obj];
	}
	return cell;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Contact *obj = [searchedContacts objectAtIndex:indexPath.row];
	#ifdef _NAME_IN_TABLE_
	txtDestNo.text = obj.Name;
	#else
	txtDestNo.text = obj.Number;
	#endif
	[self update_txtDestNo:obj.Number];	
	return nil;
}
-(void)openKeyBoard
{
	[txtDestNo becomeFirstResponder];
}

@end