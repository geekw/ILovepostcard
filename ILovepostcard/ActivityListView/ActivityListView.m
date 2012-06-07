//
//  ActivityListView.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-23.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#define ActivityList @"http://61.155.238.30/postcards/interface/activity_list"//活动列表接口
#define NumberInPage 3

#import "ActivityListView.h"


@interface ActivityListView ()

@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) BOOL refreshing;
@end

@implementation ActivityListView
@synthesize goBackButton;
@synthesize goToPostcardList,postcardList_WithoutSearchbar,itemCell;
@synthesize dataArray,dataTableView,page,refreshing,dataSource;

#pragma mark - GoBack - 返回按钮
-(IBAction)goBack
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle - 系统函数
- (void)dealloc
{
    itemCell = nil;[itemCell release];
    dataSource = nil;[dataSource release];
    goToPostcardList = nil;[goToPostcardList release];
    postcardList_WithoutSearchbar = nil;[postcardList_WithoutSearchbar release];
    [dataArray release];
    [dataTableView release];
    [goBackButton release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        page = 0;
        dataArray = [[NSMutableArray alloc] init];
    if ([dataArray count] > 0)
    {
        [dataArray removeAllObjects];//清空数组
    }
        dataTableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(5, 54, 310, 420)];
        dataTableView.delegate = self;
        dataTableView.dataSource = self;
        dataTableView.backgroundColor = [UIColor clearColor];
        dataTableView.separatorColor = [UIColor clearColor];
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
    [self.goBackButton setImage:[UIImage imageNamed:@"titlebtnbackclick.png"] forState:UIControlStateHighlighted];
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
    
    for (int i = 0; i < [activityListArray count]; i++)
    {
        NSDictionary *activityListDict = [activityListArray objectAtIndex:i];
        NSLog(@"activityListDict = %@",activityListDict);
        ItemData *item = [[ItemData alloc] init];
        NSString *nameStr   = [activityListDict valueForKey:@"name"];
        NSString *picUrlStr = [activityListDict valueForKey:@"small"];
        NSString *likeStr = [activityListDict valueForKey:@"partnum"];
        NSString *effert  = [activityListDict valueForKey:@"effect"];
        item.title = nameStr;
        item.loveCount = likeStr;
        item.imageStr = picUrlStr;
        [dataArray addObject:item];
        [item release];
    }
     [dataTableView reloadData];
}

- (void)loadData
{

    [dataTableView reloadData];
//    if (refreshing)
//    {
//        page = 1;
//        refreshing = NO;
//        [dataArray removeAllObjects];
//    }
//    for (int i = 0; i < 10; i++) 
//    {
//        [dataArray addObject:@"ROW"];
//    }
//    if (page >= 3)
//    {
//        [dataTableView tableViewDidFinishedLoadingWithMessage:@"All loaded!"];
//        dataTableView.reachedTheEnd  = YES;
//    } 
//    else 
//    {        
//        [dataTableView tableViewDidFinishedLoading];
//        dataTableView.reachedTheEnd  = NO;
//        [dataTableView reloadData];
//    }
}

#pragma mark - TableView*

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *uniqueIdentifier = @"ItemCellView";
    ItemCell  *cell = (ItemCell *) [tableView dequeueReusableCellWithIdentifier:uniqueIdentifier];

    for (int i = 0; i < [dataArray count]; i++)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ItemCellView" owner:self options:nil];
      if(!cell)
      {
        cell = [topLevelObjects objectAtIndex:i];
          
        ItemData *data = [dataArray objectAtIndex:i];
        NSString *picUrlStr = data.imageStr; 
        NSLog(@"pic = %@",picUrlStr);

        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picUrlStr]]];
        [cell.imgButton setBackgroundImage:image forState:UIControlStateNormal];
          
        cell.title.text = [NSString stringWithFormat:@"%@",data.title];
        cell.loveCount.text = [NSString stringWithFormat:@"%@",data.loveCount];

      }
    }
    currentPage ++;
    return cell;
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [df dateFromString:@"2012-05-03 10:10"];
    [df release];
    return date;
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];    
}

#pragma mark - Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [dataTableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [dataTableView tableViewDidEndDragging:scrollView];
}


@end
