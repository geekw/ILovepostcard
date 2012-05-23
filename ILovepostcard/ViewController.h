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


@interface ViewController : UIViewController
{
    GoToPostcardList *goToPostcardList;
    ActivityListView *activityListView;
}

@property (retain, nonatomic) IBOutlet UIButton *goToPostcardListButton;
@property (retain, nonatomic) IBOutlet UIButton *goToActivityListButton;

- (IBAction)goToActivityList;

- (IBAction)goToPostcardList;

@end
