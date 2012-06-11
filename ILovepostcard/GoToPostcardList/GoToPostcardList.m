//
//  GoToPostcardList.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-14.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "GoToPostcardList.h"
#import "SBJson.h"

#define NumberInOnePage 6 //每页显示个数
#define Template @"http://61.155.238.30/postcards/interface/template_list"//模板列表接口
#define Template_Keyword @"http://61.155.238.30/postcards/interface/query_template"//模板列表接口
#define Search_Hots @"http://61.155.238.30/postcards/interface/search_hots"//热门关键字


@implementation GoToPostcardList
@synthesize bottomKeywordScrollView;
@synthesize bottomKeywordView;
@synthesize keyword,mySearchBar;

int currentPage;
int currentPage_Keyword;

#pragma mark - GoBack - 返回按钮
-(IBAction)goBack
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle - 系统函数
-(void)dealloc
{
    mySearchBar = nil;[mySearchBar release];
    keyword = nil;[keyword release];
    displayEachTemplateDetals = nil;[displayEachTemplateDetals release];
    backButton = nil;[backButton release];
    [bottomKeywordView release];
    [bottomKeywordScrollView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
    }
    return self;
}
- (void)viewDidUnload
{
    templateScrollView = nil;[templateScrollView release];
    templateScrollView_Keyword = nil;[templateScrollView_Keyword release];
    [self setBottomKeywordView:nil];
    [self setBottomKeywordScrollView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated
{
        self.navigationController.navigationBarHidden = NO;
        rotationAngle = 0;
        currentPage = 1;
        addTemplatePageNumber = 0;
        
        [self performSelector:@selector(loadHttpRequset) withObject:nil];
        [self performSelector:@selector(dealWithSearchBar)];//美化searchBar
        [self performSelector:@selector(displayBottomKeywordView)];//显示底部热门关键字
        
        templateScrollView.hidden = NO;
        addMoreTemplateButton.enabled = YES;
        addMoreTemplateButton.hidden = NO;
        [addMoreTemplateButton setImage:[UIImage imageNamed:@"addMoreTemplateButton.png"]
                               forState:UIControlStateNormal];
        
        addMoreTemplateButton_Keyword.hidden = YES;
        templateScrollView_Keyword.hidden = YES;
        [addMoreTemplateButton_Keyword setImage:[UIImage imageNamed:@"addMoreTemplateButton.png"]
                                       forState:UIControlStateNormal];
        
        self.bottomKeywordScrollView.bounces = YES;
        self.bottomKeywordScrollView.showsVerticalScrollIndicator   = NO;
        self.bottomKeywordScrollView.showsHorizontalScrollIndicator = NO;
        self.bottomKeywordScrollView.pagingEnabled = YES;
        self.bottomKeywordScrollView.directionalLockEnabled = YES;
}

#pragma mark - LoadHttpRequsetFromActivityView - 从活动模板进入
- (void)loadHttpRequsetFromActivityView
{
    
    NSString *loadString = [Template stringByAppendingFormat:@"?p=%d&s=%d",currentPage,NumberInOnePage];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:loadString]];
    request.delegate = self;
    [request setDidFinishSelector:@selector(getTemplateFinished:)];//正常情况取得json数据
    [request setDidFailSelector:@selector(getTemplateFailed:)];//正常情况获取失败的提示
    [request startAsynchronous];
}


#pragma mark - ViewDidLoad - 解析json数据
- (void)viewDidLoad
{
    [super viewDidLoad];
    [backButton setImage:[UIImage imageNamed:@"titlebtnbackclick.png"] forState:UIControlStateHighlighted]; 
    templateScrollView.contentSize = CGSizeMake(320, 400);
    templateScrollView_Keyword.contentSize = CGSizeMake(320, 400);
}

