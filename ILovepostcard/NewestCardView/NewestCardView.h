//
//  NewestCardView.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-6-10.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface NewestCardView : UIViewController<UITableViewDelegate,UITableViewDataSource,ASIHTTPRequestDelegate>
{
    int loopNumber;
}

@property (retain, nonatomic) IBOutlet UIButton *goBackBtn;
@property (retain, nonatomic) NSMutableArray *tableArray;
@property (retain, nonatomic) NSString *total_pageStr;

@property (retain, nonatomic) IBOutlet UITableView *table;

@property (retain, nonatomic) IBOutlet UILabel *totalLabel;

- (IBAction)goBack;

-(void)showNewestCards:(NSArray *)array;
-(void)displayNewestCard;

@end
