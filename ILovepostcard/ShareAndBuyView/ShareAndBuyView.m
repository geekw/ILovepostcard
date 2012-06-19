//
//  ShareAndBuyView.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-25.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "ShareAndBuyView.h"
#import "JSON.h"
#import "ChooseAddressView.h"
#import "ImageProcess.h"
#import "Effects.h"
#import "ResizeImage.h"

#define FD_IMAGE_PATH(file) [NSString stringWithFormat:@"%@/Documents/ScreenShot/%@",NSHomeDirectory(),file]
#define UploadPicUrl @"http://kai7.cn/image/upload"
#define UploadPicUrl @"http://kai7.cn/image/upload"
#define UploadAllUrl @"http://61.155.238.30/postcards/interface/submit_postcard"



#define kHasAuthoredSina @"hasAuthoredSina"

@interface ShareAndBuyView ()

@end

@implementation ShareAndBuyView
@synthesize goBackButton;
@synthesize flipButton;
@synthesize flipButton_Back;
@synthesize shareButton;
@synthesize buyButton;
@synthesize flipView;
@synthesize flipButton2;
@synthesize paymentView;
@synthesize priceArray;
@synthesize resignBtn;
@synthesize sinaWeiBoShareView;
@synthesize shareBtn;
@synthesize shareTextView;
@synthesize sinashare;
@synthesize backShareAndBuyBtn;


#pragma mark - goBack - 返回按钮
-(IBAction)goBack
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle - 系统函数
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
//    NSLog(@"%@",self.priceArray);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.shareButton setImage:[UIImage imageNamed:@"weibopress.png"] forState:UIControlStateHighlighted];
    [self.goBackButton setImage:[UIImage imageNamed:@"titlebtnbackclick.png"] forState:UIControlStateHighlighted];
    flipButton_Back.backgroundColor = [UIColor blueColor];
    
    self.view.frame = CGRectMake(0, 20, 320, 460);
    self.sinaWeiBoShareView.frame = CGRectMake(-320, 0, 320, 460);
    [self.view addSubview:self.sinaWeiBoShareView];
    
    [self.backShareAndBuyBtn setImage:[UIImage imageNamed:@"titlebtnbackclick.png"] forState:UIControlStateHighlighted];
    
    if (!sinashare)
    {
        sinashare = [[SinaShare alloc] init];
    }
    self.sinashare.delegate = self;
    
    NSString *screenShotNumber = [NSString stringWithFormat:@"%d",[[NSUserDefaults standardUserDefaults] integerForKey:@"ScreenShotNumber"]];
    NSString *picSaveStr = [NSString stringWithFormat:@"frontPic%@.png",screenShotNumber];//定义图片文件名
    NSString *frontImagePath = [NSString stringWithFormat:@"%@",FD_IMAGE_PATH(picSaveStr)];
    UIImage *frontImage = [UIImage imageWithContentsOfFile:frontImagePath];
    [self.flipButton setImage:frontImage forState:UIControlStateNormal];
        
    NSString *backImageStr = [NSString stringWithFormat:@"backPic%@.png",screenShotNumber];//定义图片文件名
    NSString *backImagePath = [NSString stringWithFormat:@"%@",FD_IMAGE_PATH(backImageStr)];
    UIImage *backImage = [UIImage imageWithContentsOfFile:backImagePath];
    [self.flipButton_Back setImage:backImage forState:UIControlStateNormal];

    [ImageProcess getPortraitView:self.flipButton];
    [ImageProcess getPortraitView:self.flipButton_Back];

    [ImageProcess rotateView:self.flipButton withDegree:270];
    [ImageProcess rotateView:self.flipButton_Back withDegree:270];
}

- (void)viewDidUnload
{
    [self setSinashare:nil];
    [self setGoBackButton:nil];
    [self setFlipButton:nil];
    [self setShareButton:nil];
    [self setBuyButton:nil];
    [self setFlipButton_Back:nil];
    [self setFlipView:nil];
    [self setFlipButton2:nil];
    [self setResignBtn:nil];
    [self setSinaWeiBoShareView:nil];
    [self setShareBtn:nil];
    [self setShareTextView:nil];
    [self setBackShareAndBuyBtn:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
    sinashare = nil;[sinashare release];
    spinerView = nil;[spinerView release];
//    spiner = nil;[spiner release];
    priceArray = nil;
    paymentView = nil;[paymentView release];
    [goBackButton release];
    [shareButton release];
    [buyButton release];
    [flipButton_Back release];
    [flipView release];
    [flipButton release];
    [flipButton2 release];
    [resignBtn release];
    [sinaWeiBoShareView release];
    [shareBtn release];
    [shareTextView release];
    [backShareAndBuyBtn release];
    [super dealloc];
}
- (IBAction)flip 
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.75];
    
	[UIView setAnimationTransition:([self.flipView superview]?
                                    UIViewAnimationTransitionFlipFromLeft: UIViewAnimationTransitionFlipFromRight)
                           forView:self.flipView cache:YES];
	if ([flipButton superview])
	{
		[self.flipButton removeFromSuperview];
		[self.flipView addSubview:flipButton_Back];
	}
	else
	{
		[self.flipButton_Back removeFromSuperview];
		[self.flipView addSubview:flipButton];
	}
	[UIView commitAnimations];
}

