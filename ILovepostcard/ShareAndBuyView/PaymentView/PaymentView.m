//
//  PaymentView.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-27.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "PaymentView.h"

@interface PaymentView ()

@end

@implementation PaymentView
@synthesize goBackButton;
@synthesize snailMailButton;
@synthesize registeredLetterButton;
@synthesize expressDeliveryButton;
@synthesize payTheBillButton;

#pragma mark - GoBack - 返回按钮
- (IBAction)goBack 
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle - 系统函数
- (void)dealloc 
{
    [goBackButton release];
    [snailMailButton release];
    [registeredLetterButton release];
    [expressDeliveryButton release];
    [payTheBillButton release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [snailMailButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
    [registeredLetterButton setBackgroundImage:[UIImage imageNamed:@"paymentView3.png"] forState:UIControlStateNormal];
    [expressDeliveryButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"MailType"];//默认是挂号信
}

- (void)viewDidUnload
{
    [self setGoBackButton:nil];
    [self setSnailMailButton:nil];
    [self setRegisteredLetterButton:nil];
    [self setExpressDeliveryButton:nil];
    [self setPayTheBillButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - SelectMailType - 选择快递类型
- (IBAction)snailMail
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"MailType"];
    [snailMailButton setBackgroundImage:[UIImage imageNamed:@"paymentView3.png"] forState:UIControlStateNormal];
    [registeredLetterButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
    [expressDeliveryButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
}

- (IBAction)registeredLetter
{
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"MailType"];
    [snailMailButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
    [registeredLetterButton setBackgroundImage:[UIImage imageNamed:@"paymentView3.png"] forState:UIControlStateNormal];
    [expressDeliveryButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
}

- (IBAction)expressDelivery 
{
    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"MailType"];
    [snailMailButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
    [registeredLetterButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
    [expressDeliveryButton setBackgroundImage:[UIImage imageNamed:@"paymentView3.png"] forState:UIControlStateNormal];
}

#pragma mark - PayTheBill - 支付账单
- (IBAction)payTheBill 
{
    UIView *billView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    billView.tag = 200;
    UIImageView *billImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    billImgView.image = [UIImage imageNamed:@"paymentView4.png"];
    [billView addSubview:billImgView];
    [billImgView release];
    
    UIButton *payClientButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payClientButton.frame = CGRectMake(78, 202, 212, 37);
    payClientButton.backgroundColor = [UIColor redColor];
    [payClientButton addTarget:self action:@selector(goTaobaoClient) forControlEvents:UIControlEventTouchUpInside];
    [billView addSubview:payClientButton];
    
    UIButton *payWapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payWapButton.frame = CGRectMake(78, 253, 212, 37);
    payWapButton.backgroundColor = [UIColor yellowColor];
    [payWapButton addTarget:self action:@selector(goTaobaoWap) forControlEvents:UIControlEventTouchUpInside];
    [billView addSubview:payWapButton];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(198 ,314, 93, 37);
    cancleButton.backgroundColor = [UIColor greenColor];
    [cancleButton addTarget:self action:@selector(cancleBill) forControlEvents:UIControlEventTouchUpInside];
    [billView addSubview:cancleButton];

    [self.view addSubview:billView];
    [billView release];
}

-(void)goTaobaoClient
{
}

-(void)goTaobaoWap
{
}

-(void)cancleBill
{
    UIView *tmpView = (UIView *)[self.view viewWithTag:200];
    [tmpView removeFromSuperview];
}





@end