#pragma mark - NormalRequest - 正常请求模板列表
- (void)loadHttpRequset
{
    NSString *loadString = [Template stringByAppendingFormat:@"?p=%d&s=%d",currentPage,NumberInOnePage];
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
    
    NSString *pageTotal = [dict objectForKey:@"page_total"];//---第一级解析
    page_total = [pageTotal intValue];  
    
    NSArray *templatesArray = [dict objectForKey:@"templates"];//---第一级解析
    
    NSNumber *numberInOnePage = [NSNumber numberWithInt:[templatesArray count]];
    
    if ([ILPostcardList sharedILPostcardList].templateAbstractList != nil) 
    {
        [[ILPostcardList sharedILPostcardList].templateAbstractList removeAllObjects];
    }

    for (int i = 0; i < [numberInOnePage intValue]; i ++)
    {
        NSDictionary *tempDict = [templatesArray objectAtIndex:i];
        [self performSelector:@selector(layOutTemplate:) withObject:tempDict];//解析json数据
    }
    
    [self performSelector:@selector(displayEachTemplate:) withObject:numberInOnePage];//读取保存到单例的数组,并展示  
    
    currentPage ++;//预先加一,方便下一次请求-------重要!
    if (currentPage > page_total)
    {
        addMoreTemplateButton.enabled = NO;
        [addMoreTemplateButton setImage:[UIImage imageNamed:@"noMoreTemplateButton"] forState:UIControlStateNormal];
    }
}

-(void)layOutTemplate:(NSDictionary *)dict//解析json数据
{
    NSMutableDictionary *tmpDictionary = [[NSMutableDictionary alloc] init];
    
    NSString *idString = [dict objectForKey:@"id"];
    [tmpDictionary setObject:idString forKey:@"id"];

    templateNameString = [dict objectForKey:@"name"]; 
    [tmpDictionary setObject:templateNameString forKey:@"name"];

    NSString *backgroundPicUrl = [dict objectForKey:@"preview"];
    [tmpDictionary setObject:backgroundPicUrl forKey:@"preview"];
    
    NSString *tagsString = [dict objectForKey:@"tags"];
    [tmpDictionary setObject:tagsString forKey:@"tags"];
    
    [[ILPostcardList sharedILPostcardList].templateAbstractList addObject:tmpDictionary];

    [tmpDictionary release];
}


