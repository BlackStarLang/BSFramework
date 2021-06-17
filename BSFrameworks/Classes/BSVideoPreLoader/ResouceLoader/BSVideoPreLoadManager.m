//
//  BSVideoPreLoadManager.m
//  BSFrameworks
//
//  Created by dangdang on 2021/6/16.
//

#import "BSVideoPreLoadManager.h"
#import "BSVideoDlownLoader.h"

@interface BSVideoPreLoadManager ()<AVAssetResourceLoaderDelegate>

@property (nonatomic , strong) AVURLAsset * curAsset;

@property (nonatomic , strong) NSMutableArray *requestArr;


@end


@implementation BSVideoPreLoadManager

-(AVPlayerItem *)getPlayerItemWithUrls:(NSString *)url{
    
    NSURL *URL = [NSURL URLWithString:[self getResouceLoaderUrlWithOriginUrl:url]];
    
    self.curAsset = [AVURLAsset URLAssetWithURL:URL options:nil];
    [self.curAsset.resourceLoader setDelegate:self queue:dispatch_get_main_queue()];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:self.curAsset];
    return playerItem;
}




#pragma mark - AVAssetResourceLoaderDelegate

-(BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest{
    
    NSString *url = [self getOriginUrl:loadingRequest.request.URL.absoluteString];
    NSURL *URL = [NSURL URLWithString:url];
  
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:URL];
    
    
    NSString * range = [NSString stringWithFormat:@"bytes=%lld-%lld",loadingRequest.dataRequest.requestedOffset,((long)loadingRequest.dataRequest.requestedLength + loadingRequest.dataRequest.requestedOffset - 1)];

    [request setValue:range forHTTPHeaderField:@"Range"];
    
    BSVideoDlownLoader *downLoader = [[BSVideoDlownLoader alloc]init];
    [downLoader downLoadWithRequest:request];
    [self.requestArr addObject:request];
    
    return YES;
}



-(void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest{

    
    
}




#pragma mark - url
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



@end





