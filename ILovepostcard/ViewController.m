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
    [super dealloc];
}

#pragma mark - goToPostcardScene --进入明信片选择界面

-(IBAction)goToPostcardList
{
    GoToPostcardList *myGoToPostcardList = [[GoToPostcardList alloc] initWithNibName:@"GoToPostcardList" bundle:nil];
    goToPostcardList = myGoToPostcardList;
    [self presentModalViewController:goToPostcardList animated:YES];
    [myGoToPostcardList release];
}

@end
