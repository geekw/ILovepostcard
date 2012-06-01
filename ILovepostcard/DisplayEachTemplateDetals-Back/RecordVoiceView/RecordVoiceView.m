//
//  RecordVoiceView.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-31.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "RecordVoiceView.h"

@interface RecordVoiceView ()

@end

@implementation RecordVoiceView
@synthesize goBackButton;
@synthesize voiceRecordButton;
@synthesize playVoiceButton;
@synthesize endVoiceRecordButton;

#pragma mark - goBack - 返回按钮
-(IBAction)goBack
{
    [self dismissModalViewControllerAnimated:NO];
}

#pragma mark - View lifecycle - 系统函数
- (void)dealloc 
{
    [goBackButton release];
    [voiceRecordButton release];
    [playVoiceButton release];
    [endVoiceRecordButton release];
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
}

- (void)viewDidUnload
{
    [self setGoBackButton:nil];
    [self setVoiceRecordButton:nil];
    [self setPlayVoiceButton:nil];
    [self setEndVoiceRecordButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - VoiceRecord  - 开始录音
- (IBAction)voiceRecord 
{

}

#pragma mark - PlayVoice - 预览录音
- (IBAction)playVoice 
{

}

#pragma mark - EndVoiceRecord - 结束录音,带着生成的二维码返回
- (IBAction)endVoiceRecord 
{    
    
}
@end
