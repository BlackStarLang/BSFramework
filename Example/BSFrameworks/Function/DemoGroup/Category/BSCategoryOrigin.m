//
//  BSCategoryOrigin.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/3/8.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSCategoryOrigin.h"
#import <objc/runtime.h>
//#import "BSCategoryOrigin+BSCCExtension.h"



@interface BSCategoryOrigin ()

@property (nonatomic ,strong) NSString *extensionPropertyM;

@end



@implementation BSCategoryOrigin
{
    NSString *_originIvar;
}


-(instancetype)init{
    self = [super init];
    if (self) {
        [self initSubProperty];
    }
    return self;
}


-(void)initSubProperty{

}



/// category && extension 异同点
///
/// category 可以声明属性，但是不会自动生成实例变量，不会自动生成set、get方法
/// category 创建后，会有对应的 .h & .m 文件
/// category 可以在已有文件中扩展添加（在已有的 .h & 已有的 .m 中都可以）
/// category 的实现（@implementation）写在 .h 文件中，会使 property 有多个，都写在.m中，无问题
/// category 的 .m 文件无法使用{}声明成员变量
///
/// extension 只有.h文件
/// extension 可以声明属性，并且会生成对应的实例变量，以及对应的set、get方法
/// extension 的声明不能放在实现后，即 interface 必须要在 implementation 上边
/// extension 可以在已有文件中扩展添加（.h 和 .m 都可以，.h在外表可以直接引用，.m私有，无法引用）

/// 如果将声明放在 .m 文件中，无论是 extension 还是 category ，都将是私有的，
/// 那么 extension 已经满足所有需求，对于 category 就没有什么意义了，所以对于 category，声明还是应该放在.h文件中，
/// 或者创建单独文件作为category

-(void)showTotalInfo{
    
    unsigned icount = 0;
    Ivar *ivars = class_copyIvarList([self class], &icount);
    
    /// 实例变量列表
    for (int i = 0; i<icount; i++) {
        Ivar ivar = ivars[i];
        const char* name = ivar_getName(ivar);
        NSString *ocName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        NSLog(@"ivar:%@",ocName);
    }
    
    free(ivars);
    
    /// 属性列表
    unsigned pcount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &pcount);
    
    for (int i = 0; i<pcount; i++) {
        objc_property_t property = properties[i];
        const char* name = property_getName(property);
        NSString *ocName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        NSLog(@"property:%@",ocName);
    }
    free(properties);
    
    
    /// 方法列表
    unsigned mcount ;
    Method * methodList = class_copyMethodList([self class], &mcount);
    
    for (int i = 0; i<mcount; i++) {
        Method method = methodList[i];
        SEL selMethod = method_getName(method);
        NSString *selName = NSStringFromSelector(selMethod);
        NSLog(@"method:%@ ",selName);
    }
    free(methodList);
}


-(void)test{
    NSLog(@"test");
}


@end



@interface BSCategoryOrigin (prive1)

/// 虽然声明了属性，但是没有成员变量
@property (nonatomic ,strong) NSString *categoryPropertyM;

@end


@implementation BSCategoryOrigin (prive1)



@end
