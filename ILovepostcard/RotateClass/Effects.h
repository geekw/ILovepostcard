//
//  Effects.h
//  CoreAnimationDemo
//
//  Created by 振东 何 on 12-5-31.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Effects : NSObject

+ (UIImageView *)moveToRightCornerWithImageView:(UIImageView *)imageView;//从当前位置移到右下角。
+ (UIImageView *)rotate360DegreeWithImageView:(UIImageView *)imageView;//旋转360度。
+ (UIImageView *)flowWithImageView:(UIImageView *)imageView;//漂流。

@end
