//
//  ActivityListView.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-23.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILActivityList.h"

@interface ActivityListView : UIViewController


@property (retain, nonatomic) IBOutlet UIButton *goBackButton;

- (IBAction)goBack;

@end
