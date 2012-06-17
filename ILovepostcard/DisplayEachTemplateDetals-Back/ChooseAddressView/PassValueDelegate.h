//
//  PassValueDelegate.h
//  Macau
//
//  Created by wang piepie on 12-02-23.
//  Copyright 2011年 com.ailk. All rights reserved.
//
#import <UIKit/UIKit.h>


@protocol PassValueDelegate

//- (void)passValue:(NSString *)value;
- (void)selected:(NSNumber *)index displayLabel:(NSString *)v;//委托 通过tag值确定当前选中项

@end