- (IBAction)flip2
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.75];
    
	[UIView setAnimationTransition:([self.flipView superview]?
                                    UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight)
                           forView:self.flipView cache:YES];
	if ([flipButton superview])
	{
		[self.flipButton removeFromSuperview];
		[self.flipView addSubview:flipButton_Back];
	}
	else
	{
		[self.flipButton_Back removeFromSuperview];
		[self.flipView addSubview:flipButton];
	}
	[UIView commitAnimations];
}


#pragma mark - BuyThisCard - 1.购买明信片流程-------------------------
- (IBAction)buyThisCard
{
    [self performSelector:@selector(getAddress)];//判断是否得到了地址
}

- (void)addWaitView//等待界面
{
    spinerView = [[UIView alloc] initWithFrame:CGRectMake(20, 64, 281, 270)];
    spinerView.backgroundColor = [UIColor grayColor];
    spinerView.alpha = 0.7;
    
    UILabel *spinerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 168, 293, 44)];
    spinerLabel.text = [NSString stringWithFormat:@"正在上传明信片,请稍侯..."];
    spinerLabel.textAlignment = UITextAlignmentCenter;
    spinerLabel.backgroundColor = [UIColor clearColor];
    [spinerLabel setFont:[UIFont fontWithName:@"System" size:17]];
    [spinerView addSubview:spinerLabel];
    [spinerLabel release];
    
    TKLoadingAnimationView *spiner = [[TKLoadingAnimationView alloc] initWithFrame:CGRectMake(120, 115, 40, 40)tkLoadingAnimationViewStyle:TKLoadingAnimationViewStyleNormal];
    [spiner startAnimating];
    [spinerView addSubview:spiner];
    [spiner release];
    
    [self.view addSubview:spinerView];
    [spinerView release];
}

#pragma mark - GetAddress - 判断是否得到了地址
-(void)getAddress
{
    NSString *receiverNameStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"RECEIVER_NAME"];
//    NSString *senderNameStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"SENDER_NAME"];
    NSString *receiverAddressStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"DETAILS_ADDRESS_URL"];
    if ([receiverNameStr length] == 0 || [receiverAddressStr length] == 0 )
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"From_Back"];
        ChooseAddressView *chooseAddressView = [[ChooseAddressView alloc] init];
        chooseAddressView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:chooseAddressView animated:YES];
        [chooseAddressView release];
    }
    
    else if ([receiverNameStr length] != 0  && [receiverAddressStr length] != 0)
    {
    [self addWaitView];
    [self performSelector:@selector(uploadFrontPic)];//上传正面图
    }
}

#pragma mark - UploadFrontPic - 上传正面图片
-(void)uploadFrontPic
{
    NSString *screenShotNumber = [NSString stringWithFormat:@"%d",[[NSUserDefaults standardUserDefaults] integerForKey:@"ScreenShotNumber"]];
    NSString *picSaveStr = [NSString stringWithFormat:@"frontPic%@.png",screenShotNumber];//定义图片文件名
    NSString *str = [NSString stringWithFormat:@"%@",FD_IMAGE_PATH(picSaveStr)];
    UIImage *tmpImg = [UIImage imageWithContentsOfFile:str];
    NSData  *data = UIImagePNGRepresentation(tmpImg);
    
    if (data != nil)
    {
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:UploadPicUrl]];
        [request setDelegate:self];
        [request setData: data
            withFileName: picSaveStr
          andContentType: @"image/png"
                  forKey: @"pic"];  
        [request appendPostData:[@"{\"postcard\":\"1\"}" dataUsingEncoding:NSUTF8StringEncoding]];
        [request setDidFinishSelector:@selector(requestUploadFrontImageFinish:)];
        [request setDidFailSelector:@selector(requestUploadFrontImageFail:)];
        [request startAsynchronous];
    }
    else 
    {
        PromptView  *tmpPromptView = [[PromptView alloc] init];
        [tmpPromptView showPromptWithParentView:self.view
                                     withPrompt:@"上传图片失败" 
                                      withFrame:CGRectMake(40, 120, 240, 240)];
        [tmpPromptView release];
        return;
    }    
}

