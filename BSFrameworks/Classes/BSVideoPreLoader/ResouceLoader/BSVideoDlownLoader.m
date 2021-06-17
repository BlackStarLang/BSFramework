//
//  BSVideoDlownLoader.m
//  BSFrameworks
//
//  Created by dangdang on 2021/6/16.
//

#import "BSVideoDlownLoader.h"

@interface BSVideoDlownLoader ()<NSURLSessionDelegate,NSURLSessionDataDelegate>

@property (nonatomic , strong) NSURLSession *session;
@property (nonatomic , strong) NSURLSessionTask *task;

@property (nonatomic , strong) NSMutableArray *mutTasks;
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
    
    NSLog(@"didReceiveResponse : %@",response);
    completionHandler(NSURLSessionResponseAllow);
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    
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

@end
