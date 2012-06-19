//
//  PaymentView.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-27.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#define UploadPostcardPrice @"http://www.52mxp.com/interface/submit_price"

#define PurchaseFromClient @"http://www.52mxp.com/interface/submit_alipay"


#define Partner @"2088701817081672"
#define Seller  @"2088701817081672"

#import "PaymentView.h"
#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "AlixPay.h"
#import "DataSigner.h"
#import "Product.h"
#import "PromptView.h"
#import "SBJSON.h"
#import "ViewController.h"

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
@synthesize tempPayView;
@synthesize postOfficeView;
@synthesize priceArray;
@synthesize snailMailLabel;
@synthesize registeredMailLabel;
@synthesize expressLabel;

#pragma mark - GoBack - 返回按钮
- (IBAction)goBack 
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle - 系统函数
- (void)dealloc 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];//注销观察者
    priceArray = nil;[priceArray release];
    postOfficeView = nil;[postOfficeView release];
    tempPayView = nil;[tempPayView release];
    [goBackButton release];
    [snailMailButton release];
    [registeredLetterButton release];
    [expressDeliveryButton release];
    [preViewImgView release];
    [priceLabel release];
    [openPayViewBtn release];
    [snailMailLabel release];
    [registeredMailLabel release];
    [expressLabel release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        goBackButton.hidden = YES;
    }
    return self;
}

-(void)generateData:(NSMutableArray *)tmpArray
{
    self.expressDeliveryButton.hidden = YES;
    self.expressLabel.hidden = YES;
    
    NSMutableArray *tmpID    = [[NSMutableArray alloc] initWithCapacity:[tmpArray count]];
    NSMutableArray *tmpPrice = [[NSMutableArray alloc] initWithCapacity:[tmpArray count]];
    NSMutableArray *tmpway   = [[NSMutableArray alloc] initWithCapacity:[tmpArray count]];
//    
    for (int i = 0; i < [tmpArray count]; i ++)
    {
        NSDictionary *tmpDict = [tmpArray objectAtIndex:i];
        NSString *IDStr = [tmpDict objectForKey:@"id"];
        NSString *priceStr = [tmpDict objectForKey:@"price"];
        NSString *wayStr = [tmpDict objectForKey:@"way"];
        
        [tmpway addObject:IDStr];
        [tmpPrice addObject:@"0.01"];
//        [tmpPrice addObject:priceStr];
        [tmpID  addObject:wayStr];
        
        if ([IDStr intValue] == 1)//平邮
        {
            self.snailMailLabel.text = [NSString stringWithFormat:@"%@",wayStr];
        }
        
        if ([IDStr intValue] == 2)//挂号信
        {
            self.registeredMailLabel.text = [NSString stringWithFormat:@"%@",wayStr];
        }
        
        if ([IDStr intValue] == 3)//快递
        {
            self.expressDeliveryButton.hidden = NO;
            self.expressLabel.hidden = NO;
            self.expressLabel.text = [NSString stringWithFormat:@"%@",wayStr];
        }
    }
    
    NSArray *subjectsArray = [[NSArray alloc] initWithArray:tmpID];
    NSArray *bodyArray  = [[NSArray alloc] initWithArray:tmpway];
    NSArray *mypriceArray = [[NSArray alloc] initWithArray:tmpPrice];
    NSLog(@"%@ : %@ : %@",subjectsArray,bodyArray,mypriceArray);
    
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
        product.price = [[mypriceArray objectAtIndex:i] floatValue];
        
        [myProduct addObject:product];
        [product release];
    }
    
    [subjectsArray release], subjectsArray = nil;
	[bodyArray release], bodyArray = nil;
    [mypriceArray release];mypriceArray = nil;

}


