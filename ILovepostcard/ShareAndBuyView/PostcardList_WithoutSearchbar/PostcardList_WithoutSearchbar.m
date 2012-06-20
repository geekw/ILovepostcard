//
//  PostcardList_WithoutSearchbar.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-6-6.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#define NumberInOnePage 6 //每页显示个数
#define Template_Activity @"http://61.155.238.30/postcards/interface/activity_template_list"
#define Template_Keyword_Activity @"http://61.155.238.30/postcards/interface/query_activity_template"

#import "PostcardList_WithoutSearchbar.h"
#import "JSON.h"


@implementation PostcardList_WithoutSearchbar
@synthesize displayEachTemplateDetals;
@synthesize goBackBtn;
@synthesize listScrollView;
@synthesize mySearchBar_Activity;
@synthesize keyword_Activity;

int currentPage;
bool fromSearch;

#pragma mark - GoBack - 返回按钮
-(IBAction)goBack
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - View lifecycle - 系统函数
- (void)dealloc
{
    keyword_Activity = nil;
    [goBackBtn release];
    [listScrollView release];
    [mySearchBar_Activity release];
    [super dealloc];
    displayEachTemplateDetals = nil;[displayEachTemplateDetals release];

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.goBackBtn setImage:[UIImage imageNamed:@"titlebtnbackclick.png"] forState:UIControlStateHighlighted];
    self.listScrollView.contentSize = CGSizeMake(320, 400);
    self.listScrollView.pagingEnabled = YES;
    self.listScrollView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    fromSearch = NO;
    currentPage = 1;
    addTemplatePageNumber = 0;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"withOrWithoutSearchBar"] == NO) 
    {
      self.mySearchBar_Activity.hidden = NO;
      self.listScrollView.frame = CGRectMake(0, 94, 320, 391);
     [self performSelector:@selector(dealWithSearchBar)];//美化searchBar

    }
    else 
    {
      self.mySearchBar_Activity.hidden = YES;
      self.listScrollView.frame = CGRectMake(0, 50, 320, 391);
    }
    
    [self performSelector:@selector(loadHttpRequset)];//请求模板
}


#pragma mark - NormalRequest - 正常请求模板列表
- (void)loadHttpRequset
{
    fromSearch = NO;
    if ([self.listScrollView subviews] != nil)
    {
        [[self.listScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }

    NSString *idStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"ActivityID"];

    NSString *loadString = [Template_Activity stringByAppendingFormat:@"?id=%d&p=%d&s=%d",[idStr intValue],currentPage,NumberInOnePage];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:loadString]];
    request.delegate = self;
    [request setDidFinishSelector:@selector(getTemplateFinished:)];//正常情况取得json数据
    [request setDidFailSelector:@selector(getTemplateFailed:)];//正常情况获取失败的提示
    [request startAsynchronous];
}

-(void)getTemplateFailed:(ASIHTTPRequest *)request//网络故障提示
{
    PromptView *tmpProptView = [[PromptView alloc] init];
    [tmpProptView showPromptWithParentView:self.view
                                withPrompt:@"网络不通" 
                                 withFrame:CGRectMake(40, 120, 240, 240)];
    [tmpProptView  release];
    NSError *error = [request error];
    NSLog(@"error:%@", error);
}

- (void)getTemplateFinished:(ASIHTTPRequest *)request//取得json数据
{
    NSDictionary *dict = [request responseString].JSONValue;
    
    if (fromSearch == YES)
    {
        NSString *result_codeString = [dict objectForKey:@"result_code"];
        if ([result_codeString intValue] == 0)//没有找到模板
        {
            [self performSelector:@selector(showNoneSearchResult)];//没有模板的提示    
        }
    }
    
    NSString *pageTotal = [dict objectForKey:@"page_total"];//---第一级解析
    page_total = [pageTotal intValue];  
    
    NSString *idString  =  [dict objectForKey:@"activity_id"];
    [[NSUserDefaults standardUserDefaults] setObject:idString forKey:@"activity_id"];
    
    NSArray *templatesArray = [dict objectForKey:@"templates"];//---第一级解析
    
    //    NSString *numberInOnePage = [NSString stringWithFormat:@"%@",[templatesArray count]];
    NSNumber *numberInOnePage = [NSNumber numberWithInt:[templatesArray count]];
    
    if ([ILPostcardList sharedILPostcardList].templateAbstractList_SearchBar != nil) 
    {
        [[ILPostcardList sharedILPostcardList].templateAbstractList_SearchBar removeAllObjects];
    }
    
    for (int i = 0; i < [numberInOnePage intValue]; i ++)
    {
        NSDictionary *tempDict = [templatesArray objectAtIndex:i];
        [self performSelector:@selector(layOutTemplate:) withObject:tempDict];//解析json数据
    }
    
    [self performSelector:@selector(displayEachTemplate:) withObject:numberInOnePage];//读取保存到单例的数组,并展示  
}

