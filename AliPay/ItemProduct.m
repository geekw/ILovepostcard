//
//  ItemProduct.m
//  ILovepostcard
//
//  Created by wang piepie on 12-6-7.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "ItemProduct.h"

@implementation ItemProduct

@synthesize price,subject,body;

- (id)init
{
    if ((self = [super init])) 
    {
        price = 0.0f; 
        subject = nil;
        body = nil;
    }
    return self;
}

- (void)dealloc
{
    [subject release];
    [body release];
    [super dealloc];
}


@end
