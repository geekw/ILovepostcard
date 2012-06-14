//
//  SeachList.m
//  Macau
//
//  Created by wang piepie on 12-02-23.
//  Copyright 2011年 com.ailk. All rights reserved.
//

#import "SeachList.h"
#import <QuartzCore/QuartzCore.h>
#import "PassValueDelegate.h"


@implementation SeachList

@synthesize searchText,selectedText,resultList,delegate,tagList;

#pragma mark -
#pragma mark Initialization


- (id)init
{
    self = [super init];

    if (self)
    {

    }

    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self)
    {
        searchText = nil;
        selectedText = nil;
        resultList = [[NSMutableArray alloc] init];
    }
    return self;
}



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad 
{
    [super viewDidLoad];	
}
/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)updateData:(NSArray *)newArray
{

    [resultList removeAllObjects];	
	[resultList addObjectsFromArray:newArray];
	[self.tableView reloadData];
}

- (void)setValue:(NSInteger)index
{
    if ([resultList count] > 0) 
    {
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [resultList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSUInteger row = [indexPath row];
	cell.textLabel.text = [resultList objectAtIndex:row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize: 15.0];
    return cell;
}

#pragma mark -
#pragma mark Table view delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (delegate != nil)
    {
        selectedText = [resultList objectAtIndex:[indexPath row]];
        [delegate passValue:selectedText];
        [delegate selected:[NSNumber numberWithInteger:tagList] displayLabel:selectedText]; 
        self.tableView.hidden = YES;
    }
    

}


- (void)setListTag:(NSInteger)i
{
    tagList = i;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc 
{
    [searchText release];
    [selectedText release];
    [resultList release];
    [super dealloc];
}


@end