#pragma mark - displayEachTemplate - 显示每一个框架
-(void)displayEachTemplate:(NSNumber *)numberInOnePage
{
    for (int i = 0; i < [numberInOnePage intValue]; i ++) 
        {
            NSDictionary *tmpDict =[[ILPostcardList sharedILPostcardList].templateAbstractList objectAtIndex:i];
            NSString *idString = [tmpDict objectForKey:@"id"];
            int idName = [idString intValue];
            
            templateNameString = nil;
            templateNameString = [tmpDict objectForKey:@"name"];
            
            //NSString *tagsString = [tmpDict objectForKey:@"tags"];
            
            NSString *backgroundPicUrl = [tmpDict objectForKey:@"preview"];
            
            if (i == 0 ) 
            {
                EGOImageButton *templateButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"sendbk.png"]];
                [templateButton setImageURL:[NSURL URLWithString:backgroundPicUrl]];
                templateButton.tag = idName ;
                int y =   10 + addTemplatePageNumber * 391;
                templateButton.frame = CGRectMake(20, y, 135 , 90);
                templateButton.transform = CGAffineTransformMakeRotation(rotationAngle);//(M_PI/2) ;        
                [templateButton addTarget:self 
                                   action:@selector(displayEachTemplateDetals:) 
                         forControlEvents:UIControlEventTouchUpInside];
                [templateScrollView addSubview:templateButton];
                [templateButton release];
                
                UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(34, 104 +addTemplatePageNumber * 391, 120, 20)];
                tmpLable.text = templateNameString; 
                tmpLable.backgroundColor = [UIColor clearColor];
                tmpLable.textColor = [UIColor blueColor];
                [templateScrollView addSubview:tmpLable];
                [tmpLable release];
            }
            if (i == 1 ) 
            {
                EGOImageButton *templateButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"sendbk.png"]];
                [templateButton setImageURL:[NSURL URLWithString:backgroundPicUrl]];                templateButton.tag = idName;
                int y = 10 + addTemplatePageNumber * 391; 
                templateButton.frame = CGRectMake(164, y, 135, 90);
                templateButton.transform = CGAffineTransformMakeRotation(rotationAngle) ;        
                [templateButton addTarget:self 
                                   action:@selector(displayEachTemplateDetals:) 
                         forControlEvents:UIControlEventTouchUpInside];
                [templateScrollView addSubview:templateButton];
                [templateButton release];
                
                UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(178, 104 + addTemplatePageNumber * 391, 120, 20)];
                tmpLable.text = templateNameString; 
                tmpLable.backgroundColor = [UIColor clearColor];
                tmpLable.textColor = [UIColor blueColor];
                [templateScrollView addSubview:tmpLable];
                [tmpLable release];
            }
            if (i == 2 ) 
            {
                EGOImageButton *templateButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"sendbk.png"]];
                [templateButton setImageURL:[NSURL URLWithString:backgroundPicUrl]];                templateButton.tag = idName;
                int y = 130 + addTemplatePageNumber * 391; 
                templateButton.frame = CGRectMake(20, y, 135, 90);
                templateButton.transform = CGAffineTransformMakeRotation(rotationAngle) ;        
                [templateButton addTarget:self 
                                   action:@selector(displayEachTemplateDetals:) 
                         forControlEvents:UIControlEventTouchUpInside];
                [templateScrollView addSubview:templateButton];
                [templateButton release];
                
                UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(34, 224 + addTemplatePageNumber * 391, 120, 20)];
                tmpLable.text = templateNameString; 
                tmpLable.backgroundColor = [UIColor clearColor];
                tmpLable.textColor = [UIColor blueColor];
                [templateScrollView addSubview:tmpLable];
                [tmpLable release];
            }
            if (i == 3 ) 
            {
                EGOImageButton *templateButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"sendbk.png"]];
                [templateButton setImageURL:[NSURL URLWithString:backgroundPicUrl]];                templateButton.tag = idName;
                int y = 130 + addTemplatePageNumber * 391; 
                templateButton.frame = CGRectMake(164, y, 135, 90);
                templateButton.transform = CGAffineTransformMakeRotation(rotationAngle) ;        
                [templateButton addTarget:self 
                                   action:@selector(displayEachTemplateDetals:) 
                         forControlEvents:UIControlEventTouchUpInside];
                [templateScrollView addSubview:templateButton];
                [templateButton release];
                
                UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(178, 224 + addTemplatePageNumber * 391, 120, 20)];
                tmpLable.text = templateNameString; 
                tmpLable.backgroundColor = [UIColor clearColor];
                tmpLable.textColor = [UIColor blueColor];
                [templateScrollView addSubview:tmpLable];
                [tmpLable release];
            }
            if (i == 4 ) 
            {
                EGOImageButton *templateButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"sendbk.png"]];
                [templateButton setImageURL:[NSURL URLWithString:backgroundPicUrl]];                templateButton.tag = idName;
                int y = 250 + addTemplatePageNumber * 391; 
                templateButton.frame = CGRectMake(20, y, 135, 90);
                templateButton.transform = CGAffineTransformMakeRotation(rotationAngle) ;        
                [templateButton addTarget:self 
                                   action:@selector(displayEachTemplateDetals:) 
                         forControlEvents:UIControlEventTouchUpInside];
                [templateScrollView addSubview:templateButton];
                [templateButton release];
                
                UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(34, 344 + addTemplatePageNumber * 391, 120, 20)];
                tmpLable.text = templateNameString; 
                tmpLable.backgroundColor = [UIColor clearColor];
                tmpLable.textColor = [UIColor blueColor];
                [templateScrollView addSubview:tmpLable];
                [tmpLable release];
            }
            if (i == 5 ) 
            {
                EGOImageButton *templateButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"sendbk.png"]];
                [templateButton setImageURL:[NSURL URLWithString:backgroundPicUrl]];            templateButton.tag = idName;
            int y = 250 + addTemplatePageNumber * 391; 
            templateButton.frame = CGRectMake(164, y, 135, 90);
            templateButton.transform = CGAffineTransformMakeRotation(rotationAngle) ;        
            [templateButton addTarget:self 
                               action:@selector(displayEachTemplateDetals:) 
                     forControlEvents:UIControlEventTouchUpInside];
            [templateScrollView addSubview:templateButton];
            [templateButton release];
            
            UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(178, 344 + addTemplatePageNumber * 391, 120, 20)];
            tmpLable.text = templateNameString; 
            tmpLable.backgroundColor = [UIColor clearColor];
            tmpLable.textColor = [UIColor blueColor];
            [templateScrollView addSubview:tmpLable];
            [tmpLable release];
            }
        } 
}

