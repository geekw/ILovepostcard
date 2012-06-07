//
//  ItemProduct.h
//  ILovepostcard
//
//  Created by wang piepie on 12-6-7.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemProduct : NSObject
{
    NSString *subject;
    NSString *body;
    float price;
}

@property(nonatomic,retain) NSString *subject;
@property(nonatomic,retain) NSString *body;
@property(nonatomic,assign) float price;


@end
