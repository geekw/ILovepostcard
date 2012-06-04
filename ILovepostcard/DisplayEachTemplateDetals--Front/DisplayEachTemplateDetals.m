//
//  DisplayEachTemplateDetals.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-12.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "DisplayEachTemplateDetals.h"

#define Template_Front @"http://61.155.238.30/postcards/interface/get_template"//单个模板详情接口
#define googleMapUrl   @"http://maps.google.com/maps/api/staticmap"
#define pinUrl @"http://cdn1.iconfinder.com/data/icons/customicondesign-office6-shadow/32/pin-red.png"

#define degreesToRadian(x) (M_PI * (x) / 180.0)//定义弧度


@implementation DisplayEachTemplateDetals
@synthesize shrinkButton;
@synthesize arrowButton;
@synthesize bottomScrollView;
@synthesize bkImgView;
@synthesize idName,displayEachTemplateDetals_Back;
@synthesize tagValueStr,imagePicker,mapImgView;

bool hideOrShowMaterial;
bool hideOrShowMap;
bool hideOrShowBottonView;


#pragma mark - goBack - 返回按钮
-(IBAction)goback
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle - 系统函数
-(void)dealloc
{
    cameraButton = nil;[cameraButton release];
    bottomButton = nil;[bottomButton release];
    indicatorButton = nil;[indicatorButton release];
    tagValueStr = nil;
    mapImgView = nil;[mapImgView release];
    idName = nil;[idName release];
    backButton = nil;[backButton release];
    showOrHideMapButton = nil;[showOrHideMapButton release];
    openPhotoLibraryButton = nil;[openPhotoLibraryButton release];
    scaleAndRotateView = nil;[scaleAndRotateView release];
    displayEachTemplateDetals_Back = nil;[displayEachTemplateDetals_Back release];
    goDisplayEachTemplateDetals_BackButton = nil;[goDisplayEachTemplateDetals_BackButton release];
    [bottomScrollView release];
    [bkImgView release];
    [shrinkButton release];
    [arrowButton release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performSelector:@selector(readMapInfo)];//获得经纬度
//    [self performSelector:@selector(requestFrontDetails)];//请求明信片正面素材
    
    [backButton setImage:[UIImage imageNamed:@"titlebtnbackclick.png"] forState:UIControlStateHighlighted];
    
    [goDisplayEachTemplateDetals_BackButton setImage:[UIImage imageNamed:@"titlebtnokclick.png"] forState:UIControlStateHighlighted];
    hideOrShowMaterial = NO;
    
}

