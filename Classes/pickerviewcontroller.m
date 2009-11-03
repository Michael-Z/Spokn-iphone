//
//  pickerviewcontroller.m
//  spokn
//
//  Created by Kaustubh Deshpande on 27/10/09.
//  Copyright 2009 Geodesic Ltd. All rights reserved.
//

#import "pickerviewcontroller.h"
#include "ua.h"
#import "GTokenField.h"
#import "GTokenFieldCell.h"
#import "UIViewAdditions.h"
#import "Contact.h"
#import "ContactCell.h"
#import "contactviewcontroller.h"

/*
@implementation BarBG
@synthesize color1 = _color1, color2 = _color2;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (CGGradientRef)newGradientWithColors:(UIColor**)colors count:(int)count {
	CGFloat* components = malloc(sizeof(CGFloat)*4*count);
	for (int i = 0; i < count; ++i) {
		UIColor* color = colors[i];
		size_t n = CGColorGetNumberOfComponents(color.CGColor);
		const CGFloat* rgba = CGColorGetComponents(color.CGColor);
		if (n == 2) {
			components[i*4] = rgba[0];
			components[i*4+1] = rgba[0];
			components[i*4+2] = rgba[0];
			components[i*4+3] = rgba[1];
		} else if (n == 4) {
			components[i*4] = rgba[0];
			components[i*4+1] = rgba[1];
			components[i*4+2] = rgba[2];
			components[i*4+3] = rgba[3];
		}
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef space = CGBitmapContextGetColorSpace(context);
	CGGradientRef gradient = CGGradientCreateWithColorComponents(space, components, nil, count);
	free(components);
	return gradient;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	// fill gradient
	self.color1 = [UIColor colorWithRed:0.91 green:0.92 blue:0.93 alpha:1];
	self.color2 = [UIColor colorWithRed:0.76 green:0.77 blue:0.78 alpha:1];
	UIColor* colors[] = {_color1, _color2};
	CGGradientRef gradient = [self newGradientWithColors:colors count:2];
	CGContextDrawLinearGradient(ctx, 
								gradient, 
								CGPointMake(rect.origin.x, rect.origin.y + 1),
								CGPointMake(rect.origin.x, rect.origin.y + rect.size.height), 
								kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(gradient);
	
	
	self.color1 = [UIColor colorWithRed:0.76 green:0.78 blue:0.79 alpha:1];
	self.color2 = [UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:1];
	UIColor* colors1[] = {_color1, _color2};
	CGGradientRef gradient1 = [self newGradientWithColors:colors1 count:2];
	CGContextDrawLinearGradient(ctx, 
								gradient1, 
								CGPointMake(rect.origin.x, rect.origin.y),
								CGPointMake(rect.origin.x, rect.origin.y + 3), 
								kCGGradientDrawsBeforeStartLocation);
	CGGradientRelease(gradient1);
	
	//draw upper border
	CGContextSetLineWidth(ctx, 1.0);
	
	[[UIColor grayColor] setStroke];
	CGContextMoveToPoint(ctx, rect.origin.x, rect.origin.y);
	CGContextAddLineToPoint(ctx, rect.origin.x + rect.size.width, rect.origin.y);
	CGContextStrokePath(ctx);
	CGContextClosePath(ctx);
	
	CGContextSetLineWidth(ctx, 1.0);
	[[UIColor whiteColor] setStroke];
	CGContextMoveToPoint(ctx, rect.origin.x, rect.origin.y + 2);
	CGContextAddLineToPoint(ctx, rect.origin.x + rect.size.width, rect.origin.y + 2);
	CGContextStrokePath(ctx);
	CGContextClosePath(ctx);
	
	
	CGContextRestoreGState(ctx);	
}


- (void)dealloc {
	[_color1 release];
	[_color2 release];
	[super dealloc];
}


@end
*/
//--------------------------------------------------------------------------------------------------------------------------------------------------

