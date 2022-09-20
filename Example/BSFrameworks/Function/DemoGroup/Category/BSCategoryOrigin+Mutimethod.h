//
//  BSCategoryOrigin+Mutimethod.h
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/3/8.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSCategoryOrigin.h"

NS_ASSUME_NONNULL_BEGIN

@interface BSCategoryOrigin (Mutimethod)

//+(void)factory;  允许重复定义方法，不会报错，
//但是是否在分类里重复定义方法，不影响他的执行结果，但是会影响方法列表中的个数
//如果在这里定义了 factory ，那么 methodList 里，打印会出现两个 factory
/// 虽然声明了属性，但是没有成员变量
@property (nonatomic ,strong) NSString *categoryProperty;


@end

NS_ASSUME_NONNULL_END