- (void)viewDidUnload
{
    [self setBottomScrollView:nil];
    [self setBkImgView:nil];
    [self setShrinkButton:nil];
    [self setArrowButton:nil];
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
    
    NSDictionary *layoutDict = [dict objectForKey:@"layout"];

    NSArray *areasArray = [layoutDict objectForKey:@"areas"];//可能没有
    if (areasArray != nil)
    {
      [[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict setObject:areasArray forKey:@"areas"];  
    }    

//    NSString *backgroundStr = [layoutDict objectForKey:@"background"];
//    [[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict setObject:backgroundStr forKey:@"background"];
    
//    NSString *orientationStr = [layoutDict objectForKey:@"orientation"];
//    [[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict setObject:orientationStr forKey:@"orientation"];

    
    NSDictionary *backpicDict = [layoutDict objectForKey:@"backpic"];//可能没有
    if (backpicDict != nil) 
    {
    [[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict setObject:backpicDict forKey:@"backpic"]; 
    }

    NSArray *materialsArray = [layoutDict objectForKey:@"materials"];
    [[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict setObject:materialsArray forKey:@"materials"];

    NSLog(@"templateDetailsDict = %@",[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict);
    
    [self performSelector:@selector(showFrontDetails)];//加载正面素材
}

#pragma mark - showFrontDetails - 加载正面素材
-(void)showFrontDetails
{
    [self performSelector:@selector(showBackgroundPic_Front)];//加载正面背景图片
    [self performSelector:@selector(showHollowOutPart)];//加载镂空部分
    [self performSelector:@selector(showMaterials)];//加载素材
}

-(void)showBackgroundPic_Front
{
    NSString *backgroundStr = [[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict objectForKey:@"background"];
    if (backgroundStr != nil)
    {
        UIImage *tmpimg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:backgroundStr]]];
        self.bkImgView.image = tmpimg;
    }
}

-(void)showHollowOutPart
{
    NSArray *areasArray = [[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict objectForKey:@"areas"];
    if ([areasArray count] != 0 )
    {
        for (int i = 0; i < [areasArray count]; i++)
        {
            NSString *intStr = [NSString stringWithFormat:@"%d",i];
            [self performSelector:@selector(displayEachHollowOutPart:) withObject:intStr];
        }
    }
}


- (void)displayEachHollowOutPart:(NSString *)str
{
    int i = [str intValue];
    
    cameraButton.hidden = NO;
    [bottomButton setImage:nil forState:UIControlStateNormal];
    [indicatorButton setImage:nil forState:UIControlStateNormal];
    indicatorButton.userInteractionEnabled = NO;
    if (fileContent) 
    {
        [fileContent removeFromSuperview];
    }
    NSArray *areasArray = [[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict objectForKey:@"areas"];
    NSDictionary *areasDict = [areasArray objectAtIndex:0];
    NSLog(@"areasDict = %@",areasDict);
    
    //NSString *degreeStr = [areasDict objectForKey:@"degree"];
    NSString *hStr = [areasDict objectForKey:@"h"];
    NSString *wStr = [areasDict objectForKey:@"w"];
    NSString *xStr = [areasDict objectForKey:@"x"];
    NSString *yStr = [areasDict objectForKey:@"y"];
    
    cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraButton.frame = CGRectMake(([xStr intValue]-[wStr intValue]/2)/2, ([yStr intValue]-[hStr intValue]/2)/2,[wStr intValue]/2, [hStr intValue]/2);
    cameraButton.backgroundColor = [UIColor blackColor];
    cameraButton.alpha = 0.7;
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"addphotobk.png"] forState:UIControlStateNormal];
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"addphotobkclick.png"] forState:UIControlStateHighlighted];
    [cameraButton setImage:[UIImage imageNamed:@"addphoto.png"] forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:@"addphotoclick.png"] forState:UIControlStateHighlighted];
    [cameraButton addTarget:self 
                     action:@selector(goCameraOrPhotoLibrary:) 
           forControlEvents:UIControlEventTouchUpInside];//打开相机
    cameraButton.userInteractionEnabled = YES;
    cameraButton.tag = 500 + i * 4;
    [postcard_FrontView addSubview:cameraButton];
    
    bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomButton.frame = CGRectMake(10 + 80 * i, 3, 59, 59);
    bottomButton.backgroundColor = [UIColor whiteColor];
    [bottomButton setAlpha:0.7];
    bottomButton.tag = 502 + i * 4 ;
    [self.bottomScrollView addSubview:bottomButton];
    
    indicatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    indicatorButton.frame = CGRectMake(50 + 80 * i, 0, 30, 30);
    [indicatorButton setImage:[UIImage imageNamed:@"slidebtnadd.png"]
                     forState:UIControlStateNormal];
    
    [indicatorButton removeTarget:self action:@selector(showHollowOutPart) forControlEvents:UIControlEventTouchUpInside];
    [indicatorButton addTarget:self action:@selector(goCameraOrPhotoLibrary:)
           forControlEvents:UIControlEventTouchUpInside];
    indicatorButton.tag = 501 + i * 4;
    [self.bottomScrollView addSubview:indicatorButton];


}

