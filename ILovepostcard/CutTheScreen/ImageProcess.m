//
//  GrabScreen.m
//  TimerDisplay
//
//  Created by 振东 何 on 12-6-8.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "ImageProcess.h"
#import "QuartzCore/QuartzCore.h"

@implementation ImageProcess


+ (UIImage *)grabScreenWithScale:(CGFloat)scale
{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow]; 
    //    UIGraphicsBeginImageContext(screenWindow.frame.size); 
    UIGraphicsBeginImageContextWithOptions(screenWindow.frame.size, YES, scale);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()]; 
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext(); 
    UIGraphicsEndImageContext(); 
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil); 
    
    return image;
}

+ (UIImage *)grabImageWithView:(UIView *)view scale:(CGFloat)scale
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil); 

    return image;
} 

+ (UIImage *)mergeWithImage1:(UIImage*)image1 image2:(UIImage *)image2 frame1:(CGRect)frame1 frame2:(CGRect)frame2 size:(CGSize)size{  
    UIGraphicsBeginImageContext(size);  
    [image1 drawInRect:frame1 blendMode:kCGBlendModeLuminosity alpha:1.0];
    [image2 drawInRect:frame2 blendMode:kCGBlendModeLuminosity alpha:0.2];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();  
    
    return image;  
}

//mask方法
+ (UIImage*) maskImage:(UIImage*)image withMask:(UIImage*)mask{
    CGImageRef imgRef = [image CGImage];
    CGImageRef maskRef = [mask CGImage];
    CGImageRef actualMask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                              CGImageGetHeight(maskRef),
                                              CGImageGetBitsPerComponent(maskRef),
                                              CGImageGetBitsPerPixel(maskRef),
                                              CGImageGetBytesPerRow(maskRef),
                                              CGImageGetDataProvider(maskRef), NULL, false);
    CGImageRef masked = CGImageCreateWithMask(imgRef, actualMask);
    
    return [UIImage imageWithCGImage:masked];
}


@end
