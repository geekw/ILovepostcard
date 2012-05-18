//
//  GoToPostcardList.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-14.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "GoToPostcardList.h"
#import "SBJson.h"

#define NumberInOnePage 4 //每页显示个数
#define Template @"http://61.155.238.30/postcards/interface/template_list"//模板列表接口
#define Template_Keyword @"http://61.155.238.30/postcards/interface/query_template"//模板列表接口

@implementation GoToPostcardList
@synthesize keyword;

int currentPage;
int currentPage_Keyword;

#pragma mark - goBack - 返回按钮
-(IBAction)goBack
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle - 系统函数
-(void)dealloc
{
    keyword = nil;[keyword release];
    displayEachTemplateDetals = nil;[displayEachTemplateDetals release];
    backButton = nil;[backButton release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidUnload
{
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


#pragma mark - ViewDidLoad - 解析json数据
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;

    rotationAngle = 0;

    currentPage = 1;
    
    addTemplatePageNumber = 0;
    
    [self performSelector:@selector(loadHttpRequset) withObject:nil];
    [self performSelector:@selector(dealWithSearchBar)];//美化searchBar
    
    templateScrollView.hidden = NO;
    addMoreTemplateButton.enabled = YES;
    addMoreTemplateButton.hidden = NO;
    [addMoreTemplateButton setImage:[UIImage imageNamed:@"addMoreTemplateButton.png"]
                           forState:UIControlStateNormal];
    
    addMoreTemplateButton_Keyword.hidden = YES;
    templateScrollView_Keyword.hidden = YES;
    [addMoreTemplateButton_Keyword setImage:[UIImage imageNamed:@"addMoreTemplateButton.png"]
                                   forState:UIControlStateNormal];
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
    NSLog(@"dict = %@",dict);
    
    NSString *pageTotal = [dict objectForKey:@"page_total"];//---第一级解析
    page_total = [pageTotal intValue];  
    NSLog(@"page_total = %d",page_total);
    
    NSArray *templatesArray = [dict objectForKey:@"templates"];//---第一级解析
    NSLog(@"templatesArray = %@",templatesArray);
//    NSString *numberInOnePage = [NSString stringWithFormat:@"%@",[templatesArray count]];
    NSNumber *numberInOnePage = [NSNumber numberWithInt:[templatesArray count]];
    
    if ([ILPostcardList sharedILPostcardList].templateAbstractList != nil) 
    {
        [[ILPostcardList sharedILPostcardList].templateAbstractList removeAllObjects];
    }

    for (int i = 0; i < [numberInOnePage intValue]; i ++)
    {
        NSDictionary *tempDict = [templatesArray objectAtIndex:i];
        NSLog(@"tempDict = %@",tempDict);
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
    NSLog(@"ipl.templateAbstractList = %@",[ILPostcardList sharedILPostcardList].templateAbstractList);

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
            UIImage *backgroundPic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:backgroundPicUrl]]];
            
            if (i == 0 ) 
            {
                UIButton *templateButton = [UIButton buttonWithType:UIButtonTypeCustom];
                templateButton.tag = idName ;
                int y = -40 + addTemplatePageNumber * 406;
                templateButton.frame = CGRectMake(0, y, 150, 200);
                [templateButton setImage:backgroundPic
                                forState:UIControlStateNormal];
                templateButton.transform = CGAffineTransformMakeRotation(rotationAngle);//(M_PI/2) ;        
                [templateButton addTarget:self 
                                   action:@selector(displayEachTemplateDetals:) 
                         forControlEvents:UIControlEventTouchUpInside];
                [templateScrollView addSubview:templateButton];
                
                UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 120 +addTemplatePageNumber * 406, 150, 20)];
                tmpLable.text = templateNameString; 
                tmpLable.textColor = [UIColor redColor];
                tmpLable.alpha = 0.7;
                [templateScrollView addSubview:tmpLable];
                [tmpLable release];
            }
            
            if (i == 1 ) 
            {
                UIButton *templateButton = [UIButton buttonWithType:UIButtonTypeCustom];
                templateButton.tag = idName;
                int y = -40 + addTemplatePageNumber * 406; 
                templateButton.frame = CGRectMake(170, y, 150, 200);
                [templateButton setImage:backgroundPic
                                forState:UIControlStateNormal];
                templateButton.transform = CGAffineTransformMakeRotation(rotationAngle) ;        
                [templateButton addTarget:self 
                                   action:@selector(displayEachTemplateDetals:) 
                         forControlEvents:UIControlEventTouchUpInside];
                [templateScrollView addSubview:templateButton];
                
                UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(190, 120 + addTemplatePageNumber * 406, 150, 20)];
                tmpLable.text = templateNameString; 
                tmpLable.textColor = [UIColor redColor];
                tmpLable.alpha = 0.7;
                [templateScrollView addSubview:tmpLable];
                [tmpLable release];
                
            }
            
            if (i == 2 ) 
            {
                UIButton *templateButton = [UIButton buttonWithType:UIButtonTypeCustom];
                templateButton.tag = idName;
                int y = 160 + addTemplatePageNumber * 406; 
                templateButton.frame = CGRectMake(0, y, 150, 200);
                templateButton.transform = CGAffineTransformMakeRotation(rotationAngle) ;        
                [templateButton setImage:backgroundPic
                                forState:UIControlStateNormal];
                [templateButton addTarget:self 
                                   action:@selector(displayEachTemplateDetals:) 
                         forControlEvents:UIControlEventTouchUpInside];
                [templateScrollView addSubview:templateButton];
                
                UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 320 + addTemplatePageNumber * 406, 150, 20)];
                tmpLable.text = templateNameString; 
                tmpLable.textColor = [UIColor redColor];
                tmpLable.alpha = 0.7;
                [templateScrollView addSubview:tmpLable];
                [tmpLable release];
            }
            
            if (i == 3 ) 
            {
                UIButton *templateButton = [UIButton buttonWithType:UIButtonTypeCustom];
                templateButton.tag = idName;
                int y = 160 + addTemplatePageNumber * 406; 
                templateButton.frame = CGRectMake(170, y, 150, 200);
                [templateButton setImage:backgroundPic
                                forState:UIControlStateNormal];
                templateButton.transform = CGAffineTransformMakeRotation(rotationAngle) ;        
                [templateButton addTarget:self 
                                   action:@selector(displayEachTemplateDetals:) 
                         forControlEvents:UIControlEventTouchUpInside];
                [templateScrollView addSubview:templateButton];
                
                UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(190, 320 + addTemplatePageNumber * 406, 150, 20)];
                tmpLable.text = templateNameString; 
                tmpLable.textColor = [UIColor redColor];
                tmpLable.alpha = 0.7;
                [templateScrollView addSubview:tmpLable];
                [tmpLable release];
            }
        } 
}

