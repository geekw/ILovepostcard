//
//  DisplayEachTemplateDetals-Back.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-12.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareAndBuyView.h"

@interface DisplayEachTemplateDetals_Back : UIViewController<UINavigationControllerDelegate>
{
    IBOutlet UIButton *backButton;
    IBOutlet UIView *toolBar_BackView;//侧面工具栏--添加素材
    IBOutlet UIView *postcard_BackView;//明信片反面
}

@property (retain, nonatomic) ShareAndBuyView *shareAndBuyView;
@property (retain, nonatomic) IBOutlet UIButton *shareAndBuyViewButton;

@property (retain, nonatomic) IBOutlet UIButton *voiceRecordButton;


- (IBAction)goback;

- (IBAction)goShareAndBuyView;

- (IBAction)goVoiceRecordView;

@end
