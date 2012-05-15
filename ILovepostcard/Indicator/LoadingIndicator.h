//
//  LoadingIndicator.h
//  TongRenTang
//
//  Created by 振东 何 on 12-4-29.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingIndicator : NSObject
{
    UIView *backgroundView;
}

-(void)showWaiting:(UIView *)parentView;

-(void)hideWaiting;

@end