-(IBAction)addMoreTemplate
{
    addTemplatePageNumber ++;//页数加一
    templateScrollView.contentSize = CGSizeMake(320, 406 * (addTemplatePageNumber +1));
    [self loadHttpRequset];
}


-(void)displayEachTemplate:(NSString *)idName
             backgroundPic:(UIImage *)image 
                      name:(NSString *)nameString 
                       tag:(NSString *)tagstring
{
    NSLog(@"intIdName = %d",[idName intValue]);
    int rotationDirection = [self getRandomWithRange:2];
    if (rotationDirection == 0)//
    {
        int x = [self getRandomWithRange:100] + 50;
        NSLog(@"x = %d",x);
        rotationAngle = x / 180;
    }
    else if (rotationDirection == 1)
    {
        int x = [self getRandomWithRange:100] + 100;
        NSLog(@"x = %d",x);
        rotationAngle = -( x / 180);
        NSLog(@"rotationAngle = %f",rotationAngle);
    }
    
    if ([idName intValue] == 1 + addTemplatePageNumber * 4) 
    {
        UIButton *templateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        templateButton.tag = [idName intValue];
        int y = 0 + addTemplatePageNumber * 480;
        templateButton.frame = CGRectMake(0, y, 150, 200);
        [templateButton setImage:image
                        forState:UIControlStateNormal];
        templateButton.transform = CGAffineTransformMakeRotation(rotationAngle);//(M_PI/2) ;        
        [templateButton addTarget:self 
                           action:@selector(displayEachTemplateDetals:) 
                 forControlEvents:UIControlEventTouchUpInside];
        [templateScrollView addSubview:templateButton];
        
    }
    
    if ([idName intValue] == 2 + addTemplatePageNumber * 4) 
    {
        UIButton *templateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        templateButton.tag = [idName intValue];
        int y = 0 + addTemplatePageNumber * 480; 
        templateButton.frame = CGRectMake(170, y, 150, 200);
        [templateButton setImage:image
                        forState:UIControlStateNormal];
        templateButton.transform = CGAffineTransformMakeRotation(rotationAngle) ;        
        [templateButton addTarget:self 
                           action:@selector(displayEachTemplateDetals:) 
                 forControlEvents:UIControlEventTouchUpInside];
        [templateScrollView addSubview:templateButton];
    }
    
    if ([idName intValue] == 3 + addTemplatePageNumber * 4) 
    {
        UIButton *templateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        templateButton.tag = [idName intValue];
        int y = 217 + addTemplatePageNumber * 480; 
        templateButton.frame = CGRectMake(0, y, 150, 200);
        templateButton.transform = CGAffineTransformMakeRotation(rotationAngle) ;        
        [templateButton setImage:image
                        forState:UIControlStateNormal];
        [templateButton addTarget:self 
                           action:@selector(displayEachTemplateDetals:) 
                 forControlEvents:UIControlEventTouchUpInside];
        [templateScrollView addSubview:templateButton];
    }
    
    if ([idName intValue] == 4 + addTemplatePageNumber * 4) 
    {
        UIButton *templateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        templateButton.tag = [idName intValue];
        int y = 217 + addTemplatePageNumber * 480; 
        templateButton.frame = CGRectMake(170, y, 150, 200);
        [templateButton setImage:image
                        forState:UIControlStateNormal];
        templateButton.transform = CGAffineTransformMakeRotation(rotationAngle) ;        
        [templateButton addTarget:self 
                           action:@selector(displayEachTemplateDetals:) 
                 forControlEvents:UIControlEventTouchUpInside];
        [templateScrollView addSubview:templateButton];
    }
}
- (int) getRandomWithRange:(int)rangeValue//生成随机数,旋转角度
{
	NSInteger ran = abs(arc4random());
	NSInteger re = (ran % rangeValue);
	return re;
}


