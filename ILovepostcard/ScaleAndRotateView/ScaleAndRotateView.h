//
//  ScaleAndRotateView.h
//  ScaleAndRotate
//
//  Created by 进 吴 on 12-5-20.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScaleAndRotateView : UIView<UIGestureRecognizerDelegate>
{
	CGPoint startTouchPosition; 
}

-(void)addScaleAndRotateView:(UIView *)view;

@end
