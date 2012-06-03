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



- (IBAction)goback;

- (IBAction)goShareAndBuyView;

- (IBAction)goVoiceRecordView;

- (IBAction)goToChooseAdressView;

@end
