//
//  ViewController.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-21.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#define PicURL @"http://www.52mxp.com/interface/home_activities"

#import "ViewController.h"
#import "JSON.h"

@implementation ViewController
@synthesize listenVoiceMessageButton;
@synthesize goToPostcardListButton;
@synthesize goToPostOfficeButton;
@synthesize getMoreButton;
@synthesize loopScrollView;
@synthesize numberLabel;
@synthesize newestCardBtnView;
@synthesize newestCardBtn;
@synthesize postcardList, activityListView, voiceMessageView;
@synthesize newestCardView;
@synthesize postOfficeView,getMoreView;

static int timeNum = 0;


- (void)dealloc 
{
    getMoreView = nil;[getMoreView release];
    postOfficeView = nil;[postOfficeView release];
    newestCardView = nil;[newestCardView release];
    [postcardList release];
    [activityListView release];
    [voiceMessageView release];
    [goToPostcardListButton release];
    [listenVoiceMessageButton release];
    [goToPostOfficeButton release];
    [getMoreButton release];
    [loopScrollView release];
    [numberLabel release];
    [newestCardBtnView release];
    [newestCardBtn release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - RequestPicUrl - 请求图片地址
-(void)requestPicUrl
{
    int i = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientId"] intValue];
    NSString *requsetUrl = [PicURL stringByAppendingFormat:@"?cid=%d",i];    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requsetUrl]];
    request.delegate = self;
    [request setDidFinishSelector:@selector(getPic:)];
    [request setDidFailSelector:@selector(badInternet:)];//没有网络
    [request startAsynchronous];
}

-(void)badInternet:(ASIHTTPRequest *)request
{
    [self showAlertView];
}

-(void)showAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"网络故障" 
                                                   delegate:self 
                                          cancelButtonTitle:@"重试" 
                                          otherButtonTitles:@"退出", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self viewDidLoad];
    }
    else
    {
        exit(0);
    }
}


-(void)getPic:(ASIHTTPRequest *)request
{
    NSArray *tmpArray = [request responseString].JSONValue;
    NSLog(@"%@",tmpArray);
    
    for (int i = 0; i < tmpArray.count; i++)
    {
        NSDictionary *tmpDict = [tmpArray objectAtIndex:i];
        
        NSString *tmpUrl = [tmpDict objectForKey:@"pic"];
        
        if (tmpUrl != nil) 
        {
            EGOImageButton *tmpButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"sendbk.png"]];
            [tmpButton setImageURL:[NSURL URLWithString:tmpUrl]];
            CGRect buttonFrame = CGRectMake(i * 280, 0 ,280,157);
            tmpButton.frame = buttonFrame;
            tmpButton.backgroundColor = [UIColor clearColor];
            [tmpButton addTarget:self action:@selector(goToActivityList) forControlEvents:UIControlEventTouchUpInside];
            [self.loopScrollView addSubview:tmpButton];
            [tmpButton release];
        }
    }
    [self performSelector:@selector(showNewestCardView:) withObject:tmpArray];
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
}

- (void)scrollImage
{
    switch (timeNum) 
    {
        case 0:
            [self.loopScrollView scrollRectToVisible:CGRectMake( 1 * 280,0,280,157)  animated:YES];
            timeNum = 1;
            break;
        case 1:
            [self.loopScrollView scrollRectToVisible:CGRectMake( 2 * 280,0,280,157) animated:YES];
            timeNum = 2;
            break;
        case 2:
            [self.loopScrollView scrollRectToVisible:CGRectMake( 0 * 280,0,280,157) animated:NO];
            timeNum = 0;
            break;
//        case 3:
//            [self.loopScrollView scrollRectToVisible:CGRectMake( 0 * 280,0,280,157) animated:NO];
//            timeNum = 0;
//            break;
        default:
            break;
    }
}

