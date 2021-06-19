//
//  BSNotiAndUserdefaultStandard.m
//  BSFrameworks_Example
//
//  Created by dangdang on 2021/4/29.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSNotiAndUserdefaultStandard.h"

@implementation BSNotiAndUserdefaultStandard

#pragma mark - 基础方法
+(void)setObject:(NSObject *)object forKey:(NSString *)key{
    
    if (!key && key.length<0) return;
    if (![object isKindOfClass:[NSObject class]])return;

    [[NSUserDefaults standardUserDefaults]setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSObject *)objectForKey:(NSString *)key{
    
    if (!key && key.length<0) return nil;
    
    return  [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(void)removeObjectForKey:(NSString *)key{
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
}



#pragma mark - 用户

+(void)saveUserInfo:(NSDictionary *)userInfo{
    [self setObject:userInfo forKey:@"user_info"];
}


+(NSDictionary *)getUserInfo{
    return (NSDictionary *)[self objectForKey:@"user_info"];
}


+(void)removeUserInfo{
    [self removeObjectForKey:@"user_info"];
}



@end



@implementation BSNotification


+(void)addObserver:(NSObject *)observer forUserSelector:(SEL)selector{
    
    [[NSNotificationCenter defaultCenter]addObserver:observer selector:selector name:@"userinfo_changed" object:nil];
    
}

+(void)postUserNotiWithObject:(NSObject *)obj parameter:(NSDictionary *)parameter{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"userinfo_changed" object:obj userInfo:parameter];
    
}


+(void)removeUserObserver:(NSObject *)observer{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:@"userinfo_changed" object:nil];
}


@end
