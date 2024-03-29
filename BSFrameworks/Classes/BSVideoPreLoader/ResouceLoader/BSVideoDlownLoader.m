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
@property (nonatomic , strong) NSMutableArray *mutRequests;

@property (nonatomic , strong) BSVideoPreLoadCache *loadCache;
@property (nonatomic , assign) BOOL isRequesting;
@end

@implementation BSVideoDlownLoader


-(void)downLoadWithRequest:(NSURLRequest *)request{
    
    NSData *videoData = [self.loadCache getVideoCacheWithFileUrl:request.URL.absoluteString];
    
    if (videoData) {
        
        if ([self.delegate respondsToSelector:@selector(BSVideoDlownLoaderReceiveResponse:dataTaskRequest:)]) {
            
            NSHTTPURLResponse *HTTPURLResponse = [[NSHTTPURLResponse alloc]init];
            [self.delegate BSVideoDlownLoaderReceiveResponse:HTTPURLResponse dataTaskRequest:request];
        }
        
        if ([self.delegate respondsToSelector:@selector(BSVideoDlownLoaderDidReceiveData:request:)]) {
            [self.delegate BSVideoDlownLoaderDidReceiveData:videoData request:request];
        }
        
        if ([self.delegate respondsToSelector:@selector(BSVideoDlownLoaderDidFinishRequest:withError:)]) {
            [self.delegate BSVideoDlownLoaderDidFinishRequest:request withError:nil];
        }
        
    }else{
        [self.mutRequests addObject:request];
        if (!self.isRequesting) {
            [self loadNextRequest];
        }
    }
}

-(void)loadNextRequest{
    
    if (self.mutRequests.count) {
        NSURLRequest *request = self.mutRequests.firstObject;
        NSURLSessionTask *task = [self.session dataTaskWithRequest:request];
        self.task = task;
        [self.mutTasks addObject:task];
        [task resume];
        self.isRequesting = YES;
    }
}


#pragma mark - NSURLSessionDelegate

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    
    if ([self.delegate respondsToSelector:@selector(BSVideoDlownLoaderReceiveResponse:dataTaskRequest:)]) {
        [self.delegate BSVideoDlownLoaderReceiveResponse:response dataTaskRequest:dataTask.currentRequest];
    }

    completionHandler(NSURLSessionResponseAllow);
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
//    NSLog(@"didReceiveData : %@",dataTask.currentRequest);
//    NSURL *URL = dataTask.currentRequest.URL;
//    [self.loadCache saveVideoCacheWithData:data fileUrl:URL.absoluteString];
    
    if ([self.delegate respondsToSelector:@selector(BSVideoDlownLoaderDidReceiveData:request:)]) {

        [self.delegate BSVideoDlownLoaderDidReceiveData:data request:dataTask.currentRequest];
    }
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    self.isRequesting = NO;
    [self.mutRequests removeObject:self.mutRequests.firstObject];
    [self loadNextRequest];
//    NSLog(@"didCompleteWithError : %@",task.currentRequest);
    if ([self.delegate respondsToSelector:@selector(BSVideoDlownLoaderDidFinishRequest:withError:)]) {

        [self.delegate BSVideoDlownLoaderDidFinishRequest:task.currentRequest withError:error];
    }
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

-(NSMutableArray *)mutRequests{
    if (!_mutRequests) {
        _mutRequests = [NSMutableArray array];
    }
    return _mutRequests;
}


-(BSVideoPreLoadCache *)loadCache{
    if (!_loadCache) {
        _loadCache = [[BSVideoPreLoadCache alloc]init];
    }
    return _loadCache;
}

@end
