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
@synthesize chooseAdressViewButton;
@synthesize arrowButton;
@synthesize arrowButtonSmall;
@synthesize blessMessageText;
@synthesize QRImg2;
@synthesize QRImgView;
@synthesize stampImgView;
@synthesize postmarkImgView;
@synthesize receiverNameLabel;
@synthesize snLabel;
@synthesize postNumberLabel;
@synthesize recevierAdressText;
@synthesize senderAdressText;
@synthesize hideOrShowStampButton;
@synthesize hideOrShowPostmarkButton;
@synthesize adress_SmallButton;
@synthesize stamp_SmallButton;
@synthesize postmark_SmallButton;
@synthesize voiceRecorder_SmallButton;
@synthesize shareAndBuyViewButton,shareAndBuyView;
@synthesize recordVoiceView,chooseAddressView;

bool HideOrShowBottonView;

bool HideOrShowStamp;

bool HideOrShowPostmark;

#define degreesToRadian(x) (M_PI * (x) / 180.0)//定义弧度

#pragma mark - goBack - 返回按钮
-(IBAction)goback
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle - 系统函数
-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];//注销观察者
    
    chooseAddressView = nil;[chooseAddressView release];
    recordVoiceView   = nil;[recordVoiceView release];
    shareAndBuyView   = nil;[shareAndBuyView release];
    backButton = nil;[backButton release];
    [shareAndBuyViewButton release];
    [voiceRecordButton release];
    [chooseAdressViewButton release];
    [arrowButton release];
    [arrowButtonSmall release];
    [blessMessageText release];
    [QRImgView release];
    [stampImgView release];
    [postmarkImgView release];
    [receiverNameLabel release];
    [snLabel release];
    [postNumberLabel release];
    [recevierAdressText release];
    [senderAdressText release];
    [hideOrShowStampButton release];
    [hideOrShowPostmarkButton release];
    [adress_SmallButton release];
    [stamp_SmallButton release];
    [postmark_SmallButton release];
    [voiceRecorder_SmallButton release];
    [QRImg2 release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [backButton setImage:[UIImage imageNamed:@"titlebtnbackclick.png"] forState:UIControlStateHighlighted];
    [self.shareAndBuyViewButton setImage:[UIImage imageNamed:@"titlebtnokclick.png"] forState:UIControlStateHighlighted];
    
    [self performSelector:@selector(rotateAllTheObjects)];//先旋转控件的视图
    [self performSelector:@selector(displayStampAndPostmark)];
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
    [self setChooseAdressViewButton:nil];
    [self setArrowButton:nil];
    [self setArrowButtonSmall:nil];
    [self setBlessMessageText:nil];
    [self setQRImgView:nil];
    [self setStampImgView:nil];
    [self setPostmarkImgView:nil];
    [self setReceiverNameLabel:nil];
    [self setSnLabel:nil];
    [self setPostNumberLabel:nil];
    [self setRecevierAdressText:nil];
    [self setSenderAdressText:nil];
    [self setHideOrShowStampButton:nil];
    [self setHideOrShowPostmarkButton:nil];
    [self setAdress_SmallButton:nil];
    [self setStamp_SmallButton:nil];
    [self setPostmark_SmallButton:nil];
    [self setVoiceRecorder_SmallButton:nil];
    [self setQRImg2:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - DisplayStampAndPostmark - 加载邮票邮戳等图片
- (void)displayStampAndPostmark
{
    [self.stamp_SmallButton addTarget:self action:@selector(hideOrShowStamp) forControlEvents:UIControlEventTouchUpInside];
    [self.postmark_SmallButton addTarget:self action:@selector(hideOrShowPostmark) forControlEvents:UIControlEventTouchUpInside];
    [self.voiceRecorder_SmallButton addTarget:self action:@selector(goVoiceRecordView) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)hideOrShowStamp 
{
    if (HideOrShowStamp == NO)
    {
        HideOrShowStamp = YES;
        self.stampImgView.hidden = YES;
        [stamp_SmallButton setImage:[UIImage imageNamed:@"slidebtnhide.png"] forState:UIControlStateNormal];
    }
    else 
    {
        HideOrShowStamp = NO;
        self.stampImgView.hidden = NO;
        [stamp_SmallButton setImage:[UIImage imageNamed:@"slidebtnshow.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)hideOrShowPostmark
{
    if (HideOrShowPostmark == NO)
    {
        HideOrShowPostmark = YES;
        self.postmarkImgView.hidden = YES;
        [postmark_SmallButton setImage:[UIImage imageNamed:@"slidebtnhide.png"] forState:UIControlStateNormal];
    }
    else
    {
        HideOrShowPostmark = NO;
        self.postmarkImgView.hidden = NO;
        [postmark_SmallButton setImage:[UIImage imageNamed:@"slidebtnshow.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - GoToChooseAdressView - 进入地址选择界面
- (IBAction)goToChooseAdressView 
{
    if (!chooseAddressView)
    {
        chooseAddressView = [[ChooseAddressView alloc] init];
    }
    self.chooseAddressView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:self.chooseAddressView animated:YES];
}

#pragma mark - GoVoiceRecordView - 进入录音界面
- (IBAction)goVoiceRecordView 
{
    if (!recordVoiceView)
    {
        recordVoiceView = [[RecordVoiceView alloc] init];
    }
    self.recordVoiceView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:self.recordVoiceView animated:NO];
}

#pragma mark - RotateAllTheObjects - 旋转控件
-(void)rotateAllTheObjects
{
    self.blessMessageText.frame = CGRectMake(53.5,31.5,150,143);
    self.blessMessageText.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
    
    self.QRImg2.frame = CGRectMake(22, 18, 29, 32);
    self.QRImg2.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
    
    self.stampImgView.frame = CGRectMake(161, 290, 68, 72);
    self.stampImgView.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
    
    self.postmarkImgView.frame = CGRectMake(130, 241, 115, 85);
    self.postmarkImgView.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
    
    self.recevierAdressText.frame = CGRectMake(56, 254, 144, 30);
    self.recevierAdressText.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
    
    self.receiverNameLabel.frame = CGRectMake(26, 254, 144, 30);
    self.receiverNameLabel.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
    
    self.senderAdressText.frame = CGRectMake(-4, 254, 144, 30);
    self.senderAdressText.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
    
    self.snLabel.frame = CGRectMake(-64, 94, 158, 10);
    self.snLabel.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
    
    self.postNumberLabel.frame = CGRectMake(-35, 242, 100, 10);
    self.postNumberLabel.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(getQRPic:)
                                                 name:@"QRPic" 
                                               object:nil];
}

#pragma mark - GetQRPic - NSNotification 
-(void)getQRPic:(NSNotification *)notification
{
    UIImage *tmpImg = notification.object;
    self.QRImg2.image = tmpImg;
    
    [self.voiceRecorder_SmallButton setImage:[UIImage imageNamed:@"slidebtndel.png"] forState:UIControlStateNormal];
    [self.voiceRecorder_SmallButton removeTarget:self action:@selector(goVoiceRecordView) forControlEvents:UIControlEventTouchUpInside];
    [self.voiceRecorder_SmallButton addTarget:self action:@selector(deleteTheRecord) forControlEvents:UIControlEventTouchUpInside];//删除录音
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GetQRPic"];//标志有声音留言
}

-(void)deleteTheRecord
{
    self.QRImg2.image = nil;
    [self.voiceRecorder_SmallButton setImage:[UIImage imageNamed:@"slidebtnadd.png"] forState:UIControlStateNormal];
    [self.voiceRecorder_SmallButton removeTarget:self action:@selector(deleteTheRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.voiceRecorder_SmallButton addTarget:self action:@selector(goVoiceRecordView) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"GetQRPic"];//标志没有声音留言
}

#pragma mark - ShrinkBottom - 底部收缩
- (IBAction)shrinkBottom 
{
    if (HideOrShowBottonView == NO)
    {
        HideOrShowBottonView = YES;
        [UIView animateWithDuration:0.5
                         animations:^{
                             toolBar_BackView.frame = CGRectMake(0, 325, 320, 135);
                             toolBar_BackView.frame = CGRectMake(0, 420, 320, 135);
                         }];
        [self.arrowButtonSmall setImage:[UIImage imageNamed:@"slidearrow.png"] forState:UIControlStateNormal];
    }
    else 
    {
        HideOrShowBottonView = NO;
        [UIView animateWithDuration:0.5
                         animations:^{
                             toolBar_BackView.frame = CGRectMake(0, 420, 320, 135);
                             toolBar_BackView.frame = CGRectMake(0, 325, 320, 135);
                         }];
        [self.arrowButtonSmall setImage:[UIImage imageNamed:@"slidearrowdown.png"] forState:UIControlStateNormal];
    }
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

@end
