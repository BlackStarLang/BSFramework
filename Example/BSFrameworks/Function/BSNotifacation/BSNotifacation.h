//
//  BSNotifacation.h
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/6/19.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - 回调
@interface BSNotifacation : NSObject


/// 自定义 kvo
/// @param obsever 监听者
/// @param object 被监听者
/// @param keyForSel 监听的 setter 方法
/// 例：监听属性name，那么 keyForSel = @selector(setName:)
/// @param change 回调的新旧值
+(void)BSNotifacationAddObsever:(id)obsever object:(id)object keyForSel:(SEL )keyForSel callBack:(void(^)(id oldValue,id newValue))change;


@end



#pragma mark - 监听类
@interface BSNotifacationObject : NSObject

+(instancetype)notiObjectWithObsever:(id)obsever object:(id)object keyForSel:(SEL )keyForSel callBack:(void(^)(id oldValue,id newValue))change;


@property (nonatomic ,copy) void(^change)(id oldValue,id newValue);

@property (nonatomic ,weak) id obsever;
@property (nonatomic ,weak) id object;
@property (nonatomic ,assign) SEL keyForSel;
@property (nonatomic ,copy) NSString *propertyName;

@property (nonatomic ,assign) Class notiClass;

@end
