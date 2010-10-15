//
//  clicktocall.h
//  spokn
//
//  Created by Rishi Saxena on 12/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "spoknAppDelegate.h"
#import "countrylist.h"

@protocol clicktocallProtocol<NSObject>

-(void)setcallthroughData:(id)objectP;
@end

@class SpoknAppDelegate;
@interface clicktocall : UIViewController <UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource,NSXMLParserDelegate> {

	SpoknAppDelegate * ownerobject;
	IBOutlet UITableView *tableView;
	UILabel *labelAparty;
	UILabel *labelconnectionType;
	UILabel *number;
	UILabel *pinNumber;
	UILabel *countryPin;
	Boolean modalB;
	int viewResult1;
	int viewResult2;
	char *apartyNoCharP;
	char *pinNoCharP;
	UIActionSheet *uiActionSheetgP;
	UIView *customview;
	UILabel *text;
	NSMutableArray *sectionHeaders;
	int protocolType;
	IBOutlet UIPickerView *pickerView;
	NSMutableArray *arrayCountries;
	NSXMLParser *xmlParser;
	NSMutableArray *country;
	NSString* countryName;
	NSString* countryCode;
	countrylist *countrylispP;
	id <clicktocallProtocol> clicktocallProtocolP;
	
	
	/*For Asynchronous request*/
	NSMutableData *responseAsyncData;
	NSError  *connectionError;
	int status;
}
@property(nonatomic,assign) UITableView *tableView;
@property(nonatomic,assign) id <clicktocallProtocol> clicktocallProtocolP;
-(void)setObject:(id) object ;
-(void)modelViewB:(Boolean)lmodalB;
-(void)addCallbacknumber;
- (void)setprotocolType:(int)index;
-(char*) gecallbackNumber;
-(void)setcallthroughObj:(countrylist *)tempObj;
-(void)callthroughApiAsynchronous;
-(void)addSimPinNumber;
@end