-(IBAction)addMoreTemplate
{
    addTemplatePageNumber ++;//页数加一
    templateScrollView.contentSize = CGSizeMake(320, 400 * (addTemplatePageNumber +1));
    [self loadHttpRequset];
}


#pragma mark - SearchBar - 1.美化searchBar_带关键字
- (void)dealWithSearchBar
{
    [[self.mySearchBar.subviews objectAtIndex:0] removeFromSuperview];
    self.mySearchBar.placeholder = [NSString stringWithFormat:@"请输入您感兴趣的模板"];
    self.mySearchBar.translucent = YES;//半透明
    self.mySearchBar.delegate = self;
    self.mySearchBar.showsCancelButton = NO;//未输入文字前显示取消按钮
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.mySearchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	self.mySearchBar.showsCancelButton = NO;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.keyword = nil;
    self.keyword = [NSString stringWithFormat:@"%@",searchText];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[self.mySearchBar resignFirstResponder];
    
    if ([self.keyword isEqualToString:[NSString stringWithFormat:@""]])
    {
        [templateScrollView removeFromSuperview];
        templateScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 89, 320, 391)];
        [self.view addSubview:templateScrollView];
        
        [addMoreTemplateButton addTarget:self 
                                  action:@selector(addMoreTemplate)
                        forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addMoreTemplateButton];
        
        [self viewDidLoad];    
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar//点击搜索事件的动作
{
    currentPage_Keyword = 1;
    addTemplatePageNumber_Keyword = 0;
    
    [templateScrollView_Keyword removeFromSuperview];
    templateScrollView_Keyword = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 89, 320, 391)];
    [self.view addSubview:templateScrollView_Keyword];
    
    [addMoreTemplateButton_Keyword addTarget:self 
                              action:@selector(addMoreTemplate_Keyword)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addMoreTemplateButton_Keyword];
    
    [self performSelector:@selector(searchOnline_Keyword)];
}

#pragma mark - SearchBar - 2.点击search事件_带关键字
-(void)searchOnline_Keyword
{
    [self.mySearchBar resignFirstResponder];
    int i =[[[NSUserDefaults standardUserDefaults] objectForKey:@"ClientId"] intValue];
    NSString *keywordString = [self urlEncodedString:self.keyword];//中文字符转换成url可用的字符串
    NSString *requsetString = [Template_Keyword stringByAppendingFormat:@"?t=%@&p=%d&s=%d&cid=%d",keywordString,currentPage_Keyword,NumberInOnePage,i];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requsetString]];
    request.delegate = self;
    [request setDidFinishSelector:@selector(getTemplateFinished_Keyword:)];//带关键字-取json数据
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

-(void)getTemplateFinished_Keyword:(ASIHTTPRequest *)request
{
    NSDictionary *dict = [request responseString].JSONValue;
    
    NSString *result_codeString = [dict objectForKey:@"result_code"];
    if ([result_codeString intValue] == 0)//没有找到模板
    {
        [self performSelector:@selector(showNoneSearchResult)];//没有模板的提示    
    }
    else if ([result_codeString intValue] == 1)
    {
        templateScrollView.hidden = YES;
        templateScrollView_Keyword.hidden = NO;
        
        addMoreTemplateButton.hidden = YES;
        addMoreTemplateButton_Keyword.hidden = NO;
        
        NSString *pageTotal = [dict objectForKey:@"page_total"];//---第一级解析
        page_total = [pageTotal intValue];  
        
        NSArray *templatesArray = [dict objectForKey:@"templates"];//---第一级解析
        NSNumber *numberInOnePage = [NSNumber numberWithInt:[templatesArray count]];
        
        if ([ILPostcardList sharedILPostcardList].templateAbstractList != nil) 
        {
            [[ILPostcardList sharedILPostcardList].templateAbstractList removeAllObjects];
        }
        
        for (int i = 0; i < [numberInOnePage intValue]; i++) 
        {
            NSDictionary *tempDict = [templatesArray objectAtIndex:i];
            [self performSelector:@selector(layOutTemplate:) withObject:tempDict];//解析json数据
        }
        
        [self performSelector:@selector(displayEachTemplate_Keyword:) withObject:numberInOnePage];//读取保存到单例的数组,并展示  
        
        currentPage_Keyword ++;//预先加一,方便下一次请求-------重要!
        if (currentPage_Keyword > page_total)
        {
            addMoreTemplateButton_Keyword.enabled = NO;
            [addMoreTemplateButton_Keyword setImage:[UIImage imageNamed:@"noMoreTemplateButton.png"] forState:UIControlStateNormal];
            // addMoreTemplateFlag_Keyword = YES;
        }
    }
}

