//
//  FileManager.h


#import <Foundation/Foundation.h>

@interface FileManager : NSObject
{
 NSString *qRFile;
}
@property (nonatomic,copy) NSString *qRFile;

+(FileManager*)sharedFileManager;

@end
