//
//  VoiceMessageView.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-24.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "PlayVoiceView.h"

@interface VoiceMessageView : UIViewController<UIImagePickerControllerDelegate,ZBarReaderViewDelegate>

@property (retain, nonatomic) IBOutlet UIButton *startScanQRButton;

@property (retain, nonatomic) PlayVoiceView *playVoiceView;

@property (retain, nonatomic) IBOutlet ZBarReaderView *readQRView;

@property (retain, nonatomic) IBOutlet UIButton *goBackButton;

@property (retain, nonatomic) NSString *voiceURLStr;

- (IBAction)goBack;

- (IBAction)startScanQR;
@end
