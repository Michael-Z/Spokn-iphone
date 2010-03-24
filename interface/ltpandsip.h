
//  Created on 27/10/09.

/**
  Copyright 2009, 2010 Geodesic Limited. <http://www.geodesic.com/>
 
 Spokn for iPhone and iPod Touch.
 
 This file is part of Spokn for iPhone.
 
 Spokn for iPhone is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 Spokn for iPhone is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Spokn for iPhone.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef _LTP_AND_SIP_H_
	#define _LTP_AND_SIP_H_
	#define _LTP_
	#define _SPEEX_CODEC_
#include "ltpmobile.h"
	int spokn_pj_init(char *errorstring);
void setMute(struct ltpStack *ps,int enableB);
void setHold(struct ltpStack *ps,int enableB);
	//void setMute(int enableB);
#endif
