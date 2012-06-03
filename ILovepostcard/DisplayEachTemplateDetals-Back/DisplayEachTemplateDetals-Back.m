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
@synthesize shareAndBuyViewButton,shareAndBuyView;
@synthesize recordVoiceView,chooseAddressView;

bool hideOrShowBottonView;


#pragma mark - goBack - 返回按钮
-(IBAction)goback
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle - 系统函数
-(void)dealloc
{
    chooseAddressView = nil;[chooseAddressView release];
    recordVoiceView   = nil;[recordVoiceView release];
    shareAndBuyView   = nil;[shareAndBuyView release];
    backButton = nil;[backButton release];
    [shareAndBuyViewButton release];
    [voiceRecordButton release];
    [chooseAdressViewButton release];
    [arrowButton release];
    [arrowButtonSmall release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [backButton setImage:[UIImage imageNamed:@"titlebtnbackclick.png"] forState:UIControlStateHighlighted];
    [self.shareAndBuyViewButton setImage:[UIImage imageNamed:@"titlebtnokclick.png"] forState:UIControlStateHighlighted];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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



#pragma mark - ShrinkBottom - 底部收缩
- (IBAction)shrinkBottom 
{
    if (hideOrShowBottonView == NO)
    {
        hideOrShowBottonView = YES;
        [UIView animateWithDuration:0.5
                         animations:^{
                             toolBar_BackView.frame = CGRectMake(0, 325, 320, 135);
                             toolBar_BackView.frame = CGRectMake(0, 420, 320, 135);
                         }];
        [self.arrowButtonSmall setImage:[UIImage imageNamed:@"slidearrow.png"] forState:UIControlStateNormal];
    }
    else 
    {
        hideOrShowBottonView = NO;
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