- (void)requestUploadFrontImageFinish:(ASIFormDataRequest *)request
{
    NSString *tmpStr = [NSString stringWithFormat:@"%@",[request responseString]];
    [[NSUserDefaults standardUserDefaults] setObject:tmpStr forKey:@"FRONT_PIC"];
    
    [self performSelector:@selector(uploadBackPic)];//上传背面图
}

- (void)requestUploadFrontImageFail:(ASIFormDataRequest *)request
{
    PromptView *promptView = [[PromptView alloc] init];
    [promptView showPromptWithParentView:self.view
                              withPrompt:@"网络不好,请稍后再试" 
                               withFrame:CGRectMake(40, 120, 240, 240)];
    [promptView release];
    return;
}

#pragma mark - UploadBackPic - 上传背面图片
-(void)uploadBackPic
{    
    NSString *screenShotNumber = [NSString stringWithFormat:@"%d",[[NSUserDefaults standardUserDefaults] integerForKey:@"ScreenShotNumber"]];    
    NSString *picSaveStr = [NSString stringWithFormat:@"backPic%@.png",screenShotNumber];//定义图片文件名
    NSString *str = [NSString stringWithFormat:@"%@",FD_IMAGE_PATH(picSaveStr)];
    UIImage *tmpImg = [UIImage imageWithContentsOfFile:str];
    
    NSData  *data = UIImagePNGRepresentation(tmpImg);
    
    if (data != nil)
    {
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:UploadPicUrl]];
        [request setDelegate:self];
        [request setData: data
            withFileName: picSaveStr
          andContentType: @"image/png"
                  forKey: @"pic"];  
        [request appendPostData:[@"{\"postcard\":\"1\"}" dataUsingEncoding:NSUTF8StringEncoding]];
        [request setDidFinishSelector:@selector(requestUploadImageFinish:)];
        [request setDidFailSelector:@selector(requestUploadImageFail:)];
        [request startAsynchronous];
        
    }
    else 
    {
        PromptView  *tmpPromptView = [[PromptView alloc] init];
        [tmpPromptView showPromptWithParentView:self.view
                                     withPrompt:@"上传图片失败" 
                                      withFrame:CGRectMake(40, 120, 240, 240)];
        [tmpPromptView release];
        return;
    }    
}

- (void)requestUploadImageFinish:(ASIFormDataRequest *)request
{
    NSString *tmpStr = [NSString stringWithFormat:@"%@",[request responseString]];
    [[NSUserDefaults standardUserDefaults] setObject:tmpStr forKey:@"BACK_PIC"];
    [self performSelector:@selector(uploadAll)];//上传所有数据
}

- (void)requestUploadImageFail:(ASIFormDataRequest *)request
{
    PromptView *promptView = [[PromptView alloc] init];
    [promptView showPromptWithParentView:self.view
                              withPrompt:@"网络不好,请稍后再试" 
                               withFrame:CGRectMake(40, 120, 240, 240)];
    [promptView release];
    return;
}

#pragma mark - UploadAll - 上传所有数据
-(void)uploadAll
{
    NSString *cidStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"ClientId"]];
    NSString *tidStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"]];
    NSString *pic_a = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"FRONT_PIC"]];
    NSString *pic_b = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"BACK_PIC"]];
    
    NSString *card_sender = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"SENDER_NAME"]];
    NSString *card_sender_address = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"SENDER_ADDRESS"]];
    NSString *card_sender_postcode = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"SENDER_POSTCODE"]];
    NSString *card_recevier = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"RECEIVER_NAME"]];
    NSString *card_recevier_address = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"DETAILS_ADDRESS_URL"]];
    NSString *card_recevier_postcode = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"RECEIVER_POSTCODE"]];
    NSString *blessings = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"BLESS"]];
    
    NSString *qrcode = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"QRURL"]] retain];
    NSString *audio = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"VOICEURL"]] retain];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:UploadAllUrl]];
    
    [request setDelegate:self];
    [request setPostValue:cidStr forKey:@"cid"];
    [request setPostValue:tidStr forKey:@"tid"];
    [request setPostValue:pic_a  forKey:@"pic_a"];
    [request setPostValue:pic_b  forKey:@"pic_b"];
    [request setPostValue:card_sender forKey:@"card_sender"];
    [request setPostValue:card_sender_address forKey:@"card_sender_address"];
    [request setPostValue:card_sender_postcode forKey:@"card_sender_postcode"];
    [request setPostValue:card_recevier forKey:@"card_receiver"];
    [request setPostValue:card_recevier_address forKey:@"card_receiver_address"];
    [request setPostValue:card_recevier_postcode forKey:@"card_receivier_postcode"];
    [request setPostValue:blessings forKey:@"blessings"];
    [request setPostValue:qrcode forKey:@"qrcode"];
    [request setPostValue:audio  forKey:@"audio"];
    [request setDidFinishSelector:@selector(requestUploadAllFinish:)];
    
    NSLog(@"cid:%@ tid:%@ a:%@ b:%@ qrcode:%@ audio:%@ :%@---%@---%@---%@---%@---%@---%@", cidStr, tidStr, pic_a, pic_b, qrcode, audio,card_sender,card_sender_address,card_sender_postcode,card_recevier,card_recevier_address,card_recevier_postcode,blessings);
    
    [request setDidFailSelector:@selector(requestUploadDataFail:)];
    [request startAsynchronous];
}

