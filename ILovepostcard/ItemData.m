//
//  ItemData.m
//  ILovepostcard
//
//  Created by wang piepie on 12-6-3.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "ItemData.h"

@implementation ItemData

@synthesize title,loveCount,image;

- (id)init
{
    if ((self = [super init])) 
    {
        title = nil; 
        loveCount = nil;
        image = nil;
    }
    return self;
}

- (void)dealloc
{
    [title release];
    [loveCount release];
    [image release];
    [super dealloc];
}

@end