-(void)showNoneSearchResult//没有模板的提示
{
    PromptView *tmpProptView = [[PromptView alloc] init];
    [tmpProptView showPromptWithParentView:self.view
                                withPrompt:@"还没有相关模板" 
                                 withFrame:CGRectMake(40, 120, 240, 240)];
    [tmpProptView  release];
}

-(IBAction)addMoreTemplate_Keyword
{
    addTemplatePageNumber_Keyword ++;//页数加一
    templateScrollView.contentSize = CGSizeMake(320, 391 * (addTemplatePageNumber_Keyword +1));
    [self performSelector:@selector(searchOnline_Keyword)];
}


#pragma mark - displayEachTemplate_Keyword - 显示每一个框架_带关键字
-(void)displayEachTemplate_Keyword:(NSNumber *)numberInOnePage
{
    for (int i = 0; i < [numberInOnePage intValue]; i ++) 
    {
        NSDictionary *tmpDict =[[ILPostcardList sharedILPostcardList].templateAbstractList objectAtIndex:i];
        NSString *idString = [tmpDict objectForKey:@"id"];
        int idName = [idString intValue];
        
        templateNameString = nil;
        templateNameString = [tmpDict objectForKey:@"name"];
        
        //NSString *tagsString = [tmpDict objectForKey:@"tags"];
        
        NSString *backgroundPicUrl = [tmpDict objectForKey:@"preview"];
        if (i == 0 ) 
        {
            EGOImageButton *templateButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"sendbk.png"]];
            [templateButton setImageURL:[NSURL URLWithString:backgroundPicUrl]];          
            templateButton.tag = idName ;
            int y = 10 + addTemplatePageNumber_Keyword * 391;
            templateButton.frame = CGRectMake(12, y, 135, 90);
            templateButton.transform = CGAffineTransformMakeRotation(rotationAngle);//(M_PI/2) ;        
            [templateButton addTarget:self 
                               action:@selector(displayEachTemplateDetals:) 
                     forControlEvents:UIControlEventTouchUpInside];
            [templateScrollView_Keyword addSubview:templateButton];
            [templateButton release];
            
            UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(34, 104 +addTemplatePageNumber_Keyword * 391, 120, 20)];
            tmpLable.text = templateNameString; 
            tmpLable.backgroundColor = [UIColor clearColor];
            tmpLable.textColor = [UIColor blueColor];
            [templateScrollView_Keyword addSubview:tmpLable];
            [tmpLable release];
        }
        
        if (i == 1) 
        {
            EGOImageButton *templateButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"sendbk.png"]];
            [templateButton setImageURL:[NSURL URLWithString:backgroundPicUrl]];         
            templateButton.tag = idName;
            int y = 10 + addTemplatePageNumber_Keyword * 391; 
            templateButton.frame = CGRectMake(164, y,135, 90);
            templateButton.transform = CGAffineTransformMakeRotation(rotationAngle) ;        
            [templateButton addTarget:self 
                               action:@selector(displayEachTemplateDetals:) 
                     forControlEvents:UIControlEventTouchUpInside];
            [templateScrollView_Keyword addSubview:templateButton];
            [templateButton release];
            
            UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(178, 104 + addTemplatePageNumber_Keyword * 391, 120, 20)];
            tmpLable.text = templateNameString; 
            tmpLable.textColor = [UIColor blueColor];
            tmpLable.backgroundColor = [UIColor clearColor];
            [templateScrollView_Keyword addSubview:tmpLable];
            [tmpLable release];
            
        }
        
        if (i == 2) 
        {
            EGOImageButton *templateButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"sendbk.png"]];
            [templateButton setImageURL:[NSURL URLWithString:backgroundPicUrl]];        
            templateButton.tag = idName;
            int y = 130 + addTemplatePageNumber_Keyword * 391; 
            templateButton.frame = CGRectMake(20, y, 135, 90);
            templateButton.transform = CGAffineTransformMakeRotation(rotationAngle) ;        
            [templateButton addTarget:self 
                               action:@selector(displayEachTemplateDetals:) 
                     forControlEvents:UIControlEventTouchUpInside];
            [templateScrollView_Keyword addSubview:templateButton];
            [templateButton release];
            
            UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(34, 224 + addTemplatePageNumber_Keyword * 391, 120, 20)];
            tmpLable.text = templateNameString; 
            tmpLable.textColor = [UIColor blueColor];
            tmpLable.backgroundColor = [UIColor clearColor];
            [templateScrollView_Keyword addSubview:tmpLable];
            [tmpLable release];
        }
        
        if (i == 3) 
        {
            EGOImageButton *templateButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"sendbk.png"]];
            [templateButton setImageURL:[NSURL URLWithString:backgroundPicUrl]];
            templateButton.tag = idName;
            int y = 130 + addTemplatePageNumber_Keyword * 391; 
            templateButton.frame = CGRectMake(164, y, 135, 90);
            templateButton.transform = CGAffineTransformMakeRotation(rotationAngle) ;        
            [templateButton addTarget:self 
                               action:@selector(displayEachTemplateDetals:) 
                     forControlEvents:UIControlEventTouchUpInside];
            [templateScrollView_Keyword addSubview:templateButton];
            [templateButton release];
            
            UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(178, 224 + addTemplatePageNumber_Keyword * 391, 120, 20)];
            tmpLable.text = templateNameString; 
            tmpLable.textColor = [UIColor blueColor];
            tmpLable.backgroundColor = [UIColor clearColor];
            [templateScrollView_Keyword addSubview:tmpLable];
            [tmpLable release];
        }
        if (i == 4) 
        {
            EGOImageButton *templateButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"sendbk.png"]];
            [templateButton setImageURL:[NSURL URLWithString:backgroundPicUrl]];
            templateButton.tag = idName;
            int y = 250 + addTemplatePageNumber_Keyword * 391; 
            templateButton.frame = CGRectMake(20, y, 135, 90);
            templateButton.transform = CGAffineTransformMakeRotation(rotationAngle) ;        
            [templateButton addTarget:self 
                               action:@selector(displayEachTemplateDetals:) 
                     forControlEvents:UIControlEventTouchUpInside];
            [templateScrollView_Keyword addSubview:templateButton];
            [templateButton release];
            
            UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(34, 344 + addTemplatePageNumber_Keyword * 391, 120, 20)];
            tmpLable.text = templateNameString; 
            tmpLable.textColor = [UIColor blueColor];
            tmpLable.backgroundColor = [UIColor clearColor];
            [templateScrollView_Keyword addSubview:tmpLable];
            [tmpLable release];
        }
        
        if (i == 5) 
        {
            EGOImageButton *templateButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"sendbk.png"]];
            [templateButton setImageURL:[NSURL URLWithString:backgroundPicUrl]];
            templateButton.tag = idName;
            int y = 250 + addTemplatePageNumber_Keyword * 391; 
            templateButton.frame = CGRectMake(164, y, 135, 90);
            templateButton.transform = CGAffineTransformMakeRotation(rotationAngle) ;        
            [templateButton addTarget:self 
                               action:@selector(displayEachTemplateDetals:) 
                     forControlEvents:UIControlEventTouchUpInside];
            [templateScrollView_Keyword addSubview:templateButton];
            [templateButton release];
            
            UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(178, 344 + addTemplatePageNumber_Keyword * 391, 120, 20)];
            tmpLable.text = templateNameString; 
            tmpLable.textColor = [UIColor blueColor];
            tmpLable.backgroundColor =[UIColor clearColor];
            [templateScrollView_Keyword addSubview:tmpLable];
            [tmpLable release];
        }
    } 
}

