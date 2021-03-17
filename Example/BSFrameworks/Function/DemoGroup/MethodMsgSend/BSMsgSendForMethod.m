//
//  BSMsgSendForMethod.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/3/11.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSMsgSendForMethod.h"
#import <objc/runtime.h>
 
@interface BSMsgSendForMethod ()

@end

@implementation BSMsgSendForMethod

/// 方法的消息传递机制
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self performSelector:@selector(foo:) withObject:@"haha"];
}


//-(void)foo:(NSString *)charType{
//
//    NSLog(@"foo == %@",charType);
//}



+(BOOL)resolveClassMethod:(SEL)sel{
    
    return [super resolveClassMethod:sel];
}

//
+(BOOL)resolveInstanceMethod:(SEL)sel{
    NSLog(@"resolveInstanceMethod");
//    if (sel == NSSelectorFromString(@"foo:")) {
//
//        class_addMethod([self class], sel, class_getMethodImplementation([self class], @selector(fooMethod:)), "v:8");
//        return NO;
//    }

    return [super resolveInstanceMethod:sel];
}



-(void)fooMethod:(NSString *)charType{
    NSLog(@"fooMethod == %@",charType);
}


-(id)forwardingTargetForSelector:(SEL)aSelector{
    NSLog(@"forwardingTargetForSelector");
    return nil;//[BSMsgSendForwardingTemp alloc];
}


-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSLog(@"methodSignatureForSelector");
    
    if (aSelector == @selector(foo:)) {
        return  [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }
    
    return [super methodSignatureForSelector:aSelector];
}


-(void)forwardInvocation:(NSInvocation *)anInvocation{
    NSLog(@"forwardInvocation");
    
    SEL sel = anInvocation.selector;
    
    BSMsgSendForwardingTemp *temp = [[BSMsgSendForwardingTemp alloc]init];

    if ([temp respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:temp];
    }
}



-(void)doesNotRecognizeSelector:(SEL)aSelector{
    NSLog(@"doesNotRecognizeSelector");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


@implementation BSMsgSendForwardingTemp


-(void)foo:(NSString *)charType{
    
    NSLog(@"BSMsgSendForwardingTemp foo == %@",charType);
    
}


@end
