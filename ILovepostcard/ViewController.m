//
//  ViewController.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-21.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize listenVoiceMessageButton;
@synthesize goToPostcardListButton;
@synthesize goToActivityListButton;
@synthesize postcardList, activityListView, voiceMessageView;


- (void)dealloc 
{
    [postcardList release];
    [activityListView release];
    [voiceMessageView release];
    [goToPostcardListButton release];
    [goToActivityListButton release];
    [listenVoiceMessageButton release];
    [super dealloc];
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
    
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setGoToPostcardListButton:nil];
    [self setGoToActivityListButton:nil];
    [self setListenVoiceMessageButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

#pragma mark - GoToActivity_list --进入全部活动界面

- (IBAction)goToActivityList 
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
