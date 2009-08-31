/*
 *  windows.h
 *  spokn
 *
 *  Created by Mukesh Sharma on 24/08/09.
 *  Copyright 2009 Geodesic Ltd.. All rights reserved.
 *
 */

#ifndef _WINDOWS_H_
#define _WINDOWS_H_
#define GlobalAlloc(x,y) malloc(y)
#define RtlCopyMemory(x,y,z) memmove(x,y,z)
#define FillMemory(x, y, z) memset(x,z,y) 
#endif