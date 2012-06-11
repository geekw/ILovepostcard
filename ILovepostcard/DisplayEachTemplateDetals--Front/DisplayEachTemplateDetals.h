//
//  DisplayEachTemplateDetals.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-12.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DisplayEachTemplateDetals-Back.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "PromptView.h"
#import "TemplateDetails-Singleton.h"
#import "TouchView.h"
#import "ScaleAndRotateView.h"
#import "MapKit/MapKit.h"
#import "ImageProcess.h"
#import "EGOImageView.h"


@interface DisplayEachTemplateDetals : UIViewController<ASIHTTPRequestDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TouchVieweDelegate,MKMapViewDelegate,EGOImageViewDelegate>
{
    ScaleAndRotateView *scaleAndRotateView;
    UIView *cameraOverlayView;//相机层
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *goDisplayEachTemplateDetals_BackButton;
    IBOutlet UIView *toolBar_FrontView;//侧面工具栏--添加素材
    IBOutlet UIView *postcard_FrontView;//明信片正面
    IBOutlet UIButton *openPhotoLibraryButton;//打开本地相册按钮
    MKMapView *myMapView;
    UIButton *cameraButton;
    UIButton *bottomButton;
    UIButton *indicatorButton;
    TouchView *fileContent;
}

@property (retain, nonatomic) UIImagePickerController *imagePicker;//相机

@property (retain, nonatomic) DisplayEachTemplateDetals_Back *displayEachTemplateDetals_Back;

@property (nonatomic, retain) NSString *idName;

@property (retain, nonatomic) NSString *idName_Activity;

@property (retain, nonatomic) IBOutlet UIScrollView *bottomScrollView;

@property (retain, nonatomic) IBOutlet UIImageView *bkImgView;

@property (retain, nonatomic) NSString  *tagValueStr;

@property (retain, nonatomic) UIImageView *mapImgView;

@property (retain, nonatomic) IBOutlet UIButton *shrinkButton;

@property (retain, nonatomic) IBOutlet UIButton *arrowButton;


-(IBAction)goback;

-(void)openPhotoLibrary;//打开本地相册

-(IBAction)goDisplayEachTemplateDetals;//去编辑明信片反面

-(void)getGoogleStaticMap:(CGFloat)latitude Longitude:(CGFloat)longitude;

-(void)hideOrShowNormalMaterial:(UIButton *)sender;

- (IBAction)shrinkBottom;

@end