- (void)goCameraOrPhotoLibrary:(UIButton *)sender//选择相机还是相册
{
    int i = sender.tag;
    
    UIView *tmpView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, 320, 460)];
    tmpView.backgroundColor = [UIColor whiteColor];
    tmpView.alpha = 0.7;
    tmpView.tag = 99;
    
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpButton.frame = CGRectMake(50, 200, 100, 100);
    tmpButton.backgroundColor = [UIColor blackColor];
    tmpButton.tag = i;
    [tmpButton setTitle:@"打开相机" forState:UIControlStateNormal];
    [tmpButton addTarget:self action:@selector(loadCamera:) forControlEvents:UIControlEventTouchUpInside];
    [tmpView addSubview:tmpButton];
    
    UIButton *photoLibraryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoLibraryButton.frame = CGRectMake(200, 200, 100, 100);
    photoLibraryButton.backgroundColor = [UIColor blackColor];
    photoLibraryButton.tag = i;
    [photoLibraryButton setTitle:@"打开相册" forState:UIControlStateNormal];
    [photoLibraryButton addTarget:self action:@selector(openPhotoLibrary:) forControlEvents:UIControlEventTouchUpInside];
    [tmpView addSubview:photoLibraryButton];
    
    [self.view addSubview:tmpView];
    [tmpView release];
}

