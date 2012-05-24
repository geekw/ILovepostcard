//
//  NSObject+ILActivityList.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-23.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILActivityList : NSObject

@property(nonatomic, retain) NSMutableDictionary *activityListDict;//活动详情字典

+(ILActivityList *) sharedILActivityList;

@end
