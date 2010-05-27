//
//  callmanagement.h
//  spokn
//
//  Created by Mukesh Sharma on 06/05/10.
//  Copyright 2010 Geodesic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "LtpInterface.h"
@class CallViewController;
#define CONFERENCE_LINE_ID 307
#define MAXCALL MAX_CALL_ALLOWED + 1
typedef struct CallStructType
{
	int lineID;
	int hold;
	int order;
	int isConfB;
	long startTime;
	long timecallduration;
	int hour,min,sec;
	NSString *labelStrP;
	NSString *labeltypeStrP;
	
}CallStructType;


@interface CallManagement : NSObject {
	CallStructType callID[MAXCALL];
	int maxCallConf[MAXCALL];
	int count;
	int activeLineId;
	int conferenceOn;
	int order;
	int showDiscloser;
	int activeLineId2;
	int rowTable[2];
	int totalDisplayCall;
	
	
}
-(int) resetLineId;
-(int) addLineId:(int)lineID;
-(int) removeLineId:(int)lineID;
-(int) getindexByLineID:(int)llineID;
-(void)setHoldOnOtherThen:(int)llineid;
-(int) addCall:(int)llineID :(NSString *)nameStrP :(NSString*)typeStrP;
-(int)totalCallActive;
-(NSString*)getStringByIndex:(int)index;
-(void) selectedCall:(int)index;
-(int)getCount;
-(int)getActiveLineID;
-(int)removeCallByID:(int)llineID;
-(int) updatescreenData:(int)time :(NSString**)lmainlableP :(NSString**)lmainTypeP  :(NSString**)llable1P  :(NSString**)type1P :(NSString**)llable2P :(NSString**)type2P ;

-(void)callStart:(int)llineID;
-(void) upDateTime;
-(int)shouldStartConfrence;
-(int)makeconfrence:(NSString*)confLabelP : (NSString*)typeLabelP;
-(int)swapLineID;
-(int)isConfranceOn;
-(int)swapRow:(int)row;
-(int)isConfranceOnForIndex:(int)index;
-(int)upDateView;
-(void)assignNewIndex;
-(int)RemoveAllCallInConf:(CallViewController*)calP;
-(int)putAllCallInConfrance:(int)YesB;
-(int)imageForholdAndAddCall:(NSString**)holdImagePP :(NSString**)addCallImagePP :(int*)disableP;
-(int)getTotalDisplayCall;
-(int)totalCallInConf;
-(int)freeSlotForCall;
-(void)setConfCallIndex;

@end
