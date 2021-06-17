//
//  BSVideoPreLoadManager.h
//  BSFrameworks
//
//  Created by dangdang on 2021/6/16.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSVideoPreLoadManager : NSObject

-(AVPlayerItem *)getPlayerItemWithUrls:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