//随机生成15位订单号,外部商户根据自己情况生成订单号
- (NSString *)generateTradeNO
{
	const int N = 15 ;
	
	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *result = [[[NSMutableString alloc] init] autorelease];
	srand(time(0));
	for (int i = 0; i < N; i++)
	{   
		unsigned index = rand() % [sourceString length];
		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
		[result appendString:s];
	}
	return result;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self performSelector:@selector(generateData:) withObject:self.priceArray];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [snailMailButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
    [registeredLetterButton setBackgroundImage:[UIImage imageNamed:@"paymentView3.png"] forState:UIControlStateNormal];
    [expressDeliveryButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
    [self performSelector:@selector(registeredLetter)];    

    NSDictionary *tmpDict = [self.priceArray objectAtIndex:0];
    NSString *postcardStr = [tmpDict objectForKey:@"postcard_sn"];
    [[NSUserDefaults standardUserDefaults] setObject:postcardStr forKey:@"postcard_sn"];
}


- (void)viewDidUnload
{
    [self setPreViewImgView:nil];
    [self setPriceLabel:nil];
    [self setGoBackButton:nil];
    [self setSnailMailButton:nil];
    [self setRegisteredLetterButton:nil];
    [self setExpressDeliveryButton:nil];
    [self setOpenPayViewBtn:nil];
    [self setSnailMailLabel:nil];
    [self setRegisteredMailLabel:nil];
    [self setExpressLabel:nil];
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
    [[NSUserDefaults standardUserDefaults] setInteger:0 
                                               forKey:@"MailType"];
    [snailMailButton setBackgroundImage:[UIImage imageNamed:@"paymentView3.png"] forState:UIControlStateNormal];
    [registeredLetterButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
    [expressDeliveryButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
    
    NSDictionary *tmpDict = [self.priceArray objectAtIndex:0];
    NSString *priceStr = [tmpDict objectForKey:@"price"];
    self.priceLabel.text = [NSString stringWithFormat:@"%@元",priceStr];
}

- (IBAction)registeredLetter
{
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"MailType"];
    [snailMailButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
    [registeredLetterButton setBackgroundImage:[UIImage imageNamed:@"paymentView3.png"] forState:UIControlStateNormal];
    [expressDeliveryButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
    NSDictionary *tmpDict = [self.priceArray objectAtIndex:1];
    NSString *priceStr = [tmpDict objectForKey:@"price"];
    self.priceLabel.text = [NSString stringWithFormat:@"%@元",priceStr];
}

- (IBAction)expressDelivery 
{
    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"MailType"];
    [snailMailButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
    [registeredLetterButton setBackgroundImage:[UIImage imageNamed:@"paymentView2.png"] forState:UIControlStateNormal];
    [expressDeliveryButton setBackgroundImage:[UIImage imageNamed:@"paymentView3.png"] forState:UIControlStateNormal];
    NSDictionary *tmpDict = [self.priceArray objectAtIndex:2];
    NSString *priceStr = [tmpDict objectForKey:@"price"];
    self.priceLabel.text = [NSString stringWithFormat:@"%@元",priceStr];
}

#pragma mark - OpenPayView - 加载支付界面
- (IBAction)openPayView 
{
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    tmpView.tag = 998;
    tmpView.backgroundColor = [UIColor clearColor];
    
    UIImageView *tmpImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    tmpImgView.backgroundColor = [UIColor grayColor];
    tmpImgView.alpha = 0.6;
    [tmpView addSubview:tmpImgView];
    [tmpImgView release];
    
    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(20, 73, 281, 270)];
    payView.tag = 999;

    UIImageView *payImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 281, 270)];
    payImgView.image = [UIImage imageNamed:@"payPic.jpg"];
    [payView addSubview:payImgView];
    
    UIButton *clientBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clientBtn.frame = CGRectMake(58, 109, 213, 37);
    [clientBtn addTarget:self action:@selector(clientPay) forControlEvents:UIControlEventTouchUpInside];
    [payView addSubview:clientBtn];
    
    UIButton *wapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wapBtn.frame = CGRectMake(58, 160, 213, 37);
    [wapBtn addTarget:self action:@selector(wapPay) forControlEvents:UIControlEventTouchUpInside];
    [payView addSubview:wapBtn];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(179, 221, 92, 37);
    [cancleBtn addTarget:self action:@selector(cancelBill) forControlEvents:UIControlEventTouchUpInside];
    [payView addSubview:cancleBtn];
    
    [tmpView addSubview:payView];
    [payImgView release];
    [payView release];
    
    [self.view addSubview:tmpView];
    [tmpView release];
    
    [self performSelector:@selector(uploadPrice)];
}

-(void)uploadPrice
{
    NSString *snStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"postcard_sn"];
    NSString *alipay_feeStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"alipay_fee"];
    NSString *pay_wayStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"pay_way"];
    
