//
//  SinaShare.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-6-17.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "SinaShare.h"
#import "JSON.h"

@implementation SinaShare
@synthesize delegate;

- (void)dealloc
{
    [engine release];
    [delegate release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        engine = [[WBEngine alloc] initWithAppKey:kAppKey appSecret:kAppSecret];
        [engine setDelegate:self];
        [engine setRedirectURI:@"http://www.52mxp.com/web/index.html"];
        [engine setIsUserExclusive:NO];
    }
    return self;
}


#pragma mark - Events

- (void)logInSinaWB
{
//    if ([engine isLoggedIn] && engine.expireTime > 0) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新浪微博" message:@"你确定要取消授权吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//        [alertView show];
//        [alertView release];
//    }
//    else {
        [engine logIn];
//    }
}

- (void)logOutSinaWB
{
    [engine logOut];
}

- (void)sendContentWith:(NSString *)sendTxt withImg:(UIImage *)myImg
{
    if ([engine isLoggedIn])
    {
        [engine sendWeiBoWithText:sendTxt image:myImg];
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
    
    if (delegate && [delegate respondsToSelector:@selector(sinaLogoutFinished)]) {
        [delegate sinaLogoutFinished];
    }
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) 
    {
        [self logOutSinaWB];
    }
}



@end
