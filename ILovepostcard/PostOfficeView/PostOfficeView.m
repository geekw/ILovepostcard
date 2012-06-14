//
//  PostOfficeView.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-6-11.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#define FD_IMAGE_PATH(file) [NSString stringWithFormat:@"%@/Documents/ScreenShot/%@",NSHomeDirectory(),file]

#define Self_Record @"http://61.155.238.30/postcards/interface/self_record"

#import "PostOfficeView.h"
#import "ViewController.h"
#import "SBJSON.h"


@implementation PostOfficeView
@synthesize goBackBtn;
@synthesize myScrollView;
@synthesize displayView;
@synthesize address;
@synthesize paid;

int page_total;
int current_page;

#pragma mark - GoBack - 返回按钮
-(IBAction)goBack
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FromMainScene"])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        ViewController *viewcontroller = [[ViewController alloc] init];
        viewcontroller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:viewcontroller animated:YES];
        [viewcontroller release];
    }
}

#pragma mark - View lifecycle - 系统函数
- (void)dealloc 
{
    [goBackBtn release];
    [myScrollView release];
    [displayView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        address = [[NSMutableDictionary dictionary] retain];
        paid = [[NSMutableDictionary dictionary] retain];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.goBackBtn setImage:[UIImage imageNamed:@"titlebtnbackclick.png"] forState:UIControlStateHighlighted];
}

- (void)viewDidUnload
{
    [self setGoBackBtn:nil];
    [self setMyScrollView:nil];
    [self setDisplayView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)viewWillAppear:(BOOL)animated
{
    self.myScrollView.frame = CGRectMake(0, 0, 320, 460);
    self.myScrollView.contentSize = CGSizeMake(320, 461);
    
    NSArray *tmpArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"SaveArray"];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FromMainScene"])
    {
        NSInteger i = [[NSUserDefaults standardUserDefaults] integerForKey:@"ScreenShotNumber"]; 
        if (i > 0)//判断有明信片记录
        {
            //得到总页数
            page_total = (i - 1) / 4 + 1;
            current_page = 1;
            
            for (NSInteger y = 0 ; y < i ; y ++)
            {
                UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 115 * y, 320, 115)];
//                tmpView.tag = y + 1;
                
                UIImageView *tmpImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 8 , 150, 100)];
                
                NSString *picSaveStr = [NSString stringWithFormat:@"frontPic%d.png",y];//定义图片文件名
                NSString *str = [NSString stringWithFormat:@"%@",FD_IMAGE_PATH(picSaveStr)];
                tmpImgView.image = [UIImage imageWithContentsOfFile:str];
//                
                tmpImgView.backgroundColor = [UIColor redColor];
                [tmpView addSubview:tmpImgView];
                [tmpImgView release];
                
                UILabel *tmpLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(178, 18, 32, 21)];
                tmpLabel1.text = [NSString stringWithFormat:@"to: "];
                [tmpView addSubview:tmpLabel1];
                [tmpLabel1 release];
                
                UIImageView *tmpImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(178, 51, 17, 17)];
                tmpImg1.image = [UIImage imageNamed:@"paymentView3.png"];
                [tmpView addSubview:tmpImg1];
                [tmpImg1 release];
                
                UILabel *tmpLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(200, 51, 100, 20)];
                tmpLabel2.text = [NSString stringWithFormat:@"已制作"];
                [tmpView addSubview:tmpLabel2];
                [tmpLabel2 release];
                
                UILabel *tmpLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(200, 86, 100, 20)];
                tmpLabel3.text = [NSString stringWithFormat:@"已付款"];
                tmpLabel3.backgroundColor = [UIColor whiteColor];
                [tmpView addSubview:tmpLabel3];
                [tmpLabel3 release];
                
                
                NSDictionary *dict = [tmpArray objectAtIndex:y];
                
                NSString *postcard_sn = [dict objectForKey:@"postcard_sn"];
                
                UIImageView *tmpImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(178, 89, 17, 17)];
                tmpImg2.tag = 2 * y + 2;
                [tmpView addSubview:tmpImg2];
                [self.paid setObject:[NSString stringWithFormat:@"%d",tmpImg2.tag] forKey:postcard_sn];
                
                [tmpImg2 release];
                
                UILabel *tmpLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(200, 19, 100, 20)];
                tmpLabel4.tag = 2 * y + 1;
                [tmpView addSubview:tmpLabel4];
                [self.address setObject:[NSString stringWithFormat:@"%d",tmpLabel4.tag] forKey:postcard_sn];
                [tmpLabel4 release];

                NSLog(@"postcard_sn:%@", postcard_sn);
                
                NSLog(@"paid:%@",  [paid objectForKey:postcard_sn]);
                NSLog(@"adress:%@",[address objectForKey:postcard_sn]);
                
                [self performSelector:@selector(displayEachPostcard:) withObject:dict];
                [self.myScrollView addSubview:tmpView];
                [tmpView release];
            }
        }
    }
}


-(void)displayEachPostcard:(NSDictionary *)dict
{
    NSString *snStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"postcard_sn"]];
    NSString *requsetUrl = [Self_Record stringByAppendingFormat:@"?postcard_sn=%@",snStr];    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requsetUrl]];
    request.delegate = self;
    [request setDidFinishSelector:@selector(getTheDetails:)];
    [request startAsynchronous];
}

-(void)getTheDetails:(ASIHTTPRequest *)request
{
    NSLog(@"%@",[request url]);
    
    NSString *snStr = [[NSString stringWithFormat:@"%@",[request url]] substringWithRange:NSMakeRange([Self_Record length] + 13, 28)];

    NSLog(@"SN:%@", snStr);
    
    NSLog(@"Paid:= %@",[paid objectForKey:snStr]);
    
    NSLog(@"adress = %@",[address objectForKey:snStr]);
    
    //Todo get sn from postbody
    NSDictionary *dict = [request responseString].JSONValue;
//    NSLog(@"dict = %@",dict);
    
    NSString *payStr = [dict objectForKey:@"is_pay"];
    NSString *adressStr = [dict objectForKey:@"card_receiver_address"];
    
    NSLog(@"%@ -- %@",payStr,adressStr);
    
    int x = [[paid objectForKey:snStr] intValue];
    NSLog(@"x = %d",x);
    
    UIImageView *tmpImgView = (UIImageView *)[self.view viewWithTag:x];
    if ([payStr intValue] == 1)
    {
        tmpImgView.image = [UIImage imageNamed:@"paymentView3.png"];
    }
    else
    {
        tmpImgView.image = [UIImage imageNamed:@"paymentView2.png"];
    }

    
    int y = [[address objectForKey:snStr] intValue];
    UILabel *tmplabel = (UILabel *)[self.view viewWithTag:y];
    tmplabel.text = [NSString stringWithFormat:@"%@",adressStr];


}

@end
