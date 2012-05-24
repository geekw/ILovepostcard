//
//  PlayVoiceView.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-24.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import <AVFoundation/AVFoundation.h>


@interface PlayVoiceView : UIViewController<ASIHTTPRequestDelegate,AVAudioPlayerDelegate,UIWebViewDelegate>


@property (retain, nonatomic) IBOutlet UIButton *openWebViewButton;

@property (retain, nonatomic) IBOutlet UIButton *playAndStopButton;

@property (retain, nonatomic) IBOutlet UIButton *goBackButton;

@property (retain, nonatomic) AVAudioPlayer *audioPlayer;
@property (retain, nonatomic) IBOutlet UIWebView *voiceWebView;

- (IBAction)goBack;

- (IBAction)playAndStop;

- (IBAction)openWebView;

@end
