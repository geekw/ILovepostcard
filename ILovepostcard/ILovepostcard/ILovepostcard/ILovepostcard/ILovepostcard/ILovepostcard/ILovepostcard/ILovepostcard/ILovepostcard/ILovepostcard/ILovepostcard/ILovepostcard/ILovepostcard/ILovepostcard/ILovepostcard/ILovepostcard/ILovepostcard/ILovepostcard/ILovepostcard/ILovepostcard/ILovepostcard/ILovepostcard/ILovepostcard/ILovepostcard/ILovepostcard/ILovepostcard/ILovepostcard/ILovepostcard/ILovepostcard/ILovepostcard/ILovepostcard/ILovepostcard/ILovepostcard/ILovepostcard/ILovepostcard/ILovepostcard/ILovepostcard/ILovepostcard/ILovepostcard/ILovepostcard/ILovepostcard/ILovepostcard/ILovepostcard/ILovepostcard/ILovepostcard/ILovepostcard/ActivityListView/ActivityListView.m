//
//  ActivityListView.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-23.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#define ActivityList @"http://61.155.238.30/postcards/interface/activity_list"//单个模板详情接口
#define NumberInPage 3

#import "ActivityListView.h"

@interface ActivityListView ()

@end

@implementation ActivityListView
@synthesize goBackButton;

int currentPage;

#pragma mark - GoBack - 返回按钮
-(IBAction)goBack
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - View lifecycle - 系统函数
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentPage = 1;
    [self performSelector:@selector(requestActivityList)];//请求活动列表
}

- (void)viewDidUnload
{
    [self setGoBackButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [goBackButton release];
    [super dealloc];
}

#pragma mark - ActivityList - 请求活动列表,展示列表
-(void)requestActivityList
{
    NSString *loadString = [ActivityList stringByAppendingFormat:@"?p=%d&s=%d",currentPage,NumberInPage];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:loadString]];
    request.delegate = self;
    [request setDidFinishSelector:@selector(getActivityListFinished:)];//正常情况取得json数据
    [request setDidFailSelector:@selector(getActivityListFailed:)];//网络故障提示
    [request startAsynchronous];
}

-(void)getActivityListFailed:(ASIHTTPRequest *)request//网络故障提示
{
    PromptView *tmpProptView = [[PromptView alloc] init];
    [tmpProptView showPromptWithParentView:self.view
                                withPrompt:@"网络不通" 
                                 withFrame:CGRectMake(40, 120, 240, 240)];
    [tmpProptView  release];
    NSError *error = [request error];
    NSLog(@"error:%@", error);
}

-(void)getActivityListFinished:(ASIHTTPRequest *)request
{
    NSArray *activityListArray = [request responseString].JSONValue;
    NSLog(@"activityListArray = %@",activityListArray);
    
    NSDictionary *activityListDict = [activityListArray objectAtIndex:0];
    NSLog(@"activityListDict = %@",activityListDict);
    
}


















@end
