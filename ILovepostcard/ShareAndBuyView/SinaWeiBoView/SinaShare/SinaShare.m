//
//  SinaShare.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-6-17.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "SinaShare.h"
#import "JSON.h"

#define kAppKey @"1086873395"
#define kAppSecret @"23beaa470da2b1abfe3542075a3fb62a"
#define kHasAuthoredSina @"hasAuthoredSina"



@implementation SinaShare
@synthesize delegate;

- (void)dealloc{
    [engine release];
    [delegate release];
    
    [super dealloc];
}

- (id)init{
    self = [super init];
    if (self)
    {
        engine = [[WBEngine alloc] initWithAppKey:kAppKey appSecret:kAppSecret];
        [engine setDelegate:self];
        [engine setRedirectURI:@"http://www.ohbaba.com"];
        [engine setIsUserExclusive:NO];
        
    }
    return self;
}


#pragma mark - Events

- (void)logInSinaWB
{
    [engine logIn];
}

- (void)logOutSinaWB
{
    [engine logOut];
}

- (void)sendContentWith:(NSString *)sendTxt sendImg:(UIImage *)_image
{
    if ([engine isLoggedIn])
    {
        [engine sendWeiBoWithText:sendTxt image:_image];
    }
    else
    {
        [self logInSinaWB];
    }
}

#pragma mark - Authorize 

- (void)engineDidLogIn:(WBEngine *)engine
{    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:kHasAuthoredSina];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(sinaLoginFinished)])
    {
        [self.delegate sinaLoginFinished];
    }
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:kHasAuthoredSina];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(sinaLoginFailed)])
    {
        [self.delegate sinaLoginFailed];
    }
}


- (void)engineNotAuthorized:(WBEngine *)engine
{
    
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:kHasAuthoredSina];
}

- (void)engineDidLogOut:(WBEngine *)engine
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:kHasAuthoredSina];
}


#pragma RequestDelegate

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(sinaSendFinished)])
    {
        [self.delegate sinaSendFinished];
    }
    
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(sinaSendFailed)])
    {
        [self.delegate sinaSendFailed];
    }
    
}

@end
