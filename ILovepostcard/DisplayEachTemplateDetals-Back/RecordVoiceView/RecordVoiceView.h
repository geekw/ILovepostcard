//
//  RecordVoiceView.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-31.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordVoiceView : UIViewController


@property (retain, nonatomic) IBOutlet UIButton *goBackButton;

@property (retain, nonatomic) IBOutlet UIButton *voiceRecordButton;

@property (retain, nonatomic) IBOutlet UIButton *playVoiceButton;

@property (retain, nonatomic) IBOutlet UIButton *endVoiceRecordButton;



- (IBAction)goBack;

- (IBAction)voiceRecord;

- (IBAction)playVoice;

- (IBAction)endVoiceRecord;



@end
