//
//  FileManager.h
//  TimerDisplay
//
//  Created by 振东 何 on 12-6-9.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDocuments [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define kTempDir NSTemporaryDirectory()

@interface CreateFolder : NSObject

+ (BOOL)createFolder:(NSString *)folder atDirectory:(NSString *)directory;//在相应目录下创建一个文件夹，成功返回YES。若已存在直接返回YES。
+ (BOOL)saveData:(NSData *)data withName:(NSString *)name atDirectory:(NSString *)directory;//保存文件到相应路径下。
+ (NSData *)findFile:(NSString *)fileName atDirectory:(NSString *)directory;//查找并返回文件。
+ (BOOL)deleteFile:(NSString *)fileName atDirectory:(NSString *)directory;//删除文件。

@end