-(void)showMaterials
{
    //底部接着照相的按钮开始加载
    NSArray *areasArray = [[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict objectForKey:@"areas"];
    
    NSArray *materialsArray = [[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict objectForKey:@"materials"];
    
    //首先判断有几个按钮在下方,生成尺寸
    [self.bottomScrollView setContentSize:CGSizeMake(100 * ([materialsArray count] + [areasArray count]),60)];
    
    for (int i = 0; i < materialsArray.count; i ++)
    {
        NSDictionary *tmpDict = [materialsArray objectAtIndex:i];
        NSString *typeStr = [tmpDict objectForKey:@"type"];
        
        if ([typeStr intValue] == 2)//是一般素材
        {
            //1.加载素材到界面上
            NSString *degreeStr = [tmpDict objectForKey:@"degree"];
            NSString *hStr = [tmpDict objectForKey:@"h"];
            NSString *wStr = [tmpDict objectForKey:@"w"];
            NSString *xStr = [tmpDict objectForKey:@"x"];
            NSString *yStr = [tmpDict objectForKey:@"y"];
            
            NSString *picUrl = [tmpDict objectForKey:@"src"];
            UIImage *tmpimg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picUrl]]];
            
            UIImageView *materialsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(([xStr intValue]-[wStr intValue]/2)/2, ([yStr intValue]-[hStr intValue]/2)/2,[wStr intValue]/2, [hStr intValue]/2)];
            materialsImgView.image = tmpimg;
            materialsImgView.userInteractionEnabled = YES;
            materialsImgView.tag = i * 4 + 100;
            if (!scaleAndRotateView) 
            {
                scaleAndRotateView = [[ScaleAndRotateView alloc] init];
            }
            [scaleAndRotateView addScaleAndRotateView:materialsImgView];
            [postcard_FrontView addSubview:materialsImgView];
            [materialsImgView release];
            
            
            //2.加载响应的按钮,用来显示隐藏这个素材
            UIButton *normalButton = [UIButton buttonWithType:UIButtonTypeCustom];
            normalButton.frame = CGRectMake(10 + 80 * (i + areasArray.count), 3, 59, 59);
            normalButton.backgroundColor = [UIColor whiteColor];
            [normalButton setImage:tmpimg forState:UIControlStateNormal];
            normalButton.alpha =0.7;
            normalButton.tag = i * 4 + 101;
            [self.bottomScrollView addSubview:normalButton];
            
            UIButton *tmpIndicatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tmpIndicatorButton.frame = CGRectMake(50 + 80 * (i + areasArray.count), 0, 30, 30);
            tmpIndicatorButton.tag = i * 4 + 102;
            [tmpIndicatorButton setImage:[UIImage imageNamed:@"slidebtnshow.png"] forState:UIControlStateNormal];
            [tmpIndicatorButton addTarget:self action:@selector(hideOrShowNormalMaterial:) forControlEvents:UIControlEventTouchUpInside];
            [self.bottomScrollView addSubview:tmpIndicatorButton];
        }
    }
    
    CGRect rect1 = CGRectMake(139, 168, 100, 100);
    CGRect rect2 = CGRectMake(10, 10, 80, 80);
    
    UIView *tmpView = [[UIView alloc] initWithFrame:rect1];
    [tmpView setTag:200];
    UIImageView *tmpImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    tmpImgView.backgroundColor = [UIColor grayColor];
    [tmpView addSubview:tmpImgView];
    tmpView.alpha = 1;
    [tmpImgView release];
    
    UIImageView *tmpImgView2 = [[UIImageView alloc] initWithFrame:rect2];
    tmpImgView2.image = self.mapImgView.image;
    tmpImgView2.tag = 203;
    [tmpView addSubview:tmpImgView2];
    [tmpImgView2 release];
    
    if (!scaleAndRotateView) 
    {
        scaleAndRotateView = [[ScaleAndRotateView alloc] init];
    }
    [scaleAndRotateView addScaleAndRotateView:tmpView];
    [postcard_FrontView addSubview:tmpView];
    [tmpView release];
    
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpButton.frame = CGRectMake(10 + 80 * (materialsArray.count + areasArray.count), 3, 59, 59);
    tmpButton.tag = 201;
    tmpButton.backgroundColor = [UIColor whiteColor];
    tmpButton.alpha = 0.7;
    [tmpButton setImage:self.mapImgView.image forState:UIControlStateNormal];
    [self.bottomScrollView addSubview:tmpButton];
    
    
    UIButton *tmpButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpButton1.frame = CGRectMake(50 + 80 * (materialsArray.count + areasArray.count), 0, 30, 30);
    tmpButton1.tag = 202;
    [tmpButton1 setImage:[UIImage imageNamed:@"slidebtnshow.png"] 
                forState:UIControlStateNormal];
    [tmpButton1 addTarget:self 
                   action:@selector(hideOrShowMap:) 
         forControlEvents:UIControlEventTouchUpInside];
    [self.bottomScrollView addSubview:tmpButton1];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *materialsArray = [[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict objectForKey:@"materials"];
    int y = [materialsArray count];
    
    UITouch *touch = [touches anyObject];
    if ([touch tapCount] == 1) 
    {
        for (int i = 100; i < 100 + y; i++) 
        {
         UIImageView *tmpImgView = (UIImageView *)[self.view viewWithTag:i];
            if (touch.view == tmpImgView)
            {
                if ([tmpImgView superview]) 
                {
                    [[tmpImgView superview] bringSubviewToFront:tmpImgView];
                }
            }
        }
        
    UIView *tmpView =(UIView *)[self.view viewWithTag:200];
    if(touch.view == tmpView)
    {
        if ([tmpView superview]) 
        {
            [[tmpView superview] bringSubviewToFront:tmpView];
        }
    }
    } 
}


-(void)hideOrShowNormalMaterial:(UIButton *)sender
{
    int i = sender.tag;
    
    if (hideOrShowMaterial == NO)
    {
        hideOrShowMaterial = YES;
        UIImageView *tmpImgView = (UIImageView *)[self.view viewWithTag:i - 2];
        tmpImgView.hidden = YES;
        
        UIButton *tmpButton = (UIButton *)[self.view viewWithTag:i - 1];
        [tmpButton setImage:nil forState:UIControlStateNormal];
        
        UIButton *tmpButton1 = (UIButton *)[self.view viewWithTag:i];
        [tmpButton1 setImage:[UIImage imageNamed:@"slidebtnhide.png"] forState:UIControlStateNormal];
    }
    else
    {
        hideOrShowMaterial = NO;
        UIImageView *tmpImgView = (UIImageView *)[self.view viewWithTag:i - 2];
        tmpImgView.hidden = NO;
        
        UIButton *tmpButton = (UIButton *)[self.view viewWithTag:i - 1];
        [tmpButton setImage:tmpImgView.image forState:UIControlStateNormal];
        
        UIButton *tmpButton1 = (UIButton *)[self.view viewWithTag:i];
        [tmpButton1 setImage:[UIImage imageNamed:@"slidebtnshow.png"] forState:UIControlStateNormal];
    }
}


