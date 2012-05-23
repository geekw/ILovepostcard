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
    mapImgView = nil;[mapImgView release];
    idName = nil;[idName release];
    backButton = nil;[backButton release];
    showOrHideMapButton = nil;[showOrHideMapButton release];
    openPhotoLibraryButton = nil;[openPhotoLibraryButton release];
    scaleAndRotateView = nil;[scaleAndRotateView release];
    displayEachTemplateDetals_Back = nil;[displayEachTemplateDetals_Back release];
    goDisplayEachTemplateDetals_BackButton = nil;[goDisplayEachTemplateDetals_BackButton release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performSelector:@selector(readMapInfo)];//获得经纬度
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
    [self performSelector:@selector(showHollowOutPart)];//加载镂空部分
    [self performSelector:@selector(showMaterials)];//加载素材
}

-(void)showBackgroundPic_Front
{
    NSString *backgroundStr = [[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict objectForKey:@"background"];
    UIImage *tmpimg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:backgroundStr]]];
    UIImageView *tmpImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    tmpImgView.image = tmpimg;
    [postcard_FrontView addSubview:tmpImgView];
    [tmpImgView release];
}

-(void)showHollowOutPart
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
    cameraButton.frame = CGRectMake([xStr intValue]+30, [yStr intValue]+300,[wStr intValue]+40, [hStr intValue]+40);
    [cameraButton setImage:[UIImage imageNamed:@"addMoreTemplateButton.png"] forState:UIControlStateNormal];
    [cameraButton addTarget:self 
                     action:@selector(loadCamera) 
           forControlEvents:UIControlEventTouchUpInside];//打开相机
    cameraButton.userInteractionEnabled = YES;
    [postcard_FrontView addSubview:cameraButton];
}

-(void)showMaterials
{
    NSArray *materialsArray = [[TemplateDetails_Singleton sharedTemplateDetails_Singleton].templateDetailsDict objectForKey:@"materials"];
//    NSLog(@"materialsArray = %@",materialsArray);
    
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

        UIImageView *picImgView = [[UIImageView alloc] initWithFrame:CGRectMake([xStr intValue] + 100, [yStr intValue] + 100, [wStr intValue] + 80, [hStr intValue] + 80)];
        picImgView.image = tmpimg;
        picImgView.userInteractionEnabled = YES;
        [postcard_FrontView addSubview:picImgView];
        [picImgView release];
        if (!scaleAndRotateView) 
        {
            scaleAndRotateView = [[ScaleAndRotateView alloc] init];
        }
        [scaleAndRotateView addScaleAndRotateView:picImgView];
    }
}

#pragma mark - loadCamera - 打开相机
-(void)loadCamera
{
    UIImagePickerControllerSourceType sourceType;
    sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) 
    {
        imagePickerCamera = [[UIImagePickerController alloc] init];
        imagePickerCamera.sourceType = sourceType;
        imagePickerCamera.delegate = self; 
        
        //此处要禁止系统拍照界面,否则后面的takePicture方法不能使用!
        imagePickerCamera.showsCameraControls = NO;
        imagePickerCamera.toolbarHidden = YES;
        imagePickerCamera.wantsFullScreenLayout = YES;
        imagePickerCamera.allowsEditing = NO;
        
        //叠加一透明层到界面上,用来放各种按钮的图标,设透明
        cameraOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        imagePickerCamera.cameraOverlayView = cameraOverlayView;
        [imagePickerCamera.cameraOverlayView becomeFirstResponder];
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
        [shootButton addTarget:imagePickerCamera 
                        action:@selector(takePicture) 
              forControlEvents:UIControlEventTouchUpInside];
        shootButton.backgroundColor = [UIColor redColor];
        shootButton.hidden = NO;
        shootButton.userInteractionEnabled = YES;
        [cameraOverlayView addSubview:shootButton];
    }
    //打开摄像头的动画
    [self presentModalViewController:imagePickerCamera 
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
    //带动画效果隐藏cameraImagePicker界面
    [self dismissModalViewControllerAnimated:YES];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) 
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
        
        TouchView *fileContent = [[TouchView alloc] initWithFrame:CGRectMake([xStr intValue] + 10, [yStr intValue] + 90,[wStr intValue] + 200, [hStr intValue] + 200)];
        [fileContent setImage:image];
        [fileContent setViewTag: [idName intValue]];
        fileContent.delegate = self;
        [self.view addSubview:fileContent];
        [postcard_FrontView addSubview:fileContent];
        [fileContent release];
    }
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) 
    {
        UIImageView *photoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)]; 
        photoImgView.image = image;
        [photoImgView setUserInteractionEnabled:YES];
        [postcard_FrontView addSubview:photoImgView];
        [photoImgView release];
        
        if (!scaleAndRotateView) 
        {
            scaleAndRotateView = [[ScaleAndRotateView alloc] init];
        }
        [scaleAndRotateView addScaleAndRotateView:photoImgView];
    }
}


//切换闪光灯
- (void)changeFlashlight:(UIButton *)button
{
    static NSInteger i = 0;
    if (i == 0)
    {
        imagePickerCamera.cameraFlashMode = -1;
        [button setImage:[UIImage imageNamed:@ "flashon.png"]
                forState:UIControlStateNormal];
        i = i + 1;
    }
    else if ( i == 1)
    {
        imagePickerCamera.cameraFlashMode = 1;
        [button setImage:[UIImage imageNamed:@ "flashoff.png"]
                forState:UIControlStateNormal];
        i = i +1;
    }
    else if ( i == 3)
    {
        imagePickerCamera.cameraFlashMode = 0;
        [button setImage:[UIImage imageNamed:@ "flashauto.png"]
                forState:UIControlStateNormal];
        i = 0;
    }
}

//切换前后摄像头
- (void)changeCamera
{
    if( [UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceFront] && imagePickerCamera !=nil)
    {
        imagePickerCamera.cameraDevice = !imagePickerCamera.cameraDevice;
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
#pragma mark - bottomViewButtonActions - 底部三个按钮的动作
-(IBAction)openPhotoLibrary//打开本地相册
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) 
    {
        UIImagePickerController *photoPickerController = [[UIImagePickerController alloc] init];
        photoPickerController.delegate = self;
        photoPickerController.allowsEditing = YES;
        photoPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:photoPickerController animated:YES];
        [photoPickerController release];
    }
}


-(IBAction)showOrHideMap//显示隐藏地图
{
    if (hidden == YES) 
    {
        hidden = NO;
        mapImgView.hidden = NO;
    }
    else if(hidden == NO)
    {
        hidden = YES;
        mapImgView.hidden = YES;
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
        NSLog(@"latitude = %f",latitudeValue);
        NSLog(@"longitude = %f",longitudeValue);
    
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
    [request startAsynchronous];
}

-(void)getStaticMapFinished:(ASIHTTPRequest *)request
{
    NSData *pngData = [request responseData];
    
    mapImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 111, 111)];
    mapImgView.image = [UIImage imageWithData:pngData];
    [postcard_FrontView addSubview:mapImgView];
    mapImgView.hidden = YES;
    hidden = YES;
    if (mapImgView.image != nil) 
    {
        [myMapView release];
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
