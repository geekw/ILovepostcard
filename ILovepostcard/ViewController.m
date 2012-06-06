//
//  ViewController.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-21.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#define PicURL @"http://61.155.238.30/postcards/interface/home_activities"

#import "ViewController.h"

@implementation ViewController
@synthesize listenVoiceMessageButton;
@synthesize goToPostcardListButton;
@synthesize goToPostOfficeButton;
@synthesize getMoreButton;
@synthesize loopScrollView;
@synthesize numberLabel;
@synthesize postcardList, activityListView, voiceMessageView;

static int timeNum = 0;


- (void)dealloc 
{
    [postcardList release];
    [activityListView release];
    [voiceMessageView release];
    [goToPostcardListButton release];
    [listenVoiceMessageButton release];
    [goToPostOfficeButton release];
    [getMoreButton release];
    [loopScrollView release];
    [numberLabel release];
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
    [request startAsynchronous];
}

-(void)getPic:(ASIHTTPRequest *)request
{
    NSDictionary *dict = [request responseString].JSONValue;
    NSLog(@"dict = %@",dict);
    
    NSString *unpayStr = [dict objectForKey:@"unpay_count"];
    NSLog(@"unpay = %@",unpayStr);
    self.numberLabel.text = [NSString stringWithFormat:@"%@",unpayStr];
    
    NSArray *tmpArray = [dict objectForKey:@"activities"];
    for (int i = 0; i < [tmpArray count]; i++)
    {
        NSDictionary *tmpDict = [tmpArray objectAtIndex:i];
        NSLog(@"tmpDict = %@",tmpDict);
        
        NSString *tmpUrl = [tmpDict objectForKey:@"pic"];
        
        if (tmpUrl != nil) 
        {
              UIImage *tmpImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tmpUrl]]];
            CGRect buttonFrame = CGRectMake(i * 280, 0 ,280,157);
            UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tmpButton.frame = buttonFrame;
            tmpButton.backgroundColor = [UIColor clearColor];
            [tmpButton setBackgroundImage:tmpImg forState:UIControlStateNormal];
            [tmpButton addTarget:self action:@selector(goToActivityList) forControlEvents:UIControlEventTouchUpInside];
            [self.loopScrollView addSubview:tmpButton];
        }
}
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
}

-(void)scrollImage
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
            [self.loopScrollView scrollRectToVisible:CGRectMake( 3 * 280,0,280,157) animated:YES];
            timeNum = 3;
            break;
        case 3:
            [self.loopScrollView scrollRectToVisible:CGRectMake( 0 * 280,0,280,157) animated:NO];
            timeNum = 0;
            break;
        default:
            break;
    }
}

//-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.x == 0)
//    {
//        timeNum = 0;
//    }
//    if (scrollView.contentOffset.x == 280)
//    {
//        timeNum = 1;
//    }    
//    if (scrollView.contentOffset.x == 560)
//    {
//        timeNum = 2;
//    }    
//    if (scrollView.contentOffset.x == 840)
//    {
//        timeNum = 3;
//    }    
//}


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
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - HandleLoopScrollView --图片循环播放
-(void)handleLoopScrollView
{
    [self.loopScrollView setContentSize:CGSizeMake(280 * 4, 157)];
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

- (IBAction)goToPostOfficeView
{
    
}

- (IBAction)getMore 
{
    
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

@end
