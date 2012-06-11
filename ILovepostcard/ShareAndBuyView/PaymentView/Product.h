//
//  Product.h
//  ILovepostcard
//
//  Created by  on 12-6-11.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <Foundation/Foundation.h>

//测试商品信息封装在Product中,外部商户可以根据自己商品实际情况定义
@interface Product : NSObject
{
@private
	float     _price;
	NSString *_subject;
	NSString *_body;
	NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *orderId;

@end