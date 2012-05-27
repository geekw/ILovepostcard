//
//  DisplayEachTemplateDetals-Back.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-12.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "DisplayEachTemplateDetals-Back.h"

@implementation DisplayEachTemplateDetals_Back
@synthesize voiceRecordButton;
@synthesize shareAndBuyViewButton,shareAndBuyView;

bool startOrPause;

#pragma mark - goBack - 返回按钮
-(IBAction)goback
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle - 系统函数
-(void)dealloc
{
    shareAndBuyView = nil;[shareAndBuyView release];
    backButton = nil;[backButton release];
    [shareAndBuyViewButton release];
    [voiceRecordButton release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [self setShareAndBuyViewButton:nil];
    [self setVoiceRecordButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - GoShareAndBuyView - 进入微博分享,购买界面
- (IBAction)goShareAndBuyView 
{
    if (!shareAndBuyView)
    {
        shareAndBuyView = [[ShareAndBuyView alloc] init];
    }
    self.shareAndBuyView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:self.shareAndBuyView animated:YES];
}

#pragma mark - GoVoiceRecordView - 进入录音界面
- (IBAction)goVoiceRecordView 
{
    startOrPause = NO;//默认不播放
    
    UIView *voiceRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    voiceRecordView.tag = 201;
    
    UIImageView *tmpImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    tmpImgView.image =[UIImage imageNamed:@"postBack7.png"];
    [voiceRecordView addSubview:tmpImgView];
    [tmpImgView release];
    
    UIButton *playVoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playVoiceButton.frame = CGRectMake(31,259,90,35);
    playVoiceButton.backgroundColor = [UIColor redColor];
    [playVoiceButton addTarget:self action:@selector(playRecordedVoice) forControlEvents:UIControlEventTouchUpInside];
    playVoiceButton.userInteractionEnabled = NO;
    [voiceRecordView addSubview:playVoiceButton];
    
    UIButton *recordVoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recordVoiceButton.frame = CGRectMake(127,258,164,37);
    recordVoiceButton.backgroundColor = [UIColor blueColor];
    [recordVoiceButton addTarget:self action:@selector(recordVoice) forControlEvents:UIControlEventTouchUpInside];
    [voiceRecordView addSubview:recordVoiceButton];

    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(30,403,89,37);
    cancleButton.backgroundColor = [UIColor blackColor];
    [cancleButton addTarget:self action:@selector(cancleRecord) forControlEvents:UIControlEventTouchUpInside];
    [voiceRecordView addSubview:cancleButton];

    UIButton *completeRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completeRecordButton.frame = CGRectMake(127,403,164,37);
    completeRecordButton.backgroundColor = [UIColor yellowColor];
    [completeRecordButton addTarget:self action:@selector(completeRecord) forControlEvents:UIControlEventTouchUpInside];
    [voiceRecordView addSubview:completeRecordButton];

    [self.view addSubview:voiceRecordView];
    [voiceRecordView release];
    
}

-(void)recordVoice//开始录音
{

}

-(void)playRecordedVoice//预览已经录制的音频
{
    if (startOrPause == NO)
    {
        startOrPause = YES;
    }
    else if (startOrPause == YES)
    {
        startOrPause = NO;
    }
    
}

-(void)cancleRecord//取消录音
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRecord"];
    UIView *tmpView = (UIView *)[self.view viewWithTag:201];
    [tmpView removeFromSuperview];
}

-(void)completeRecord//完成录音
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isRecord"];
    UIView *tmpView = (UIView *)[self.view viewWithTag:201];
    [tmpView removeFromSuperview];
}


@end