-(void)hideOrShowMap:(UIButton *)sender
{
//    int i = sender.tag;
    if (hideOrShowMap == NO)
    {
        hideOrShowMap = YES;
        UIView *tmpView = (UIView *)[self.view viewWithTag:200];
        tmpView.hidden = YES;
        
        UIButton *tmpButton = (UIButton *)[self.view viewWithTag:201];
        [tmpButton setImage:nil forState:UIControlStateNormal];
        
        UIButton *tmpButton1 = (UIButton *)[self.view viewWithTag:202];
        [tmpButton1 setImage:[UIImage imageNamed:@"slidebtnhide.png"] forState:UIControlStateNormal];
    }
    else
    {
        hideOrShowMap = NO;
        UIView *tmpView = (UIView *)[self.view viewWithTag:200];
        tmpView.hidden = NO;
        
        UIButton *tmpButton = (UIButton *)[self.view viewWithTag:201];
        [tmpButton setImage:self.mapImgView.image forState:UIControlStateNormal];
        
        UIButton *tmpButton1 = (UIButton *)[self.view viewWithTag:202];
        [tmpButton1 setImage:[UIImage imageNamed:@"slidebtnshow.png"] forState:UIControlStateNormal];
    }
}




#pragma mark - loadCamera - 打开相机
-(void)loadCamera:(UIButton *)sender
{
    int i = sender.tag; 
    
    UIView *tmpView = (UIView *)[self.view viewWithTag:99];
    [tmpView removeFromSuperview];
    
    UIImagePickerControllerSourceType sourceType;
    sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) 
    {
        imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.sourceType = sourceType;
        self.imagePicker.delegate = self; 
        
        //此处要禁止系统拍照界面,否则后面的takePicture方法不能使用!
        self.imagePicker.showsCameraControls = NO;
        self.imagePicker.toolbarHidden = YES;
        self.imagePicker.wantsFullScreenLayout = YES;
        self.imagePicker.allowsEditing = NO;
        
        //叠加一透明层到界面上,用来放各种按钮的图标,设透明
        cameraOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        self.imagePicker.cameraOverlayView = cameraOverlayView;
        [self.imagePicker.cameraOverlayView becomeFirstResponder];
        cameraOverlayView.alpha = 1.0f;
        
        //判断是否有闪光灯
        if ([UIImagePickerController isFlashAvailableForCameraDevice:sourceType] == YES) 
        {
            CGRect flashLightChangeFrame = CGRectMake(15, 20, 67.5, 33);
            UIButton *flashLightChangeButton = [[UIButton alloc] initWithFrame:flashLightChangeFrame];
            [flashLightChangeButton addTarget:self
                                       action:@selector(changeFlashlight)
                             forControlEvents:UIControlEventTouchUpInside];
            [flashLightChangeButton setImage:[UIImage imageNamed:@ "flashauto.png"]
                                    forState:UIControlStateNormal];
            [cameraOverlayView addSubview:flashLightChangeButton];
            [flashLightChangeButton release];
        }
        
        //加载切换摄像头的按钮
        UIButton *changeCameraButton = [[UIButton alloc] initWithFrame:CGRectMake(240, 20, 67.5, 33)];
        [changeCameraButton setImage:[UIImage imageNamed:@"changcamera.png"]
                            forState:UIControlStateNormal];
        [changeCameraButton setImage:[UIImage imageNamed:@"changcamera.png"]
                            forState:UIControlStateSelected];
        [changeCameraButton addTarget:self
                               action:@selector(changeCamera)//切换摄像头方法
                     forControlEvents:UIControlEventTouchUpInside];
        [cameraOverlayView addSubview:changeCameraButton];
        [changeCameraButton release];
        
        //加载拍照按钮
        UIButton *shootButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shootButton.frame = CGRectMake(100, 380, 123.5, 46.8);
        [shootButton setImage:[UIImage imageNamed:@"take.png"] forState:UIControlStateNormal]; 
        [shootButton setImage:[UIImage imageNamed:@"takeon.png"] forState:UIControlStateHighlighted]; 
        shootButton.tag = i;
        self.tagValueStr = [NSString stringWithFormat:@"%d",i];
//        NSLog(@"tagValueStr = %@",self.tagValueStr);
        [shootButton addTarget:self.imagePicker 
                        action:@selector(takePicture) 
              forControlEvents:UIControlEventTouchUpInside];
        shootButton.backgroundColor = [UIColor redColor];
        shootButton.hidden = NO;
        shootButton.userInteractionEnabled = YES;
        [cameraOverlayView addSubview:shootButton];
    }
    //打开摄像头的动画
    [self presentModalViewController:self.imagePicker 
                                      animated:YES];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"fromCameraOrAlbum"];
    //打开界面的动画 begin 和 commit
    [UIView beginAnimations:nil context:NULL];
    //打开界面的动画的延时时间
    [UIView setAnimationDelay:1.0f];
    //摄像机前景的透明度
    cameraOverlayView.alpha = 1.0f;
    [UIView commitAnimations];
}


