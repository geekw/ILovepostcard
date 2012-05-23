//
//  ViewController.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-21.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize goToPostcardListButton;
@synthesize goToActivityListButton;

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
    
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setGoToPostcardListButton:nil];
    [self setGoToActivityListButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
    [goToPostcardListButton release];
    [goToActivityListButton release];
    [super dealloc];
}

#pragma mark - GoToPostcardScene --进入明信片模板界面
-(IBAction)goToPostcardList
{
    GoToPostcardList *myGoToPostcardList = [[GoToPostcardList alloc] initWithNibName:@"GoToPostcardList" bundle:nil];
    goToPostcardList = myGoToPostcardList;
    [self presentModalViewController:goToPostcardList animated:YES];
    [myGoToPostcardList release];
}


#pragma mark - GoToActivity_list --进入全部活动界面
- (IBAction)goToActivityList 
{
    ActivityListView *myActivityListView = [[ActivityListView alloc] initWithNibName:@"ActivityListView" bundle:nil];
    activityListView = myActivityListView;
    [self presentModalViewController:activityListView animated:YES];
    [myActivityListView release];
}

@end
