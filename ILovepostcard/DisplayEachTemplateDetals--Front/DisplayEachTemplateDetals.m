//
//  DisplayEachTemplateDetals.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-12.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "DisplayEachTemplateDetals.h"

#define Template_Front @"http://61.155.238.30/postcards/interface/get_template"//单个模板详情接口

@implementation DisplayEachTemplateDetals
@synthesize idName;


#pragma mark - goBack - 返回按钮
-(IBAction)goback
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle - 系统函数
-(void)dealloc
{
    idName = nil;[idName release];
    backButton = nil;[backButton release];
    displayEachTemplateDetals_Back = nil;[displayEachTemplateDetals_Back release];
    goDisplayEachTemplateDetals_BackButton = nil;[goDisplayEachTemplateDetals_BackButton release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performSelector:@selector(requestFrontDetails)];//请求明信片正面素材
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - requestFrontDetails - 请求正面素材
-(void)requestFrontDetails
{
    int idValue = [idName intValue];
    NSString *loadString = [Template_Front stringByAppendingFormat:@"?id=%d",idValue];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:loadString]];
    request.delegate = self;
    [request setDidFinishSelector:@selector(getTemplateFinished:)];//正常情况取得json数据
    [request setDidFailSelector:@selector(getTemplateFailed:)];//网络故障提示
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

-(void)getTemplateFinished:(ASIHTTPRequest *)request//正常情况取得json数据
{
    
    if ([TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict != nil) 
    {
        [[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict removeAllObjects];
    }
    
    NSDictionary *dict = [request responseString].JSONValue;
//    NSLog(@"dict_Front = %@",dict);
    
    NSDictionary *layoutDict = [dict objectForKey:@"layout"];
    NSLog(@"layoutDict = %@",layoutDict);

    NSArray *areasArray = [layoutDict objectForKey:@"areas"];
    NSLog(@"areasDict = %@",areasArray);
    [[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict setObject:areasArray forKey:@"areas"];

    NSString *backgroundStr = [layoutDict objectForKey:@"background"];
    [[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict setObject:backgroundStr forKey:@"background"];
    
    NSString *orientationStr = [layoutDict objectForKey:@"orientation"];
    [[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict setObject:orientationStr forKey:@"orientation"];

    
    NSDictionary *backpicDict = [layoutDict objectForKey:@"backpic"];
    [[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict setObject:backpicDict forKey:@"backpic"];
    
    NSArray *materialsArray = [layoutDict objectForKey:@"materials"];
    [[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict setObject:materialsArray forKey:@"materials"];

    NSLog(@"templateDetailsDict = %@",[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict);
    
    [self performSelector:@selector(showFrontDetails)];//加载正面素材
}

#pragma mark - showFrontDetails - 加载正面素材

-(void)showFrontDetails
{
    [self performSelector:@selector(showBackgroundPic_Front)];//加载正面背景图片
}

-(void)showBackgroundPic_Front
{
    NSString *backgroundStr = [[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict objectForKey:@"background"];
    UIImage *tmpimg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:backgroundStr]]];
    UIImageView *tmpImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    tmpImgView.image = tmpimg;
    [postcard_FrontView addSubview:tmpImgView];
    
    [self performSelector:@selector(showHollowOutPart:) withObject:tmpImgView];//加载镂空部分
    [self performSelector:@selector(showMaterials:) withObject:tmpImgView];//加载素材部分

    [tmpImgView release];
}

-(void)showHollowOutPart:(UIImageView *)imageView
{
    NSArray *areasArray = [[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict objectForKey:@"areas"];
    NSLog(@"areasDict = %@",areasArray);
    
    NSDictionary *areasDict = [areasArray objectAtIndex:0];
    NSLog(@"areasDict = %@",areasDict);
    
//    NSString *degreeStr = [areasDict objectForKey:@"degree"];
    NSString *hStr = [areasDict objectForKey:@"h"];
    NSString *wStr = [areasDict objectForKey:@"w"];
    NSString *xStr = [areasDict objectForKey:@"x"];
    NSString *yStr = [areasDict objectForKey:@"y"];
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraButton.frame = CGRectMake([xStr intValue]+10, [yStr intValue]+150,[wStr intValue]+40, [hStr intValue]+40);
    [cameraButton setImage:[UIImage imageNamed:@"addMoreTemplateButton.png"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(loadCamera) forControlEvents:UIControlEventTouchUpInside];//打开相机
    [imageView addSubview:cameraButton];
}

-(void)showMaterials:(UIImageView *)imageView
{
    NSArray *materialsArray = [[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict objectForKey:@"materials"];
    NSLog(@"materialsArray = %@",materialsArray);
    
    for (int i = 0; i < materialsArray.count; i ++)
    {
        NSDictionary *tmpDict = [materialsArray objectAtIndex:i];
//        NSString *degreeStr = [tmpDict objectForKey:@"degree"];
        NSString *hStr = [tmpDict objectForKey:@"h"];
        NSString *wStr = [tmpDict objectForKey:@"w"];
        NSString *xStr = [tmpDict objectForKey:@"x"];
        NSString *yStr = [tmpDict objectForKey:@"y"];

        NSString *picUrl = [tmpDict objectForKey:@"src"];
        UIImage *tmpimg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picUrl]]];
        
        UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake([xStr intValue]+10, [yStr intValue]+40,[wStr intValue]+40, [hStr intValue]+40)];  
        tmpImageView.image = tmpimg;
        [imageView addSubview:tmpImageView];
        [tmpImageView release];
    }
}


#pragma mark - goDisplayEachTemplateDetals - 去编辑明信片反面
-(IBAction)goDisplayEachTemplateDetals
{
    DisplayEachTemplateDetals_Back *tmpDisplayEachTemplateDetals_Back = [[DisplayEachTemplateDetals_Back alloc] initWithNibName:@"DisplayEachTemplateDetals-Back" bundle:nil];
    tmpDisplayEachTemplateDetals_Back.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    displayEachTemplateDetals_Back = tmpDisplayEachTemplateDetals_Back;
    [self presentModalViewController:displayEachTemplateDetals_Back 
                            animated:YES];
    [tmpDisplayEachTemplateDetals_Back release];
}


@end