//takePicture得到的图片
- (void)imagePickerController:(UIImagePickerController *)picker
		didFinishPickingImage:(UIImage *)image
				  editingInfo:(NSDictionary *)editingInfo
{   
    
    NSLog(@"tagValueStr = %@",self.tagValueStr);
    NSLog(@"tagValue = %d",[self.tagValueStr intValue]);
    
    /*   if ([self.tagValueStr intValue] % 2 == 0)//偶数
    {
         i = [self.tagValueStr intValue] + 3;

    }
    else//奇数
    {
         i = [self.tagValueStr intValue] + 2;

    }*/
        //带动画效果隐藏cameraImagePicker界面
        [self dismissModalViewControllerAnimated:YES];
    
        NSArray *areasArray = [[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict objectForKey:@"areas"];
        
        NSDictionary *areasDict = [areasArray objectAtIndex:0];
        NSString *degreeStr = [areasDict objectForKey:@"degree"];
        NSString *hStr = [areasDict objectForKey:@"h"];
        NSString *wStr = [areasDict objectForKey:@"w"];
        NSString *xStr = [areasDict objectForKey:@"x"];
        NSString *yStr = [areasDict objectForKey:@"y"];
        
        fileContent = [[TouchView alloc] initWithFrame:CGRectMake(([xStr intValue]-[wStr intValue]/2)/2, ([yStr intValue]-[hStr intValue]/2)/2,[wStr intValue]/2, [hStr intValue]/2)];
        [fileContent setImage:image];
        [fileContent setViewTag: 199];
        fileContent.delegate = self;
        [self.view addSubview:fileContent];
        [postcard_FrontView addSubview:fileContent];
        [fileContent release];
    
    /*  
    if ([self.tagValueStr intValue] % 2 == 0)
    {
        UIButton *tmpButton = (UIButton *)[self.view viewWithTag:[self.tagValueStr intValue]];
        tmpButton.hidden = YES;//隐藏页面上的button
        
        UIButton *tmpButton2 = (UIButton *)[self.view viewWithTag:[self.tagValueStr intValue] + 1];
        [tmpButton2 setImage:image forState:UIControlStateNormal];
        [tmpButton2 addTarget:self action:@selector(showHollowOutPart) forControlEvents:UIControlEventTouchUpInside];

        UIButton *tmpButton3 = (UIButton *)[self.view viewWithTag:[self.tagValueStr intValue] + 2];
        [tmpButton3 setImage:[UIImage imageNamed:@"slidebtndel.png"] forState:UIControlStateNormal];
        [tmpButton3 addTarget:self action:@selector(showHollowOutPart) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else
    {
        UIButton *tmpButton = (UIButton *)[self.view viewWithTag:[self.tagValueStr intValue] - 1];
        tmpButton.hidden = YES;//隐藏页面上的button
        
        UIButton *tmpButton2 = (UIButton *)[self.view viewWithTag:[self.tagValueStr intValue]];
        [tmpButton2 setImage:image forState:UIControlStateNormal];
        [tmpButton2 addTarget:self action:@selector(showHollowOutPart) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *tmpButton3 = (UIButton *)[self.view viewWithTag:[self.tagValueStr intValue] + 1];
        [tmpButton3 setImage:[UIImage imageNamed:@"slidebtndel.png"] forState:UIControlStateNormal];
        [tmpButton3 addTarget:self action:@selector(showHollowOutPart) forControlEvents:UIControlEventTouchUpInside];
    }
    */
    
    cameraButton.hidden = YES;
    
    [bottomButton setImage:image forState:UIControlStateNormal];
    
    [indicatorButton setImage:[UIImage imageNamed:@"slidebtndel.png"] forState:UIControlStateNormal];
    [indicatorButton removeTarget:self action:@selector(goCameraOrPhotoLibrary:) forControlEvents:UIControlEventTouchUpInside];
    
    [indicatorButton addTarget:self action:@selector(showHollowOutPart) forControlEvents:UIControlEventTouchUpInside];
}

//切换闪光灯
- (void)changeFlashlight:(UIButton *)button
{
    static NSInteger i = 0;
    if (i == 0)
    {
        self.imagePicker.cameraFlashMode = -1;
        [button setImage:[UIImage imageNamed:@ "flashon.png"]
                forState:UIControlStateNormal];
        i = i + 1;
    }
    else if ( i == 1)
    {
        self.imagePicker.cameraFlashMode = 1;
        [button setImage:[UIImage imageNamed:@ "flashoff.png"]
                forState:UIControlStateNormal];
        i = i +1;
    }
    else if ( i == 3)
    {
        self.imagePicker.cameraFlashMode = 0;
        [button setImage:[UIImage imageNamed:@ "flashauto.png"]
                forState:UIControlStateNormal];
        i = 0;
    }
}

//切换前后摄像头
- (void)changeCamera
{
    if( [UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceFront] && imagePicker !=nil)
    {
        self.imagePicker.cameraDevice = !self.imagePicker.cameraDevice;
    }
}


#pragma mark - OpenPhotoLibrary - 打开相册
-(IBAction)openPhotoLibrary:(UIButton *)sender
{
    int i = sender.tag;   
    
    self.tagValueStr = [NSString stringWithFormat:@"%d",i];
    NSLog(@"tagValueStr = %@",self.tagValueStr);

    UIView *tmpView = (UIView *)[self.view viewWithTag:99];
    [tmpView removeFromSuperview];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) 
    {
        if (!imagePicker)
        {
            imagePicker = [[UIImagePickerController alloc] init];
        }
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = YES;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:self.imagePicker animated:YES];
    }
}


