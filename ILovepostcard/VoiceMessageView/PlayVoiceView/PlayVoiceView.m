//
//  PlayVoiceView.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-24.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "PlayVoiceView.h"
#import "Effects.h"

#define VOICEURL @"http://5.gaosu.com/download/ring/000/093/646453d2fbddb1caaea4ee36f1c5fd35.mp3"

@interface PlayVoiceView ()
@end

@implementation PlayVoiceView
@synthesize voiceWebView;
@synthesize tapeRoll1;
@synthesize tapeRoll2;
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
    [tapeRoll1 release];
    [tapeRoll2 release];
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
    [self.playAndStopButton setImage:[UIImage imageNamed:@"btn-playclick.png"] 
                            forState:UIControlStateNormal];
    [audioPlayer play];
    [Effects rotate360DegreeWithImageView:self.tapeRoll1];
    [Effects rotate360DegreeWithImageView:self.tapeRoll2];
    self.playAndStopButton.userInteractionEnabled = NO;
}

/*
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
*/

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
    self.playAndStopButton.userInteractionEnabled = NO;
    [self.playAndStopButton setImage:nil forState:UIControlStateNormal];
    self.playAndStopButton.backgroundColor = [UIColor grayColor];
    [self.playAndStopButton setTitle:@"请稍侯..." forState:UIControlStateNormal];
    [self.playAndStopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [self.goBackButton setImage:[UIImage imageNamed:@"titlebtnbackclick.png"] 
                       forState:UIControlStateHighlighted];

    NSString *voiceUrlStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"voiceURLStr"];
    NSLog(@"%@",voiceUrlStr);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:voiceUrlStr]];
    request.delegate = self;
    [request setDidFinishSelector:@selector(getVoiceFinished:)];
    [request startAsynchronous];    
}

-(void)getVoiceFinished:(ASIHTTPRequest *)request
{
    NSData *voiceData = [request responseData];
    audioPlayer = [[AVAudioPlayer alloc] initWithData:voiceData error:nil];
    [audioPlayer setNumberOfLoops:1];
    audioPlayer.delegate = self;
    [audioPlayer stop];
    [audioPlayer prepareToPlay];
    self.playAndStopButton.userInteractionEnabled = YES;
    self.playAndStopButton.backgroundColor = [UIColor clearColor];
    [self.playAndStopButton setImage:[UIImage imageNamed:@"btn-play.png"] 
                            forState:UIControlStateNormal];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.playAndStopButton setImage:[UIImage imageNamed:@"btn-play.png"] 
                            forState:UIControlStateNormal ];
    [self.playAndStopButton setUserInteractionEnabled:YES];
    [self.tapeRoll1.layer removeAllAnimations];
    [self.tapeRoll2.layer removeAllAnimations];
}

- (void)viewDidUnload
{
    [self setGoBackButton:nil];
    [self setPlayAndStopButton:nil];
    [self setOpenWebViewButton:nil];
    [self setVoiceWebView:nil];
    [self setTapeRoll1:nil];
    [self setTapeRoll2:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
