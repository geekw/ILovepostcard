//
//  RecordVoiceView.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-31.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>


@interface RecordVoiceView : UIViewController<AVAudioPlayerDelegate, AVAudioRecorderDelegate,AVAudioSessionDelegate>
{
//    NSTimer *levelTimer;
    
    NSTimer *myTimer;
}


@property (retain, nonatomic) IBOutlet UIButton *goBackButton;

@property (retain, nonatomic) IBOutlet UIButton *voiceRecordButton;

@property (retain, nonatomic) IBOutlet UIButton *playVoiceButton;

@property (retain, nonatomic) IBOutlet UIButton *endVoiceRecordButton;

@property (retain, nonatomic) AVAudioPlayer *audioPlayer;

@property (retain, nonatomic) AVAudioRecorder *audioRecorder;

@property (retain, nonatomic) AVAudioSession *audioSession;

@property (retain, nonatomic) IBOutlet UILabel *timerLabel;

- (IBAction)goBack;

- (IBAction)voiceRecord;

- (IBAction)playVoice;

- (IBAction)endVoiceRecord;



@end