//    NSLog(@"%@--%@--%@",snStr,alipay_feeStr,pay_wayStr);
    
    NSString *loadString = [UploadPostcardPrice stringByAppendingFormat:@"?postcard_sn=%@&alipay_fee=%@&pay_way=%@",snStr,alipay_feeStr,pay_wayStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:loadString]];
    request.delegate = self;
    [request setDidFinishSelector:@selector(submit_priceFinished:)];
    [request setDidFailSelector:@selector(submit_priceFailed:)];
    [request startAsynchronous];
}

-(void)submit_priceFinished:(ASIHTTPRequest *)request
{
    if ([request responseStatusCode] == 200)
    {
        NSLog(@"success!");
    }
}

-(void)submit_priceFailed:(ASIHTTPRequest *)request
{
    PromptView *myPromptView = [[PromptView alloc] init];
    [myPromptView showPromptWithParentView:self.view
                                withPrompt:@"网络连接失败,请重试"
                                 withFrame:CGRectMake(40, 120, 240, 240)];
    [myPromptView  release];
    NSError *error = [request error];
    NSLog(@"error:%@", error);
}


#pragma mark - ClientPay - 客户端支付
- (void)clientPay
{   
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(fromZhiFuBaoClient) 
                                                 name:@"fromZhiFuBaoClient" 
                                               object:nil];
    
    int i = [[NSUserDefaults standardUserDefaults] integerForKey:@"MailType"]; 
    NSLog(@"i = %d",i);
        
    Product *product = [myProduct objectAtIndex:i];
    
    //将商品信息赋予AlixPayOrder的成员变量
	AlixPayOrder *order = [[AlixPayOrder alloc] init];
	order.partner = Partner;
	order.seller  = Seller;
	order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制)
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
        return;
    }
    else if (ret == kSPErrorSignError) 
    {
        NSLog(@"签名错误！");
        return;
    }
    
    [self performSelector:@selector(finishPay)];
    
    [[NSUserDefaults standardUserDefaults] setObject:product.body forKey:@"pay_way"];//交易方式id号
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.2f",product.price] forKey:@"alipay_fee"];//交易费用
    [[NSUserDefaults standardUserDefaults] setObject:order.tradeNO forKey:@"ZhiFuBaoSn"];
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
    NSLog(@"%@",order.tradeNO);
	order.productName = product.subject; //商品标题
	order.productDescription = product.body; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
//	order.notifyURL =  @"http://192.168.0.119:8080/appbacktest/RSANotifyReceiver"; //回调URL
    
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
    
    [self performSelector:@selector(finishPay)];

    [[NSUserDefaults standardUserDefaults] setObject:product.body forKey:@"pay_way"];//交易方式id号
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.2f",product.price] forKey:@"alipay_fee"];//交易费用
    [[NSUserDefaults standardUserDefaults] setObject:order.tradeNO forKey:@"ZhiFuBaoSn"];
}

- (void)cancelBill
{
    UIView *tmpView = (UIView *)[self.view viewWithTag:998];
    [tmpView removeFromSuperview];
}

-(void) finishPay
{  
    UIView *tmpView = (UIView *)[self.view viewWithTag:999];
    [tmpView removeFromSuperview];

    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(20, 73, 281, 270)];
    payView.tag = 999;

    UIImageView *payImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 281, 270)];
    payImgView.image = [UIImage imageNamed:@"hintBar.png"];

    UIButton *clientBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clientBtn.frame = CGRectMake(23, 113, 235, 43);
    clientBtn.tag = 79;
    [clientBtn addTarget:self action:@selector(goToPostOfficeView) forControlEvents:UIControlEventTouchUpInside];
    [clientBtn setBackgroundImage:[UIImage imageNamed:@"btn-biggreen.png"] forState:UIControlStateNormal];
    [clientBtn setBackgroundImage:[UIImage imageNamed:@"btn-biggreenclick.png"] forState:UIControlStateHighlighted];
    [clientBtn setTitle:@"快去查看你的明信片吧!" forState:UIControlStateNormal];
    [clientBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tmpView addSubview:clientBtn];

    [payView addSubview:payImgView];
    [payView addSubview:clientBtn];
    [payImgView release];

    UIView *mainView =(UIView *)[self.view viewWithTag:998];
    [mainView addSubview:payView];
    [payView release];
}