- (void)showNewestCardView:(NSArray *)tArray
{
    EGOImageButton *newestCardButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"sendbk.png"]];
    newestCardButton.frame = CGRectMake(5,5,135,90);
    NSDictionary *tmpDict = [tArray objectAtIndex:1];
    NSString *tmpUrl = [tmpDict objectForKey:@"pic"];
    [newestCardButton setImageURL:[NSURL URLWithString:tmpUrl]];
    [newestCardButton addTarget:self action:@selector(goToNewestCardView) forControlEvents:UIControlEventTouchUpInside];
    [self.newestCardBtnView addSubview:newestCardButton];
    [newestCardButton release];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self requestPicUrl];
    [goToPostcardListButton setBackgroundImage:[UIImage imageNamed:@"makepress.png"] forState:UIControlStateHighlighted];
    [listenVoiceMessageButton setBackgroundImage:[UIImage imageNamed:@"listenpress.png"] forState:UIControlStateHighlighted];
    [goToPostOfficeButton setBackgroundImage:[UIImage imageNamed:@"postofficepress.png"] forState:UIControlStateHighlighted];
    [getMoreButton setBackgroundImage:[UIImage imageNamed:@"morepress.png"] forState:UIControlStateHighlighted];
    
    [self performSelector:@selector(handleLoopScrollView)];
}

- (void)viewDidUnload
{
    [self setGoToPostcardListButton:nil];
    [self setListenVoiceMessageButton:nil];
    [self setGoToPostOfficeButton:nil];
    [self setGetMoreButton:nil];
    [self setLoopScrollView:nil];
    [self setNumberLabel:nil];
    [self setNewestCardBtnView:nil];
    [self setNewestCardBtn:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - HandleLoopScrollView --图片循环播放
-(void)handleLoopScrollView
{
    [self.loopScrollView setContentSize:CGSizeMake(280 * 3, 157)];
    self.loopScrollView.delegate = self;
    self.loopScrollView.pagingEnabled = YES;
    self.loopScrollView.userInteractionEnabled = YES;
    self.loopScrollView.showsHorizontalScrollIndicator = NO;
    self.loopScrollView.showsVerticalScrollIndicator = NO;
    self.loopScrollView.delaysContentTouches = YES;
}

#pragma mark - GoToPostcardScene --进入明信片模板界面
-(IBAction)goToPostcardList
{
    if (!postcardList)
    {
        postcardList = [[GoToPostcardList alloc] init];
    }
    self.postcardList.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:self.postcardList animated:YES];
}

#pragma mark - GoToNewestCardView --进入最新明信片的界面
- (void)goToNewestCardView 
{
    if (!newestCardView)
    {
        newestCardView = [[NewestCardView alloc] init];
    }
    self.newestCardView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:self.newestCardView animated:YES];
}

#pragma mark - GoToActivity_list --进入全部活动界面
- (void)goToActivityList 
{
    if (!activityListView)
    {
        activityListView = [[ActivityListView alloc] init];
    }
    self.activityListView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:self.activityListView animated:YES];
    
}

#pragma mark - GoToVoiceMessage --进入读取语音留言界面
- (IBAction)goToVoiceMessageView 
{
    if (!voiceMessageView)
    {
        voiceMessageView = [[VoiceMessageView alloc] init];
    }
    self.voiceMessageView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;;
    [self presentModalViewController:self.voiceMessageView animated:YES];
}

#pragma mark - GoToPostOfficeView --进入邮局界面
- (IBAction)goToPostOfficeView
{
    if (!postOfficeView)
    {
        postOfficeView = [[PostOfficeView alloc] init];
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FromMainScene"];
    self.postOfficeView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:self.postOfficeView animated:YES];
}

#pragma mark - GetMore --进入更多界面
- (IBAction)getMore 
{
    if (!getMoreView)
    {
        getMoreView = [[GetMoreView alloc] init];
    }
    self.getMoreView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:self.getMoreView animated:YES];

}

- (IBAction)goNewestCardView 
{
    if (!newestCardView) {
        newestCardView = [[NewestCardView alloc] init];
    }
    self.newestCardView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:self.newestCardView animated:YES];
}

@end
