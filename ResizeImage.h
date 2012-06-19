//
//  ResizeImage.h
//  MyFlow
//
//  Created by 振东 何 on 12-5-29.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResizeImage : NSObject

+ (UIImage *)scale:(UIImage *)image toSize:(CGSize)size;

@end
