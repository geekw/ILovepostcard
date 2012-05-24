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

@interface ActivityListView : UIViewController<ASIHTTPRequestDelegate>

@property (retain, nonatomic) IBOutlet UIButton *goBackButton;

- (IBAction)goBack;

@end
