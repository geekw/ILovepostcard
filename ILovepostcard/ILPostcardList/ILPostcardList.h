//
//  ILPostcardList.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-14.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILPostcardList : NSObject
{
    NSMutableArray *templateAbstractList;
}

@property (nonatomic,retain) NSMutableArray *templateAbstractList;
@property (nonatomic, retain)NSMutableArray *templateAbstractList_SearchBar;

+ (ILPostcardList *)sharedILPostcardList;

@end
