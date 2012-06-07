//
//  ActivityDetailView.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-6-7.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "SBJson.h"

@interface ActivityDetailView : UIViewController<ASIHTTPRequestDelegate>


@property (retain, nonatomic) NSString *activityTag;
@property (retain, nonatomic) NSDictionary *listDict;

@property (retain, nonatomic) IBOutlet UIButton *goBackBtn;


- (IBAction)goBack;


@end
