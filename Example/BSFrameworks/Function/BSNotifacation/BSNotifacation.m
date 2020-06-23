//
//  BSNotifacation.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/6/19.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSNotifacation.h"
#import <objc/objc.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "BSObjcPerson.h"

@interface BSNotifacation ()


@end

@implementation BSNotifacation


/// 自定义 kvo
/// @param obsever 监听者
/// @param object 被监听者
/// @param keyForSel 监听的 属性名称 方法
/// 例：监听属性name，那么 keyForSel = @selector(setName:)
/// @param change 回调的新旧值

+(void)BSNotifacationAddObsever:(id)obsever object:(id)object keyForSel:(SEL )keyForSel callBack:(void(^)(id oldValue,id newValue))change{

    // ==================================================
    // 新建 notiobject 类,用于处理回调，动态生成对象 等操作
    // 思路：调用一次监听 就生成一个 自定义的监听对象
    // 监听对象初始化后，已经重写了被监听对象object的class方法和setter方法
    // 所以不要轻易调用 class ，应使用 object_getClass 获取 class ，
    // 以免使用的时候混淆 class 的真正面目
    // ==================================================
    BSNotifacationObject *notiObj = [BSNotifacationObject notiObjectWithObsever:obsever object:object keyForSel:keyForSel callBack:change];
    
    
    
    // ==================================================
    // 将 notiObj（BSNotifacationObject） 添加到数组中，然后 关联给 objcCls
    // 目的：这样一个实例对象的所有监听就都和他的 isa 相关联，
    // 回调的时候，可以根据isa指向的class直接拿到数组，
    // 再根据 方法名 去进行批量的block回调
    // ==================================================
    Class objcCls = object_getClass(object);
    
    NSMutableArray *mutNotiObj = objc_getAssociatedObject(objcCls, "notiObj");
    if (!mutNotiObj) {
        mutNotiObj = [NSMutableArray array];
    }
    [mutNotiObj addObject:notiObj];
    
    objc_setAssociatedObject(objcCls, "notiObj", mutNotiObj, OBJC_ASSOCIATION_RETAIN);
    
//    NSLog(@"关联对象：%@",objc_getAssociatedObject(objcCls, "notiObj"));
}


@end



#pragma mark - 自定义监听对象

@interface BSNotifacationObject ()


@end

@implementation BSNotifacationObject

#pragma mark -  初始化

+(instancetype)notiObjectWithObsever:(id)obsever object:(id)object keyForSel:(SEL)keyForSel callBack:(void (^)(id, id))change{
    
   return [[[self class]alloc]initNotiObjectWithObsever:obsever object:object keyForSel:keyForSel callBack:change];
}


-(instancetype)initNotiObjectWithObsever:(id)obsever object:(id)object keyForSel:(SEL)keyForSel callBack:(void (^)(id, id))change{
    
    self = [super init];
    if (self) {
        
        self.change = change;
        self.obsever = obsever;
        self.object = object;
        self.keyForSel = keyForSel;
        self.propertyName = NSStringFromSelector(keyForSel);
        
        [self dynamicCreatObject];
        [self exchangeDealloc:self.object];
    }
    return self;
}


#pragma mark - 获取 setter 和 getter 方法

// 根据 keyForSel 获取 setter name
-(SEL)selForGetter{
    
    NSString *name = NSStringFromSelector(self.keyForSel);
    NSString *firsWord = [name substringWithRange:NSMakeRange(0, 1)];
    firsWord = firsWord.uppercaseString;
    
    NSString *otherWord = [name substringWithRange:NSMakeRange(1, name.length - 1)];
    NSString *selectorName = [@"get" stringByAppendingFormat:@"%@%@",firsWord,otherWord];
   
    return NSSelectorFromString(selectorName);
}


// 根据 keyForSel 获取 getter name
-(SEL)selForSetter{
    
    NSString *name = NSStringFromSelector(self.keyForSel);
    NSString *firsWord = [name substringWithRange:NSMakeRange(0, 1)];
    firsWord = firsWord.uppercaseString;
    
    NSString *otherWord = [name substringWithRange:NSMakeRange(1, name.length - 1)];

    NSString *selectorName = [@"set" stringByAppendingFormat:@"%@%@:",firsWord,otherWord];
   
    return NSSelectorFromString(selectorName);
}


