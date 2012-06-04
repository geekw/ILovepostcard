//
//  AlertView.m
//  Demo
//
//  Created by 振东 何 on 12-5-10.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "PromptView.h"

@interface PromptView ()

- (void)hidePromptView;

@end


@implementation PromptView

- (void)dealloc{
    [promptLbl release];
    [super dealloc];
}

- (id)init{
    self = [super init];
    if (self)
    {
        promptLbl = [[UILabel alloc] init];
        promptLbl.alpha = 0.0f;
        promptLbl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        promptLbl.textAlignment = UITextAlignmentCenter;
        promptLbl.textColor = [UIColor orangeColor];
        promptLbl.layer.cornerRadius = 8;
        promptLbl.font = [UIFont systemFontOfSize:30];
    }
    return self;
}


- (void)showPromptWithParentView:(UIView *)parentView
                      withPrompt:(NSString *)promptText 
                       withFrame:(CGRect)frame
{
    promptLbl.text = promptText;
    promptLbl.frame = frame;
    [parentView addSubview:promptLbl];
    
    [UIView beginAnimations:nil context:nil];
    promptLbl.alpha = 1.0f;
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:2.0f];
    [UIView commitAnimations];
    
    [self performSelector:@selector(hidePromptView) withObject:nil afterDelay:2.5];
}


- (void)hidePromptView
{
    [UIView beginAnimations:nil context:nil];
    promptLbl.alpha = 0.0;
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:2.0f];
    [UIView commitAnimations];
}


@end
