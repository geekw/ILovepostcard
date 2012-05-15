//
//  DisplayEachTemplateDetals.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-12.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "DisplayEachTemplateDetals.h"

#define template @"http://61.155.238.30:port/postcards/interface/get_template"//单个模板详情接口


@implementation DisplayEachTemplateDetals
@synthesize idName;


#pragma mark - goBack - 返回按钮
-(IBAction)goback
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle - 系统函数
-(void)dealloc
{
    idName = nil;[idName release];
    backButton = nil;[backButton release];
    displayEachTemplateDetals_Back = nil;[displayEachTemplateDetals_Back release];
    goDisplayEachTemplateDetals_BackButton = nil;[goDisplayEachTemplateDetals_BackButton release];
    [super dealloc];
}

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
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                        duration:(NSTimeInterval)duration
{
    
}

#pragma mark - goDisplayEachTemplateDetals - 去编辑明信片反面
-(IBAction)goDisplayEachTemplateDetals
{
    DisplayEachTemplateDetals_Back *tmpDisplayEachTemplateDetals_Back = [[DisplayEachTemplateDetals_Back alloc] initWithNibName:@"DisplayEachTemplateDetals-Back" bundle:nil];
    tmpDisplayEachTemplateDetals_Back.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    displayEachTemplateDetals_Back = tmpDisplayEachTemplateDetals_Back;
    [self presentModalViewController:displayEachTemplateDetals_Back 
                            animated:YES];
    [tmpDisplayEachTemplateDetals_Back release];
}


@end