-(void)layOutTemplate:(NSDictionary *)dict//解析json数据
{
    NSMutableDictionary *tmpDictionary = [[NSMutableDictionary alloc] init];
    NSLog(@"dict = %@",dict);
    
    NSString *idStr = [dict objectForKey:@"id"];
    [tmpDictionary setObject:idStr forKey:@"id"];
        
    NSString *templateNameString = [dict objectForKey:@"name"]; 
    [tmpDictionary setObject:templateNameString forKey:@"name"];
    
    NSString *backgroundPicUrl = [dict objectForKey:@"preview"];
    [tmpDictionary setObject:backgroundPicUrl forKey:@"preview"];
    
    NSString *tagsString = [dict objectForKey:@"tags"];
    [tmpDictionary setObject:tagsString forKey:@"tags"];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"withOrWithoutSearchBar"] == NO) 
    {
        self.mySearchBar_Activity.text = [NSString stringWithFormat:@"%@",tagsString];
    }
    
    [[ILPostcardList sharedILPostcardList].templateAbstractList_SearchBar addObject:tmpDictionary];
    
    [tmpDictionary release];
}

- (void)viewDidUnload
{
    [self setGoBackBtn:nil];
    [self setListScrollView:nil];
    [self setMySearchBar_Activity:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - SearchBar - 1.美化searchBar_带关键字
- (void)dealWithSearchBar
{
    [[self.mySearchBar_Activity.subviews objectAtIndex:0] removeFromSuperview];
    self.mySearchBar_Activity.placeholder = [NSString stringWithFormat:@"请输入您感兴趣的模板"];
    self.mySearchBar_Activity.translucent = YES;//半透明
    self.mySearchBar_Activity.delegate = self;
    self.mySearchBar_Activity.showsCancelButton = NO;//未输入文字前显示取消按钮
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.mySearchBar_Activity.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	self.mySearchBar_Activity.showsCancelButton = NO;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.keyword_Activity = nil;
    self.keyword_Activity = [NSString stringWithFormat:@"%@",searchText];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[self.mySearchBar_Activity resignFirstResponder];
//    [self viewWillAppear:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{ 
    if (self.keyword_Activity != nil) 
    {
        [self performSelector:@selector(searchOnline_Keyword)];
    }
}

#pragma mark - SearchBar - 2.点击search事件_带关键字
-(void)searchOnline_Keyword
{
    currentPage = 1;
    addTemplatePageNumber = 0; 
    fromSearch = YES;
    
    NSString *idStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"ActivityID"];
    [self.mySearchBar_Activity resignFirstResponder];
    int cid =[[[NSUserDefaults standardUserDefaults] objectForKey:@"ClientId"] intValue];
    NSString *keywordString = [self urlEncodedString:self.keyword_Activity];//中文字符转换成url可用的字符串
    NSString *requsetString = [Template_Keyword_Activity stringByAppendingFormat:@"?t=%@&p=%d&s=%d&cid=%d&id=%d",keywordString,currentPage,NumberInOnePage,cid,[idStr intValue]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requsetString]];
    request.delegate = self;
    [request setDidFinishSelector:@selector(getTemplateFinished:)];//带关键字-取json数据
    [request setDidFailSelector:@selector(getTemplateFailed:)];//联网失败提示
    [request startAsynchronous];
}

