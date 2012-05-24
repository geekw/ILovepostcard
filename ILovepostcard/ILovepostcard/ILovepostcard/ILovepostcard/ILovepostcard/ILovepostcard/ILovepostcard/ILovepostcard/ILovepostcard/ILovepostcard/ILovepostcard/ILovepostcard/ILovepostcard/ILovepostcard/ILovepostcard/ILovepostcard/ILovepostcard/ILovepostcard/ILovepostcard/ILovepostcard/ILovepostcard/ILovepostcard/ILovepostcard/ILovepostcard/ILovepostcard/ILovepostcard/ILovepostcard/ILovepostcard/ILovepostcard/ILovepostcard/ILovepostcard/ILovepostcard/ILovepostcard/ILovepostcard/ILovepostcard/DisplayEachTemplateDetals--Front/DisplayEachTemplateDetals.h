//
//  DisplayEachTemplateDetals.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-12.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayEachTemplateDetals-Back.h"
#import "SBJson.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "PromptView.h"
#import "TemplateDetails-Singleton.h"
#import "TouchView.h"
#import "ScaleAndRotateView.h"
#import "MapKit/MapKit.h"


@interface DisplayEachTemplateDetals : UIViewController<ASIHTTPRequestDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TouchVieweDelegate,MKMapViewDelegate>
{
    ScaleAndRotateView *scaleAndRotateView;
    DisplayEachTemplateDetals_Back *displayEachTemplateDetals_Back;
    
    UIImagePickerController *imagePickerCamera;//相机
    UIView *cameraOverlayView;//相机层
    
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *goDisplayEachTemplateDetals_BackButton;
    IBOutlet UIView *toolBar_FrontView;//侧面工具栏--添加素材
    IBOutlet UIView *postcard_FrontView;//明信片正面
    IBOutlet UIButton *openPhotoLibraryButton;//打开本地相册按钮
    IBOutlet UIButton *showOrHideMapButton;//隐藏或者显示地图
    
    MKMapView *myMapView;
    UIImageView *mapImgView;
    
    BOOL hidden;
}

@property(nonatomic, retain) NSString *idName;

-(IBAction)goback;
-(IBAction)openPhotoLibrary;//打开本地相册
-(IBAction)showOrHideMap;//隐藏或者显示地图
-(IBAction)goDisplayEachTemplateDetals;//去编辑明信片反面

-(void)getGoogleStaticMap:(CGFloat)latitude Longitude:(CGFloat)longitude;
@end
