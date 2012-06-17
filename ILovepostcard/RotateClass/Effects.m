//
//  Effects.m
//  CoreAnimationDemo
//
//  Created by 振东 何 on 12-5-31.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "Effects.h"
#import "QuartzCore/QuartzCore.h"

#define   DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)

@implementation Effects

+ (UIImageView *)moveToRightCornerWithImageView:(UIImageView *)imageView{
    CGPoint fromePoint = imageView.center;
    
    //路径曲线
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:fromePoint];
    CGPoint toPoint = CGPointMake(310, 460);
    [movePath addQuadCurveToPoint:toPoint controlPoint:CGPointMake(toPoint.x, fromePoint.y)];
        
    //关键帧
    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim.path = movePath.CGPath;
    moveAnim.removedOnCompletion = NO;
    
    //旋转变化
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //x, y缩小0.1，z 轴不变
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
    scaleAnim.removedOnCompletion = NO;
    
    //透明度变化
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"alpha"];
    opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnim.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnim.removedOnCompletion = NO;
    
    //关键帧，旋转，透明度组合起来执行
    CAAnimationGroup *animGrop = [CAAnimationGroup animation];
    animGrop.animations = [NSArray arrayWithObjects:moveAnim, scaleAnim, opacityAnim, nil];
    animGrop.duration = 3;
    [imageView.layer addAnimation:animGrop forKey:nil];
    
    return imageView;
}

+ (UIImageView *)rotate360DegreeWithImageView:(UIImageView *)imageView{
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D: 
                         
                         CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 0.5;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = 1000;
    
    //在图片边缘添加一个像素的透明区域，去图片锯齿
    CGRect imageRrect = CGRectMake(0, 0,imageView.frame.size.width, imageView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size); 
    [imageView.image drawInRect:CGRectMake(1,1,imageView.frame.size.width-2,imageView.frame.size.height-2)];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imageView.layer addAnimation:animation forKey:nil];
    return imageView;
}

+ (UIImageView *)flowWithImageView:(UIImageView *)imageView{
    CGPoint fromPoint = imageView.center;
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:fromPoint];
    CGPoint toPoint = CGPointMake(fromPoint.x +50 , fromPoint.y + 50) ;
    
    [movePath addLineToPoint:toPoint];
    
    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim.path = movePath.CGPath;
    
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //沿Z轴旋转
    scaleAnim.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI,0.4,0.1,1)];
    scaleAnim.cumulative = YES;
    scaleAnim.duration =1;
    //旋转2遍，360度    
    scaleAnim.repeatCount =2;
    imageView.center = toPoint;
    scaleAnim.removedOnCompletion = YES;
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:moveAnim, scaleAnim, nil];
    animGroup.duration = 2;
    
    [imageView.layer addAnimation:animGroup forKey:nil];
    
    return imageView;
}


@end
