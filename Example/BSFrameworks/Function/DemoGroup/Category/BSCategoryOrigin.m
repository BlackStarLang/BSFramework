//
//  BSCategoryOrigin.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/3/8.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSCategoryOrigin.h"
#import <objc/runtime.h>


@interface BSCategoryOrigin ()

@property (nonatomic ,strong) NSString *extensionPropertyM;

@end



@implementation BSCategoryOrigin
{
    NSString *_originIvar;
}


/// 对于 +load 方法，本类会先执行，
/// 而category会后执行，但是都会执行

+(void)load{
    NSLog(@"BSCategoryOrigin load");
}


+(void)initialize{
    NSLog(@"BSCategoryOrigin initialize");
}


/// 对于 工厂化 方法，和实例方法相同
/// 只执行 category，由于缓存机制的问题，category执行完，
/// 会加入到缓存中，在执行此方法是，直接拿缓存中的
+(void)factory{
    NSLog(@"factory Origin");
}





-(instancetype)init{
    self = [super init];
    if (self) {
        [self initSubProperty];
    }
    return self;
}


-(void)initSubProperty{
    
    NSLog(@"====== initSubProperty ========");
}



/// category && extension 异同点
///
/// category 可以声明属性，但是不会自动生成实例变量，不会自动生成set、get方法
/// category 创建后(新建文件)，会有对应的 .h & .m 文件
/// category 可以在已有文件中扩展添加（在已有的 .h & 已有的 .m 中都可以）
/// category 的实现（@implementation）写在 .h 中，需要实现setter 和getter方法，否则会报警告，如果放在.m中则只需要实现 setter就解决警告问题（这里只是解决警告问题）
/// category 的实现（@implementation）如果写在.h 中，通过runtime 遍历成员变量，会发现property声明的属性变成了多个，如果我们自己实现对应的setter和getter，发现setter 和getter方法也变成了多个（打印方法：本文中的 showTotalInfo）
/// category 无法使用{}声明成员变量
///
/// extension 只有.h文件
/// extension 可以声明属性，并且会生成对应的实例变量，以及对应的set、get方法
/// extension 的声明不能放在实现后，即 interface 必须要在 implementation 上边
/// extension 可以在已有文件中扩展添加（.h 和 .m 都可以，.h在外面可以直接引用，.m私有，无法在其他类中引用）

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
    // 如果 targetClass = object_getClass([self class]) ,则会打印类方法（factory）
    Class targetClass = object_getClass([self class]);
    targetClass = [self class];
    
    NSLog(@"=================");
    NSLog(@"%@ %@ 元类",targetClass,class_isMetaClass(targetClass)?@"是":@"不是");
    NSLog(@"=================");
    ///通过元类的判断，可以发现，类方法存放在元类中
    Method * methodList = class_copyMethodList(targetClass, &mcount);
    
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


//#pragma mark - [CategoryOrigin prive1 声明和实现]
///// .m 中声明的 category，由于.m 文件私有，
///// 所以在.m 文件中声明category ，基本没什么意义
//@interface BSCategoryOrigin (prive1)
//
///// 虽然声明了属性，但是没有成员变量
//@property (nonatomic ,strong) NSString *categoryPropertyM;
//
//@end
//
//
//@implementation BSCategoryOrigin (prive1)
//
//-(void)setCategoryPropertyM:(NSString *)categoryPropertyM{
//
//}
//
//@end


//#pragma mark - [CategoryOrigin prive2 实现]
//@implementation BSCategoryOrigin (prive2)
//
//-(void)setCategoryPropertyX:(NSString *)categoryPropertyX{
//
//}

//@end

