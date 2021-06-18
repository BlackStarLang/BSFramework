//
//  BSVideoPreLoadCache.m
//  BSFrameworks
//
//  Created by dangdang on 2021/6/16.
//

#import "BSVideoPreLoadCache.h"

#define BS_CACHE            @"BS_CACHE"
#define Documents           @"Documents"
#define Date_Formatter      @"yyyy-MM-dd HH"



@interface BSVideoPreLoadCache ()

@property (nonatomic , strong)NSMutableArray *dataCaches;

@end



@implementation BSVideoPreLoadCache

#pragma mark - 读写操作

#pragma mark 写入缓存
-(void)saveVideoCacheWithData:(NSData *)cacheData fileUrl:(NSString *)fileUrl{
    
    BSVideoPreLoadCacheModel *cacheModel = [[BSVideoPreLoadCacheModel alloc]init];
    cacheModel.data = cacheData;
    cacheModel.fileUrl = fileUrl;
    [self.dataCaches addObject:cacheModel];
    
    @synchronized (self) {
        [self writeDateToFile:cacheModel];
    }
}


#pragma mark 读取缓存
-(NSData *)getVideoCacheWithFileUrl:(NSString *)fileUrl{
    
    NSString *filePath = [[NSUserDefaults standardUserDefaults]objectForKey:fileUrl];
    
    NSError *error = nil;
    NSData *cacheData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedAlways error:&error];
    if (error) {
        NSLog(@"read video cache fail : %@",error);
        return nil;
    }
    return cacheData;
}


#pragma mark 将数据写入文件中
-(void)writeDateToFile:(BSVideoPreLoadCacheModel *)cacheModel{
    
    NSString *filePath = [[NSUserDefaults standardUserDefaults]objectForKey:cacheModel.fileUrl];
    
    if (!filePath) {
        
        filePath = [self getFilePathWithFileName:[cacheModel.fileUrl lastPathComponent]];
        [[NSUserDefaults standardUserDefaults]setObject:filePath forKey:cacheModel.fileUrl];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createFileAtPath:filePath contents:cacheModel.data attributes:nil];
        
    }else{
        
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        [handle seekToEndOfFile];
        [handle writeData:cacheModel.data];
        [handle closeFile];
    }
    
    NSLog(@"save path : %@",filePath);
}

#pragma mark - 路径相关 ,之所以用时间做路径，是为了缓存暴增情况下，使用时间去做缓存清理的维度
#pragma mark 获取 存储的缓存文件路径
-(NSString *)getFilePathWithFileName:(NSString *)fileName{
    
    NSString *documentPath = [self getDocumentPath];
    NSString *datePath = [self getCurrentDatePath];

    NSString *filePath = [documentPath stringByAppendingPathComponent:datePath];
    
    /// 创建缓存路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExist = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];

    if (!isDir || !isExist) {
        NSError *error = nil;
        
        BOOL success = [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!success || error) {
            NSLog(@"create file path fail : %@",error);
            return nil;
        }
    }
    
    return [filePath stringByAppendingPathComponent:fileName];
}


#pragma mark 获取 Documents 下的自定义路径，用于存储缓存文件
-(NSString *)getDocumentPath{
    
    NSString *homePath = [NSHomeDirectory() stringByAppendingPathComponent:Documents];
    NSString *mainPath = [homePath stringByAppendingPathComponent:BS_CACHE];
    
    return mainPath;
}


#pragma mark 获取当前的日期作为路径
-(NSString *)getCurrentDatePath{
    
    NSDate *todayDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:Date_Formatter];
    
    NSString *dateStr = [formatter stringFromDate:todayDate];
    return dateStr;
}


#pragma mark - 属性初始化

-(NSMutableArray *)dataCaches{
    if (!_dataCaches) {
        _dataCaches = [NSMutableArray array];
    }
    return _dataCaches;
}


@end



#pragma mark - 缓存模型
@implementation BSVideoPreLoadCacheModel




@end
