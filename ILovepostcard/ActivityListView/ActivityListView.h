//
//  ActivityListView.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-23.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILActivityList.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "PromptView.h"

#import "PullingRefreshTableView.h"

#define MAX_COUNT 5

@interface ActivityListView : UIViewController<ASIHTTPRequestDelegate,UITableViewDataSource, UITableViewDelegate,PullingRefreshTableViewDelegate>

{
    int currentPage;
    int currentPage_Keyword;
    PullingRefreshTableView *dataTableView;
    NSMutableArray *dataArray;      //  数据源
}


@property (retain, nonatomic) IBOutlet UIButton *goBackButton;

@property (nonatomic, retain) PullingRefreshTableView *dataTableView;
@property (nonatomic, retain) NSMutableArray *dataArray;


- (void)updateThread:(NSString *)returnKey;
- (void)updateTableView;

- (IBAction)goBack;

@end
