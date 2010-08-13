//
//  clicktocall.m
//  spokn
//
//  Created by Rishi Saxena on 12/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "clicktocall.h"
#import  "AddeditcellController.h"
#import "alertmessages.h"
#import "spoknAppDelegate.h"
#import "countrylist.h"
#define SPOKNCOLOR [UIColor colorWithRed:63/255.0 green:90/255.0 blue:139/255.0 alpha:1.0]
#define ROW_HEIGHT 42

@implementation clicktocall
@synthesize tableView;
@synthesize clicktocallProtocolP;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		
		CGRect LabelFrame1 = CGRectMake(20, 6, 117, ROW_HEIGHT-5);
		labelconnectionType = [[UILabel alloc] initWithFrame:LabelFrame1];
		labelconnectionType.textAlignment = UITextAlignmentLeft;
		labelconnectionType.tag = 1;
		
		CGRect LabelFrame3 = CGRectMake(20, 6, 117, ROW_HEIGHT-5);
		number = [[UILabel alloc] initWithFrame:LabelFrame3];
		number.textAlignment = UITextAlignmentLeft;
		number.tag = 3;
		
		CGRect LabelFrame2 = CGRectMake(160, 6, 117, ROW_HEIGHT-5);
		labelAparty = [[UILabel alloc] initWithFrame:LabelFrame2];
		labelAparty.textAlignment = UITextAlignmentRight;
		labelAparty.tag = 2;
		

    }
    return self;
}

//Method writes a string to a text file
-(void) writeToTextFile:(NSString *)lcontent
{
	//get the documents directory:
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	//make a file name to write the data to using the documents directory:
	NSString *fileName = [NSString stringWithFormat:@"%@/newcountrylist.txt",documentsDirectory];
	
	//save content to the documents directory
	[lcontent writeToFile:fileName 
			   atomically:NO 
				 encoding:NSStringEncodingConversionAllowLossy 
					error:nil];
	
}
-(NSString *) getTextFromFile
{
	//get the documents directory:
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	//make a file name to write the data to using the documents directory:
	NSString *fileName = [NSString stringWithFormat:@"%@/newcountrylist.txt", documentsDirectory];
	return  [[NSString alloc] initWithContentsOfFile:fileName
										  usedEncoding:nil
												 error:nil];
	
	
	
}


-(char*) gecallbackNumber
{
	
	NSString *nsP;
	nsP=(NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"callbacknumber"]; 
	//nsP = [[NSUserDefaults standardUserDefaults] stringForKey:@"callbacknumber"];
	if(nsP)
		return (char*)([nsP  cStringUsingEncoding:NSUTF8StringEncoding]);
	else return nil;
}

-(void)setObject:(id) object 
{
	self->ownerobject = object;
	self->clicktocallProtocolP = object;
}

-(void)callthroughApiAsynchronous
{
	/****************Asynchronous Request**********************/
	int timestamp;
	timestamp = [[NSUserDefaults standardUserDefaults] integerForKey:@"Timestamp"];
	
	NSString *urlString = [NSString stringWithFormat:@"http://api.spokn.com/accesslines?time=%d",timestamp];
	
	NSURLRequest *urlRequest = [[NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NO timeoutInterval:30.0] retain];
    
	// Note: An NSOperation creates an autorelease pool, but doesn't schedule a run loop
	// Create the connection and schedule it on a run loop under our namespaced run mode
	NSURLConnection *rssConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
	
	//[rssConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	//[rssConnection start];
	[rssConnection release];
	[urlRequest release], urlRequest = nil;

	
}


