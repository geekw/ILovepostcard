//
//  LoadingIndicator.m
//  TongRenTang
//
//  Created by 振东 何 on 12-4-29.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "LoadingIndicator.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoadingIndicator

- (void)dealloc{
    [backgroundView release];
    
    [super dealloc];
}

//显示进度滚轮指示器
-(void)showWaiting:(UIView *)parentView{    
    if (!backgroundView)
    {
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(110, 180, 100, 50)];
        backgroundView.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.5];
        backgroundView.layer.cornerRadius = 6;
    }
    [parentView addSubview:backgroundView];

    UIActivityIndicatorView* progressInd = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    progressInd.center = CGPointMake(25, 25);
    [progressInd startAnimating];
    progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [backgroundView addSubview:progressInd];
    [progressInd release];
    
    UILabel *waitingLbl = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, 60, 30)];
    waitingLbl.textAlignment = UITextAlignmentCenter;
    waitingLbl.text = @"请稍候...";
    waitingLbl.font = [UIFont systemFontOfSize:12];
    waitingLbl.backgroundColor = [UIColor clearColor];
    waitingLbl.textColor = [UIColor whiteColor];
    [backgroundView addSubview:waitingLbl];
    [waitingLbl release];
}

//消除滚动轮指示器
-(void)hideWaiting 
{
    [backgroundView removeFromSuperview];
}


@end
