//
//  ShareAndBuyView.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-25.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "ShareAndBuyView.h"


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
    
}

- (void)viewDidUnload
{
    [self setGoBackButton:nil];
    [self setFlipButton:nil];
    [self setShareButton:nil];
    [self setBuyButton:nil];
    [self setFlipButton_Back:nil];
    [self setFlipView:nil];
    [self setFlipButton2:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
    priceArray = nil;
    paymentView = nil;[paymentView release];
    [goBackButton release];
    [shareButton release];
    [buyButton release];
    [flipButton_Back release];
    [flipView release];
    [flipButton release];
    [flipButton2 release];
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

- (IBAction)shareToSIna
{
    
}

- (IBAction)buyThisCard
{
    if (!paymentView)
    {
        paymentView = [[PaymentView alloc] init];
    }
    
    if (self.paymentView.priceArray == nil)
    {
        self.paymentView.priceArray = [[NSMutableArray alloc] initWithArray:self.priceArray];
    }
    else
    {
        [self.paymentView.priceArray removeAllObjects];
        self.paymentView.priceArray = [[NSMutableArray alloc] initWithArray:self.priceArray];
    }
    
    self.paymentView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:paymentView animated:YES];
}
@end
