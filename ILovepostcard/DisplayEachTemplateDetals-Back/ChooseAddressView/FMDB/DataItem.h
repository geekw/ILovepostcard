//
//  DataItem.h
//  SQLTest
//
//  Created by wang piepie on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataItem : NSObject
{
    NSString *province;
    NSString *city;
    NSString *county;
    NSString *postcode;
}

@property(nonatomic,retain)NSString *province;
@property(nonatomic,retain)NSString *city;
@property(nonatomic,retain)NSString *county;
@property(nonatomic,retain)NSString *postcode;

@end
