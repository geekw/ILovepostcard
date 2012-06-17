//
//  PostOfficeView.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-6-11.
//  Copyright (c) 2012年 开趣. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "ASIHTTPRequest.h"


@interface PostOfficeView : UIViewController<ASIHTTPRequestDelegate, UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UIButton *goBackBtn;

@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (retain, nonatomic) IBOutlet UIView *displayView;

@property (retain, nonatomic) NSMutableDictionary *address;

@property (retain, nonatomic) NSMutableDictionary *paid;

@property (retain, nonatomic) IBOutlet UITableView *table;

@property (retain, nonatomic) NSMutableArray *tableArray;

- (IBAction)goBack;


@end
