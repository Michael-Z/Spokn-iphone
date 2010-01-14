
//  Created on 28/06/09.

/**
 Copyright 2009,2010 Geodesic, <http://www.geodesic.com/>
 
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
#import <Foundation/Foundation.h>
#include "LtpInterface.h"

@interface LtpTimer : NSObject {
	@private
	NSTimer *timerP;
	LtpInterfaceType *ltpInterfacesP;
}

@property(readwrite,assign) LtpInterfaceType *ltpInterfacesP;
-(int) startTimer;
-(int)stopTimer;

@end
