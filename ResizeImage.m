//
//  ResizeImage.m
//  MyFlow
//
//  Created by 振东 何 on 12-5-29.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "ResizeImage.h"

@implementation ResizeImage

+ (UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
