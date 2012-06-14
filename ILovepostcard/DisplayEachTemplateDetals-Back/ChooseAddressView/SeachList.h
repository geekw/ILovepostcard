//
//  SeachList.h
//  Macau
//
//  Created by wang piepie on 12-02-23.
//  Copyright 2011年 com.ailk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PassValueDelegate;

@interface SeachList : UITableViewController 
{
	NSString		*searchText;
	NSString		*selectedText;
	NSMutableArray	*resultList;
	id <PassValueDelegate>	delegate;
    NSInteger tagList;//tag值

}

@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, copy) NSString	*selectedText;
@property (nonatomic, copy) NSMutableArray	*resultList;
@property (assign) id <PassValueDelegate> delegate;
@property (nonatomic, assign) NSInteger tagList;

- (void)setListTag:(NSInteger)i;
- (void)updateData:(NSArray *)newArray;
- (void)setValue:(NSInteger)index;
@end
