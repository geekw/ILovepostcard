//
//  SinaShare.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-6-17.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBEngine.h"
#import "PromptView.h"


@protocol SinaShareDelegate <NSObject>

- (void)sinaLoginFinished;
- (void)sinaLoginFailed;
- (void)sinaSendFinished;
- (void)sinaSendFailed;
- (void)sinaLogoutFinished;

@end

@interface SinaShare : NSObject <WBEngineDelegate, UIAlertViewDelegate>
{
    WBEngine *engine;
}

@property (retain, nonatomic) id <SinaShareDelegate> delegate;

- (void)logInSinaWB;

- (void)logOutSinaWB;

- (void)sendContentWith:(NSString *)sendTxt withImg:(UIImage *)myImg;


@end
