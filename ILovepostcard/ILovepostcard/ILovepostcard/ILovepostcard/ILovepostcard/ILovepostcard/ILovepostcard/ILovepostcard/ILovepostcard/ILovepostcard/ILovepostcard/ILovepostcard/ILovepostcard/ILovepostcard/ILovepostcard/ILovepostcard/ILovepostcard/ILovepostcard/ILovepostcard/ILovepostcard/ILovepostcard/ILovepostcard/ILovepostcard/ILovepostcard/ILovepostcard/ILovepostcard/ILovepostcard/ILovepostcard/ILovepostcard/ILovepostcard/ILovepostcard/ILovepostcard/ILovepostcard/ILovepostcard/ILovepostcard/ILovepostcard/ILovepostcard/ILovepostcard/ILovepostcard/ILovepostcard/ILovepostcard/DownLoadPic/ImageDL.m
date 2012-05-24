

#import "ImageDL.h" 

static ImageDL *instance = nil;
@implementation ImageDL
 
+ (id)sharedImageDL
{
    if (nil == instance) {
        instance = [ImageDL new];
    }
    return instance;
}

- (id)init
{
    if ((self = [super init])) 
    {
        delegate = nil; 
        dictionaryQueue = [[NSMutableDictionary alloc] init];
        dictionaryDelegate = [[NSMutableDictionary alloc] init];
        dictionaryFlag = [[NSMutableDictionary alloc] init];
        
        threadQueue = [[NSOperationQueue alloc] init];
        [threadQueue setMaxConcurrentOperationCount:1];
        if ([threadQueue operationCount] > 0) 
            [threadQueue cancelAllOperations];
    }
    return self;
}

- (void)dealloc
{ 
    [instance release];
    [delegate release];
    [threadQueue cancelAllOperations];
    [threadQueue release];
    [dictionaryQueue release];
    [dictionaryDelegate release];
    [dictionaryFlag release];
    [super dealloc];
}

- (void)pushDownLoadImage:(NSString*)file delegate:(id<ImageDLDelegate>)imageDelegate flag:(NSNumber*)number
{
    NSString *fullPath = [NSString stringWithFormat:@"%@%@",IMAGE_WEB_SITE,file];
    NSURL *url = [NSURL URLWithString:fullPath];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;   
    [threadQueue addOperation:request];
    
    [dictionaryQueue setObject:file forKey:url]; 
    [dictionaryDelegate setObject:imageDelegate forKey:url];
    [dictionaryFlag setObject:number forKey:url];
}

- (void)pushDownLoadImageEX:(NSString *)group name:(NSString *)file delegate:(id<ImageDLDelegate>)imageDelegate flag:(NSNumber *)number
{
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@/%@",IMAGE_WEB_SITE,group,file];
    NSURL *url = [NSURL URLWithString:fullPath];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;   
    [threadQueue addOperation:request];
    
    [dictionaryQueue setObject:file forKey:url]; 
    [dictionaryDelegate setObject:imageDelegate forKey:url];
    [dictionaryFlag setObject:number forKey:url];
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    id<ImageDLDelegate> imageDelegate = [dictionaryDelegate objectForKey:[request url]];
    if ([imageDelegate respondsToSelector:@selector(willBeginDownLoad)]) 
        [imageDelegate performSelector:@selector(willBeginDownLoad)];
}

- (void)requestFinished:(ASIHTTPRequest*)request
{ 
    for (id obj in [dictionaryQueue allKeys])
    {
        if ([obj isKindOfClass:[NSURL class]])
        {
            NSURL *tempURL = (NSURL*)obj;
            NSString *tempBuffer = [tempURL absoluteString];
            NSString *buffer = [[request url] absoluteString]; 
            if ([tempBuffer isEqualToString:buffer])
            {
                NSString *file = [dictionaryQueue objectForKey:tempURL];
                NSData *data = [request responseData];
                [data writeToFile:MM_IMAGE_PATH(file) atomically:YES];
                
                NSLog(@"图片下载成功：%@",file);
                
                id<ImageDLDelegate> imageDelegate = [dictionaryDelegate objectForKey:[request url]];
                NSNumber *number = [dictionaryFlag objectForKey:[request url]];
                if ([imageDelegate respondsToSelector:@selector(willEndDownload:flag:)]) 
                {
                    [imageDelegate performSelector:@selector(willEndDownload:flag:) withObject:MMFindLocalImage(file) withObject:number];
                } 
                break;
            } 
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
    NSLog(@"图片下载失败！%@",[request url]);
    id<ImageDLDelegate> imageDelegate = [dictionaryDelegate objectForKey:[request url]];
    if ([imageDelegate respondsToSelector:@selector(willEndDownload::)]) 
    {
        [imageDelegate performSelector:@selector(willEndDownload::) withObject:nil withObject:0];
    }
}

@end
