//
//  PlayVoiceView.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-24.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "PlayVoiceView.h"

#define VOICEURL @"http://5.gaosu.com/download/ring/000/093/646453d2fbddb1caaea4ee36f1c5fd35.mp3"

@interface PlayVoiceView ()
@end

@implementation PlayVoiceView
@synthesize voiceWebView;
@synthesize openWebViewButton;
@synthesize playAndStopButton;
@synthesize goBackButton,audioPlayer;

//bool PlayOrStop;


- (void)dealloc 
{
    audioPlayer = nil;[audioPlayer release];
    [goBackButton release];
    [playAndStopButton release];
    [openWebViewButton release];
    [voiceWebView release];
    [super dealloc];
}


#pragma mark - GoBack - 返回按钮
- (IBAction)goBack 
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - PlayAndStop - 播放或者停止音乐
- (IBAction)playAndStop
{
//    if (PlayOrStop == YES) 
//    {
//        PlayOrStop = NO;
        [audioPlayer play];
//    }
//    else
//    {
//        PlayOrStop = YES;
//        [audioPlayer stop];
//        [audioPlayer prepareToPlay];
//    }
}

#pragma mark - OpenWebView - 打开网页播放器播放
- (IBAction)openWebView
{
    voiceWebView = [[UIWebView alloc] init];
    [voiceWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:VOICEURL]]];
    [self.view addSubview:voiceWebView];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [voiceWebView release];
}


#pragma mark - View lifecycle - 系统函数
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    PlayOrStop = YES;
//    NSString *voiceUrlStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"voiceURLStr"];

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:VOICEURL]];
    request.delegate = self;
    [request setDidFinishSelector:@selector(getVoiceFinished:)];
    [request startAsynchronous];
}

-(void)getVoiceFinished:(ASIHTTPRequest *)request
{
    NSData *voiceData = [request responseData];
    audioPlayer = [[AVAudioPlayer alloc] initWithData:voiceData error:nil];
    [audioPlayer stop];
    [audioPlayer prepareToPlay];
}

- (void)viewDidUnload
{
    [self setGoBackButton:nil];
    [self setPlayAndStopButton:nil];
    [self setOpenWebViewButton:nil];
    [self setVoiceWebView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
