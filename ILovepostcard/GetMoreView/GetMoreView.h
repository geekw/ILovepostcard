//
//  GetMoreView.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-6-11.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaShare.h"
#import "AboutUsViewController.h"

@interface GetMoreView : UIViewController <SinaShareDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UIButton *goBackBtn;
@property (retain, nonatomic) IBOutlet UIButton *weiBoShareBtn;
@property (retain, nonatomic) IBOutlet UIButton *aboutUsBtn;
@property (retain, nonatomic) IBOutlet UIButton *gradeBtn;
@property (retain, nonatomic) IBOutlet UIButton *serviceBtn;

@property (retain, nonatomic) SinaShare *sinaShare;
@property (retain, nonatomic) AboutUsViewController *aboutUsViewController;
@property (retain, nonatomic) IBOutlet UITableView *table;
@property (retain, nonatomic) NSMutableArray *tableArray;
@property (retain, nonatomic) NSMutableArray *imageArray;

@property (retain, nonatomic) UIButton *authorizeBtn;

- (IBAction)goBack;

- (void)weiBoShare;
- (void)goAboutUsView;
- (void)giveScore;
- (void)callServer;

@end
