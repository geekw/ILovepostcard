//
//  DataItem.m
//  SQLTest
//
//  Created by wang piepie on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataItem.h"

@implementation DataItem

@synthesize province,city,county,postcode;

- (id)init
{
    if ((self = [super init]))
    {
        province = nil;
        city = nil;
        county = nil;
        postcode = nil;
    }
    
    return self;
}


- (void)dealloc 
{    
    [province release];
    province = nil;
    [city release];
    city = nil;
    [county release];
    county = nil;
    [postcode release];
    postcode = nil;
    [super dealloc];
}

@end
