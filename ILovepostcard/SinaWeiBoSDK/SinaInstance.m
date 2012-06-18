//
//  SinaInstance.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-6-18.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "SinaInstance.h"
#import "JSON.h"
#import "WBEngine.h"

#define kAppKey @"1086873395"
#define kAppSecret @"23beaa470da2b1abfe3542075a3fb62a"
#define kHasAuthoredSina @"hasAuthoredSina"


static SinaInstance *sharedInstance = nil;
static WBEngine *engine = nil;
static id <SinaShareDelegate> delegate;

@implementation SinaInstance

+ (SinaInstance*)sharedManager
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            [[self alloc] init]; // assignment not done here
            engine = [[WBEngine alloc] initWithAppKey:kAppKey appSecret:kAppSecret];
//            [engine setDelegate:self];
            [engine setRedirectURI:@"http://www.52mxp.com/web/index.html"];
            [engine setIsUserExclusive:NO];

        }
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

+(void)logInSinaWB{
    [engine logIn];
}

+(void)logOutSinaWB{
    [engine logOut];
}

+(void)sendContentWith:(NSString *)sendTxt 
               sendImg:(UIImage *)_image{
    if ([engine isLoggedIn])
    {
        [engine sendWeiBoWithText:sendTxt image:_image];
    }
    else
    {
        [self logInSinaWB];
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
- (id)retain
{
    return self;
}
- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}
- (void)release
{
    //do nothing
}
- (id)autorelease
{
    return self;
}

@end
