//
//  BSSocketManager.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2021/3/29.
//

#import <Foundation/Foundation.h>
#import "BSSocketProtocal.h"
NS_ASSUME_NONNULL_BEGIN

@interface BSSocketManager : NSObject

+(instancetype)shareManager;

@property (nonatomic ,weak)id<BSSocketProtocal>delegate;

-(void)connect;

-(void)disConnect;

-(void)sendMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