#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {	
	
	if ([response isKindOfClass:[NSHTTPURLResponse class]])
	{
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
       
		status = [httpResponse statusCode];
	}
}	

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
	if(responseAsyncData==nil)
	{	
		responseAsyncData = [[NSMutableData alloc] initWithLength:0];
	}	
	
	
	[responseAsyncData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

	[self connectionDidFinishLoading:nil];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
	
	NSString *xmlDataFromChannelSchemes;

	if(responseAsyncData)
	{
		NSString *result = [[NSString alloc] initWithData:responseAsyncData encoding:NSASCIIStringEncoding];
		//NSLog(@"\n result:%@\n\n", result);
		[self writeToTextFile:result];
		xmlDataFromChannelSchemes = [[NSString alloc] initWithString:result];
		NSData *xmlDataInNSData = [xmlDataFromChannelSchemes dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
		xmlParser = [[NSXMLParser alloc] initWithData:xmlDataInNSData];
		[xmlParser setDelegate:self];
		[xmlParser parse];
		[pickerView reloadAllComponents];
		[xmlParser release];
		[xmlDataFromChannelSchemes release];
		[result release];
		[responseAsyncData release];
		responseAsyncData = nil;
	}
	else
	{
		
	//	if (status == 304)
		{
			NSString *data;
			data = [self getTextFromFile];
			//NSLog(@"\n data:%@\n\n", data);
			if(data)
			{	
				xmlDataFromChannelSchemes = [[NSString alloc] initWithString:data];
			}
			else 
			{
				NSError *fileError = 0;
				NSString *filePath = [[NSBundle mainBundle] pathForResource:@"countrylist" ofType:@"txt"];
				NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:&fileError];
				if(fileError)
				{
					fileContents = @"";
				}	
				xmlDataFromChannelSchemes = [[NSString alloc] initWithString:fileContents];
			}

			NSData *xmlDataInNSData = [xmlDataFromChannelSchemes dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
			xmlParser = [[NSXMLParser alloc] initWithData:xmlDataInNSData];
			[xmlParser setDelegate:self];
			[xmlParser parse];
			[pickerView reloadAllComponents];
			[xmlParser release];
			[xmlDataFromChannelSchemes release];
			[responseAsyncData release];
			responseAsyncData = nil;

		}
/*		else
		{
			NSString *titleP=0,*msgP=0;
			//	NSLog(@"Connection Sucessful %i", status);
			switch(status)
			{
				case 404:
					titleP = @"Request failed";
					msgP = @"Resource not found at server";
				case 415:
					titleP = @"Request failed";
					msgP = @"Unsupported Media Type";	
				case 401:
					titleP = @"Request failed";
					msgP = @"Unauthorized";
				case 500:
					titleP = @"Request failed";
					msgP = @"Internal Server Error";
					break;
					
				default:
					titleP = @"Request failed";
					msgP = @"Unknown Server Error";
					break;
					
			}
			
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:titleP message:msgP delegate:nil cancelButtonTitle:_OK_ otherButtonTitles: nil] autorelease];
			[alert show];
			
		}            */
		
	}
	NSString *cityName;
	NSString * cityNumber;
	cityName = [[NSUserDefaults standardUserDefaults] stringForKey:@"city_name"];
	cityNumber = [[NSUserDefaults standardUserDefaults] stringForKey:@"city_number"];
	if(cityName && cityNumber)
	{
		
		//NSLog(@"%@-%@",cityName,cityNumber);
		NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
		[pickerView selectRow:[prefs integerForKey:@"picker_row"] inComponent:0 animated:YES];
		countrylist *tempCountrylist;
		tempCountrylist = [arrayCountries objectAtIndex:[prefs integerForKey:@"picker_row"]];
		if(tempCountrylist)
		{	
			if([tempCountrylist.secondaryname isEqualToString:cityName] && ([tempCountrylist.number  isEqualToString:cityNumber]))
			{	
				[self setcallthroughObj:[arrayCountries objectAtIndex:[prefs integerForKey:@"picker_row"]]];
			}
			else
			{
				tempCountrylist = nil;
			}
		}
		
		if(tempCountrylist==nil)
		{
			NSEnumerator * enumerator = [arrayCountries objectEnumerator];
			countrylist *tempCountrylistP;
			int row;
			
			while(tempCountrylistP = [enumerator nextObject])
			{
				//NSLog(@"%@-%@",tempCountrylistP.secondaryname,tempCountrylistP.number);
				if([tempCountrylistP.secondaryname isEqualToString:cityName] && ([tempCountrylist.number  isEqualToString:cityNumber]))
				{	
					row = [arrayCountries indexOfObject:tempCountrylistP];
					if(row>-1)
					{	
						[self setcallthroughObj:[arrayCountries objectAtIndex:row]];
						[[NSUserDefaults standardUserDefaults] setInteger:row forKey:@"picker_row"];
						[[NSUserDefaults standardUserDefaults] synchronize];
					}
					else
					{
						[self setcallthroughObj:[arrayCountries objectAtIndex:0]];
					}
				}	
			}
		}
	}
}
/*
-(void)callthroughApiSynchronous
{
	int timestamp;
	timestamp = [[NSUserDefaults standardUserDefaults] integerForKey:@"Timestamp"];
	printf("timestamp=%d",timestamp);
	//prepar request
	NSString *urlString = [NSString stringWithFormat:@"http://api.spokn.com/accesslines?time=%d",timestamp];
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"GET"];
	
	//set headers
	NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	//get response
	NSHTTPURLResponse* urlResponse = nil;
	//NSString *serverMessage;
	NSError *error = 0;  
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
	//NSLog(@"\n\n%@\n\n", error);
	
	if(responseData==nil) //|| urlResponse==nil)
	{
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Request failed" message:@"Call-through request failed" delegate:nil cancelButtonTitle:_OK_ otherButtonTitles: nil] autorelease];
		[alert show];
		return; 
	}
	
	NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	NSLog(@"\n Response Code: %d\n", [urlResponse statusCode]);
	if ([urlResponse statusCode] == 304)
	{
		NSLog(@"\n Response Code: %d\n", [urlResponse statusCode]);
	}	
	if ([urlResponse statusCode] == 200) 
	{
		NSLog(@"\n result:%@\n\n", result);
	}
	else if ([urlResponse statusCode] == 404)
	{
		//NSLog(@"Not Found");
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Request failed" message:@"Resource not found at server" delegate:nil cancelButtonTitle:_OK_ otherButtonTitles: nil] autorelease];
		[alert show];
	}
	else if ([urlResponse statusCode] == 415)
	{
		//NSLog(@"Unsupported Media Type");
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Request failed" message:@"Unsupported Media Type" delegate:nil cancelButtonTitle:_OK_ otherButtonTitles: nil] autorelease];
		[alert show];
	}
	else if ([urlResponse statusCode] == 401)
	{
		//NSLog(@"Unauthorized");
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Request failed" message:@"Unauthorized" delegate:nil cancelButtonTitle:_OK_ otherButtonTitles: nil] autorelease];
		[alert show];
	}
	else if ([urlResponse statusCode] == 500)
	{
		//NSLog(@"Internal Server Error");
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Request failed" message:@"Internal Server Error" delegate:nil cancelButtonTitle:_OK_ otherButtonTitles: nil] autorelease];
		[alert show];
	}
	
	NSString *xmlDataFromChannelSchemes;
	
	 NSError *fileError = 0;
	 NSString *filePath = [[NSBundle mainBundle] pathForResource:@"countrylist" ofType:@"txt"];
	 NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:&fileError];
	 if(fileError)
	 {
	 fileContents = @"";
	 }	
	 xmlDataFromChannelSchemes = [[NSString alloc] initWithString:fileContents];


	if ([urlResponse statusCode] == 304)
	{
		NSString *data;
		data = [self getTextFromFile];
  		xmlDataFromChannelSchemes = [[NSString alloc] initWithString:data];
		
		if(result != nil)
		{
			[result release];
		}	
	}
	else
	{
		xmlDataFromChannelSchemes = [[NSString alloc] initWithString:result];
		[self writeToTextFile:result];
		if(result != nil)
		{
			[result release];
		}
	}
	
	
	NSData *xmlDataInNSData = [xmlDataFromChannelSchemes dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	xmlParser = [[NSXMLParser alloc] initWithData:xmlDataInNSData];
	[xmlParser setDelegate:self];
	[xmlParser parse];
	[xmlParser release];
	[xmlDataFromChannelSchemes release];
	
	
}
*/


-(IBAction)donePressed
{
	
	char *tempP=0;
	char *newNoP=0;
	tempP = (char*)[[labelAparty text]  cStringUsingEncoding:NSUTF8StringEncoding];
	newNoP = NormalizeNumber(tempP,1);
	if(newNoP){
		[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithUTF8String:newNoP] forKey:@"callbacknumber"]; 
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	free(newNoP);
	[self  dismissModalViewControllerAnimated:YES];
}

-(void)modelViewB:(Boolean)lmodalB
{
	modalB = lmodalB;
	
}

-(void)addCallbacknumber
{
	AddeditcellController     *AddeditcellControllerviewP;	
	AddeditcellControllerviewP = [[AddeditcellController alloc]init];
	[AddeditcellControllerviewP SetkeyBoardType:UIKeyboardTypePhonePad :NUMBER_RANGE buttonType:1];
	[AddeditcellControllerviewP setObject:self->ownerobject];
	viewResult = 0;
	char *apartyCharP;
	apartyCharP = (char*)[[labelAparty text] cStringUsingEncoding:NSUTF8StringEncoding];
	if(apartyCharP)
	{
		strcpy(apartyNoCharP,apartyCharP);
	}
	
	[AddeditcellControllerviewP setData:apartyNoCharP value:"Enter forward number." placeHolder:"Number" title:"Aparty" returnValue:&viewResult];
	
	[ [self navigationController] pushViewController:AddeditcellControllerviewP animated: YES ];
	
	[AddeditcellControllerviewP release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setTitle:@"Spokn Settings"];
	tableView.delegate = self;
	tableView.dataSource = self;
	protocolType = 0;
	pickerView.delegate = self;
	pickerView.dataSource = self;
	apartyNoCharP = malloc(100);
	memset(apartyNoCharP,0,100);
	sectionHeaders = [[NSMutableArray alloc] initWithObjects:@"Protocol",@"Callback Number",@"Choose Call-through line of:",nil];
	
	
	if(modalB)
	{
		self.navigationItem.rightBarButtonItem = [ [ [ UIBarButtonItem alloc ]
													initWithBarButtonSystemItem: UIBarButtonSystemItemDone
													target: self
													action: @selector(donePressed) ] autorelease ];
		
		
	}
	NSString *nsP;
	nsP = [[NSUserDefaults standardUserDefaults] stringForKey:@"callbacknumber"];
	if(nsP)
	{
		[labelAparty setText:nsP];
	}
		
	//For Synchronous Request
	//[self callthroughApiSynchronous];
	//For Synchronous Request
	//[self callthroughApiAsynchronous];
	
	[tableView reloadData];		
}

- (void)viewWillAppear:(BOOL)animated  
{  
	[super viewWillAppear:animated];
	char *newNoP;
	if(viewResult)
	{
		if(strlen(apartyNoCharP)==0)
		{
			newNoP = NormalizeNumber(apartyNoCharP,1);
			[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithUTF8String:newNoP] forKey:@"callbacknumber"]; 
			[[NSUserDefaults standardUserDefaults] synchronize];
			free(newNoP);
		}
	}
	if(strlen(apartyNoCharP)>0)
	{
		NSString *stringStrP;
		newNoP = NormalizeNumber(apartyNoCharP,1);
		[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithUTF8String:newNoP] forKey:@"callbacknumber"]; 
		[[NSUserDefaults standardUserDefaults] synchronize];
		stringStrP = [[NSString alloc] initWithUTF8String:newNoP ];
		[labelAparty setText:stringStrP];
		[stringStrP release];
		free(newNoP);
	}
	else 
	{
		NSString *nsP;
		nsP = [[NSUserDefaults standardUserDefaults] stringForKey:@"callbacknumber"];
		if(nsP)
		{
			[labelAparty setText:nsP];
			[tableView reloadData];
		}
	}
	
	if(protocolType)
	{	[[NSUserDefaults standardUserDefaults] setInteger:protocolType  forKey:@"protocoltypeIndex"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[self setprotocolType:protocolType];
		
		
	}
	else 
	{
		int setIndex;
		setIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"protocoltypeIndex"];
		if(setIndex)
		{
			[self setprotocolType:setIndex];
		}
		else {
			[self setprotocolType:1];
		}
		
	}
	//printf("protocol type %d",protocolType);
	[tableView reloadData];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	
	[sectionHeaders release];
	[labelconnectionType release];
	[number release];
	[labelAparty release];
	if(apartyNoCharP)
	{	
		free(apartyNoCharP);
	}
	[arrayCountries release];
}
#pragma mark Actionsheet methods
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
	[actionSheet release];
	uiActionSheetgP = nil;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (actionSheet == uiActionSheetgP)
	{
		[self setprotocolType:buttonIndex+1];
		[actionSheet release];
	}
}

