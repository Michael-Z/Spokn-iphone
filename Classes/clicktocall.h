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
@required
-(void)setcallthroughData:(id)objectP;
@end

@class SpoknAppDelegate;
@interface clicktocall : UIViewController <UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource,NSXMLParserDelegate> {

	SpoknAppDelegate * ownerobject;
	IBOutlet UITableView *tableView;
	UILabel *labelAparty;
	UILabel *labelconnectionType;
	UILabel *number;
	Boolean modalB;
	int viewResult;
	char *apartyNoCharP;
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
	NSString *content;
	
	/*For Asynchronous request*/
	NSMutableData *responseAsyncData;
	BOOL finished;
	NSError  *connectionError;
}
@property(nonatomic,assign) UITableView *tableView;
@property(nonatomic,assign) id <clicktocallProtocol> clicktocallProtocolP;
-(void)setObject:(id) object ;
-(void)modelViewB:(Boolean)lmodalB;
-(void)addCallbacknumber;
- (void)setprotocolType:(int)index;
-(char*) gecallbackNumber;
-(void)callthroughApiSynchronous;
-(void)setcallthroughObj:(countrylist *)tempObj;
-(void)callthroughApiAsynchronous;

@end
