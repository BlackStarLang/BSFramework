//
//  BSCategoryOrigin.h
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/3/8.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSCategoryOrigin : NSObject

@property (nonatomic ,strong) NSString *originProperty;

-(void)showTotalInfo;

-(void)test;

@end



/// .h 文件中的 category ，自动生成实例变量，set、get 方法

@interface BSCategoryOrigin (prive)

/// 虽然声明了属性，但是没有成员变量
@property (nonatomic ,strong) NSString *categoryPropertyH;

@end


@implementation BSCategoryOrigin (prive)



@end


/// .h 文件中的 extension ，自动生成实例变量，set、get 方法
@interface BSCategoryOrigin ()

@property (nonatomic ,strong) NSString *extensionPropertyH;

@end



NS_ASSUME_NONNULL_END
