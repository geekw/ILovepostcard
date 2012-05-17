//
//  ILPostcardList.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-14.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "ILPostcardList.h"

static ILPostcardList *instance;
const int LIST_CAPACITY = 1000;

@implementation ILPostcardList
@synthesize templateAbstractList;

+(ILPostcardList *)sharedILPostcardList
{
    if (instance == nil)
    {
        instance = [ILPostcardList new];
    }
    return instance;
}

- (id)init
{
    if (self == [super init])
    {
        templateAbstractList = [[NSMutableArray alloc] initWithCapacity:LIST_CAPACITY];
    }
    return self;
}

- (void)dealloc
{
    [instance release];
    [super dealloc];
}

@end
