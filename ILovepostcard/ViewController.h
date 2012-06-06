//
//  ViewController.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-21.
//  Copyright (c) 2012年 开趣. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GoToPostcardList.h"
#import "ActivityListView.h"
#import "VoiceMessageView.h"

@interface ViewController : UIViewController<UIScrollViewDelegate>

@property (retain, nonatomic) GoToPostcardList *postcardList;
@property (retain, nonatomic) ActivityListView *activityListView;
@property (retain, nonatomic) VoiceMessageView *voiceMessageView;

@property (retain, nonatomic) IBOutlet UIButton *listenVoiceMessageButton;

@property (retain, nonatomic) IBOutlet UIButton *goToPostcardListButton;

@property (retain, nonatomic) IBOutlet UIButton *goToPostOfficeButton;

@property (retain, nonatomic) IBOutlet UIButton *getMoreButton;

@property (retain, nonatomic) IBOutlet UIScrollView *loopScrollView;

@property (retain, nonatomic) IBOutlet UILabel *numberLabel;

- (IBAction)goToVoiceMessageView;

- (IBAction)goToActivityList;

- (IBAction)goToPostcardList;

- (IBAction)goToPostOfficeView;

- (IBAction)getMore;


@end