- (void)setprotocolType:(int)index
{
	switch(index)
	{
		case 1://mean SIP
		{	
			//NSLog(@"sip");
			[labelconnectionType setText:@"SIP"];
			[ownerobject setoutCallTypeProtocol:index];
			pickerView.hidden = YES;
		}	
			break;
		case 2://mean CallBack
		{	
			//NSLog(@"CallBack");
			[labelconnectionType setText:@"CALLBACK"];
			[ownerobject setoutCallTypeProtocol:index];
			pickerView.hidden = YES;
		}	
			break;
			
		case 4://mean all
		{	
			[labelconnectionType setText:@"All"];
			[ownerobject setoutCallTypeProtocol:index];
			[self callthroughApiAsynchronous];
			pickerView.hidden = NO;
		}	
			break;	
		case 3://mean callthrough
		{	
			[labelconnectionType setText:@"Call-through"];
			[ownerobject setoutCallTypeProtocol:index];
			//[self callthroughApiSynchronous];
			[self connectionDidFinishLoading:nil];
			[self callthroughApiAsynchronous];
			//[self performSelectorOnMainThread : @ selector(callthroughApi) withObject:nil waitUntilDone:NO];
			//[NSThread detachNewThreadSelector:@selector(callthroughApi) toTarget:[self class] withObject:nil];
			pickerView.hidden = NO;
		}	
			break;
		
		default:
			break;
			
	}	
	if(index>=1 && index<5)
	{	
		[[NSUserDefaults standardUserDefaults] setInteger:index  forKey:@"protocoltypeIndex"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}	
	[tableView reloadData];
}

-(void)setcallthroughObj:(countrylist *)tempObj
{
	[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithString:tempObj.secondaryname] forKey:@"city_name"]; 
	[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithString:tempObj.number] forKey:@"city_number"]; 
	[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithString:tempObj.code] forKey:@"country_code"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[clicktocallProtocolP setcallthroughData:tempObj];
}