- (void)requestUploadDataFail:(ASIFormDataRequest *)request
{
    PromptView *promptView = [[PromptView alloc] init];
    [promptView showPromptWithParentView:self.view
                              withPrompt:@"网络不好,请稍后再试" 
                               withFrame:CGRectMake(40, 120, 240, 240)];
    [promptView release];
    return;
}

-(void)requestUploadAllFinish:(ASIFormDataRequest *)request
{    
    if ([request responseStatusCode] == 200) 
    {
        NSArray *tmpPriceArray = [request responseString].JSONValue;
    
        NSLog(@"array = %@",tmpPriceArray);

        if (!paymentView)
        {
            paymentView = [[PaymentView alloc] init];
        }
        
        if (self.paymentView.priceArray == nil)
        {
            self.paymentView.priceArray = [[NSMutableArray alloc] initWithArray:tmpPriceArray];
        }
        else
        {
            [self.paymentView.priceArray removeAllObjects];
            self.paymentView.priceArray = [[NSMutableArray alloc] initWithArray:tmpPriceArray];
        }
        
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"VOICEURL"];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"QRURL"];//上传成功后,清空声音和二维码的地址!
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"RECEIVER_NAME"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"DETAILS_ADDRESS_URL"];

        [self performSelector:@selector(payThisPostcard)];
    }
}

-(void)payThisPostcard
{
    [spinerView removeFromSuperview];
    
    if (!paymentView)
     {
       paymentView = [[PaymentView alloc] init];
     }
    self.paymentView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:paymentView animated:YES];
}

#pragma mark - ShareToSIna - 2.分享明信片流程----------------------


- (IBAction)goToShareView//判断是否登陆
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kHasAuthoredSina] == NO) 
    {
        if (!sinashare)
        {
            sinashare = [[SinaShare alloc] init];
        }
        self.sinashare.delegate = self;
        [self.sinashare logInSinaWB];
    }
    else
    {    
        self.sinaWeiBoShareView.frame = CGRectMake(0, 0, 320, 460);
        [self.view addSubview:self.sinaWeiBoShareView];
    }
    
}

- (IBAction)shareToSina//分享
{
    NSString *screenShotNumber = [NSString stringWithFormat:@"%d",[[NSUserDefaults standardUserDefaults] integerForKey:@"ScreenShotNumber"]];
    NSString *picSaveStr = [NSString stringWithFormat:@"frontPic%@.png",screenShotNumber];//定义图片文件名
    NSString *str = [NSString stringWithFormat:@"%@",FD_IMAGE_PATH(picSaveStr)];
    UIImage *tmpImg = [UIImage imageWithContentsOfFile:str];
    
    NSString *textStr = [NSString stringWithFormat:@"%@",self.shareTextView.text];
    
    NSLog(@"%@,%@",textStr,tmpImg);
    if (!sinashare)
    {
        sinashare = [[SinaShare alloc] init];
    }
    [self.sinashare sendContentWith:textStr withImg:tmpImg];
}


- (IBAction)resignKeyboard
{
    [self.shareTextView resignFirstResponder];//跳回键盘
}

-(void)sinaLoginFinished//登陆完毕,跳到购买界面
{
    [self.view addSubview:self.sinaWeiBoShareView];
}

-(void)sinaLoginFailed//登陆失败
{
    PromptView *tmpPromptView = [[PromptView alloc] init];
    [tmpPromptView showPromptWithParentView:self.view 
                                 withPrompt:@"登录失败"
                                  withFrame:CGRectMake(40, 120, 240, 240)];
    [tmpPromptView release];
    
}
-(void)sinaSendFinished//发送完毕
{
    [self performSelector:@selector(backShareAndBuyView)];//发送完毕回到主界面
}

-(void)sinaSendFailed//发送失败
{
    PromptView *tmpPromptView = [[PromptView alloc] init];
    [tmpPromptView showPromptWithParentView:self.view 
                                 withPrompt:@"发送失败"
                                  withFrame:CGRectMake(40, 120, 240, 240)];
    [tmpPromptView release];

}

- (IBAction)backShareAndBuyView//返回分享,购买界面
{
    [self.sinaWeiBoShareView removeFromSuperview];
}


@end
