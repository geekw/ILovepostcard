//
//  ItemData.h
//  ILovepostcard
//
//  Created by wang piepie on 12-6-3.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemData : NSObject
{
    NSString *title;
    NSString *loveCount;
    UIImage *image;
}

@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *loveCount;
@property(nonatomic,retain)UIImage *image;

@end
