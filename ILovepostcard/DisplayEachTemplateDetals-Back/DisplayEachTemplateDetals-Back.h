//
//  DisplayEachTemplateDetals-Back.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-12.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareAndBuyView.h"
#import "RecordVoiceView.h"
#import "ChooseAddressView.h"
#import "ImageProcess.h"
#import "TemplateDetails-Singleton.h"


@interface DisplayEachTemplateDetals_Back : UIViewController<UINavigationControllerDelegate>
{
    IBOutlet UIButton *backButton;
    IBOutlet UIView *toolBar_BackView;//侧面工具栏--添加素材
    IBOutlet UIView *postcard_BackView;//明信片反面
}

@property (retain, nonatomic) ShareAndBuyView *shareAndBuyView;
@property (retain, nonatomic) RecordVoiceView *recordVoiceView;
@property (retain, nonatomic) ChooseAddressView *chooseAddressView;

@property (retain, nonatomic) IBOutlet UIButton *shareAndBuyViewButton;
@property (retain, nonatomic) IBOutlet UIButton *voiceRecordButton;
@property (retain, nonatomic) IBOutlet UIButton *chooseAdressViewButton;

@property (retain, nonatomic) IBOutlet UIButton *arrowButton;

@property (retain, nonatomic) IBOutlet UIButton *arrowButtonSmall;

@property (retain, nonatomic) IBOutlet UITextView *blessMessageText;

@property (retain, nonatomic) IBOutlet UIImageView *QRImg2;

@property (retain, nonatomic) IBOutlet UIImageView *QRImgView;

@property (retain, nonatomic) IBOutlet UIImageView *stampImgView;

@property (retain, nonatomic) IBOutlet UIImageView *postmarkImgView;

@property (retain, nonatomic) IBOutlet UILabel *receiverNameLabel;

@property (retain, nonatomic) IBOutlet UILabel *snLabel;

@property (retain, nonatomic) IBOutlet UILabel *postNumberLabel;

@property (retain, nonatomic) IBOutlet UITextView *recevierAdressText;

@property (retain, nonatomic) IBOutlet UITextView *senderAdressText;

@property (retain, nonatomic) IBOutlet UIButton *hideOrShowStampButton;

@property (retain, nonatomic) IBOutlet UIButton *hideOrShowPostmarkButton;

@property (retain, nonatomic) IBOutlet UIButton *adress_SmallButton;

@property (retain, nonatomic) IBOutlet UIButton *stamp_SmallButton;

@property (retain, nonatomic) IBOutlet UIButton *postmark_SmallButton;

@property (retain, nonatomic) IBOutlet UIButton *voiceRecorder_SmallButton;

@property (retain, nonatomic) IBOutlet UIView *postcard_BackView;

- (IBAction)goback;

- (IBAction)goShareAndBuyView;

- (IBAction)goVoiceRecordView;

- (IBAction)goToChooseAdressView;

- (IBAction)shrinkBottom;

- (IBAction)hideOrShowStamp;

- (IBAction)hideOrShowPostmark;



@end
