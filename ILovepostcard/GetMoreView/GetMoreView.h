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

@interface GetMoreView : UIViewController <SinaShareDelegate>

@property (retain, nonatomic) IBOutlet UIButton *goBackBtn;
@property (retain, nonatomic) IBOutlet UIButton *weiBoShareBtn;
@property (retain, nonatomic) IBOutlet UIButton *aboutUsBtn;
@property (retain, nonatomic) IBOutlet UIButton *gradeBtn;
@property (retain, nonatomic) IBOutlet UIButton *serviceBtn;

@property (retain, nonatomic) SinaShare *sinaShare;
@property (retain, nonatomic) AboutUsViewController *aboutUsViewController;

- (IBAction)goBack;
- (IBAction)weiBoShare:(id)sender;
- (IBAction)goAboutUsView;
- (IBAction)giveScore;
- (IBAction)callServer;


@end
