//
//  AboutUsViewController.m
//  ILovepostcard
//
//  Created by 振东 何 on 12-6-18.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController
@synthesize backBtn;

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
    
    [self.backBtn setImage:[UIImage imageNamed:@"titlebtnbackclick.png"] forState:UIControlStateHighlighted];

}

- (void)viewDidUnload
{
    [self setBackBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [backBtn release];
    [super dealloc];
}

- (IBAction)backParentView {
    [self dismissModalViewControllerAnimated:YES];
}
@end
