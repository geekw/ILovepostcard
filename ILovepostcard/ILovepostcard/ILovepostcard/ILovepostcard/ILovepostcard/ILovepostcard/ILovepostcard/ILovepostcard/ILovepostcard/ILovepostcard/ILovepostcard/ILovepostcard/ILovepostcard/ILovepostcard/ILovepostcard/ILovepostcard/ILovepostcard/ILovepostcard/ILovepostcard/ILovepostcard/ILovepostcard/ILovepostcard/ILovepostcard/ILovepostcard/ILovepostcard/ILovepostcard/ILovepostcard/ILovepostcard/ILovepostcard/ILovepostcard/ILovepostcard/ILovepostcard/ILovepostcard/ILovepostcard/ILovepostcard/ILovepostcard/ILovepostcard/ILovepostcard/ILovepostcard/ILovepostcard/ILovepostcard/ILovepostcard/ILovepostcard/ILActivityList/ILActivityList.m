//
//  NSObject+ILActivityList.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-23.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "ILActivityList.h"

static ILActivityList *activityListInstance;
const int ACTIVITYLIST = 1000;

@implementation ILActivityList
@synthesize activityListDict;


-(void)dealloc
{
    [activityListInstance release];
    [super dealloc];
}

+(ILActivityList *)sharedILActivityList
{
    if (activityListInstance == nil)
    {
        activityListInstance = [ILActivityList new];
    }
    return activityListInstance;
}

-(id)init
{
    if (self == [super init]) 
    {
        activityListDict = [[NSMutableDictionary dictionaryWithCapacity:ACTIVITYLIST] retain];
    }
    return self;
}


@end