#pragma optional
- (void)TouchViewActionBegin:(NSNumber *)tag
{
    int index = [tag intValue];
    
    switch (index)
    {
        case 0:
        {
            NSLog(@"a```sa");
        }
            break;
        case 1:
        {
            NSLog(@"asa");
        }
            break;    
        default:
            break;
    }
}


#pragma mark - ReadMapInfo - 读取经纬度信息
-(void)readMapInfo
{
    myMapView = [[MKMapView alloc] init];
    myMapView.showsUserLocation = YES;
    myMapView.delegate = self;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CGFloat latitudeValue ;
    CGFloat longitudeValue;
    
    latitudeValue  = userLocation.coordinate.latitude;
    longitudeValue = userLocation.coordinate.longitude;
        NSLog(@"latitude  = %f", latitudeValue);
        NSLog(@"longitude = %f", longitudeValue);
    
    if (latitudeValue != 0.000000 || longitudeValue != 0.000000) 
    {
        [self getGoogleStaticMap:latitudeValue Longitude:longitudeValue];
    }
}

-(void)getGoogleStaticMap:(CGFloat)latitude Longitude:(CGFloat)longitude
{
    NSString *latitudeValue  = [NSString stringWithFormat:@"%f",latitude];
    NSString *longitudeValue = [NSString stringWithFormat:@"%f",longitude];
    
    NSString *centerStr = [[NSString stringWithFormat:@"%@ , %@",latitudeValue,longitudeValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"centerStr = %@",centerStr);


    NSString *markersStr = [[NSString stringWithFormat:@"icon:%@|%@ , %@",pinUrl,latitudeValue,longitudeValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"markersStr = %@",markersStr);
    
    NSString *sizeStr = [NSString stringWithFormat:@"111x111"];
    NSLog(@"sizeStr = %@",sizeStr);
    
    NSString *loadString = [googleMapUrl stringByAppendingFormat:@"?center=%@&size=%@&zoom=11&language=zh-cn&markers=%@&sensor=true",centerStr,sizeStr,markersStr];
    NSLog(@"loadString = %@",loadString);

    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:loadString]];
    request.delegate = self;
    [request setDidFinishSelector:@selector(getStaticMapFinished:)];
    [request startSynchronous];
}

