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
#import "AlixPay.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import <sys/utsname.h>
#import "CreateFolder.h"
#import "DataItem.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize dataArray;

#pragma mark - View lifecycle - 系统函数
- (void)dealloc
{
    [_window release];
    [_viewController release];
    [dataArray release];
    [super dealloc];
}

- (BOOL)isSingleTask
{
	struct utsname name;
	uname(&name);
	float version = [[UIDevice currentDevice].systemVersion floatValue];//判定系统版本。
	if (version < 4.0 || strstr(name.machine, "iPod1,1") != 0 || strstr(name.machine, "iPod2,1") != 0) {
		return YES;
	}
	else {
		return NO;
	}
}

- (void)parseURL:(NSURL *)url application:(UIApplication *)application 
{
	AlixPay *alixpay = [AlixPay shared];
	AlixPayResult *result = [alixpay handleOpenURL:url];
	if (result) 
    {
		//是否支付成功
		if (9000 == result.statusCode) 
        {
			/*
			 *用公钥验证签名
			 */
			id<DataVerifier> verifier = CreateRSADataVerifier([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA public key"]);
			if ([verifier verifyString:result.resultString withSign:result.signString]) 
            {
				UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"支付成功!" 
																	 message:result.statusMessage 
																	delegate:nil 
														   cancelButtonTitle:@"确定" 
														   otherButtonTitles:nil];
				alertView.tag = 89;
                alertView.delegate = self;
                [alertView show];
				[alertView release];
                
			}//验签错误
			else 
            {
				UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" 
																	 message:@"签名错误" 
																	delegate:nil 
														   cancelButtonTitle:@"确定" 
														   otherButtonTitles:nil];
				[alertView show];
				[alertView release];
			}
		}
		//如果支付失败,可以通过result.statusCode查询错误码
		else
        {
			UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" 
																 message:result.statusMessage 
																delegate:nil 
													   cancelButtonTitle:@"确定" 
													   otherButtonTitles:nil];
            NSLog(@"statusMessage = %@",result.statusMessage);
			[alertView show];
			[alertView release];
		}
	}	
}
-(void)alertView:(UIAlertView *)alertView 
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 89)
    {
        if (buttonIndex == 0) 
        {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"fromZhiFuBaoClient" object:nil];
        }
    }
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    //创建文件夹
    [CreateFolder createFolder:@"ScreenShot" atDirectory:kDocuments];
    [CreateFolder createFolder:@"Record" atDirectory:kDocuments];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"ScreenShotNumber"] == 0)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"ScreenShotNumber"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SaveArray"] == nil)
    {
        NSMutableArray *saveArray = [[NSMutableArray alloc] initWithCapacity:1000];
        [[NSUserDefaults standardUserDefaults] setObject:saveArray forKey:@"SaveArray"];
    }
        
    NSString *clienIdStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"ClientId"];
    if (clienIdStr == nil)
    {
        [self performSelector:@selector(getClientId)];//获取ClientId
    }
    /*
	 *单任务handleURL处理
	 */
	if ([self isSingleTask]) 
    {
		NSURL *url = [launchOptions objectForKey:@"UIApplicationLaunchOptionsURLKey"];
		
		if (nil != url)
        {
          [self parseURL:url application:application];
		}
	}
    dataArray = [[NSMutableArray alloc] init]; 
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mydatabase" ofType:@"sqlite"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    NSLog(@"%d",fileExists);
    
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    if (![db open])
    {  
        NSLog(@"Could not open db.");  
    }  
    
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM PostCode"];  
    
    while ([rs next])
    {  
        NSLog(@"%@ %@ %@ %@",[rs stringForColumn:@"province"],[rs stringForColumn:@"city"],[rs stringForColumn:@"county"],[rs stringForColumn:@"postcode"]); //查询 
        DataItem *di = [[DataItem alloc] init];
        di.province = [rs stringForColumn:@"province"];
        di.city = [rs stringForColumn:@"city"];
        di.county = [rs stringForColumn:@"county"];
        di.postcode = [rs stringForColumn:@"postcode"];
        [dataArray addObject:di];
        NSLog(@"%@ %@ %@ %@",di.province,di.city,di.county,di.postcode);
        [di release];
    } 
    
    [rs close];
    NSLog(@"%@",dataArray);
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	
	[self parseURL:url application:application];
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


#pragma mark - GetClientId - 返回clientId
-(void)getClientId
{
    NSString *clientStr = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    NSLog(@"clientStr = %@",clientStr);
    NSString*  systemVersion=[[UIDevice currentDevice] systemVersion];
    NSString *loadString = [ClientIdURL stringByAppendingFormat:@"?cos=1&imei=%@&c=1&iv=%@",clientStr,systemVersion];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:loadString]];
    request.delegate = self;
    [request setDidFinishSelector:@selector(getClientIdFineshed:)];//正常情况取得json数据
    [request startSynchronous];
}

- (void)getClientIdFineshed:(ASIHTTPRequest *)request//取得json数据
{
    [[NSUserDefaults standardUserDefaults] setValue:[request responseString] forKey:@"ClientId"];
    NSLog(@"cid = %@",[[ NSUserDefaults standardUserDefaults] valueForKey:@"ClientId"]);
}


@end
