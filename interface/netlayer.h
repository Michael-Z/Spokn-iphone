
//  Created on 28/06/09.

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

#ifndef _NETLAYER_H_
#define _NETLAYER_H_

#include <sys/socket.h>
#include<sys/types.h>
#include <stddef.h>
#include <netinet/in.h>
#include <sys/time.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>
# include <netdb.h>
#include <stdlib.h>
#include<arpa/inet.h>

#include "ltpmobile.h"
	int restartSocket(int *isockP);
	int  netWriteLocal(int isock,void *msg, int length, unsigned int address, unsigned short port);
	unsigned int  lookupDNSLocal(char *host);
	int netRead(int isock,void *msg, int maxlength, unsigned long *address, short unsigned *port);
	
#endif
