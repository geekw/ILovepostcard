//
//  RecordVoiceView.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-31.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#define RECORDPATH [NSString stringWithFormat:@"%@/Documents/Record/",NSHomeDirectory()]


#import "RecordVoiceView.h"

@interface RecordVoiceView ()

@end

@implementation RecordVoiceView
@synthesize timerLabel;
@synthesize goBackButton;
@synthesize voiceRecordButton;
@synthesize playVoiceButton;
@synthesize endVoiceRecordButton;
@synthesize audioPlayer,audioSession,audioRecorder;


int currentTime;
bool StopOrSatrt;

#pragma mark - goBack - 返回按钮
-(IBAction)goBack
{
    [self dismissModalViewControllerAnimated:NO];
}

#pragma mark - View lifecycle - 系统函数
- (void)dealloc 
{
    audioPlayer = nil;[audioPlayer release];
    audioRecorder = nil;[audioRecorder release];
    audioSession = nil;[audioSession release];
    [goBackButton release];
    [voiceRecordButton release];
    [playVoiceButton release];
    [endVoiceRecordButton release];
    [timerLabel release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    playVoiceButton.userInteractionEnabled = NO;
}

- (void)viewDidUnload
{
    [self setGoBackButton:nil];
    [self setVoiceRecordButton:nil];
    [self setPlayVoiceButton:nil];
    [self setEndVoiceRecordButton:nil];
    [self setTimerLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - VoiceRecord  - 开始录音
- (IBAction)voiceRecord 
{
    if (StopOrSatrt == NO)
    {
        StopOrSatrt = YES;
        
        self.playVoiceButton.userInteractionEnabled = NO;
        
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        [fileManager createDirectoryAtPath:RECORDPATH attributes:nil];
        
        self.audioSession= [AVAudioSession sharedInstance];
        self.audioSession.delegate = self;
        
        NSString *strName = [@"record" stringByAppendingString:@".caf"];
        NSString *fullPath = [RECORDPATH stringByAppendingPathComponent:strName];
        
        [[NSUserDefaults standardUserDefaults] setValue:fullPath forKey:@"LocalRecordPath"];
        NSString *voicePath = [[NSUserDefaults standardUserDefaults] valueForKey:@"LocalRecordPath"]; 
        NSURL *url = [NSURL fileURLWithPath:voicePath];//录音存放目录
        
        NSDictionary *settings=[NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:kAudioFormatMPEG4AAC],AVFormatIDKey,
                                [NSNumber numberWithFloat:8000.0],AVSampleRateKey,
                                [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                                [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                                [NSNumber numberWithInt:8],AVLinearPCMBitDepthKey,
                                [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                nil];   
        NSError *error;
      
        self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
        self.audioRecorder.delegate = self;
        [self.audioSession setActive: YES error: nil];
        [self.audioRecorder prepareToRecord];        
        self.audioRecorder.meteringEnabled = YES;        
        [self.audioRecorder peakPowerForChannel:0];
//        levelTimer=[NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(levelTimerCallback:) userInfo:nil repeats:YES];
        [self.audioRecorder record];
        
        currentTime = 0;
        myTimer = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showTime) userInfo:nil repeats:YES] retain];
        
    }
    else
    {
        StopOrSatrt = NO;
        [audioRecorder stop];
        [self.audioSession setActive: NO error: nil];
        playVoiceButton.userInteractionEnabled = YES;
        
        [myTimer invalidate];        
    }
}


-(void)showTime
{
    currentTime++;
    if (currentTime == 20) 
    {
        StopOrSatrt = NO;
        [audioRecorder stop];
        [self.audioSession setActive: NO error: nil];
        playVoiceButton.userInteractionEnabled = YES;
        
        [myTimer invalidate];      
        
        return;
    }
    
    int secs = currentTime % 60;
    int mins = (currentTime / 60) % 60;
    
    self.timerLabel.text = [NSString stringWithFormat:@"%.2d:%.2d", mins, secs];
}

-(void)levelTimerCallback:(NSTimer *)timer
{
    [self.audioRecorder updateMeters];
    NSLog(@"1 %f 2%f",[self.audioRecorder averagePowerForChannel:0],[self.audioRecorder peakPowerForChannel:0]);
}

#pragma mark - PlayVoice - 预览录音
- (IBAction)playVoice 
{
    self.timerLabel.text = @"00:00";
    currentTime = 0;
    myTimer = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showTime) userInfo:nil repeats:YES] retain];

    NSString *voicePath = [[NSUserDefaults standardUserDefaults] valueForKey:@"LocalRecordPath"]; 
    NSData   *data=[NSData dataWithContentsOfFile:voicePath options:0 error:nil];
    
    NSLog(@"voiceData = %@",data);
    
    NSError  *error;
    
    self.audioPlayer= [[AVAudioPlayer alloc] initWithData:data error:&error];
    self.audioPlayer.volume = 0.5;
    self.audioPlayer.meteringEnabled=YES;
    self.audioPlayer.numberOfLoops= 0;
    self.audioPlayer.delegate=self;
    [self.audioPlayer prepareToPlay];
    
    if(self.audioPlayer== nil)
    {
        NSLog(@"Error");
    }
    else
    {
        NSLog(@"I am playing");
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
        [self.audioPlayer play];
    }

}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.audioPlayer stop];
    [myTimer invalidate];
}

#pragma mark - EndVoiceRecord - 结束录音,带着生成的二维码返回
- (IBAction)endVoiceRecord 
{    
    [self.audioPlayer release];

    
}
@end
