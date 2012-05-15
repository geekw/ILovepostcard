//
//  SecondViewController.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-9.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "SecondViewController.h"
#import "AppDelegate.h"


@implementation SecondViewController

-(void)dealloc
{
    goToPostcardList = nil;[goToPostcardList release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self.navigationController.navigationBarHidden = YES;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.title = NSLocalizedString(@"明信片", @"明信片");
//        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }

    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - goToPostcardScene --进入明信片选择界面

-(IBAction)goToPostcardScene
{
    GoToPostcardList *myGoToPostcardList = [[GoToPostcardList alloc] initWithNibName:@"GoToPostcardList" bundle:nil];
    goToPostcardList = myGoToPostcardList;
    [self presentModalViewController:goToPostcardList animated:YES];
    [myGoToPostcardList release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
