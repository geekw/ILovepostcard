//
//  PaymentView.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-27.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#define Partner @"2088701817081672"
#define Seller  @"2088701817081672"


#import "PaymentView.h"
#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "AlixPay.h"
#import "DataSigner.h"

@interface PaymentView ()

@end

@implementation PaymentView
@synthesize preViewImgView;
@synthesize priceLabel;
@synthesize openPayViewBtn;
@synthesize goBackButton;
@synthesize snailMailButton;
@synthesize registeredLetterButton;
@synthesize expressDeliveryButton;

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
    [preViewImgView release];
    [priceLabel release];
    [openPayViewBtn release];
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



-(void)generateData
{
    NSArray *subjectsArray = [[NSArray alloc] initWithObjects:@"平邮",
                              @"挂号信",
                              @"快递", nil];
    NSArray *bodyArray = [[NSArray alloc] initWithObjects:@"不限期",
                          @"三天",
                          @"三天", nil];
    NSArray *priceArray = [[NSArray alloc] initWithObjects:@"0.01f",
                           @"0.01f",
                           @"0.01f", nil];
    if (!myProduct)
    {
        myProduct = [[NSMutableArray alloc] init];
    }
    else 
    {
        [myProduct removeAllObjects];
    }
    for (int i = 0; i < [subjectsArray count]; i++)
    {
        Product *product = [[Product alloc] init];
        product.subject = [subjectsArray objectAtIndex:i];
        product.body  = [bodyArray objectAtIndex:i];
        product.price = [[priceArray objectAtIndex:i] floatValue];
        
        [myProduct addObject:product];
        [product release];
    }
    
    [subjectsArray release], subjectsArray = nil;
	[bodyArray release], bodyArray = nil;
    
}


 //随机生成27位订单号,外部商户根据自己情况生成订单号
//- (NSString *)generateTradeNO
//{
//	const int N = 27;
//	
//	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//	NSMutableString *result = [[[NSMutableString alloc] init] autorelease];
//	srand(time(0));
//	for (int i = 0; i < N; i++)
//	{   
//		unsigned index = rand() % [sourceString length];
//		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
//		[result appendString:s];
//	}
//	return result;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [snailMailButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
    [registeredLetterButton setBackgroundImage:[UIImage imageNamed:@"paymentView3.png"] forState:UIControlStateNormal];
    [expressDeliveryButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"MailType"];//默认是挂号信
    self.priceLabel.text = [NSString stringWithFormat:@"4.99元"];
}

//- (void)viewDidUnload
//{
//    [self setPreViewImgView:nil];
//    [self setPriceLabel:nil];
//    [self setGoBackButton:nil];
//    [self setSnailMailButton:nil];
//    [self setRegisteredLetterButton:nil];
//    [self setExpressDeliveryButton:nil];
//    [self setOpenPayViewBtn:nil];
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
#pragma mark - SelectMailType - 选择快递类型
- (IBAction)snailMail
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"MailType"];
    [snailMailButton setBackgroundImage:[UIImage imageNamed:@"paymentView3.png"] forState:UIControlStateNormal];
    [registeredLetterButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
    [expressDeliveryButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
    self.priceLabel.text = [NSString stringWithFormat:@"3.99元"];
}

- (IBAction)registeredLetter
{
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"MailType"];
    [snailMailButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
    [registeredLetterButton setBackgroundImage:[UIImage imageNamed:@"paymentView3.png"] forState:UIControlStateNormal];
    [expressDeliveryButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
    self.priceLabel.text = [NSString stringWithFormat:@"4.99元"];
}

- (IBAction)expressDelivery 
{
    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"MailType"];
    [snailMailButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
    [registeredLetterButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
    [expressDeliveryButton setBackgroundImage:[UIImage imageNamed:@"paymentView3.png"] forState:UIControlStateNormal];
    self.priceLabel.text = [NSString stringWithFormat:@"5.99元"];
}


#pragma mark - OpenPayView - 加载支付界面
- (IBAction)openPayView 
{
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    tmpView.backgroundColor = [UIColor clearColor];
    UIImageView *tmpImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    tmpImgView.backgroundColor = [UIColor grayColor];
    tmpImgView.alpha = 0.6;
    [tmpView addSubview:tmpImgView];
    [tmpImgView release];
    
    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(20, 73, 281, 270)];
    UIImageView *payImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 281, 270)];
    
    UIButton *clientBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clientBtn.frame = CGRectMake(58, 109, 213, 37);
    [clientBtn addTarget:self action:@selector(clientPay) forControlEvents:UIControlStateNormal];
    [payView addSubview:clientBtn];
    
    UIButton *wapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wapBtn.frame = CGRectMake(58, 160, 213, 37);
    [wapBtn addTarget:self action:@selector(wapPay) forControlEvents:UIControlStateNormal];
    [payView addSubview:wapBtn];
    
    [payView addSubview:payImgView];
    [tmpView addSubview:payView];
    [payImgView release];
    [payView release];
    
}


