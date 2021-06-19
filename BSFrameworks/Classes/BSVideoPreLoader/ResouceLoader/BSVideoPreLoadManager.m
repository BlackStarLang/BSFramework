//
//  BSVideoPreLoadManager.m
//  BSFrameworks
//
//  Created by dangdang on 2021/6/16.
//

#import "BSVideoPreLoadManager.h"
#import "BSVideoDlownLoader.h"
#import <CoreServices/CoreServices.h>

@interface BSVideoPreLoadManager ()<AVAssetResourceLoaderDelegate,BSVideoDlownLoaderDelegate>

@property (nonatomic , strong) AVURLAsset * curAsset;

@property (nonatomic , strong) NSMutableArray *loadingRequestArr;

@property (nonatomic , strong) BSVideoDlownLoader *downLoader;

@property (nonatomic , strong) NSMutableDictionary *requestInfo;

@end


@implementation BSVideoPreLoadManager

-(void)dealloc{
    
    NSLog(@"BSVideoPreLoadManager dealloc");
}

-(AVPlayerItem *)getPlayerItemWithUrls:(NSString *)url{
    
    NSString *newUrl = [self getResouceLoaderUrlWithOriginUrl:url];
    NSURL *URL = [NSURL URLWithString:newUrl];
    
    self.curAsset = [AVURLAsset URLAssetWithURL:URL options:nil];
    [self.curAsset.resourceLoader setDelegate:self queue:dispatch_get_main_queue()];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:self.curAsset];
    //暂停时继续缓存
    playerItem.canUseNetworkResourcesForLiveStreamingWhilePaused = YES;
    return playerItem;
}




#pragma mark - AVAssetResourceLoaderDelegate

-(BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest{
    
    [self.loadingRequestArr addObject:loadingRequest];
    [self willSendDownloadRequestWithLoadingRequest:loadingRequest];
    
    return YES;
}


-(void)willSendDownloadRequestWithLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest{
    
    NSString *url = loadingRequest.request.URL.absoluteString;
    NSString *originUrl = [self getOriginUrl:url];
    NSURL *URL = [NSURL URLWithString:originUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:URL];
    
    long long local = loadingRequest.dataRequest.requestedOffset;
    long long lenth = loadingRequest.dataRequest.requestedLength + loadingRequest.dataRequest.requestedOffset - 1;
    
    NSString * contentRange = [NSString stringWithFormat:@"bytes=%lld-%lld",local,lenth];
    
    NSLog(@"=\n===========\ncontentRange : %@\n==========",contentRange);
    [request setValue:contentRange forHTTPHeaderField:@"Range"];
    
    NSString *requestId = [NSString stringWithFormat:@"%@:%@",request.URL,contentRange];
    
    [self.requestInfo setValue:loadingRequest forKey:requestId];
    
    self.downLoader = [[BSVideoDlownLoader alloc]init];
    self.downLoader.delegate = self;
    [self.downLoader downLoadWithRequest:request];
}


-(void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest{
    
    
    [self.loadingRequestArr removeAllObjects];
    
}



#pragma mark - BSVideoDlownLoaderDelegate

- (void)BSVideoDlownLoaderReceiveResponse:(NSURLResponse *)response dataTaskRequest:(NSURLRequest *)request{
    
    NSString *requestId = [self getRequestIdWithRequest:request];
    AVAssetResourceLoadingRequest *loadRequest = [self.requestInfo objectForKey:requestId];
    
    if (loadRequest) {
        AVAssetResourceLoadingContentInformationRequest *infoRequest = loadRequest.contentInformationRequest;
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            
            NSHTTPURLResponse *HTTPURLResponse = (NSHTTPURLResponse *)response;
            //        NSString *acceptRange = HTTPURLResponse.allHeaderFields[@"Accept-Ranges"];
            
            infoRequest.byteRangeAccessSupported = YES;
            infoRequest.contentLength = [[[HTTPURLResponse.allHeaderFields[@"Content-Range"]
                                           componentsSeparatedByString:@"/"] lastObject] longLongValue];
            if (infoRequest.contentLength == 0) {
                infoRequest.contentLength = [HTTPURLResponse.allHeaderFields[@"Content-Length"] longLongValue];
            }
        }
        
        NSString *mimeType = response.MIMEType;
        CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType,
                                                                        (__bridge CFStringRef)(mimeType),
                                                                        NULL);
        infoRequest.contentType = CFBridgingRelease(contentType);
    }
}


-(void)BSVideoDlownLoaderDidReceiveData:(NSData *)data request:(NSURLRequest *)request{
    
    NSString *requestId = [self getRequestIdWithRequest:request];
    
    AVAssetResourceLoadingRequest *loadRequest = [self.requestInfo objectForKey:requestId];
    [loadRequest.dataRequest respondWithData:data];
    [loadRequest finishLoading];
}



#pragma mark - url

-(NSString *)getRequestIdWithRequest:(NSURLRequest *)request{
    
    NSString *url = request.URL.absoluteString;
    NSString *range = [request.allHTTPHeaderFields objectForKey:@"Range"];
    NSString *requestId = [url stringByAppendingFormat:@":%@",range];
    
    return requestId?:@"";
}



-(NSString *)getResouceLoaderUrlWithOriginUrl:(NSString *)url{
    
    NSString *newUrl = [@"bs_cache:" stringByAppendingString:url];
    return newUrl;
}


-(NSString *)getOriginUrl:(NSString *)url{
    
    if ([url hasPrefix:@"bs_cache:"]) {
        
        NSString *newUrl = [url stringByReplacingOccurrencesOfString:@"bs_cache:" withString:@""];
        return newUrl;
    }
    return url;
}


//-(BSVideoDlownLoader *)downLoader{
//    if (!_downLoader) {
//        _downLoader = [[BSVideoDlownLoader alloc]init];
//        _downLoader.delegate = self;
//    }
//    return _downLoader;
//}

-(NSMutableArray *)loadingRequestArr{
    if (!_loadingRequestArr) {
        _loadingRequestArr = [NSMutableArray array];
    }
    return _loadingRequestArr;
}

-(NSMutableDictionary *)requestInfo{
    if (!_requestInfo) {
        _requestInfo = [NSMutableDictionary dictionary];
    }
    return _requestInfo;
}

@end





