//
//  GetMoreView.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-6-11.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "GetMoreView.h"
#import "PromptView.h"

@implementation GetMoreView
@synthesize goBackBtn;
@synthesize weiBoShareBtn;
@synthesize aboutUsBtn;
@synthesize gradeBtn;
@synthesize serviceBtn;
@synthesize sinaShare;
@synthesize aboutUsViewController;


#pragma mark - GoBack - 返回按钮
-(IBAction)goBack
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)weiBoShare:(id)sender {
    if (!sinaShare) {
        sinaShare = [[SinaShare alloc] init];
        sinaShare.delegate = self;
    }
    [sinaShare logInSinaWB];
}

- (IBAction)goAboutUsView {
    if (!aboutUsViewController) {
        aboutUsViewController = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
    }
    [self presentModalViewController:aboutUsViewController animated:YES];
}

- (IBAction)giveScore {
    NSString *urlStr = @"http://itunes.apple.com/us/app/wo-ai-ming-xin-pian/id537098326?ls=1&mt=8";
    NSURL *url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)callServer {
    NSString *urlStr = @"tel://8004664411";
    NSURL *url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:url];
}


#pragma mark - View lifecycle - 系统函数
- (void)dealloc 
{
    [goBackBtn release];
    [weiBoShareBtn release];
    [aboutUsBtn release];
    [gradeBtn release];
    [serviceBtn release];
    sinaShare = nil;
    [aboutUsViewController release];
    
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
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.goBackBtn setImage:[UIImage imageNamed:@"titlebtnbackclick.png"] forState:UIControlStateHighlighted];
}

- (void)viewDidUnload
{
    [self setGoBackBtn:nil];
    [self setWeiBoShareBtn:nil];
    [self setAboutUsBtn:nil];
    [self setGradeBtn:nil];
    [self setServiceBtn:nil];
    [self setSinaShare:nil];
    [self setAboutUsBtn:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)sinaLoginFinished{
    PromptView *promptView = [[PromptView alloc] init];
    [promptView showPromptWithParentView:self.view withPrompt:@"登录成功" withFrame:CGRectMake(120, 400, 80, 40)];
    [promptView release];
}

- (void)sinaLogoutFinished{
    PromptView *promptView = [[PromptView alloc] init];
    [promptView showPromptWithParentView:self.view withPrompt:@"登出成功" withFrame:CGRectMake(120, 400, 80, 40)];
    [promptView release];
}

@end
