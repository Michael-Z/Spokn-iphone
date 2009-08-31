/*
 *  netlayer.h
 *  spoknclient
 *
 *  Created by Mukesh Sharma on 28/06/09.
 *  Copyright 2009 Geodesic Ltd.. All rights reserved.
 *
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
