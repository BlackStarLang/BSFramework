//
//  BSCategoryOrigin.h
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/3/8.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

///====================================
/// MARK: Class 说明 分类测试
/// Desc: 如果需要测试其中规则，需要将所有代码注释打开
/// 目前看着比较乱，所以把分类全部注释掉了。
/// 测试需要注意"BSCategoryOrigin+Mutimethod.h"这个分类，单独创建的类

///
/// Author : BlackStar
///====================================

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSCategoryOrigin : NSObject

{
    @private
    NSString *prive_x;
}

@property (nonatomic ,strong) NSString *originProperty;

+(void)factory;

-(void)showTotalInfo;

-(void)test;

@end


#pragma mark - [CategoryOrigin prive 声明和实现]
/// 声明
@interface BSCategoryOrigin (prive)

/// 虽然声明了属性，但是没有成员变量
@property (nonatomic ,strong) NSString *categoryPropertyH;

@end

/// 实现
//@implementation BSCategoryOrigin (prive)
////
////-(void)setCategoryPropertyH:(NSString *)categoryPropertyH{
////
////}
////
////-(NSString *)categoryPropertyH{
////    return @"categoryPropertyH";
////}
//
//@end


//#pragma mark - [CategoryOrigin prive2 声明]
//@interface BSCategoryOrigin (prive2)
//
//@property (nonatomic ,strong) NSString *categoryPropertyX;
//
//+(void)factory;
//
//@end



//#pragma mark - [CategoryOrigin - extension]
///// .h 文件中的 extension ，自动生成实例变量，set、get 方法
//@interface BSCategoryOrigin ()
//
//@property (nonatomic ,strong) NSString *extensionPropertyH;
//
//@end



NS_ASSUME_NONNULL_END
