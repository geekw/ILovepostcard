//
//  TemplateDetails-Singleton.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-17.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "TemplateDetails-Singleton.h"

static TemplateDetails_Singleton *templateDetailsInstance;
const int TEMPLATEDETAILS_CAPACITY = 1000;


@implementation TemplateDetails_Singleton
@synthesize templateDetailsDict;

-(void)dealloc
{
    [templateDetailsInstance release];
    [super dealloc];
}

+(TemplateDetails_Singleton *)sharedTemplateDetails_Singleton
{
    if (templateDetailsInstance == nil)
    {
        templateDetailsInstance = [TemplateDetails_Singleton new];
    }
    return templateDetailsInstance;
}

-(id)init
{
    if (self == [super init])
    {
        templateDetailsDict = [[NSMutableDictionary dictionaryWithCapacity:TEMPLATEDETAILS_CAPACITY] retain];
    }
    return self;
}

@end
