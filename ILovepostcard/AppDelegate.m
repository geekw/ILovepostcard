//
//  AppDelegate.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-9.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize tabbar_controller = _tabbar_controller;

- (void)dealloc
{
    [_window release];
    [tabbar_controller release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    NSMutableArray *view_manager = [[NSMutableArray alloc] initWithCapacity:0];
    
    //要显示的controller
    FirstViewController  *firstViewController = [[FirstViewController alloc] init];
    UINavigationController *first_nav = [[UINavigationController alloc] initWithRootViewController:firstViewController];
    [view_manager addObject:first_nav];
    first_nav.navigationBarHidden = YES;
    [firstViewController release];
    [first_nav release];
    
    SecondViewController *secondViewController = [[SecondViewController alloc] init];
    UINavigationController *second_nav = [[UINavigationController alloc] initWithRootViewController:secondViewController];
    [view_manager addObject:second_nav];
    second_nav.navigationBarHidden = YES;
    [secondViewController release];
    [second_nav release];
    
    ThirdViewController *thirdViewController = [[ThirdViewController alloc] init];
    UINavigationController *third_nav = [[UINavigationController alloc] initWithRootViewController:thirdViewController];
    [view_manager addObject:third_nav];
    third_nav.navigationBarHidden = YES;
    [thirdViewController release];
    [third_nav release];

    tabbar_controller= [[UICustomTabController alloc] init];
    [tabbar_controller setNeed_to_custom:YES];
    [tabbar_controller setTab_bar_bg:[UIImage imageNamed:@"tools_bar_bg.png"]];
    [tabbar_controller setNormal_image:[UIImage imageNamed:@"NavBar_01.png"]];
    [tabbar_controller setSelect_image:[UIImage imageNamed:@"NavBar_01_s.png"]];
    [tabbar_controller setShow_style:UItabbarControllerShowStyleOnlyText];
    [tabbar_controller setViewControllers:view_manager]; 
    [tabbar_controller setSelectedIndex:1];
    [tabbar_controller setShow_size:40];
    tabbar_controller.hidesBottomBarWhenPushed = YES;
    
    [view_manager release];
    [self.window addSubview:tabbar_controller.view];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
