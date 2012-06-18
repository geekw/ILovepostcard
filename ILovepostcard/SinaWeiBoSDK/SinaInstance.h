//
//  SinaInstance.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-6-18.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBEngine.h"

@protocol SinaShareDelegate <NSObject>

- (void)sinaLoginFinished;
- (void)sinaLoginFailed;
- (void)sinaSendFinished;
- (void)sinaSendFailed;

@end


@interface SinaInstance : NSObject<WBEngineDelegate>

+(void)logInSinaWB;

+(void)logOutSinaWB;

+(void)sendContentWith:(NSString *)sendTxt 
                sendImg:(UIImage *)_image;


@end