#pragma mark - 动态创建 子类 ，并为其添加方法
-(void)dynamicCreatObject{
    
    /// 动态生成继承 self.object 的子类 BSNoti_object
    /// 如果 noti 类 不存在，则创建 noti 类
    Class class = object_getClass(self.object);
    NSString *notiClassName = NSStringFromClass(class);
    if (![notiClassName hasPrefix:@"BSNoti_"]) {
        notiClassName = [NSString stringWithFormat:@"BSNoti_%@",NSStringFromClass(class)];
    }
    const char *charClassName = [notiClassName cStringUsingEncoding:NSUTF8StringEncoding];
    
    Class notiClass = objc_getClass(charClassName);
    
    if (!notiClass) {
        notiClass = objc_allocateClassPair(class, charClassName, 0);

        objc_registerClassPair(notiClass);
    }
    self.notiClass = notiClass;
    // 将 object 的isa 指向 notiClass，
    // 即 调用 object 的时候 其实object已经变成了BSNoti_object
    object_setClass(self.object, notiClass);


    /// 如果方法还没有，则 给 notiClass 增加 方法
    if (![self notiClass:notiClass hasSel:[self selForSetter]]) {
       
        // 将 keyForSel 的 IMP 改成 自定义 BSSetter 方法
        Class superClass = class_getSuperclass(notiClass);
        Method keyMethod = class_getInstanceMethod(superClass, [self selForSetter]);
        const char *keyMethodType = method_getTypeEncoding(keyMethod);
       
        char argType[128] = {};
        method_getArgumentType(keyMethod, 2, argType, 128);
        
        NSString *typeName = [NSString stringWithUTF8String:argType];
//        NSLog(@"method arg type = %@",typeName);
        
        // **********************************************************
        // 如果是 id 类型的赋值，则IMP为setterNew，
        // 如果是int类型，则是setterInt，
        // 其他类型如float、double、bool也需要单独写（目前只写了int类型）
        // int 的不能使用 float ，double 去赋值，数值会出错，暂不知道问题，
        // 但是猜测 float和double，int和bool 可以使用同一个IMP
        // **********************************************************
        IMP targetImp = (IMP)setterNew;
        if ([typeName isEqualToString:@"i"]) {
            targetImp = (IMP)setterInt;
        }
        
        // **********************************************************
        // IMP 可以使用 C method 和 OC method 两种方法获取
        // Method instanceMethod = class_getInstanceMethod([self class], @selector(BSSetter:));
        // IMP ocImp = (IMP)method_getImplementation(instanceMethod);
        // **********************************************************
        BOOL addSuccess = class_addMethod(notiClass, [self selForSetter], targetImp , keyMethodType);
        
        if (!addSuccess) {
            NSLog(@"添加方法失败");
        }
    }
    
    // **********************************************
    // 重写 class 方法，使子类的 class 方法返回 父类
    // ***********************************************
    SEL classSel = NSSelectorFromString(@"class");
    if (![self notiClass:notiClass hasSel:classSel]) {
        
        Class superClass = [self.object superclass];
        Method keyMethod = class_getInstanceMethod(superClass, @selector(class));
        const char *keyMethodType = method_getTypeEncoding(keyMethod);
        
        IMP classImp = class_getMethodImplementation([self class], @selector(BSNotiClass));
        class_addMethod(notiClass, classSel, classImp, keyMethodType);
    }
}

#pragma mark 用于判断 class 是否含有 某方法
-(BOOL)notiClass:(Class)class hasSel:(SEL)sel{
  
    unsigned int count;
    
    Method *methodList = class_copyMethodList(class, &count);
    
    NSMutableArray *methodMut = [NSMutableArray array];
    for (int i = 0; i<count; i++) {
        Method method = methodList[i];
        SEL methodName = method_getName(method);
        [methodMut addObject:NSStringFromSelector(methodName)];
    }
    
//    NSLog(@"\nmethodList=\n%@",methodMut);
    
    NSString *oldSetName = NSStringFromSelector(sel);
    if ([methodMut containsObject:oldSetName]) {
        return YES;
    }
    return NO;
}




#pragma mark - 重写 class 方法 和 setter 方法

#pragma mark 重写 class 方法，返回父类的class
-(Class)BSNotiClass{
    Class baseCls = object_getClass(self);
    Class supperCls = class_getSuperclass(baseCls);
    return  supperCls;
}

//#pragma mark 重写setter方法  OC版本 setter 方法（对象赋值）
//-(void)BSSetter:(id)value{
//
//    Class objcClass = object_getClass(self);
//    NSMutableArray *oldMut = objc_getAssociatedObject(objcClass, "notiObj");
//    NSMutableArray *tempArr = [oldMut copy];
//
//
//    NSMutableArray *targetMut = [NSMutableArray array];
//    id oldValue = nil;
//    SEL selector = nil;
//
//    for (BSNotifacationObject *bsNotiObj in tempArr) {
//
//        if (bsNotiObj.obsever) {
//            if (self==bsNotiObj.object) {
//                [targetMut addObject:bsNotiObj];
//                oldValue = [bsNotiObj.object valueForKey:bsNotiObj.propertyName];
//                selector = [bsNotiObj selForSetter];
//            }
//        }else{
//            [oldMut removeObject:bsNotiObj];
//        }
//    }
//
//
//    if (selector) {
//        // 通知后 赋值
//        Class superClass = [self class];
//
//        Method superSet = class_getInstanceMethod(superClass, selector);
//        IMP superImp = method_getImplementation(superSet);
//        ((void(*)(id, SEL, id))superImp)(self, selector, value);
//
//    }else{
//        NSLog(@"监听对象不存在");
//    }
//
//
//    for (BSNotifacationObject *bsNotiObj in tempArr) {
//        bsNotiObj.change(oldValue, value);
//    }
//}

