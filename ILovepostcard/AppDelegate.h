//
//  AppDelegate.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-9.
//  Copyright (c) 2012年 开趣. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"


@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,ASIHTTPRequestDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;



@end