- (NSString *)urlEncodedString:(NSString *)string//中文字符转换成url可用的字符串
{
    NSData *utf8Data = [string dataUsingEncoding:NSUTF8StringEncoding];
	char *hex = "0123456789ABCDEF";
	unsigned char * data = (unsigned char*)[utf8Data bytes];
	int len = [utf8Data length];
	NSMutableString* s = [NSMutableString string];
	for(int i = 0;i<len;i++){
		unsigned char c = data[i];
		if( ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z') || ('0' <= c && c <= '9') )
        {
			NSString *ts = [[NSString alloc] initWithCString:(char *)&c length:1];
			[s appendString:ts];
			[ts release];
		} 
        else 
        {
			[s appendString:@"%"];
			char ts1 = hex[c >> 4];
			NSString *ts = [[NSString alloc] initWithCString:&ts1 length:1];
			[s appendString:ts];
			[ts release];
            
			char ts2 = hex[c & 15];
			ts = [[NSString alloc] initWithCString:&ts2 length:1];
			[s appendString:ts];
			[ts release];
		}
	}
	return s;
}

-(void)showNoneSearchResult//没有模板的提示
{
    PromptView *tmpProptView = [[PromptView alloc] init];
    [tmpProptView showPromptWithParentView:self.view
                                withPrompt:@"还没有相关模板" 
                                 withFrame:CGRectMake(40, 120, 240, 240)];
    [tmpProptView  release];
}

#pragma mark - displayEachTemplate - 显示每一个框架
-(void)displayEachTemplate:(NSNumber *)numberInOnePage
{
    for (int i = 0; i < [numberInOnePage intValue]; i ++) 
    {
        NSDictionary *tmpDict =[[ILPostcardList sharedILPostcardList].templateAbstractList_SearchBar objectAtIndex:i];
        NSString *idString = [tmpDict objectForKey:@"id"];
        int idName = [idString intValue];
        
        NSString *templateNameString = [tmpDict objectForKey:@"name"];
        NSString *backgroundPicUrl = [tmpDict objectForKey:@"preview"];

        if (i == 0 ) 
        {
            EGOImageButton *templateButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"sendbk.png"]];
            [templateButton setImageURL:[NSURL URLWithString:backgroundPicUrl]];
            templateButton.tag = idName ;
            int y =   10 + addTemplatePageNumber * 391;
            templateButton.frame = CGRectMake(20, y, 135 , 90);
            [templateButton addTarget:self 
                               action:@selector(displayEachTemplateDetals:) 
                     forControlEvents:UIControlEventTouchUpInside];
            [self.listScrollView addSubview:templateButton];
            [templateButton release];
            
            UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(34, 104 +addTemplatePageNumber * 391, 120, 20)];
            tmpLable.text = [NSString stringWithFormat:@"%@",templateNameString]; 
            tmpLable.backgroundColor = [UIColor clearColor];
            tmpLable.textColor = [UIColor blueColor];
            [self.listScrollView addSubview:tmpLable];
            [tmpLable release];
        }
        if (i == 1 ) 
        {
            EGOImageButton *templateButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"sendbk.png"]];
            [templateButton setImageURL:[NSURL URLWithString:backgroundPicUrl]];
            templateButton.tag = idName;
            int y = 10 + addTemplatePageNumber * 391; 
            templateButton.frame = CGRectMake(164, y, 135, 90);
            [templateButton addTarget:self 
                               action:@selector(displayEachTemplateDetals:) 
                     forControlEvents:UIControlEventTouchUpInside];
            [self.listScrollView addSubview:templateButton];
            [templateButton release];
            
            UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(178, 104 + addTemplatePageNumber * 391, 120, 20)];
            tmpLable.text = [NSString stringWithFormat:@"%@",templateNameString]; 
            tmpLable.backgroundColor = [UIColor clearColor];
            tmpLable.textColor = [UIColor blueColor];
            [self.listScrollView addSubview:tmpLable];
            [tmpLable release];
        }
        if (i == 2 ) 
        {
            EGOImageButton *templateButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"sendbk.png"]];
            [templateButton setImageURL:[NSURL URLWithString:backgroundPicUrl]];
            templateButton.tag = idName;
            int y = 130 + addTemplatePageNumber * 391; 
            templateButton.frame = CGRectMake(20, y, 135, 90);
            [templateButton addTarget:self 
                               action:@selector(displayEachTemplateDetals:) 
                     forControlEvents:UIControlEventTouchUpInside];
            [self.listScrollView addSubview:templateButton];
            [templateButton release];
            
            UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(34, 224 + addTemplatePageNumber * 391, 120, 20)];
            tmpLable.text = templateNameString; 
            tmpLable.backgroundColor = [UIColor clearColor];
            tmpLable.textColor = [UIColor blueColor];
            [self.listScrollView addSubview:tmpLable];
            [tmpLable release];
        }
        if (i == 3 ) 
        {
            EGOImageButton *templateButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"sendbk.png"]];
            [templateButton setImageURL:[NSURL URLWithString:backgroundPicUrl]];
            templateButton.tag = idName;
            int y = 130 + addTemplatePageNumber * 391; 
            templateButton.frame = CGRectMake(164, y, 135, 90);
            [templateButton addTarget:self 
                               action:@selector(displayEachTemplateDetals:) 
                     forControlEvents:UIControlEventTouchUpInside];
            [self.listScrollView addSubview:templateButton];
            [templateButton release];
            
            UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(178, 224 + addTemplatePageNumber * 391, 120, 20)];
            tmpLable.text = templateNameString; 
            tmpLable.backgroundColor = [UIColor clearColor];
            tmpLable.textColor = [UIColor blueColor];
            [self.listScrollView addSubview:tmpLable];
            [tmpLable release];
        }
        if (i == 4 ) 
        {
            EGOImageButton *templateButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"sendbk.png"]];
            [templateButton setImageURL:[NSURL URLWithString:backgroundPicUrl]];
            templateButton.tag = idName;
            int y = 250 + addTemplatePageNumber * 391; 
            templateButton.frame = CGRectMake(20, y, 135, 90);
            [templateButton addTarget:self 
                               action:@selector(displayEachTemplateDetals:) 
                     forControlEvents:UIControlEventTouchUpInside];
            [self.listScrollView addSubview:templateButton];
            [templateButton release];
            
            UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(34, 344 + addTemplatePageNumber * 391, 120, 20)];
            tmpLable.text = templateNameString; 
            tmpLable.backgroundColor = [UIColor clearColor];
            tmpLable.textColor = [UIColor blueColor];
            [self.listScrollView addSubview:tmpLable];
            [tmpLable release];
        }
        if (i == 5 ) 
        {
            EGOImageButton *templateButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"sendbk.png"]];
            [templateButton setImageURL:[NSURL URLWithString:backgroundPicUrl]];
            templateButton.tag = idName;
            int y = 250 + addTemplatePageNumber * 391; 
            templateButton.frame = CGRectMake(164, y, 135, 90);
            [templateButton addTarget:self 
                               action:@selector(displayEachTemplateDetals:) 
                     forControlEvents:UIControlEventTouchUpInside];
            [self.listScrollView addSubview:templateButton];
            [templateButton release];
            
            UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(178, 344 + addTemplatePageNumber * 391, 120, 20)];
            tmpLable.text = templateNameString; 
            tmpLable.backgroundColor = [UIColor clearColor];
            tmpLable.textColor = [UIColor blueColor];
            [self.listScrollView addSubview:tmpLable];
            [tmpLable release];
        }
    } 
    if (currentPage < page_total)//判断是否到最后一页
    {
        currentPage ++;
        addTemplatePageNumber ++;
    }
}

#pragma mark - AddPage - 增加页数
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (currentPage < page_total)//如果没到最后一页
    {
        if (self.listScrollView.contentOffset.y > 20)
        {
            self.listScrollView.contentSize = CGSizeMake(320, addTemplatePageNumber*400);
            [self performSelector:@selector(loadHttpRequset)];//请求模板
        }
     }
}

#pragma mark - displayEachTemplateDetals - 点击进入每个模板详情
-(void)displayEachTemplateDetals:(UIButton *)sender
{
    DisplayEachTemplateDetals *tmpDisplayEachTemplateDetals = [[DisplayEachTemplateDetals alloc] initWithNibName:@"DisplayEachTemplateDetals" bundle:nil];
    tmpDisplayEachTemplateDetals.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    displayEachTemplateDetals = tmpDisplayEachTemplateDetals;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FromActivityList"];
    displayEachTemplateDetals.idName_Activity = [[NSUserDefaults standardUserDefaults] objectForKey:@"ActivityID"];
    displayEachTemplateDetals.idName = [NSString stringWithFormat:@"%d",sender.tag];
    [self presentModalViewController:displayEachTemplateDetals
                            animated:YES];
    [tmpDisplayEachTemplateDetals release];
}

@end