#pragma mark - ClientPay - 客户端支付
- (void)clientPay
{
    int i = [[NSUserDefaults standardUserDefaults] integerForKey:@"MailType"]; 
    NSLog(@"i = %d",i);
    
    Product *product = [myProduct objectAtIndex:i];
    
    //将商品信息赋予AlixPayOrder的成员变量
	AlixPayOrder *order = [[AlixPayOrder alloc] init];
	order.partner = Partner;
	order.seller  = Seller;
	order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
	order.productName = product.subject; //商品标题
	order.productDescription = product.body; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
	order.notifyURL =  @"http://192.168.0.119:8080/appbacktest/RSANotifyReceiver"; //回调URL
	
	//应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于安全支付成功后重新唤起商户应用
	NSString *appScheme = @"ILovepostcard"; 
	
	//将商品信息拼接成字符串
	NSString *orderSpec = [order description];
	NSLog(@"orderSpec = %@",orderSpec);
	
	//获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
	id <DataSigner> signer = CreateRSADataSigner([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA private key"]);
	NSString *signedString = [signer signString:orderSpec];
	
	//将签名成功字符串格式化为订单字符串,请严格按照该格式
	NSString *orderString = nil;
	if (signedString != nil) 
    {
		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
	}
    NSLog(@"orderString = %@",orderString);
    
    //获取安全支付单例并调用安全支付接口
    AlixPay * alixpay = [AlixPay shared];
    int ret = [alixpay pay:orderString applicationScheme:appScheme];
    
    if (ret == kSPErrorAlipayClientNotInstalled)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" 
                                                             message:@"您还没有安装支付宝的客户端，请先装。" 
                                                            delegate:self 
                                                   cancelButtonTitle:@"确定" 
                                                   otherButtonTitles:nil];
        [alertView setTag:123];
        [alertView show];
        [alertView release];
    }
    else if (ret == kSPErrorSignError) 
    {
        NSLog(@"签名错误！");
    }
    
}

#pragma mark - WapPay - 网页支付
- (void)wapPay 
{
    int i = [[NSUserDefaults standardUserDefaults] integerForKey:@"MailType"]; 
    NSLog(@"i = %d",i);
    
    Product *product = [myProduct objectAtIndex:i];
	//如果partner和seller数据存于其他位置,请改写下面两行代码
	NSString *partner = Partner;
    NSString *seller  = Seller;
	
	//partner和seller获取失败,提示
	if ([partner length] == 0 || [seller length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
														message:@"缺少partner或者seller。" 
													   delegate:self 
											  cancelButtonTitle:@"确定" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
    
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
	order.partner = partner;
	order.seller = seller;
	order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
	order.productName = product.subject; //商品标题
	order.productDescription = product.body; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
	order.notifyURL =  @"http://192.168.0.119:8080/appbacktest/RSANotifyReceiver"; //回调URL
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于安全支付成功后重新唤起商户应用
	NSString *appScheme = @"ILovepostcard"; 
	
	//将商品信息拼接成字符串
	NSString *orderSpec = [order description];
	NSLog(@"orderSpec = %@",orderSpec);
	
	//获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
	id <DataSigner> signer = CreateRSADataSigner([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA private key"]);
	NSString *signedString = [signer signString:orderSpec];
	
	//将签名成功字符串格式化为订单字符串,请严格按照该格式
	NSString *orderString = nil;
	if (signedString != nil) 
    {
		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
	}
    NSLog(@"orderString = %@",orderString);
    
    
    NSString *stringURL = [NSString stringWithFormat:@"http://61.155.238.30:31801/pay/index.php?subject=%@&out_trade_no=%@&total_fee=%@",order.productName,order.tradeNO,order.amount];
    NSLog(@"%@",stringURL);
    
    NSURL *url = [NSURL URLWithString:[stringURL stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    NSLog(@"%@",url);
    
    [[UIApplication sharedApplication] openURL:url];
    
}


-(void)cancleBill
{
    UIView *tmpView = (UIView *)[self.view viewWithTag:200];
    [tmpView removeFromSuperview];
}
 */

@end
