//
//  BSVideoDlownLoader.m
//  BSFrameworks
//
//  Created by dangdang on 2021/6/16.
//

#import "BSVideoDlownLoader.h"
#import "BSVideoPreLoadCache.h"

@interface BSVideoDlownLoader ()<NSURLSessionDelegate,NSURLSessionDataDelegate>

@property (nonatomic , strong) NSURLSession *session;
@property (nonatomic , strong) NSURLSessionTask *task;

@property (nonatomic , strong) NSMutableArray *mutTasks;

@property (nonatomic , strong) BSVideoPreLoadCache *loadCache;

@end

@implementation BSVideoDlownLoader


-(void)downLoadWithRequest:(NSURLRequest *)request{
    
    NSURLSessionTask *task = [self.session dataTaskWithRequest:request];
    self.task = task;
    [self.mutTasks addObject:task];
    [task resume];
}



#pragma mark - NSURLSessionDelegate

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    
    if ([self.delegate respondsToSelector:@selector(BSVideoDlownLoaderReceiveResponse:dataTaskRequest:)]) {
        
        [self.delegate BSVideoDlownLoaderReceiveResponse:response dataTaskRequest:dataTask.currentRequest];
    }

    completionHandler(NSURLSessionResponseAllow);
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
//    NSURL *URL = dataTask.currentRequest.URL;
//    [self.loadCache saveVideoCacheWithData:data fileUrl:URL.absoluteString];
    
    if ([self.delegate respondsToSelector:@selector(BSVideoDlownLoaderDidReceiveData:request:)]) {
        
        [self.delegate BSVideoDlownLoaderDidReceiveData:data request:dataTask.currentRequest];
    }
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
   
    [task cancel];
}


#pragma mark - 属性初始化

-(NSURLSession *)session{
    
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    }
    return _session;
}

-(NSMutableArray *)mutTasks{
    if (!_mutTasks) {
        _mutTasks = [NSMutableArray array];
    }
    return _mutTasks;
}

-(BSVideoPreLoadCache *)loadCache{
    if (!_loadCache) {
        _loadCache = [[BSVideoPreLoadCache alloc]init];
    }
    return _loadCache;
}

@end