@implementation pickerviewcontroller
@synthesize upDateProtocolP;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	printf("\n mukesh");
	if(modalB==false)
	{
		[txtDestNo resignFirstResponder];
	}
		//	[self dismissKeyboard:numberFieldP];
	
}
-(void)addSelectedContact:(SelectedContctType*)  lcontactObjectP
{
	#ifdef _NAME_IN_TABLE_
	[txtDestNo addCellWithString:[NSString stringWithUTF8String:lcontactObjectP->nameChar] type:[NSString stringWithUTF8String:lcontactObjectP->number] ];
#else	
	[txtDestNo addCellWithString:[NSString stringWithUTF8String:lcontactObjectP->number] type:[NSString stringWithUTF8String:lcontactObjectP->number] ];
	
#endif
}
-(char*)getContactNumberList
{
	char *numberCharP = 0;
	NSString *resultP;
	int countInt = 0;
	
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
	//=============================================================
	[self update_txtDestNo:@""];
	char *allforwardNoCharP;
	allforwardNoCharP = [self getContactNumberList];
	if(allforwardNoCharP==0)
	{
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Forward number should not be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
		
		[alert show];
		[alert release];
	}
	else
	{
	//=============================================================
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
		printf("\n inside the no");

		[self addSelectedContact:&selectedContact];
		//[txtDestNo addCellWithString:[NSString stringWithUTF8String:nocharP :nameCharP]];

	}

}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
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
			 initWithTitle: @"Send" style:UIBarButtonItemStyleDone
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
			_composerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
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
				txtDestNo = [[GTokenField alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
			}
			else
			{
					txtDestNo = [[GTokenField alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
			}
			txtDestNo.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
			txtDestNo.backgroundColor = [UIColor whiteColor];
			txtDestNo.delegate = self;
			txtDestNo.autocorrectionType = UITextAutocorrectionTypeNo;
			txtDestNo.autocapitalizationType = UITextAutocapitalizationTypeNone;	
			txtDestNo.rightViewMode = UITextFieldViewModeAlways;
			txtDestNo.clearsOnBeginEditing = NO;
			//txtDestNo.placeholder = @"Numerics only";
			txtDestNo.keyboardType = UIKeyboardTypeNamePhonePad;
			txtDestNo.returnKeyType = UIReturnKeyDefault;
			txtDestNo.font = [UIFont systemFontOfSize:16.0];
			[txtDestNo addTarget:self action:@selector(updateSearchTable:) forControlEvents:UIControlEventEditingChanged];
			
			UIButton* addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
			[addButton addTarget:self action:@selector(addFromContact:) forControlEvents:UIControlEventTouchUpInside];
			txtDestNo.rightView = addButton;
			
			[_composerScrollView addSubview:txtDestNo];
			
			UILabel *toLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 1, 30, 38)];
			toLabel.text = @"To:";
			toLabel.backgroundColor = [UIColor clearColor];
			toLabel.textColor = [UIColor grayColor];
			[_composerScrollView addSubview:toLabel];
		}
		[self.view addSubview:_composerScrollView];
		if(modalB==false)
		{	
			tbl_contacts = [[UITableView alloc] initWithFrame:CGRectMake(0, 43, 320, 100) style:UITableViewStylePlain];
			
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
	
	NSString *texttosearch = [txtDestNo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	texttosearch = [self remSpChar:texttosearch];
	
	// input validation
	
	if([texttosearch length] > 0)
	{
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
					for(int j = 0; j < [string count]; j++)
					{
						object = [[Contact alloc] init];
						object.Name = name;
						
						CFStringRef xyz =  ABMultiValueCopyLabelAtIndex ( phone_Array, j);
						
						object.Detail = [[self remSpChar:(NSString *)xyz] lowercaseString];
						object.Number = [self remSpChar:[string objectAtIndex:j]];
						
						//object.Detail = [NSString stringWithString:(NSString *)xyz];
						//object.Number = [NSString stringWithString:[string	:j]];
						
						[searchedContacts addObject:object];					
						[object release], object = nil;
					}	
					CFRelease(peopleMobile);
				}
				[name release], name = nil;
			}//people
		}
		CFRelease(people);
	}
	
	if( [searchedContacts count] > 0 )
	{
		// reload data
		[tbl_contacts reloadData];
		[self showSearchTable];
	}else
	{
		[self hideSearchTable];
	}
	

