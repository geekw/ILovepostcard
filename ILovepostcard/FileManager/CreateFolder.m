//
//  FileManager.m
//  TimerDisplay
//
//  Created by 振东 何 on 12-6-9.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "CreateFolder.h"

@implementation CreateFolder

+ (BOOL)createFolder:(NSString *)folder atDirectory:(NSString *)directory
{
    NSString *savePath = [directory stringByAppendingPathComponent:folder];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL exist = [fileManager fileExistsAtPath:savePath isDirectory:&isDirectory];
    NSError *error = nil;
    if (!exist || !isDirectory)
    {
        [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    return [fileManager fileExistsAtPath:savePath isDirectory:&isDirectory];
}

+ (BOOL)saveData:(NSData *)data 
        withName:(NSString *)name 
     atDirectory:(NSString *)directory
{
    if (data && name && directory) 
    {
        NSString *filePath = [directory stringByAppendingPathComponent:name];
        NSLog(@"filePath:%@", filePath);

       return [data writeToFile:filePath atomically:YES];
    }
    return NO;
}

+ (NSData *)findFile:(NSString *)fileName atDirectory:(NSString *)directory{
    NSData *data = nil;
    if (fileName && directory) 
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [directory stringByAppendingPathComponent:fileName];
        NSLog(@"filePath:%@", filePath);

        if ([fileManager fileExistsAtPath:filePath]) 
        {
            data = [NSData dataWithContentsOfFile:filePath];
        }
    }
    
    return data;
}

+ (BOOL)deleteFile:(NSString *)fileName atDirectory:(NSString *)directory{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [directory stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    return success;
}

@end
