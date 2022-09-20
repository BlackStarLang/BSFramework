//
//  BSCategoryOrigin+Mutimethod.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/3/8.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSCategoryOrigin+Mutimethod.h"
#import <objc/runtime.h>

@interface BSCategoryOrigin (Mutimethod)

@property (nonatomic ,strong) NSString *kvoTest;
+(void)priveFactory;
@end


@implementation BSCategoryOrigin (Mutimethod)

//+(void)factory{
//    NSLog(@"factory category");
//}

+(void)priveFactory{
    NSLog(@"priveFactory category");
}

//+(void)load{
//    NSLog(@"BSCategoryOrigin category load");
//}
//
//+(void)initialize{
//    NSLog(@"BSCategoryOrigin category initialize");
//}

// 与本类同名方法
-(void)test{

//    NSLog(@"testtest");
    unsigned mcount ;
    Method * methodList = class_copyMethodList([self class], &mcount);
    
    for (int i = 0; i<mcount; i++) {
        Method method = methodList[i];
        SEL selMethod = method_getName(method);
        NSString *selName = NSStringFromSelector(selMethod);
        NSLog(@"method:%@ ",selName);
    }
}

//// 新方法
//-(void)newTest{
//    NSLog(@"newTest");
//}
//
//// 属性 set/get 方法
//-(void)setAge:(NSString *)age{
//
//}
//
//-(NSString *)age{
//
//    return @"1";
//}

-(void)setKvoTest:(NSString *)kvoTest{
    objc_setAssociatedObject(self, @"kvoTest", kvoTest, OBJC_ASSOCIATION_COPY);
}


-(NSString *)kvoTest{
    return objc_getAssociatedObject(self, @"kvoTest");
}


@end
