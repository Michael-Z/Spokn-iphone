//
//  Contact.m
//  munduSMS
//
//  Created by Vinay Chavan on 14/06/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import "Contact.h"

@implementation Contact

- (id) init {
	self = [super init];
	
	_name = nil;
	_detail = nil;
	_number = nil;
	
	return self;
}

- (NSString*)Name {
	return _name;
}
- (void) setName:(NSString*)value {
	if( _name != value ) {
		[_name release], _name = nil;
		_name = [value retain];
	}
}

- (NSString*)Detail {
	return _detail;
}
- (void)setDetail:(NSString*)value {
	if( _detail != value ) {
		[_detail release], _detail = nil;
		_detail = [value retain];
	}	
}

- (NSString*)Number {
	return _number;
}
- (void)setNumber:(NSString*)value {
	if( _number != value ) {
		[_number release], _number = nil;
		_number = [value retain];
	}	
}

- (void)cleanup {
	if(_name)	
		[_name release], _name = nil;
	if(_detail)
		[_detail release], _detail = nil;
	if(_number)
		[_number release], _number = nil;	
}

- (void)dealloc {
	if(_name)	
		[_name release], _name = nil;
	if(_detail)
		[_detail release], _detail = nil;
	if(_number)
		[_number release], _number = nil;	
	[super dealloc];
}

//@synthesize Name = _name, Detail = _detail, Number = _number;
//
//- (void)dealloc {
//	[_name release];
//	[_detail release];
//	[_number release];
//	[super dealloc];
//}
@end