#pragma mark - displayBottomKeywordView - 底部热门推荐关键字
-(void)displayBottomKeywordView
{
    NSString *hotWordsUrl = [Search_Hots stringByAppendingFormat:@"?cid=4"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:hotWordsUrl]];
    request.delegate = self;
    [request setDidFinishSelector:@selector(getHotWordsFinished_Keyword:)];//带关键字-取json数据
    [request setDidFailSelector:@selector(getTemplateFailed:)];//联网失败提示
    [request startAsynchronous];
}

-(void)getHotWordsFinished_Keyword:(ASIHTTPRequest *)request
{
    NSArray *hotWords = [request responseString].JSONValue;
    
    if (4 < [hotWords count] <= 8)
    {
        [self.bottomKeywordScrollView setContentSize:CGSizeMake(320, 25)]; 
    }
    if (8 < [hotWords count] <= 12)
    {
        [self.bottomKeywordScrollView setContentSize:CGSizeMake(320*2, 25)];
    }
    if (12 < [hotWords count] <= 16)
    {
        [self.bottomKeywordScrollView setContentSize:CGSizeMake(320*3, 25)];
    }

    for (int i = 0; i < [hotWords count]; i++)
    {
        NSDictionary *tmpDict = [hotWords objectAtIndex:i];
        NSString *tmpStr = [tmpDict objectForKey:@"tags"];
        UIButton *tmpButton = [[UIButton alloc] initWithFrame:CGRectMake(4 + i * 80, 0, 73, 25)];
        [tmpButton setBackgroundImage:[UIImage imageNamed:@"tag.png"] forState:UIControlStateNormal];
        [tmpButton setBackgroundImage:[UIImage imageNamed:@"tagclick.png"] forState:UIControlStateHighlighted];
        tmpButton.tag = 500 + i;
        [tmpButton setTitle:tmpStr 
                       forState:UIControlStateNormal];
        [tmpButton addTarget:self action:@selector(searchOnlineFromBottomView_Keyword:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomKeywordScrollView addSubview:tmpButton];
        [tmpButton release];
    }
       
}


-(void)searchOnlineFromBottomView_Keyword:(UIButton *)sender
{ 
    UILabel *tmpLable =[[UILabel alloc] init];
    tmpLable.text = sender.titleLabel.text;
        
    currentPage_Keyword = 1;
    
    addTemplatePageNumber_Keyword = 0;
    
    [templateScrollView_Keyword removeFromSuperview];
    templateScrollView_Keyword = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 89, 320, 391)];
    [self.view addSubview:templateScrollView_Keyword];
    
    [addMoreTemplateButton_Keyword addTarget:self 
                                      action:@selector(addMoreTemplate_Keyword)
                            forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addMoreTemplateButton_Keyword];

    NSString *cidStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"ClientId"];
    
    NSString *keywordString = [self urlEncodedString:tmpLable.text];//中文字符转换成url可用的字符串
    NSString *requsetString = [Template_Keyword stringByAppendingFormat:@"?t=%@&p=%d&s=%d&cid=4",keywordString,currentPage_Keyword,NumberInOnePage];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requsetString]];
    request.delegate = self;
    [request setDidFinishSelector:@selector(getTemplateFinished_Keyword:)];//带关键字-取json数据
    [request setDidFailSelector:@selector(getTemplateFailed:)];//联网失败提示
    [request startAsynchronous];
}

#pragma mark - displayEachTemplateDetals - 点击进入每个模板详情
-(void)displayEachTemplateDetals:(UIButton *)sender
{
    DisplayEachTemplateDetals *tmpDisplayEachTemplateDetals = [[DisplayEachTemplateDetals alloc] initWithNibName:@"DisplayEachTemplateDetals" bundle:nil];
    tmpDisplayEachTemplateDetals.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    displayEachTemplateDetals = tmpDisplayEachTemplateDetals;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FromActivityList"];
    displayEachTemplateDetals.idName = [NSString stringWithFormat:@"%d",sender.tag];
    [self presentModalViewController:displayEachTemplateDetals
                            animated:YES];
    [tmpDisplayEachTemplateDetals release];
}

@end
