//
//  BSCategryOriginSubClass.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2022/9/7.
//  Copyright © 2022 blackstar_lang@163.com. All rights reserved.
//

#import "BSCategryOriginSubClass.h"
#import "BSCategoryOrigin+Mutimethod.h"
#import <objc/runtime.h>

@implementation BSCategryOriginSubClass



//私有方法test
-(void)subClassTestMethod{
    
}

-(void)setKvoTest:(NSString *)kvoTest{
    NSLog(@"haha");
}

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
    Class targetClass = object_getClass([self class]);//[self class];
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

@end
