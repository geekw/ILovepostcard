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
#import "ItemCell.h"
//#import "AlixPayOrder.h"



@interface ActivityListView ()

@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) BOOL refreshing;

- (NSString *)generateTradeNO;


@end

@implementation ActivityListView
@synthesize goBackButton;

@synthesize dataArray,dataTableView,page,refreshing;


/*
 *随机生成15位订单号,外部商户根据自己情况生成订单号
 */
- (NSString *)generateTradeNO
{
	const int N = 15;
	
	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *result = [[[NSMutableString alloc] init] autorelease];
	srand(time(0));
	for (int i = 0; i < N; i++)
	{   
		unsigned index = rand() % [sourceString length];
		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
		[result appendString:s];
	}
	return result;
}


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
    if (self)
    {
        page = 0;
        dataArray = [[NSMutableArray alloc] init];
        dataTableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 44, 320, 416)];
        dataTableView.delegate = self;
        dataTableView.dataSource = self;
        dataTableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:dataTableView];

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    currentPage = 1;
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
    [dataArray release];
    [dataTableView release];
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
    
    if (page == 0) 
    {
        [dataTableView launchRefreshing];
    }
    
    NSDictionary *activityListDict = [activityListArray objectAtIndex:0];
    NSLog(@"activityListDict = %@",activityListDict);
    
}


- (void)loadData
{
}


#pragma mark - TableView*

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *uniqueIdentifier = @"ItemCell";
    
    ItemCell  *cell = nil;
    
    cell = (ItemCell *) [tableView dequeueReusableCellWithIdentifier:uniqueIdentifier];
    
    if(!cell)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ItemCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[ItemCell class]])
            {
                cell = (ItemCell *)currentObject;
                break;
            }
        }
    }
    return cell;
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [df dateFromString:@"2012-05-03 10:10"];
    [df release];
    return date;
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];    
}

#pragma mark - Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [dataTableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [dataTableView tableViewDidEndDragging:scrollView];
}


@end