#pragma mark Table view methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [sectionHeaders objectAtIndex:section];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Detemine if it's in editing mode
	
    return UITableViewCellEditingStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (pickerView.hidden==TRUE) {
		return 2;
	}
	else {
		return 3;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger section = [indexPath section];
	if (section ==2) {
		return -5;
	}
	else {
		return 50;
	}
	
}
- (UITableViewCell *)tableView:(UITableView *)ltableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = [indexPath row];
	NSInteger section = [indexPath section];
	
	UILabel *templabel;
    
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
#ifdef __IPHONE_3_0
		
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
#else
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
#endif
		
		if(section==0 && row==0 )
		{
			templabel = labelconnectionType;
			templabel.textColor = SPOKNCOLOR;
			[cell addSubview:templabel];
		}
		if(section==1 && row==0 )
		{
			
			templabel = number;
			templabel.textColor = SPOKNCOLOR;
			templabel.text = @"NUMBER";
			[cell addSubview:templabel];
			
			templabel = labelAparty;
			templabel.textColor = SPOKNCOLOR;
			[cell addSubview:templabel];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			
		}
	}	
	else
	{
	}
	return cell;
	
}
- (void)tableView:(UITableView *)ltableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	int row = [indexPath row];
	int section = [indexPath section];
	if(section==0 && row==0)
	{
		
		uiActionSheetgP= [[UIActionSheet alloc] 
						  initWithTitle: @"Please select your prefrences" 
						  delegate:self
						  cancelButtonTitle:_CANCEL_ 
						  destructiveButtonTitle:nil
						  otherButtonTitles:@"Sip",@"CallBack",@"Call-through",@"All", nil];
		
		uiActionSheetgP.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
		[uiActionSheetgP showInView:[ownerobject tabBarController].view];
	}
	if(section==1 && row==0)
	{
		[self addCallbacknumber];
	}
	[ltableView deselectRowAtIndexPath : indexPath animated:YES];
}
#pragma mark Pickerview methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	
	return [arrayCountries count];
}
/*
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	countrylist *tempP;
	NSString * strP;
    tempP = [arrayCountries objectAtIndex:row];
	//strP = [[NSString alloc] initWithFormat:@"%@-%i ",tempP.secondaryname,tempP.number];
	strP = [[NSString alloc] initWithFormat:@"   %@ - %@ - (+%i) ",[tempP.name capitalizedString],[tempP.secondaryname capitalizedString],tempP.code];
	//NSLog(@"\n: %@ : %i :%@  :%i\n", tempP.name, tempP.code,tempP.secondaryname,tempP.number);  
	return strP;  
}
*/
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)viewP
{
	UILabel *label;
	if ([viewP isKindOfClass:[UILabel class]] == YES)
	{

		label = (UILabel*)viewP;
	}
	else 
	{
		CGRect LabelFrame1 = CGRectMake(0, 0, 320, 50);
		label = [[UILabel alloc] initWithFrame:LabelFrame1];
		label.textAlignment = UITextAlignmentLeft;
		label.tag = 1;
		label.adjustsFontSizeToFitWidth = FALSE;
		label.font = [UIFont systemFontOfSize:16];
		label.textColor = SPOKNCOLOR;
	}

	countrylist *tempP;
	NSString * strP;
    tempP = [arrayCountries objectAtIndex:row];
	strP = [[NSString alloc] initWithFormat:@"   %@ - %@ (+%@) ",[tempP.name capitalizedString],[tempP.secondaryname capitalizedString],tempP.code];
	label.text = strP;
	[strP release];
 
	return label;
}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
	if(row > -1)
	{	
		[self setcallthroughObj:[arrayCountries objectAtIndex:row]];
		[[NSUserDefaults standardUserDefaults] setInteger:row forKey:@"picker_row"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	}
}
#pragma mark xmlParser methods
/* Called when the parser runs into an open tag (<tag>) */ 
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 	attributes:(NSDictionary *)attributeDict 
{
	if([elementName isEqualToString:@"spokn"])
	{
		arrayCountries = [[NSMutableArray alloc] init];
	}
	else if([elementName isEqualToString:@"time"])
	{
		int timestamp;
		timestamp = [[attributeDict objectForKey:@"value"] integerValue];

		[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithString:[attributeDict objectForKey:@"value"]] forKey:@"Timestamp"]; 
		[[NSUserDefaults standardUserDefaults] synchronize];
	}	
	else if([elementName isEqualToString:@"country"])
	{
		countryName = [[NSString alloc] initWithString:[attributeDict objectForKey:@"name"]];
		countryCode = [[NSString alloc] initWithString:[attributeDict objectForKey:@"code"]];
		
		
	}	
	else if([elementName isEqualToString:@"area"])
	{
		countrylispP = [[countrylist alloc] init];
		countrylispP.name = self->countryName;			
		countrylispP.code = self->countryCode;
		countrylispP.secondaryname = [attributeDict objectForKey:@"name"];
		countrylispP.number = [attributeDict objectForKey:@"number"];
		//NSLog(@"\nname: %@ code: %@\n", countrylispP.code, countrylispP.number);
		
	}
	
}


/* Called when the parser runs into a close tag (</tag>). */
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{
	if([elementName isEqualToString:@"spokn"])
	{
		NSSortDescriptor *alphaDesc = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(compare:)];
		[arrayCountries sortUsingDescriptors:[NSMutableArray arrayWithObjects:alphaDesc, nil]];	
		[alphaDesc release], alphaDesc = nil;
		return;
	}
	else if([elementName isEqualToString:@"area"])
	{
		[arrayCountries addObject:countrylispP];
		[countrylispP release];
		countrylispP = nil;
	}	
	else if([elementName isEqualToString:@"country"])
	{
		[countryName release];
		[countryCode release];
	}	
	
}


@end
