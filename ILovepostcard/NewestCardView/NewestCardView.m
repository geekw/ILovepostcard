//
//  NewestCardView.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-6-10.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#define NewestCardUrl @"http://61.155.238.30/postcards/interface/finished_items"

#import "NewestCardView.h"
#import "JSON.h"
#import "PromptView.h"
#import "NewestCardViewCellView.h"
#import "DisplayEachTemplateDetals.h"

@implementation NewestCardView
@synthesize table;
@synthesize totalLabel;
@synthesize goBackBtn;
@synthesize tableArray,total_pageStr;

static int currentPage;

int addPageNumber;
#pragma mark - GoBack - 返回按钮
-(IBAction)goBack
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle - 系统函数
- (void)dealloc 
{
    total_pageStr = nil;
    [goBackBtn release];
    [table release];
    [totalLabel release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
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

-(void)viewWillAppear:(BOOL)animated
{
    [self performSelector:@selector(displayNewestCard)];
}

-(void)displayNewestCard
{
    NSLog(@"%d",currentPage);
    NSString *requsetUrl = [NewestCardUrl stringByAppendingFormat:@"?p=%d&s=6",currentPage];    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requsetUrl]];
    request.delegate = self;
    [request setDidFinishSelector:@selector(getTheNewestCard:)];
    [request setDidFailSelector:@selector(getTheNewestCard_Failed:)];
    [request startAsynchronous];
}

-(void)getTheNewestCard:(ASIHTTPRequest *)request
{
    addPageNumber = 0;
    
    NSDictionary *dict = [request responseString].JSONValue;
    NSLog(@"%@",dict);
    self.total_pageStr = [dict objectForKey:@"page_total"];
    
    self.totalLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"total"]];
    NSLog(@"%@",self.totalLabel.text);

    
    NSArray *tmpArray = [dict objectForKey:@"items"];

    [self.tableArray addObjectsFromArray:tmpArray];
    [self.table reloadData];

}

/*
-(void)getTheNewestCard:(ASIHTTPRequest *)request
{
    NSDictionary *dict = [request responseString].JSONValue;
    self.total_pageStr = [dict objectForKey:@"page_total"];
    
    NSArray *tmpArray = [dict objectForKey:@"items"];
    loopNumber = ceil(tmpArray.count/2);
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < loopNumber; i++)
    {
        if (array != nil) 
        {
            [array removeAllObjects];
        }
        [array addObject:[tmpArray objectAtIndex:loopNumber*2+0]];
        [array addObject:[tmpArray objectAtIndex:loopNumber*2+1]];

    }
    
}
*/

-(void)getTheNewestCard_Failed:(ASIHTTPRequest *)request
{
    PromptView *tmpPromptView = [[PromptView alloc] init];
    [tmpPromptView showPromptWithParentView:self.view 
                                 withPrompt:@"网络错误" 
                                  withFrame:CGRectMake(40, 120, 240, 240)];
    [tmpPromptView release];
}

#pragma mark - TableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.tableArray.count + 1) / 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewestCardViewCellView *cell = [self.table dequeueReusableCellWithIdentifier:@"NewestCardViewCellView"];
    if (!cell) 
    {
        cell = [NewestCardViewCellView getInstance];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    NSInteger leftIndex = 2 * indexPath.row;
    NSInteger rightIndex = 2 * indexPath.row + 1;
    
    cell.btn1.tag = [[[self.tableArray objectAtIndex:leftIndex] objectForKey:@"template_id"] intValue];
    cell.label1.text = [[self.tableArray objectAtIndex:leftIndex] objectForKey:@"card_receiver_address"];
    
    NSString *urlStr1 = [[self.tableArray objectAtIndex:leftIndex] objectForKey:@"minipic"];
    UIImage *tmpImg1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr1]]];
    [cell.btn1 setBackgroundImage:tmpImg1 forState:UIControlStateNormal];
    [cell.btn1 addTarget:self action:@selector(goToDisplayView:) forControlEvents:UIControlEventTouchUpInside];
    
    if (rightIndex < [self.tableArray count]) 
    {
        NSString *urlStr2 = [[self.tableArray objectAtIndex:leftIndex] objectForKey:@"minipic"];
        UIImage *tmpImg2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr2]]];
        cell.btn2.tag = [[[self.tableArray objectAtIndex:rightIndex] objectForKey:@"template_id"] intValue];
        cell.label2.text = [[self.tableArray objectAtIndex:rightIndex] objectForKey:@"card_receiver_address"];
        [cell.btn2 setBackgroundImage:tmpImg2 forState:UIControlStateNormal];
        [cell.btn2 addTarget:self action:@selector(goToDisplayView:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    addPageNumber ++;
    NSLog(@"%d",addPageNumber);
    if (addPageNumber == 2)
    {
        currentPage ++;
    }
    
    return cell;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.goBackBtn setImage:[UIImage imageNamed:@"titlebtnbackclick.png"]
                    forState:UIControlStateHighlighted];
    tableArray = [[NSMutableArray alloc] init];
    currentPage = 1;
    self.table.delegate = self;
    self.table.dataSource = self;

}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height)
    {
        if (currentPage < [self.total_pageStr intValue]) 
        {
            [self displayNewestCard];
        }
    }
}


-(void)goToDisplayView:(UIButton *)sender
{
    DisplayEachTemplateDetals *display = [[DisplayEachTemplateDetals alloc] init];
    display.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    display.idName = [NSString stringWithFormat:@"%d",sender.tag];
    NSLog(@"%@",display.idName);
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FromActivityList"];
    [self presentModalViewController:display animated:YES];
}

- (void)viewDidUnload
{
    [self setGoBackBtn:nil];
    [self setTable:nil];
    [self setTotalLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
