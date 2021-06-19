//
//  BSNotiAndUserdefaultStandard.h
//  BSFrameworks_Example
//
//  Created by dangdang on 2021/4/29.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BSNotiAndUserdefaultStandard : NSObject

+(void)setObject:(NSObject *)object forKey:(NSString *)key;
+(NSObject *)objectForKey:(NSString *)key;
+(void)removeObjectForKey:(NSString *)key;

#pragma mark - 用户

+(void)saveUserInfo:(NSDictionary *)userInfo;
+(NSDictionary *)getUserInfo;
+(void)removeUserInfo;

@end



@interface BSNotification : NSObject

+(void)addObserver:(NSObject *)observer forUserSelector:(SEL)selector;
+(void)postUserNotiWithObject:(NSObject *)obj parameter:(NSDictionary *)parameter;
+(void)removeUserObserver:(NSObject *)observer;


@end
