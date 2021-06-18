//
//  BSVideoPreLoadCache.h
//  BSFrameworks
//
//  Created by dangdang on 2021/6/16.
//

#import <Foundation/Foundation.h>



@interface BSVideoPreLoadCache : NSObject

/// 存储视频缓存数据
-(void)saveVideoCacheWithData:(NSData *)cacheData fileUrl:(NSString *)fileUrl;

/// 获取视频缓存
-(NSData *)getVideoCacheWithFileUrl:(NSString *)fileUrl;

@end





@interface BSVideoPreLoadCacheModel : NSObject

@property (nonatomic , strong) NSData *data;

@property (nonatomic , copy) NSString *fileUrl;


@end
