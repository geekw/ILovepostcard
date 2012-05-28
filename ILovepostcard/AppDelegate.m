//
//  AppDelegate.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-9.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#define ClientIdURL @"http://61.155.238.30/postcards/interface/client_id"

#import "AppDelegate.h"
#import "ViewController.h"
#import "UIDevice+IdentifierAddition.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

#pragma mark - View lifecycle - 系统函数
- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    NSString *clienIdStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"ClientId"];
    if (clienIdStr == nil)
    {
        [self performSelector:@selector(getClientId)];//获取ClientId
    }
    
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

#pragma mark - GetClientId - 返回clientId
-(void)getClientId
{
    NSString *clientStr = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    NSLog(@"clientStr = %@",clientStr);
    
    NSString*  systemVersion=[[UIDevice currentDevice] systemVersion];
    NSLog(@"systemVersion = %@",systemVersion);
    
    NSString *loadString = [ClientIdURL stringByAppendingFormat:@"?cos=1&imei=%@&c=1&iv=%@",clientStr,systemVersion];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:loadString]];
    request.delegate = self;
    [request setDidFinishSelector:@selector(getClientIdFineshed:)];//正常情况取得json数据
    [request startAsynchronous];
    
}

- (void)getClientIdFineshed:(ASIHTTPRequest *)request//取得json数据
{
    [[NSUserDefaults standardUserDefaults] setValue:[request responseString] forKey:@"ClientId"];
    NSLog(@"cid = %@",[[ NSUserDefaults standardUserDefaults] valueForKey:@"ClientId"]);
}


@end
