//
//  Contact.h
//  munduSMS
//
//  Created by Vinay Chavan on 14/06/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact: NSObject {
	
	NSString *_name;
	NSString *_detail;
	NSString *_number;
}

- (NSString*)Name;
- (void)setName:(NSString*)value;
- (NSString*)Detail;
- (void)setDetail:(NSString*)value;
- (NSString*)Number;
- (void)setNumber:(NSString*)value;
//
//- (void)cleanup;

//@property (nonatomic, retain) NSString *Name;
//@property (nonatomic, retain) NSString *Detail;
//@property (nonatomic, retain) NSString *Number;
@end
