//
//  TemplateDetails-Singleton.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-17.
//  Copyright (c) 2012年 开趣. All rights reserved.
//



@interface TemplateDetails_Singleton : NSObject

@property(nonatomic, retain)NSMutableDictionary *templateDetailsDict;//模板详情字典

+(TemplateDetails_Singleton *) sharedTemplateDetails_Singleton;

@end