/*	struct AddressBook *addressP;
	int i=0;
	char *ignoreSpaceStrP = 0;
//	sectionType *setTypeP;
//	NSString *CellIdentifier,*rangeStringP;
	
	NSString *texttosearch = [txtDestNo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	texttosearch = [self remSpChar:texttosearch];
	self->count = GetTotalCount(uaObject);
	if(count > 0)
	{	
		for (i=0;i<count;++i)
		{
			addressP = GetObjectAtIndex(uaObject ,i);
			ignoreSpaceStrP = addressP->title;
			while(*ignoreSpaceStrP==' ')
			{
				ignoreSpaceStrP++;
			}
		}
	}
	
/*	for (i=0;i<count;++i)
	{
		sectionData *secP;
		addressP = GetObjectAtIndex(uaObject ,i);		
		ignoreSpaceStrP = addressP->title;
		while(*ignoreSpaceStrP==' ')
		{
			ignoreSpaceStrP++;
		}
		CellIdentifier = [[NSString alloc] initWithUTF8String:ignoreSpaceStrP] ;
		secP = [[sectionData alloc] init];
		secP->recordid = addressP->id;
		
		rangeStringP = 	[[CellIdentifier substringToIndex:1] uppercaseString];
		
		for (i = 0; i < MAXSEC; i++){
			
			setTypeP = [[sectionType alloc] init];
			setTypeP->index = i;
			[sectionArray addObject: setTypeP] ;
			//("\n%d",i);
		}
		NSRange range = [ALPHA rangeOfString:rangeStringP];
		if (range.location != NSNotFound && range.location <MAXSEC) 
		{	
			if(texttosearch)
			{	
				if([texttosearch length]>0)
				{	
					NSRange range1 = [[CellIdentifier uppercaseString] rangeOfString:texttosearch];//[[[self getName:person] uppercaseString] rangeOfString:upString];
					//if (range1.location != NSNotFound) 
					//{	
					//////printf("\n%s %ld %d",addressP->title,addressP->id ,i);
					[ searchArray addObject:secP];
					//}	
				}
				else
				{
					//[ setTypeP->elementP addObject:secP];
				}
			}
			
			// Add the name to the proper array
			[secP release];
			
			[CellIdentifier release];
		}
		
		//addressP = (struct AddressBook *)getContact( secP->recordid);
		
	}
	*/
	
	
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
		self.view.frame = CGRectMake(0, 0, 320,160 );	
		[upDateProtocolP upDateScreen];
	}
	
	tbl_contacts.hidden = NO;
	_composerScrollView.scrollEnabled = NO;
}

- (void) hideSearchTable
{
	tbl_contacts.hidden = YES;
	if(modalB==false)
	{	
		self.view.frame = CGRectMake(0, 0, 320,50 );
		[upDateProtocolP upDateScreen];
	}
	_composerScrollView.scrollEnabled = YES;	
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
	NSLog(@"\nmm = %@\n",text);
	if(![text isEqualToString:@""])
	{	
		if(typeStrP==nil || [typeStrP isEqualToString:@""])
		{
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
	
	//printf("dffs");
	if(modalB==true)
	{
		return YES;
	}
	if(theTextField == txtDestNo) 
	{
		NSString *temp = [txtDestNo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if( ![temp isEqualToString:@""] )
		{
			[self update_txtDestNo:@""];
		}
		
		[theTextField resignFirstResponder];
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
	[searchedContacts release];
	if(txtDestNo != nil)
	{
		[txtDestNo release];
		txtDestNo = nil;
	}

	[super dealloc];
}




//--------------------Search Table Functions------------------------------------------------------------------------------
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
        cell = [[[ContactCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
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

@end