#pragma mark - GoToPostOfficeView - 付款完成,准备进入下一界面
- (void)goToPostOfficeView
{
    [self performSelector:@selector(saveCompletePostcard)];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FromMainScene"];

    PostOfficeView *_postOfficeView = [[PostOfficeView alloc] init];
    _postOfficeView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:_postOfficeView animated:YES];
    [_postOfficeView release];
}

-(void)saveCompletePostcard
{
    NSInteger i = [[NSUserDefaults standardUserDefaults] integerForKey:@"ScreenShotNumber"];
    NSMutableDictionary *tmpDict = [[NSMutableDictionary dictionary] retain];

    NSString *cidStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"ClientId"];
    NSString *postcard_snStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"postcard_sn"];
    NSString *zhifubaoSnStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZhiFuBaoSn"];
    NSString *productNameStr = [NSString stringWithFormat:@"明信片"];
    NSString *alipay_feeStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"alipay_fee"];
    
//    NSLog(@"%@--%@--%@--%@--%@",cidStr,postcard_snStr,zhifubaoSnStr,productNameStr,alipay_feeStr);

    [tmpDict setObject:cidStr forKey:@"cid"];
    [tmpDict setObject:postcard_snStr forKey:@"postcard_sn"];
    [tmpDict setObject:zhifubaoSnStr forKey:@"tradeno"];
    [tmpDict setObject:productNameStr forKey:@"productname"];
    [tmpDict setObject:alipay_feeStr forKey:@"alipay_fee"];

    NSArray *arrary = [[NSUserDefaults standardUserDefaults] objectForKey:@"SaveArray"];
    NSMutableArray *saveArray = [NSMutableArray arrayWithArray:arrary];//!!!!!!!!!!!!!!
    
    [saveArray addObject:tmpDict];
    
    [[NSUserDefaults standardUserDefaults] setObject:saveArray forKey:@"SaveArray"];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveArray"]);
    [tmpDict release];
    i ++;
    
    [[NSUserDefaults standardUserDefaults] setInteger:i forKey:@"ScreenShotNumber"];
    NSLog(@"%d",[[NSUserDefaults standardUserDefaults] integerForKey:@"ScreenShotNumber"]);
}

#pragma mark - FromZhiFuBaoClient - 支付宝客户端成功支付
-(void)fromZhiFuBaoClient
{
    [self performSelector:@selector(updateClientPurchaseStatus)];
    UIButton *tmpBtn = (UIButton *)[self.view viewWithTag:79];
    tmpBtn.userInteractionEnabled = NO;
}

-(void)updateClientPurchaseStatus
{
  NSString *cidStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"ClientId"];
  NSString *postcard_snStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"postcard_sn"];
  NSString *zhifubaoSnStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZhiFuBaoSn"];
  NSString *productNameStr = [NSString stringWithFormat:@"明信片"];
  NSString *alipay_feeStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"alipay_fee"];
    
  ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:PurchaseFromClient]];
  [request setDelegate:self];
  [request setPostValue:cidStr forKey:@"cid"];
  [request setPostValue:postcard_snStr forKey:@"postcard_sn"];
  [request setPostValue:zhifubaoSnStr  forKey:@"tradeno"];
  [request setPostValue:productNameStr forKey:@"productname"];
  [request setPostValue:alipay_feeStr  forKey:@"alipay_fee"];
  [request setDidFinishSelector:@selector(requestUploadFinish:)]; 
  [request setDidFailSelector:@selector(requestUploadFailed:)];
  [request startAsynchronous];
}

-(void)requestUploadFinish:(ASIFormDataRequest *)requset
{
    NSLog(@"%@",[requset responseString]);
    UIButton *tmpBtn = (UIButton *)[self.view viewWithTag:79];
    tmpBtn.userInteractionEnabled = YES;
}

-(void)requestUploadFailed:(ASIFormDataRequest *)requset
{
    PromptView *myPromptView = [[PromptView alloc] init];
    [myPromptView showPromptWithParentView:self.view
                                withPrompt:@"网络连接失败,请重试"
                                 withFrame:CGRectMake(40, 120, 240, 240)];
    [myPromptView  release];
    NSError *error = [requset error];
    NSLog(@"error:%@", error);
}

@end