#pragma mark id 类型的 setter 方法，C语言方法
void setterNew(id self , SEL _cmd , id value){
    
    Class objcClass = object_getClass(self);
    NSMutableArray *oldMut = objc_getAssociatedObject(objcClass, "notiObj");
    NSMutableArray *tempArr = [oldMut copy];
    
    NSMutableArray *targetMut = [NSMutableArray array];
    id oldValue = nil;
    SEL selector = nil;

    for (BSNotifacationObject *bsNotiObj in tempArr) {

        if (bsNotiObj.obsever) {
            if (self==bsNotiObj.object && [bsNotiObj selForSetter]==_cmd) {
                [targetMut addObject:bsNotiObj];
                oldValue = [bsNotiObj.object valueForKey:bsNotiObj.propertyName];
                selector = [bsNotiObj selForSetter];
            }
        }else{
            [oldMut removeObject:bsNotiObj];
        }
    }
    
    
    if (selector) {
        // 通知后 赋值
        Class superClass = [self class];
        
        Method superSet = class_getInstanceMethod(superClass, selector);
        IMP superImp = method_getImplementation(superSet);
        ((void(*)(id, SEL, id))superImp)(self, selector, value);
        
    }else{
        NSLog(@"监听对象不存在");
    }
    
    
    for (BSNotifacationObject *bsNotiObj in targetMut) {
        bsNotiObj.change(oldValue, value);
    }
}

#pragma mark  int 类型的 setter 方法 C语言方法
void setterInt(id self , SEL _cmd , int value){
    
    Class objcClass = object_getClass(self);

    NSMutableArray *oldMut = objc_getAssociatedObject(objcClass, "notiObj");
    NSMutableArray *tempArr = [oldMut copy];

    
    NSMutableArray *targetMut = [NSMutableArray array];
    NSString * oldValue = 0;
    SEL selector = nil;
    
    for (BSNotifacationObject *bsNotiObj in tempArr) {

        if (bsNotiObj.obsever) {
            if (self==bsNotiObj.object && [bsNotiObj selForSetter]==_cmd) {
                [targetMut addObject:bsNotiObj];
                oldValue = [bsNotiObj.object valueForKey:bsNotiObj.propertyName];
                selector = [bsNotiObj selForSetter];
            }
        }else{
            [oldMut removeObject:bsNotiObj];
        }
    }
    
    
    if (selector) {
        //  通知后 赋值
        Class superClass = [self class];
        
        Method superSet = class_getInstanceMethod(superClass, selector);
        IMP superImp = method_getImplementation(superSet);
        ((void(*)(id, SEL, int))superImp)(self, selector, value);
        
    }else{
        NSLog(@"监听对象不存在");
    }
    
    for (BSNotifacationObject *bsNotiObj in targetMut) {
        bsNotiObj.change(oldValue, [NSString stringWithFormat:@"%d",value]);
    }
}



#pragma mark - 检测 obsever 是否存在，如果不存在，则把不需要监听的对象移除

-(void)exchangeDealloc:(id)object{
    
//    SEL dealloc = NSSelectorFromString(@"dealloc");
//    Method oldDealloc = class_getInstanceMethod([self.obsever class], dealloc);
//    Method ObsDealloc = class_getInstanceMethod([self class], @selector(obseverDealloc));
//    method_exchangeImplementations(oldDealloc, ObsDealloc);
//
//    objc_setAssociatedObject(self.obsever, "noti_object", object, OBJC_ASSOCIATION_RETAIN);
//    objc_setAssociatedObject(self.obsever, "bsnoti_obj", self, OBJC_ASSOCIATION_RETAIN);
}

/// 方法交换，obsever 的 dealloc 和 obseverDealloc 进行交换
/// 主动 调用 dealloc会闪退，没找到解决方案，暂时不做
-(void)obseverDealloc{
    
//    id notiObj = objc_getAssociatedObject(self, "bsnoti_obj");
//    [notiObj obseverDealloc];// 会闪退，因为主动调用了dealloc方法
//
//    id object = objc_getAssociatedObject(self, "noti_object");
//    Class objClass = object_getClass(object);
//    NSMutableArray *mutArr = objc_getAssociatedObject(objClass, "notiObj");
//    NSArray *copyArr = [mutArr copy];
//
//    for (BSNotifacationObject *notiObj in copyArr) {
//        if ([notiObj.obsever isEqual: self] || !notiObj.obsever) {
//            [mutArr removeObject:notiObj];
//        }
//    }
}


@end
