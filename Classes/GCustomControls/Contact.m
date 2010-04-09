
//  Created  on 14/06/09.
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
