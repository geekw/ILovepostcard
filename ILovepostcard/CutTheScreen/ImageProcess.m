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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scaleFont" object:nil];
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil); 

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


+ (UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


+ (UIView *)rotateView:(UIView *)view withDegree:(int)degree{
    //先将图转到竖立。
    view.frame = CGRectMake((view.frame.size.width - view.frame.size.height) / 2 + view.frame.origin.x, (view.frame.size.height - view.frame.size.width) / 2 + view.frame.origin.y, view.frame.size.height, view.frame.size.width);

    //通过动画将图转横。
//    [UIView beginAnimations:@"rotate_back" context:nil];
    view.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.0f);
//    [UIView commitAnimations];

    return view;
}

@end
