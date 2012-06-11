//
//  GrabScreen.h
//  TimerDisplay
//
//  Created by 振东 何 on 12-6-8.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageProcess : NSObject

+ (UIImage *)grabScreenWithScale:(CGFloat)scale;//截屏

+ (UIImage *)grabImageWithView:(UIView *)view 
                         scale:(CGFloat)scale;//截图

+ (UIImage *)mergeWithImage1:(UIImage*)image1 
                      image2:(UIImage *)image2 
                      frame1:(CGRect)frame1 
                      frame2:(CGRect)frame2 
                        size:(CGSize)size;//合并图片

+ (UIImage *)maskImage:(UIImage*)image withMask:(UIImage*)mask;//把一张图盖在另一张上面


@end
