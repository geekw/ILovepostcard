//
//  GetMoreView.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-6-11.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "GetMoreView.h"
#import "PromptView.h"
#import "WeiBoCell.h"

@implementation GetMoreView
@synthesize goBackBtn;
@synthesize weiBoShareBtn;
@synthesize aboutUsBtn;
@synthesize gradeBtn;
@synthesize serviceBtn;
@synthesize sinaShare;
@synthesize aboutUsViewController;
@synthesize table;
@synthesize tableArray;
@synthesize imageArray;
@synthesize weiboSwitch;

#pragma mark - GoBack - 返回按钮
-(IBAction)goBack
{
    [self dismissModalViewControllerAnimated:YES];
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
    [tableArray release];
    [table release];
    [imageArray release];
    [weiboSwitch release];
    
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
    
    tableArray = [[NSMutableArray alloc] initWithObjects:@"新浪微博授权", @"关于我爱明信片", @"给我们评分", @"客服电话 025 8221 1566", nil];
    imageArray = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"weiboico.png"], [UIImage imageNamed:@"aboutus.png"],[UIImage imageNamed:@"mailico.png"],[UIImage imageNamed:@"starico.png"],nil];
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
    [self setTableArray:nil];
    [self setTable:nil];
    [self setImageArray:nil];
    [self setWeiboSwitch:nil];
    
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - SinaShareDelegate

- (void)sinaLoginFinished{
    PromptView *promptView = [[PromptView alloc] init];
    [promptView showPromptWithParentView:self.view withPrompt:@"登录成功" withFrame:CGRectMake(120, 400, 80, 40)];
    [promptView release];
    
    [weiboSwitch setOn:YES animated:YES];
}

- (void)sinaLoginFailed {
    PromptView *promptView = [[PromptView alloc] init];
    [promptView showPromptWithParentView:self.view withPrompt:@"登录失败" withFrame:CGRectMake(120, 400, 80, 40)];
    [promptView release];
    
    [weiboSwitch setOn:YES animated:YES];
}

- (void)sinaLogoutFinished{
    PromptView *promptView = [[PromptView alloc] init];
    [promptView showPromptWithParentView:self.view withPrompt:@"登出成功" withFrame:CGRectMake(120, 400, 80, 40)];
    [promptView release];
    
    [weiboSwitch setOn:NO animated:YES];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [sinaShare logOutSinaWB];
    }
    else
    {
        [weiboSwitch setOn:YES];
    }
}

#pragma mark - TableDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"MoreCell";
    if (indexPath.row == 0) 
    {
        WeiBoCell *weiboCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        if (!weiboCell) {
            weiboCell = [WeiBoCell getInstance];
        }
        
        BOOL state = [[NSUserDefaults standardUserDefaults] boolForKey:kHasAuthoredSina];
        [weiboCell configCellWithImage:[imageArray objectAtIndex:indexPath.row] title:[tableArray objectAtIndex:indexPath.row] state:state];
        
        return weiboCell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }

        if (indexPath.row == 3)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else 
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.imageView.image = [imageArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [tableArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 1:
            [self goAboutUsView];
            break;
        case 2:
            [self giveScore];
            break;
        case 3:
            [self callServer];
            break;

        default:
            break;
    }
}

- (void)weiBoShare{
    if (!sinaShare) {
        sinaShare = [[SinaShare alloc] init];
        sinaShare.delegate = self;
    }
    
    if (![weiboSwitch isOn])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新浪微博" message:@"你确定要取消授权吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
        [alertView release];

    }
    else 
    {
        [sinaShare logInSinaWB];
    }
    
}


- (void)goAboutUsView {
    if (!aboutUsViewController) {
        aboutUsViewController = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
    }
    [self presentModalViewController:aboutUsViewController animated:YES];
}

- (void)giveScore {
    NSString *urlStr = @"http://itunes.apple.com/us/app/wo-ai-ming-xin-pian/id537098326?ls=1&mt=8";
    NSURL *url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)callServer {
    NSString *urlStr = @"tel://8004664411";
    NSURL *url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    weiboSwitch = (UISwitch *)[self.view viewWithTag:SWITCHTAG];
    [weiboSwitch addTarget:self action:@selector(weiBoShare) forControlEvents:UIControlEventTouchUpInside];

}


@end
