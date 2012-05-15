//
//  AppDelegate.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-9.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "UICustomTabController.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UICustomTabController *tabbar_controller;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UICustomTabController *tabbar_controller;


//@property (strong, nonatomic) UITabBarController *tabBarController;

@end
