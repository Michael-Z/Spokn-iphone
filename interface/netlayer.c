
// Created on 28/06/09.

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

#include "netlayer.h"

int netRead(int isock,void *msg, int maxlength, unsigned long *address, short unsigned *port)
{	
	fd_set	readfs;
	struct sockaddr_in	addr;
	int	 ret;
	struct timeval	tv;
#ifdef WIN32
	int dummylen;
#else
	socklen_t	dummylen;
#endif
	
	tv.tv_sec = 0;
	tv.tv_usec = 10; //10msec time-out
	FD_ZERO(&readfs);
	FD_SET(isock, &readfs);
	
	
	ret = select(32, &readfs, NULL, NULL, &tv);
	if (ret <= 0)
		return 0;
	
	if (FD_ISSET(isock, &readfs))
	{
		dummylen = sizeof(addr);
		ret = recvfrom(isock, (char *)msg, maxlength, 0, (struct sockaddr *)&addr, &dummylen);
		
		*address	= (unsigned long)addr.sin_addr.s_addr;
		*port	= (int)addr.sin_port;
		return ret;
	}
	
	return 0;
}


/* some utils, specific to pocket pc */

int restartSocket(int *isockP){
	
	if(isockP==0)
	{
		return -1;
		
	}
	if (*isockP)
		close(*isockP);
	
	*isockP = (int)socket(AF_INET, SOCK_DGRAM, 0);
	
	if (*isockP == -1)
		return -1;
	return 0;
}

int  netWriteLocal(int isock,void *msg, int length, unsigned int address, unsigned short port){
	struct sockaddr_in	addr;
	
	addr.sin_addr.s_addr = address;
	addr.sin_port = (short)port;
	addr.sin_family = AF_INET;
	
	int ret = sendto(isock, (char *)msg, length, 0, (struct sockaddr *)&addr, sizeof(addr));
	return ret;
}
unsigned int  lookupDNSLocal(char *host){
	int i, count=0;
	char *p = host;
	//	int tmp;
	struct sockaddr_in	addr;
	struct hostent		*pent;
	
	if (!strcmp(host, "0"))
		return 0;
	
	while (*p){
		for (i = 0; i < 3; i++, p++)
			if (!isdigit(*p))
				break;
		if (*p != '.')
			break;
		p++;
		count++;
	}
	
	if (count == 3 && i > 0 && i <= 3)
		//inet_pton( AF_INET, "127.0.0.1", &addr.sin_addr);
		return inet_addr(host);
	
	pent = gethostbyname(host);
	if (!pent)
		return INADDR_NONE;
	
	addr.sin_addr = *((struct in_addr *) *pent->h_addr_list);
	
	return addr.sin_addr.s_addr;
}


