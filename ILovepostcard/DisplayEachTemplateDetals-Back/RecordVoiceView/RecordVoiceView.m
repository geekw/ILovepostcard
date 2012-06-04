//
//  RecordVoiceView.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-31.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#define RECORDPATH [NSString stringWithFormat:@"%@/Documents/Record/",NSHomeDirectory()]

#define UPLOAD_IMAGE_WEBSITE_PATH [NSString stringWithFormat:@"http://61.155.238.30:80/postcards/file/upload"]


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
@synthesize promptView;

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
    promptView  = nil;[promptView release];
    audioPlayer = nil;[audioPlayer release];
    audioRecorder = nil;[audioRecorder release];
    audioSession  = nil;[audioSession release];
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
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    NSString *strName = [@"record" stringByAppendingString:@".caf"];
    NSString *fullPath = [RECORDPATH stringByAppendingPathComponent:strName];
    [[NSUserDefaults standardUserDefaults] setValue:fullPath forKey:@"LocalRecordPath"];

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
        currentTime = 0;
        self.playVoiceButton.userInteractionEnabled = NO;

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
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];

        self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
        self.audioRecorder.delegate = self;
        
        self.audioSession= [AVAudioSession sharedInstance];
        self.audioSession.delegate = self;
        
        [self.audioRecorder prepareToRecord];  
        [self.audioSession setActive: YES error: nil];
        
        self.audioRecorder.meteringEnabled = YES;        
        [self.audioRecorder peakPowerForChannel:0];
        [self.audioRecorder record];
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

//-(void)levelTimerCallback:(NSTimer *)timer
//{
//    [self.audioRecorder updateMeters];
//    NSLog(@"1 %f 2%f",[self.audioRecorder averagePowerForChannel:0],[self.audioRecorder peakPowerForChannel:0]);
//}

#pragma mark - PlayVoice - 预览录音
- (IBAction)playVoice 
{
    self.timerLabel.text = @"00:00";
    currentTime = 0;
    myTimer = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showTime) userInfo:nil repeats:YES] retain];

    NSString *voicePath = [[NSUserDefaults standardUserDefaults] valueForKey:@"LocalRecordPath"]; 
    NSData   *data =[NSData dataWithContentsOfFile:voicePath options:0 error:nil];
    
    NSLog(@"voiceData = %@",data);
    
    NSError  *error;
    
    self.audioPlayer= [[AVAudioPlayer alloc] initWithData:data error:&error];
    self.audioPlayer.volume = 0.7;
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
    
    NSString *voicePath = [[NSUserDefaults standardUserDefaults] valueForKey:@"LocalRecordPath"]; 
    NSData   *data =[NSData dataWithContentsOfFile:voicePath options:0 error:nil];
    if (data != nil)
    {
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:UPLOAD_IMAGE_WEBSITE_PATH]];
        [request setDelegate:self];
        [request setData: data
            withFileName: @"recordTest.caf"
          andContentType: @"recordTest/caf"
                  forKey: @"file"];    [request appendPostData:[@"{\"postcard\":\"1\"}" dataUsingEncoding:NSUTF8StringEncoding]];
        [request setDidFinishSelector:@selector(requestUploadImageFinish:)];
        [request setDidFailSelector:@selector(requestUploadImageFail:)];
        [request startAsynchronous];

    }
    else 
    {
        if (!promptView) {
            promptView = [[PromptView alloc] init];
        }
        [promptView showPromptWithParentView:self.view
                                  withPrompt:@"请您先录音" 
                                   withFrame:CGRectMake(40, 120, 240, 240)];
        return;
    
    }
    


    
}
@end
