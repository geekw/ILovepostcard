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
#define template @"http://61.155.238.30:port/postcards/interface/template_list"//模板列表接口

@implementation GoToPostcardList

static int currentPage = 1;

#pragma mark - goBack - 返回按钮
-(IBAction)goBack
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle - 系统函数
-(void)dealloc
{
    templateScrollView = nil;[templateScrollView release];
    displayEachTemplateDetals = nil;[displayEachTemplateDetals release];
    backButton = nil;[backButton release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
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

#pragma mark - getJsonData - 解析json数据
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    addTemplatePageNumber = 0;
    [self performSelector:@selector(loadHttpRequset) withObject:nil];
    rotationAngle = 0;
}

- (void)loadHttpRequset
{
    NSLog(@"currentPage = %d",currentPage);
    NSString *loadString = [template stringByAppendingFormat:@"?p=%d&s=%d",currentPage,NumberInOnePage];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:loadString]];
    request.delegate = self;
    [request setDidFinishSelector:@selector(getTemplateFinished:)];//取得json数据
    [request setDidFailSelector:@selector(getTemplateFailed:)];//获取失败的提示
    [request startAsynchronous];
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
    
    if (addTemplatePageNumber < page_total - 1) //如果没到最后一页
    {
        for (int i = 0 ; i < NumberInOnePage ; i++)
        {
            NSDictionary *tempDict = [templatesArray objectAtIndex:i + addTemplatePageNumber * 4];
            [self performSelector:@selector(layOutTemplate:) withObject:tempDict];//解析json数据
        }
    }
    else if (addTemplatePageNumber == page_total - 1)//如果到了最后一页
    {
        NSLog(@"templatesArray.count = %d",templatesArray.count);
        for (int i = 0; i < templatesArray.count - addTemplatePageNumber * 4; i ++)
        {
            NSDictionary *tempDict = [templatesArray objectAtIndex:i + addTemplatePageNumber * 4];
            NSLog(@"tempDict = %@",tempDict);
            [self performSelector:@selector(layOutTemplate:) withObject:tempDict];//解析json数据
        }
    }
    
    [self performSelector:@selector(displayEachTemplate)];//保存到单例的数组之后,展示
    currentPage ++;//预先加一,方便下一次请求-------重要!
}

-(void)layOutTemplate:(NSDictionary *)dict//解析json数据
{
    NSMutableDictionary *tmpDictionary = [[NSMutableDictionary alloc] init];
    
    NSString *idString = [dict objectForKey:@"id"];
    [tmpDictionary setObject:idString forKey:@"id"];

    NSString *nameString = [dict objectForKey:@"name"]; 
    [tmpDictionary setObject:nameString forKey:@"name"];

    NSString *backgroundPicUrl = [dict objectForKey:@"preview"];
    [tmpDictionary setObject:backgroundPicUrl forKey:@"preview"];
    
    NSString *tagsString = [dict objectForKey:@"tags"];
    [tmpDictionary setObject:tagsString forKey:@"tags"];
    
    [[ILPostcardList sharedILPostcardList].templateAbstractList addObject:tmpDictionary];
    NSLog(@"ipl.templateAbstractList = %@",[ILPostcardList sharedILPostcardList].templateAbstractList);

//    [self displayEachTemplate:idString 
//                backgroundPic:backgroundPic 
//                         name:nameString 
//                          tag:tagsString];
}

-(void)getTemplateFailed:(ASIHTTPRequest *)request//网络故障提示
{
    PromptView *tmpProptView = [[PromptView alloc] init];
    [tmpProptView showPromptWithParentView:self.view
                                withPrompt:@"网络不通" 
                                 withFrame:CGRectMake(40, 120, 240, 240)];
    [tmpProptView  release];
}

#pragma mark - displayEachTemplate - 显示每一个框架(放在哪一页,哪一个位置)

-(void)displayEachTemplate
{
    for (int i = 0; i < 4; i ++) 
    {
        NSDictionary *tmpDict =[[ILPostcardList sharedILPostcardList].templateAbstractList objectAtIndex:i];
        NSString *idString = [tmpDict objectForKey:@"id"];
        int idName = [idString intValue];
        
//        NSString *nameString = [tmpDict objectForKey:@"name"]; 
//        NSString *tagsString = [tmpDict objectForKey:@"tags"];

        NSString *backgroundPicUrl = [tmpDict objectForKey:@"preview"];
        UIImage *backgroundPic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:backgroundPicUrl]]];
        
        
        if (idName == 1 + addTemplatePageNumber * 4) 
        {
            UIButton *templateButton = [UIButton buttonWithType:UIButtonTypeCustom];
            templateButton.tag = idName ;
            int y = 0 + addTemplatePageNumber * 480;
            templateButton.frame = CGRectMake(0, y, 150, 200);
            [templateButton setImage:backgroundPic
                            forState:UIControlStateNormal];
            templateButton.transform = CGAffineTransformMakeRotation(rotationAngle);//(M_PI/2) ;        
            [templateButton addTarget:self 
                               action:@selector(displayEachTemplateDetals:) 
                     forControlEvents:UIControlEventTouchUpInside];
            [templateScrollView addSubview:templateButton];
        }
        
        if (idName == 2 + addTemplatePageNumber * 4) 
        {
            UIButton *templateButton = [UIButton buttonWithType:UIButtonTypeCustom];
            templateButton.tag = idName;
            int y = 0 + addTemplatePageNumber * 480; 
            templateButton.frame = CGRectMake(170, y, 150, 200);
            [templateButton setImage:backgroundPic
                            forState:UIControlStateNormal];
            templateButton.transform = CGAffineTransformMakeRotation(rotationAngle) ;        
            [templateButton addTarget:self 
                               action:@selector(displayEachTemplateDetals:) 
                     forControlEvents:UIControlEventTouchUpInside];
            [templateScrollView addSubview:templateButton];
        }
        
        if (idName == 3 + addTemplatePageNumber * 4) 
        {
            UIButton *templateButton = [UIButton buttonWithType:UIButtonTypeCustom];
            templateButton.tag = idName;
            int y = 217 + addTemplatePageNumber * 480; 
            templateButton.frame = CGRectMake(0, y, 150, 200);
            templateButton.transform = CGAffineTransformMakeRotation(rotationAngle) ;        
            [templateButton setImage:backgroundPic
                            forState:UIControlStateNormal];
            [templateButton addTarget:self 
                               action:@selector(displayEachTemplateDetals:) 
                     forControlEvents:UIControlEventTouchUpInside];
            [templateScrollView addSubview:templateButton];
        }
        
        if (idName == 4 + addTemplatePageNumber * 4) 
        {
            UIButton *templateButton = [UIButton buttonWithType:UIButtonTypeCustom];
            templateButton.tag = idName;
            int y = 217 + addTemplatePageNumber * 480; 
            templateButton.frame = CGRectMake(170, y, 150, 200);
            [templateButton setImage:backgroundPic
                            forState:UIControlStateNormal];
            templateButton.transform = CGAffineTransformMakeRotation(rotationAngle) ;        
            [templateButton addTarget:self 
                               action:@selector(displayEachTemplateDetals:) 
                     forControlEvents:UIControlEventTouchUpInside];
            [templateScrollView addSubview:templateButton];
        }
    }
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

#pragma mark - addMoreTemplate - 增加一页明信片模板
-(IBAction)addMoreTemplate
{
    addTemplatePageNumber ++;//页数加一
    templateScrollView.contentSize = CGSizeMake(320, 480 * (addTemplatePageNumber +2));
}


#pragma mark - displayEachTemplateDetals - 点击进入每个模板
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