-(void)getStaticMapFinished:(ASIHTTPRequest *)request
{
    NSData *pngData = [request responseData];
    
    [[NSUserDefaults standardUserDefaults] setValue:pngData forKey:@"mapPic"];
    NSLog(@"mapPic = %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"mapPic"]);
    
    if (!mapImgView)
    {
        mapImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 111, 111)];
    }
    self.mapImgView.image = [UIImage imageWithData:pngData];
    
    UIImageView *tmpImgView = (UIImageView *)[self.view viewWithTag:203];
    tmpImgView.image = [UIImage imageWithData:pngData];
    
    UIButton *tmpButton = (UIButton *)[self.view viewWithTag:201];
    [tmpButton setImage:[UIImage imageWithData:pngData] forState:UIControlStateNormal];
    
    if (mapImgView.image != nil) 
    {
        [myMapView release];
    }
}

#pragma mark - ShrinkBottom - 底部收缩
- (IBAction)shrinkBottom 
{
    if (hideOrShowBottonView == NO)
    {
        hideOrShowBottonView = YES;
        [UIView animateWithDuration:0.5
                         animations:^{
                             toolBar_FrontView.frame = CGRectMake(0, 325, 320, 135);
                             toolBar_FrontView.frame = CGRectMake(0, 420, 320, 135);
                         }];
        [self.arrowButton setImage:[UIImage imageNamed:@"slidearrow.png"] forState:UIControlStateNormal];
    }
    else 
    {
        hideOrShowBottonView = NO;
        [UIView animateWithDuration:0.5
                         animations:^{
                             toolBar_FrontView.frame = CGRectMake(0, 420, 320, 135);
                             toolBar_FrontView.frame = CGRectMake(0, 325, 320, 135);
                         }];
        [self.arrowButton setImage:[UIImage imageNamed:@"slidearrowdown.png"] forState:UIControlStateNormal];
    }
}


#pragma mark - goDisplayEachTemplateDetals - 去编辑明信片反面
-(IBAction)goDisplayEachTemplateDetals
{
    if (!displayEachTemplateDetals_Back)
    {
      displayEachTemplateDetals_Back = [[DisplayEachTemplateDetals_Back alloc] initWithNibName:@"DisplayEachTemplateDetals-Back" bundle:nil];  
    }
    
    self.displayEachTemplateDetals_Back.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:self.displayEachTemplateDetals_Back 
                            animated:YES];
}


@end
