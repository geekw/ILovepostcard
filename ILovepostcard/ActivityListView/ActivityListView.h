//
//  ActivityListView.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-23.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "PromptView.h"
#import "GoToPostcardList.h"
#import "PostcardList_WithoutSearchbar.h"
#import "ItemCell.h"
#import "PullingRefreshTableView.h"
#import "ActivityDetailView.h"

#define MAX_COUNT 5


@interface ActivityListView : UIViewController<ASIHTTPRequestDelegate,UITableViewDataSource, UITableViewDelegate,PullingRefreshTableViewDelegate>

{
    int currentPage;
    PullingRefreshTableView *dataTableView;
    NSMutableArray *dataArray;      //  数据源
}

@property (nonatomic, retain) PullingRefreshTableView *dataTableView;
@property (retain, nonatomic) GoToPostcardList *goToPostcardList;
@property (retain, nonatomic) PostcardList_WithoutSearchbar *postcardList_WithoutSearchbar;
@property (retain, nonatomic) ItemCell *itemCell;
@property (retain ,nonatomic) ActivityDetailView *detailView;

@property (retain, nonatomic) IBOutlet UIButton *goBackButton;
@property (nonatomic, retain) NSMutableArray *dataArray;


//- (void)updateThread:(NSString *)returnKey;
//
//- (void)updateTableView;

- (IBAction)goBack;

@end
