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
@synthesize paymentView;


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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setGoBackButton:nil];
    [self setFlipButton:nil];
    [self setShareButton:nil];
    [self setBuyButton:nil];
    [self setFlipButton_Back:nil];
    [self setFlipView:nil];
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
    paymentView = nil;[paymentView release];
    [goBackButton release];
    [flipButton release];
    [shareButton release];
    [buyButton release];
    [flipButton_Back release];
    [flipView release];
    [super dealloc];
}
- (IBAction)flip 
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.75];
    
	[UIView setAnimationTransition:([self.flipView superview] ?
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
    self.paymentView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:paymentView animated:YES];
}
@end