#pragma mark - SearchBar - 1.美化searchBar_带关键字
- (void)dealWithSearchBar
{
    [[mySearchBar.subviews objectAtIndex:0] removeFromSuperview];
    mySearchBar.placeholder = [NSString stringWithFormat:@"请输入您感兴趣的模板"];
    mySearchBar.translucent = YES;//半透明
    mySearchBar.delegate = self;
    mySearchBar.showsCancelButton = NO;//未输入文字前显示取消按钮
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    mySearchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	mySearchBar.showsCancelButton = NO;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.keyword = nil;
    self.keyword = [NSString stringWithFormat:@"%@",searchText];
    NSLog(@"keyword = %@",self.keyword);
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[mySearchBar resignFirstResponder];

    NSLog(@"keyword = %@",self.keyword);
    
    if ([self.keyword isEqualToString:[NSString stringWithFormat:@""]])
    {
        [templateScrollView removeFromSuperview];
        templateScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 74, 320, 406)];
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
    templateScrollView_Keyword = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 74, 320, 406)];
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
    [mySearchBar resignFirstResponder];
    NSString *keywordString = [self urlEncodedString:self.keyword];//中文字符转换成url可用的字符串
    NSString *requsetString = [Template_Keyword stringByAppendingFormat:@"?t=%@&p=%d&s=%d",keywordString,currentPage_Keyword,NumberInOnePage];
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
    NSLog(@"dict_Key = %@",dict);
    
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
    templateScrollView.contentSize = CGSizeMake(320, 406 * (addTemplatePageNumber_Keyword +1));
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
        UIImage *backgroundPic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:backgroundPicUrl]]];
        
        if (i == 0 ) 
        {
            UIButton *templateButton = [UIButton buttonWithType:UIButtonTypeCustom];
            templateButton.tag = idName ;
            int y = -40 + addTemplatePageNumber_Keyword * 406;
            templateButton.frame = CGRectMake(0, y, 150, 200);
            [templateButton setImage:backgroundPic
                            forState:UIControlStateNormal];
            templateButton.transform = CGAffineTransformMakeRotation(rotationAngle);//(M_PI/2) ;        
            [templateButton addTarget:self 
                               action:@selector(displayEachTemplateDetals:) 
                     forControlEvents:UIControlEventTouchUpInside];
            [templateScrollView_Keyword addSubview:templateButton];
            
            UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 120 +addTemplatePageNumber_Keyword * 406, 150, 20)];
            tmpLable.text = templateNameString; 
            tmpLable.textColor = [UIColor redColor];
            tmpLable.alpha = 0.7;
            [templateScrollView_Keyword addSubview:tmpLable];
            [tmpLable release];
        }
        
        if (i == 1) 
        {
            UIButton *templateButton = [UIButton buttonWithType:UIButtonTypeCustom];
            templateButton.tag = idName;
            int y = -40 + addTemplatePageNumber_Keyword * 406; 
            templateButton.frame = CGRectMake(170, y, 150, 200);
            [templateButton setImage:backgroundPic
                            forState:UIControlStateNormal];
            templateButton.transform = CGAffineTransformMakeRotation(rotationAngle) ;        
            [templateButton addTarget:self 
                               action:@selector(displayEachTemplateDetals:) 
                     forControlEvents:UIControlEventTouchUpInside];
            [templateScrollView_Keyword addSubview:templateButton];
            
            UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(190, 120 + addTemplatePageNumber_Keyword * 406, 150, 20)];
            tmpLable.text = templateNameString; 
            tmpLable.textColor = [UIColor redColor];
            tmpLable.alpha = 0.7;
            [templateScrollView_Keyword addSubview:tmpLable];
            [tmpLable release];
            
        }
        
        if (i == 2) 
        {
            UIButton *templateButton = [UIButton buttonWithType:UIButtonTypeCustom];
            templateButton.tag = idName;
            int y = 160 + addTemplatePageNumber_Keyword * 406; 
            templateButton.frame = CGRectMake(0, y, 150, 200);
            templateButton.transform = CGAffineTransformMakeRotation(rotationAngle) ;        
            [templateButton setImage:backgroundPic
                            forState:UIControlStateNormal];
            [templateButton addTarget:self 
                               action:@selector(displayEachTemplateDetals:) 
                     forControlEvents:UIControlEventTouchUpInside];
            [templateScrollView_Keyword addSubview:templateButton];
            
            UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 320 + addTemplatePageNumber_Keyword * 406, 150, 20)];
            tmpLable.text = templateNameString; 
            tmpLable.textColor = [UIColor redColor];
            tmpLable.alpha = 0.7;
            [templateScrollView_Keyword addSubview:tmpLable];
            [tmpLable release];
        }
        
        if (i == 3) 
        {
            UIButton *templateButton = [UIButton buttonWithType:UIButtonTypeCustom];
            templateButton.tag = idName;
            int y = 160 + addTemplatePageNumber_Keyword * 406; 
            templateButton.frame = CGRectMake(170, y, 150, 200);
            [templateButton setImage:backgroundPic
                            forState:UIControlStateNormal];
            templateButton.transform = CGAffineTransformMakeRotation(rotationAngle) ;        
            [templateButton addTarget:self 
                               action:@selector(displayEachTemplateDetals:) 
                     forControlEvents:UIControlEventTouchUpInside];
            [templateScrollView_Keyword addSubview:templateButton];
            
            UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(190, 320 + addTemplatePageNumber_Keyword * 406, 150, 20)];
            tmpLable.text = templateNameString; 
            tmpLable.textColor = [UIColor redColor];
            tmpLable.alpha = 0.7;
            [templateScrollView_Keyword addSubview:tmpLable];
            [tmpLable release];
        }
    } 
}


#pragma mark - displayEachTemplateDetals - 点击进入每个模板详情
-(void)displayEachTemplateDetals:(UIButton *)sender
{
    DisplayEachTemplateDetals *tmpDisplayEachTemplateDetals = [[DisplayEachTemplateDetals alloc] initWithNibName:@"DisplayEachTemplateDetals" bundle:nil];
    tmpDisplayEachTemplateDetals.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    displayEachTemplateDetals = tmpDisplayEachTemplateDetals;
    displayEachTemplateDetals.idName = [NSString stringWithFormat:@"%d",sender.tag];
    NSLog(@"idName = %@",displayEachTemplateDetals.idName);
    [self presentModalViewController:displayEachTemplateDetals
                            animated:YES];
    [tmpDisplayEachTemplateDetals release];
}

@end
