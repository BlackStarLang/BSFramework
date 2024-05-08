//
//  NSMutableArray+ZHSafe.m
//  ZongHeng
//
//  Created by 孙震 on 2022/12/15.
//  Copyright © 2022 ZongHeng. All rights reserved.
//

#import "NSMutableArray+ZHSafe.h"
#import "NSObject+ZHSwizzling.h"
#import <objc/runtime.h>

@implementation NSMutableArray (ZHSafe)

///TODO: lzq test 上线需要打开

#pragma mark --- init method

+ (void)load {
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        //替换 objectAtIndex:
        NSString *tmpGetStr = @"objectAtIndex:";
        NSString *tmpSafeGetStr = @"zhSafeMutable_objectAtIndex:";
        [NSObject zhExchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpGetStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeGetStr)];

        //替换 removeObjectsInRange:
        NSString *tmpRemoveStr = @"removeObjectsInRange:";
        NSString *tmpSafeRemoveStr = @"zhSafeMutable_removeObjectsInRange:";


        [NSObject zhExchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpRemoveStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeRemoveStr)];


        //替换 insertObject:atIndex:
        NSString *tmpInsertStr = @"insertObject:atIndex:";
        NSString *tmpSafeInsertStr = @"zhSafeMutable_insertObject:atIndex:";


        [NSObject zhExchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpInsertStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeInsertStr)];

        //替换 removeObject:inRange:
        NSString *tmpRemoveRangeStr = @"removeObject:inRange:";
        NSString *tmpSafeRemoveRangeStr = @"zhSafeMutable_removeObject:inRange:";

        [NSObject zhExchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpRemoveRangeStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeRemoveRangeStr)];

        //替换 replaceObjectAtIndex:withObject:
        NSString *tmpReplaceIndexStr = @"replaceObjectAtIndex:withObject:";
        NSString *tmpSafeReplaceIndexStr = @"zhSafeMutable_replaceObjectAtIndex:withObject:";

        [NSObject zhExchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpReplaceIndexStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeReplaceIndexStr)];


        // 替换 objectAtIndexedSubscript
        NSString *tmpSubscriptStr = @"objectAtIndexedSubscript:";
        NSString *tmpSecondSubscriptStr = @"zhSafeMutable_objectAtIndexedSubscript:";
        [NSObject zhExchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpSubscriptStr)                                     swizzledSelector:NSSelectorFromString(tmpSecondSubscriptStr)];
    });

}

#pragma mark --- implement method

/**
 取出NSArray 第index个 值

 @param index 索引 index
 @return 返回值
 */
- (id)zhSafeMutable_objectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self zhSafeMutable_objectAtIndex:index];
}

/**
 NSMutableArray 移除 索引 index 对应的 值

 @param range 移除 范围
 */
- (void)zhSafeMutable_removeObjectsInRange:(NSRange)range {

    if (range.location > self.count) {
        return;
    }

    if (range.length > self.count) {
        return;
    }

    if ((range.location + range.length) > self.count) {
        return;
    }

    return [self zhSafeMutable_removeObjectsInRange:range];
}


/**
 在range范围内， 移除掉anObject

 @param anObject 移除的anObject
 @param range 范围
 */
- (void)zhSafeMutable_removeObject:(id)anObject inRange:(NSRange)range {
    if (range.location > self.count) {
        return;
    }

    if (range.length > self.count) {
        return;
    }

    if ((range.location + range.length) > self.count) {
        return;
    }

    if (!anObject){
        return;
    }


    return [self zhSafeMutable_removeObject:anObject inRange:range];

}

/**
 replace object at index

 @param anObject 新值
 @param index 索引 index
 */
- (void)zhSafeMutable_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index >= self.count){
        return;
    }

    if (!anObject){
        return;
    }

    [self zhSafeMutable_replaceObjectAtIndex:index withObject:anObject];
}

/**
 NSMutableArray 插入 新值 到 索引index 指定位置

 @param anObject 新值
 @param index 索引 index
 */
- (void)zhSafeMutable_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > self.count) {
        return;
    }

    if (!anObject){
        return;
    }

    [self zhSafeMutable_insertObject:anObject atIndex:index];
}


/**
 取出NSArray 第index个 值 对应 __NSArrayI

 @param idx 索引 idx
 @return 返回值
 */
- (id)zhSafeMutable_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count){
        return nil;
    }
    return [self zhSafeMutable_objectAtIndexedSubscript:idx];
}

@end
