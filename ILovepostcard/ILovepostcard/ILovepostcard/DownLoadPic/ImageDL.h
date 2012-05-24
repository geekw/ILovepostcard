

#import <Foundation/Foundation.h>

@protocol ImageDLDelegate <NSObject>
@optional
-(void) willBeginDownLoad;               
@required
-(void) willEndDownload:(UIImage*)image flag:(NSNumber*)number;				
@end

@interface ImageDL : NSObject<ASIHTTPRequestDelegate>
{
@private
    id<ImageDLDelegate> delegate; 
    NSMutableDictionary *dictionaryQueue;
    NSMutableDictionary *dictionaryDelegate;
    NSMutableDictionary *dictionaryFlag;
    NSOperationQueue *threadQueue; 
}

+ (id)sharedLGImageDL;

- (void)pushDownLoadImage:(NSString*)file delegate:(id<ImageDLDelegate>)imageDelegate flag:(NSNumber*)number; 
- (void)pushDownLoadImageEX:(NSString*)group name:(NSString*)file delegate:(id<ImageDLDelegate>)imageDelegate flag:(NSNumber*)number; 

@end