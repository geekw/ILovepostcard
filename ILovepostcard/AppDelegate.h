//
//  AppDelegate.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-9.
//  Copyright (c) 2012年 开趣. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "FMResultSet.h"
#import "FMDatabase.h"


@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,ASIHTTPRequestDelegate>
{
    NSMutableArray *dataArray;

}

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) ViewController *viewController;

- (void)parseURL:(NSURL *)url application:(UIApplication *)application;
- (BOOL)isSingleTask;
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
@end
