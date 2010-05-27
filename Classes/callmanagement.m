//
//  callmanagement.m
//  spokn
//
//  Created by Mukesh Sharma on 06/05/10.
//  Copyright 2010 Geodesic Ltd. All rights reserved.
//

#import "callmanagement.h"

#import "callviewcontroller.h"
#import  "alertmessages.h"
@implementation CallManagement
-(id) init
{
	self = [super init];
	[self resetLineId];
	order = 10;
	return self;

}
-(int) getindexByLineID:(int)llineID
{
	for(int i=0;i<MAXCALL;++i)
	{
		if(callID[i].lineID==llineID)
			return i;
	}
	return -1;
}
-(int) resetLineId
{
	for(int i=0;i<MAXCALL;++i)
	{
		memset(&callID[i],0,sizeof(CallStructType));
		callID[i].lineID  = -1;
		callID[i].order  = 100;
	}
	return 0;
	
}
-(int)sortByOrder
{
	int i,j;
	CallStructType t;
	int index = -1;
	for(i=0;i<MAXCALL;++i)
	{
		
		for(j=0;j<MAXCALL-2;++j)
		{
			if(callID[j].order>callID[j+1].order)
			{
				t = callID[j];
				callID[j] = callID[j+1];
				callID[j+1] = t;
			}
		}
		
	}
	if(count>0)
	{	
		for(i=0;i<MAXCALL;++i)
		{
			if(callID[i].lineID>=0)
			{
				index  = i;
			}
		}	
	}	
	return index;//this is index of active id 
	
}

-(int) addLineId:(int) lineID
{
	int index = -1;
	for(int i=0;i<MAXCALL;++i)
	{
		if(callID[i].lineID==-1)
		{
			memset(&callID[i],0,sizeof(CallStructType));
			callID[i].order = order++;
			callID[i].lineID  = lineID;
			count++;
			index = i;
			break;		
			
			
		}
	}
	[self sortByOrder];
	if(index>=0)
	{	
		index = 	[self getindexByLineID:lineID];
	}
	return index;
	
}
-(void)setHoldOnOtherThen:(int)llineid
{
	for(int i=0;i<MAXCALL;++i)
	{
		if(callID[i].lineID==llineid)
		{
			callID[i].hold = 0;			
			
		}
		else {
			callID[i].hold = 1;	
		}
	}
	
	
}

-(int) removeLineId:(int)lineID
{
	int newlineid = -1;
	for(int i=0;i<MAXCALL;++i)
	{
		if(callID[i].lineID==lineID)
		{
			callID[i].isConfB = 0;
			callID[i].lineID  = -1;
			callID[i].order  = 100;
			callID[i].min  = 0;
			callID[i].hour  = 0;
			callID[i].sec  = 0;
			callID[i].startTime  = 0;
			callID[i].timecallduration   = 0;
			[callID[i].labelStrP release];
			callID[i].labelStrP = 0;
			[callID[i].labeltypeStrP release];
			callID[i].labeltypeStrP = 0;
			count--;
			
			break;
		}
		
	}
	
	newlineid = [self sortByOrder];
	
	return newlineid;
	
}
-(int)freeSlotForCall
{
	if(count<MAXCALL)
	{
		return 0;
	}
	return 1;


}
-(int) addCall:(int)llineID :(NSString *)nameStrP :(NSString*)typeStrP
{
		
	int t;
	t = [self addLineId:llineID];
	if(t<0)
	{
		return 1;
	
	}
	activeLineId2 = activeLineId;
	activeLineId  = 	t;
	
	rowTable[0] = activeLineId2;
	rowTable[1] = activeLineId;

		
	[self setHoldOnOtherThen:llineID];
	totalDisplayCall++;
	callID[activeLineId].labelStrP = nameStrP; 
	[nameStrP retain]; 
	callID[activeLineId].labeltypeStrP = typeStrP;
	[typeStrP retain];
	return 0;
	
}
-(int)totalCallActive
{
	return [self totalCallInConf];
}
-(int)getCount
{
	return count;
}
-(NSString*)getStringByIndex:(int)index
{
	int j = 0;
	index++;
	
	j=maxCallConf[index];
	NSLog(@"\n%d %@",callID[j].lineID,callID[j].labelStrP);
	return callID[j].labelStrP;
	
}
-(void)setConfCallIndex
{
	
	int j=0;
	int i=0;
	memset(maxCallConf,0,MAXCALL);
	for(i=0;i<MAXCALL;++i)
	{
		if(callID[i].isConfB)
		{
			maxCallConf[j]=i;
			j++;
		}
			
	}


}

