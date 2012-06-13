//
//  AlertView.h
//  Demo
//
//  Created by 振东 何 on 12-5-10.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"

@interface PromptView : NSObject
{
    UILabel *promptLbl;
}

- (void)showPromptWithParentView:(UIView *)parentView
                      withPrompt:(NSString *)promptText 
                       withFrame:(CGRect)frame;


//+ (void)showPromptWithParentViewAllTheTime:(UIView *)parentView
//                      withPrompt:(NSString *)promptText 
//                       withFrame:(CGRect)frame;//永久显示
//+ (void)hideThisPromptView;//手动隐藏


@end
