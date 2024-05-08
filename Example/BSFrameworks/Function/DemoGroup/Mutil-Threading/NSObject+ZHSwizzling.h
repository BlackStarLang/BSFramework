//
//  NSObject+ZHSwizzling.h
//  ZongHeng
//
//  Created by 孙震 on 2022/12/15.
//  Copyright © 2022 ZongHeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZHSwizzling)

+ (void)zhExchangeInstanceMethodWithSelfClass:(Class)selfClass
                           originalSelector:(SEL)originalSelector
                           swizzledSelector:(SEL)swizzledSelector;

@end

NS_ASSUME_NONNULL_END