-(void) selectedCall:(int)index
{
	if(count<4)//mean only two call in confrence
	{
		int llineID;
		llineID = callID[index+1].lineID;
		[self removeCallByID:CONFERENCE_LINE_ID];
		conferenceOn = 0;
		showDiscloser = NO;
		activeLineId = [self getindexByLineID:llineID];
		
		if(activeLineId)
		{
			activeLineId2 = 0;
			rowTable[0] = activeLineId2;
			rowTable[1] = activeLineId;

		}
		else {
			activeLineId2 = 1;
			rowTable[1] = activeLineId2;
			rowTable[0] = activeLineId;
		}
		callID[activeLineId2].isConfB = FALSE;
		callID[activeLineId].isConfB = FALSE;
	
	}
	else {
		activeLineId2 = 0;//confrence
		activeLineId = index+1;
		showDiscloser = NO;
		rowTable[0] = activeLineId2;
		rowTable[1] = activeLineId;
		callID[activeLineId].isConfB = FALSE;
		
	}
	callID[activeLineId].isConfB = false;
	totalDisplayCall++;
}
-(void)assignNewIndex
{
	int j=0;
	for(int i=0;i<MAXCALL;++i)
	{
		if(callID[i].lineID>=0)
		{
			rowTable[j++] = i;
			if(j>1)
				break;
		}
		
	}


}
-(int)getActiveLineID
{
	if(activeLineId<0)
	{
		return -1;
	}

	return callID[activeLineId].lineID;
}
-(int)removeCallByID:(int)llineID
{
	int indexl;
	int conf=false;
	indexl = [self getindexByLineID:llineID];
	if(indexl>=0)
	{
		conf=callID[indexl].isConfB;
	}
	activeLineId = [self removeLineId :llineID];
	if(llineID==CONFERENCE_LINE_ID ||(conferenceOn && [self totalCallInConf]<=1))//mean confrence
	{
		//UnconferenceInterface(ownerobject.ltpInterfacesP);
		conferenceOn = 0;
		showDiscloser = 0;
		if(llineID!=CONFERENCE_LINE_ID)
		{
			activeLineId = [self removeLineId :CONFERENCE_LINE_ID];
		}
		[self putAllCallInConfrance:NO];
	}
	else
	{
		if(conferenceOn&&count>1)
		{
			activeLineId = 0;
			showDiscloser = 1;
			if(conf==false)//mean private call is removed
			{
				totalDisplayCall = 1;
				activeLineId2 = activeLineId;
				activeLineId = [self getindexByLineID:CONFERENCE_LINE_ID];//confrence
				
				//callID[activeLineId].labelStrP = [self makeNewStringFromAllName]; 
				conferenceOn = 1;
				showDiscloser = 1;
				return activeLineId;
			}
		}
	}
	[self assignNewIndex ];
	return activeLineId;
}
-(int)upDateView
{
	if(self->count==1)
	{
		return 1;
	}
	else {
		if(conferenceOn  && totalDisplayCall==1)
		{
			return 1;
		}
			
	}
	return 0;



}
-(int) updatescreenData:(int)time :(NSString**)lmainlableP :(NSString**)lmainTypeP  :(NSString**)llable1P  :(NSString**)type1P :(NSString**)llable2P :(NSString**)type2P 
{
	
	if(activeLineId<0 || count<1)
	{
		return -1;
	}
	if(time==0)
	{
		*lmainlableP = callID[activeLineId].labelStrP;
		[callID[activeLineId].labelStrP retain];
		*lmainTypeP = callID[activeLineId].labeltypeStrP;
		[callID[activeLineId].labeltypeStrP retain];
		
		

	
	}
	else {
		
		*lmainTypeP = [[NSString alloc] initWithFormat:@"%2d:%02d",callID[activeLineId].min,callID[activeLineId].sec];
		

		
	}

	if(activeLineId>=0)
	{	
		
		NSString *str;
		 
			
			
			if(activeLineId==rowTable[0])
			{
				
				if(time==0)
				{	
					*llable1P = callID[activeLineId].labelStrP;
					[*llable1P retain];
					//[name1LabelP setText:callID[activeLineId].labelStrP];
					if(callID[activeLineId].startTime==0)
					{
						*type1P = callID[activeLineId].labeltypeStrP;
						[*type1P retain];
					}
					*llable2P = callID[rowTable[1]].labelStrP;
					[*llable2P retain];	
					*type2P = [[NSString alloc]initWithString:@"HOLD"];
					
				}
				else {
					str = [[NSString alloc] initWithFormat:@"%2d:%02d",callID[activeLineId].min,callID[activeLineId].sec];
					*type1P = str;
				}
				
			}
			else
			{
				
				if(time==0)
				{	
					*llable2P = callID[activeLineId].labelStrP;
					[*llable2P retain];
					//[name1LabelP setText:callID[activeLineId].labelStrP];
					if(callID[activeLineId].startTime==0)
					{
						*type2P = callID[activeLineId].labeltypeStrP;
						[*type2P retain];
					}
					*llable1P = callID[rowTable[0]].labelStrP;
					[*llable1P retain];	
					*type1P = [[NSString alloc]initWithString:@"HOLD"];
					
				}
				else {
					str = [[NSString alloc] initWithFormat:@"%2d:%02d",callID[activeLineId].min,callID[activeLineId].sec];
					*type2P = str;
				}
			}	
	}
				
	
	
	/*
	 if(time==0)
	 {	
	 if(lactiveLineId>=0)
	 {	
	 [labelStrP release];
	 labelStrP = callID[activeLineId].labelStrP;
	 [labelStrP retain]; 
	 [labelStrP release];
	 [labeltypeStrP release];
	 labeltypeStrP = callID[activeLineId].labeltypeStrP ;
	 [labeltypeStrP retain];
	 }
	 }	
	 
	 if(activeLineId>=0)
	 {	
	 
	 NSString *str;
	 if(count == 1 ||( confrenceOn && showDiscloser))
	 {	
	 [callnoLabelP setText:callID[activeLineId].labelStrP];
	 if(callID[activeLineId].startTime==0)
	 [callTypeLabelP setText:callID[activeLineId].labeltypeStrP];
	 }	
	 else {
	 
	 
	 if(activeLineId==0)
	 {
	 NSString *str;
	 if(time==0)
	 {	
	 [name1LabelP setText:callID[activeLineId].labelStrP];
	 if(callID[activeLineId].startTime==0)
	 [type1LabelP setText:callID[activeLineId].labeltypeStrP];
	 [name2LabelP setText:callID[activeLineId2].labelStrP];
	 [type2LabelP setText:@"hold"];
	 }
	 else {
	 str = [NSString stringWithFormat:@"%2d:%2d",callID[activeLineId].min,callID[activeLineId].sec];
	 [type1LabelP setText:str];
	 }
	 
	 }
	 else
	 {
	 
	 if(time==0)
	 {	
	 [name2LabelP setText:callID[activeLineId].labelStrP];
	 if(callID[activeLineId].startTime==0)
	 [type2LabelP setText:callID[activeLineId].labeltypeStrP];
	 [name1LabelP setText:callID[activeLineId2].labelStrP];
	 [type1LabelP setText:@"hold"];
	 }
	 else {
	 str = [NSString stringWithFormat:@"%2d:%2d",callID[activeLineId].min,callID[activeLineId].sec];
	 [type2LabelP setText:str];
	 }
	 
	 
	 }
	 
	 
	 
	 }
	 
	 }*/ 
	return activeLineId;
}
-(void)callStart:(int)llineID
{
	int index = [self getindexByLineID:llineID];
	
	if(index>=0)
	{
		
		if(callID[index].startTime==0)
		{	
			callID[index].startTime = 1;
			callID[index].timecallduration = 0;
			callID[index].min = 0;
			callID[index].hour = 0;
			callID[index].sec = 0;
		}	
	}
	
	
}
-(NSString*) makeNewStringFromAllName
{
	NSMutableString *resultP;
	int first;
	resultP = [[NSMutableString alloc] init];
	for(int i=0;i<MAXCALL;++i)
	{
		if(callID[i].lineID!=CONFERENCE_LINE_ID)
		{
			if(callID[i].labelStrP)
			{	
				if(first)
				{
					first = false;
					[resultP appendFormat:@"%@",callID[i].labelStrP];
				}
				else {
					[resultP appendFormat:@", %@",callID[i].labelStrP];
				}

				
			}	
		}
	}
	return resultP;
}
-(void) upDateTime
{
	for(int i=0;i<MAXCALL;++i)
	{	
		
		if(callID[i].startTime == 1 && callID[i].lineID>=0)
		{	
			callID[i].timecallduration++;
			time_t timeP = {0};
			struct tm ;// tmLoc;
			timeP = callID[i].timecallduration;
			if(callID[i].sec>59)
			{
				callID[i].min++;
				callID[i].sec=0;
			}
			if(callID[i].min>59)
			{
				callID[i].min = 0;
				callID[i].hour++;
			}
			callID[i].sec++;
		}	
	}	
	
	
}
-(int)shouldStartConfrence
{
	if(count>1 && conferenceOn==0 && showDiscloser==0)
		return 1;
	if(conferenceOn && totalDisplayCall>1)//mean one of the call is private
	{
		totalDisplayCall = 1;
		return 2;
	}
	return 0;

}
-(int)totalCallInConf
{
	int lcount = 0;
	for(int i=0;i<count;++i)
	{
		if(callID[i].isConfB  && callID[i].lineID!=CONFERENCE_LINE_ID)
			lcount++;
	}
	return lcount;
}
-(int)putAllCallInConfrance:(int)YesB
{
	for(int i=0;i<MAXCALL;++i)
	{
		callID[i].isConfB = YesB;
	}
	if(YesB)
	{	
		totalDisplayCall = 1;
		activeLineId2 = activeLineId;
		activeLineId = [self getindexByLineID:CONFERENCE_LINE_ID];//confrence
		conferenceOn = 1;
		showDiscloser = 1;
	}
	//callID[activeLineId].labelStrP = [self makeNewStringFromAllName]; 
	
	
	return 0;

}
-(int)RemoveAllCallInConf:(CallViewController*)calP
{
	for(int i=0;i<MAXCALL;++i)
	{
		if(callID[i].isConfB && callID[i].lineID!=-1)
		{
			if(callID[i].lineID!=CONFERENCE_LINE_ID)
			{
				[calP handupCall:callID[i].lineID];
			}
			callID[i].isConfB = 0;
			callID[i].lineID  = -1;
			callID[i].order  = 100;
			callID[i].min  = 0;
			callID[i].hour  = 0;
			callID[i].sec  = 0;
			callID[i].startTime  = 0;
			callID[i].timecallduration   = 0;
			[callID[i].labelStrP release];
			callID[i].labelStrP = 0;
			[callID[i].labeltypeStrP release];
			callID[i].labeltypeStrP = 0;
			count--;
			
			
		}
	}
	
	activeLineId =  [self sortByOrder];
	return activeLineId;

}
-(int)makeconfrence:(NSString*)confLabelP : (NSString*)typeLabelP
{
	int oldOrder;
	oldOrder = order;
	order = 1;
	totalDisplayCall = 1;
	activeLineId2 = -1;
	activeLineId = [self addLineId:CONFERENCE_LINE_ID];//confrence
	
	//callID[activeLineId].labelStrP = [self makeNewStringFromAllName]; 
	callID[activeLineId].labelStrP = confLabelP;
	[confLabelP retain]; 
	
	callID[activeLineId].startTime = 1;
	callID[activeLineId].labeltypeStrP = typeLabelP;
	[typeLabelP retain];
	
	
	order = oldOrder;
	
	conferenceOn = 1;
	showDiscloser = 1;
	return 1;

}
-(int)swapLineID
{
	if((count>1 && conferenceOn==FALSE) || (conferenceOn==TRUE && totalDisplayCall>1) )
	{
		int t;
		t= activeLineId;
		activeLineId = activeLineId2;
		activeLineId2 = t;
		return 1;
	
	}
	return 0;
}
-(int)isConfranceOnForIndex:(int)index
{
	if(conferenceOn)
	{
		if(callID[index].lineID == CONFERENCE_LINE_ID  && callID[activeLineId].lineID == CONFERENCE_LINE_ID)
		{
			return 1;
		}
	
	}
	return 0;
}
-(int)isConfranceOn
{
	return conferenceOn;
}
 -(int)swapRow:(int)row
{
	if(rowTable[row]!=activeLineId)
		return 1;
	return 0;

}
-(int)imageForholdAndAddCall:(NSString**)holdImagePP :(NSString**)addCallImagePP :(int*)disableP
{
	if(disableP)
	{
		*disableP = NO;
	}
	
	if((conferenceOn==false && count>1 )|| (conferenceOn==YES && totalDisplayCall>1) )
	{
		*holdImagePP = [[NSString alloc ] initWithString:SWAP_CALL_IMG_PNG];
		*addCallImagePP = [[NSString alloc ] initWithString:MERGE_CALL_IMG_PNG];
	}
	else {
		*holdImagePP = [[NSString alloc ] initWithString:HOLD_CALL_PNG];
		*addCallImagePP = [[NSString alloc ] initWithString:ADD_CALL_PNG];
		if(count<MAXCALL)
		{
			
			if(disableP)
			{	
				*disableP = NO;
			}	
		}
		else
		{
			
			if(disableP)
			{	
				*disableP = YES;
			}	
		}

	}

	return 0;

}
-(int)getTotalDisplayCall
{
	return totalDisplayCall;
}
@end
