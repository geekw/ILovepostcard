//
//  ActivityDetailView.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-6-7.
//  Copyright (c) 2012年 开趣. All rights reserved.
//
#define ActivityDetails @"http://61.155.238.30/postcards/interface/get_activity"//活动列表接口

#define degreesToRadian(x) (M_PI * (x) / 180.0)//定义弧度


#import "ActivityDetailView.h"

@implementation ActivityDetailView
@synthesize activityTag;
@synthesize goBackBtn;
@synthesize activityImgView;
@synthesize activityLabel1;
@synthesize activityLabel2;
@synthesize descriptionField;
@synthesize templateListBtn;
//@synthesize listDict;
@synthesize postcardList_WithoutSearchbar;
@synthesize promptView;
@synthesize effert;

#pragma mark - GoBack - 返回按钮
- (IBAction)goBack 
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle - 系统函数
- (void)dealloc
{
    effert = nil;
    promptView = nil;[promptView release];
    postcardList_WithoutSearchbar = nil;[postcardList_WithoutSearchbar release];
//    listDict = nil;
    [goBackBtn release];
    [activityImgView release];
    [activityLabel2 release];
    [activityLabel1 release];
    [templateListBtn release];
    [descriptionField release];
    [super dealloc];
    activityTag = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self performSelector:@selector(requestActivityList)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.goBackBtn setImage:[UIImage imageNamed:@"titlebtnbackclick.png"] forState:UIControlStateHighlighted];
}

- (void)viewDidUnload
{
    [self setGoBackBtn:nil];
    [self setActivityImgView:nil];
    [self setActivityLabel2:nil];
    [self setActivityLabel1:nil];
    [self setTemplateListBtn:nil];
    [self setDescriptionField:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - ActivityList - 请求活动列表,展示列表
-(void)requestActivityList
{
    int cid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ClientId"] intValue];
    NSString *loadString = [ActivityDetails stringByAppendingFormat:@"?id=%d&cid=%d",[self.activityTag intValue],cid];
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
    NSDictionary *dict = [request responseString].JSONValue;
    self.descriptionField.userInteractionEnabled = NO;
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"small"]]]];
    NSString *title  = [dict objectForKey:@"name"];
    NSString *heartNum = [dict objectForKey:@"partnum"];
    NSString *decriptionStr = [dict objectForKey:@"description"];
    NSString *effertStr = [dict objectForKey:@"force"];
    NSString *idStr = [dict objectForKey:@"id"];
    [[NSUserDefaults standardUserDefaults] setObject:idStr forKey:@"ActivityID"];
    
    self.activityImgView.image = image;
    self.activityLabel1.text = [NSString stringWithFormat:@"%@",title];
    self.activityLabel2.text = [NSString stringWithFormat:@"%@",heartNum];
    self.descriptionField.text = [NSString stringWithFormat:@"%@",decriptionStr];
    self.effert = effertStr;
}


#pragma mark - GoToTemplateListView - 进入模板选择界面
- (IBAction)goToTemplateListView 
{
    if ([self.effert intValue] == 1)//进入带搜索栏的
    {
       [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"withOrWithoutSearchBar"];

    }
    else if ([self.effert intValue] == 0)//进入不带搜索栏的
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"withOrWithoutSearchBar"];
    }
    PostcardList_WithoutSearchbar *tmpView = [[PostcardList_WithoutSearchbar alloc] init];
    tmpView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.postcardList_WithoutSearchbar = tmpView;
    [self presentModalViewController:self.postcardList_WithoutSearchbar animated:YES];
    [tmpView release];
    
//    if (!postcardList_WithoutSearchbar)
//    {
//        postcardList_WithoutSearchbar = [[PostcardList_WithoutSearchbar alloc] init];
//    }
//    self.postcardList_WithoutSearchbar.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentModalViewController:self.postcardList_WithoutSearchbar animated:YES];
    
}
@end
