//
//  BSBlockController.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/12/30.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import "BSBlockController.h"

@interface BSBlockController ()

@property (nonatomic ,copy) void(^mallocBlock)(NSString * test);

@property (nonatomic ,strong) BlockTest *test;

@end


@implementation BSBlockController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self blockType]; // 类型研究
    
    [self variables];   // 变量截获验证
}


/// Block 有三种类型，确切的说是block的class（isa）
/// - 全局block :     __NSGlobalBlock__ (_NSConcreteGlobalBlock)
/// - 栈block  :      __NSStackBlock__  (_NSConcreteStackBlock)
/// - 堆block  :      __NSMallocBlock__ (_NSConcreteMallocBlock)

/// Block 的实例其实只有两种
/// __NSGlobalBlock__
/// __NSMallocBlock__
/// 他不会产生stack类型的实例，StackBlock类实例化后，
/// 一定是MallocBlock

/// 总结
/// block 在 ARC 下，引入外部变量前提下
/// 下列情况下会将block从栈拷贝到堆
///
/// 1、Block作为函数返回值返回时
/// 2、带有 useringBlock 的 Cocoa 方法或者 GCD 的API传递Block时候
/// 3、将 block 赋给带有 __strong 修饰符的 变量
///

/// 为什么属性block要使用copy修饰？
/// 实际上使用 strong 和 copy 是一样的,但是苹果官方建议我们使用copy,
/// 因为我们在操作block的时候，要在堆上操控，使用strong，系统也会帮我们copy。
/// 但是按照代码规范来说，语义和代码保持一致，所以使用copy更为恰当
///
///
/// 如果使用weak声明block，然后使用 _mallocBlock 打印，则是 static 类型 block
/// 使用 self.mallocBlock 则是 __NSMallocBlock__

#pragma mark - block 类型
-(void)blockType{
    
    [self globalBlockType]; // 全局
    [self stackBlockType];  // 栈Block
    [self mallocBlockType]; // 堆Block
}




/// 不使用 外部变量，无论哪种方式声明 block
/// 都是 _NSConcreteGlobalBlock 类型
/// 并且Class都是 __NSGlobalBlock__

-(void)globalBlockType{
    
    // 不使用外部变量，都为 global 类型
    
    NSLog(@"============global start=============");
    
    // 属性
    self.mallocBlock = ^(NSString *test) {
        NSLog(@"global block 1 : %@",test);
    };
    
    self.mallocBlock(@"first Block test");
    NSLog(@"%@",self.mallocBlock);
    NSLog(@"%@",[self.mallocBlock class]);

    
    
    // 临时变量
    void(^pblock)(NSString *) = ^(NSString *ss){
        NSLog(@"global block 2 : %@",ss);
    };
    pblock(@"pblock test");
    
    NSLog(@"%@",pblock);
    NSLog(@"%@",[pblock class]);
    
    // 不使用变量
    NSLog(@"%@",^{NSLog(@"test");});
    NSLog(@"%@",[^{NSLog(@"test");} class]);
    
    // BlockTest ,以参数形式存在的block,相当于临时变量
    BlockTest *test = [[BlockTest alloc]init];
    int i = 5;
    [test testBlock:^(NSString * _Nonnull testStr) {
//        i = 6;
        NSLog(@"%d",i);
    }];
    
    NSLog(@"============global end=============\n-");
}



/// stackBlock
///
/// 使用外部临时变量的情况下
/// 虽然不声明成属性和临时变量的block实例都是 __NSMallocBlock__ 实例
/// 但是他们的 isa 指向的是 __NSStackBlock__
///
-(void)stackBlockType{
    
    // 不声明属性和变量，并且使用外部变量，为static类型
    // 但是实际上这种 block 没有意义
    
    NSLog(@"============stack start=============");
    
//   __weak NSString *tempStr = @"test";
    
    // 使用 __unsafe_unretained 才能clang成功
    __unsafe_unretained NSString *tempStr = @"test";

    NSLog(@"%@",^{NSLog(@"%@",tempStr);} );
    NSLog(@"%@",[^{NSLog(@"%@",tempStr);} class]);
    
    
    BlockTest *test = [[BlockTest alloc]init];
    
    [test testBlock:^(NSString * _Nonnull testStr) {
        NSLog(@"%@",tempStr);
    }];
    
    NSLog(@"============stack end=============\n-");
}



/// mallocBlock
///
/// 使用外部临时变量的情况下
/// 声明成属性、临时变量、使用copy 的block实例都是__NSMallocBlock__
/// 并且他们的 isa 也同样指向 __NSMallocBlock__
///
-(void)mallocBlockType{
    
    // 使用外部变量，并且声明称临时变量或者属性，都为 global 类型
    
    NSLog(@"============malloc start=============");
    
    NSString *tempStr = @"tempStr";
    
    // 属性block
    self.mallocBlock = ^(NSString *test) {
        NSLog(@"global block 1 : %@",tempStr);
    };
    
    self.mallocBlock(@"first Block test");
    NSLog(@"%@",_mallocBlock);
    NSLog(@"%@",[_mallocBlock class]);
    
    
    // 临时变量pblock
    void(^pblock)(NSString *) = ^(NSString *ss){
        NSLog(@"global block 2 : %@",tempStr);
    };
    pblock(@"pblock test");
    
    NSLog(@"%@",pblock);
    NSLog(@"%@",[pblock class]);
   
    
    int i = 0;
    NSLog(@"no variables %@",[^{NSLog(@"test %d",i);} copy]);
    NSLog(@"no variables %@",[[^{NSLog(@"test %d",i);} copy]class]);

    NSLog(@"============malloc end=============\n-");
}









/// block 变量截获(block内部使用变量)
/// 分为三种情况：普通临时变量、__block 修饰的临时变量、static修饰的临时变量、属性
///
/// 相关文章 https://www.jianshu.com/p/221d0778dcaa ，https://www.jianshu.com/p/404ff9d3cd42
///
/// 关于全局变量
/// 全局变量因为他在任何地方都可以访问到
/// 所以在block内部并没有对全局变量进行截获，
/// 而是采用直接访问的方式去使用
///
///
/// block 在 ARC 下，下列情况下会将block从栈拷贝到堆
/// 调用 Block 的 copy 方法
/// Block作为函数返回值返回时
/// 带有useringBlock的cocoa 方法或者 GCD 的API传递Block时候
/// 将 block 赋给带有 __strong 修饰符的 _id 类型或者 block 类型时
///
///
/// 当Block从栈中复制到堆，__block也跟着变化：
///
/// 当Block在栈上时，__block的存储域是栈，__block变量被栈上的Block持有。
/// 当Block被复制到堆上时，会通过调用Block内部的copy函数，
/// copy函数内部会调用_Block_object_assign函数。
/// 此时__block变量的存储域是堆，__block变量被堆上的Block持有。
/// 当堆上的Block被释放，会调用Block内部的dispose，
/// dispose函数内部会调用_Block_object_dispose，堆上的__block被释放。
///
/// 当多个栈上的Block使用栈上的__block变量，__block变量被栈上的多个Block持有。
/// 当Block0被复制到堆上时，__block也会被复制到堆上，被堆上Block0持有。
/// Block1仍然持有栈上的__block，原栈上__block变量的__forwarding指向拷贝到堆上之后的__block变量。
/// 当Block1也被复制到堆上时，堆上的__block被堆上的Block0和Block1只有，并且__block的引用计数+1。
/// 当堆上的Block都被释放，__block变量结构体实例引用计数为0，调用_Block_object_dispose，堆上的__block被释放。
///
/// __forwarding指针的使命：确保能正确的访问__block变量。
///
///

#pragma mark - 变量截获

-(void)variables{
    
    [self normalVariables];
    [self __blockVariables];
    [self staticVariables];
    [self propertyVariables];
}



/// 1、普通临时变量
/// 验证：block内捕获外部变量值（不是变量的值，而是地址），而不是指针
/// 虽然block调用前更改了字符串的值，但是block内部没有改变，
///
/// 从结果上看，block 内部是无法修改普通临时变量(OC对象类型)的指针的。但是你可以修改他的值
/// 对于基础类型如 int 他是无法修改其值的
///
/// 总结：与其说block捕获的是值，不如说block捕获的是对象的内存地址
/// 我们拿到这个对象的内存地址，肯定能更改这个内存地址上的值，
/// 但是无法把这个地址变成另外的地址，这也就是为什么block无法在内部修改 string 字符串
/// 却可以修改 NSMutableString 字符串。因为string字符串在赋值的过程中，地址改变了
/// 而 NSMutableString 使用 appendingString，内存地址没变，只是存贮的值修改了
///
-(void)normalVariables{
    
    NSLog(@"===========临时变量============");
    NSString * tempStr = [[NSString alloc]initWithFormat:@"大家好"];
    NSLog(@"原始字符串 : %@ == %p",tempStr,tempStr);
    
    self.mallocBlock = ^(NSString * test) {
        NSLog(@"block 内部 : %@ == %p",tempStr,tempStr);
    };
    
    
    tempStr = @"hello world";
    
    self.mallocBlock(@"test");
    
    NSLog(@"block 外部 : %@ == %p",tempStr,tempStr);

    NSLog(@"");
}



/// 2、__block 修饰的临时变量
/// block 截获__block变量后，会生成一个新的结构体，他有个isa ，是一个对象，
/// 结构体内还有一个值对应着外部变量的值。也就是说block截获外部变量后又生成了一个新的
/// 对象，对象中存着外部变量相关的信息。
/// 在这个新的结构体中还有个 __forwarding 变量，__forwarding指向了
/// blockcopy后的堆区变量，而堆区的__forwarding指向了堆区的isa，__forwarding的
/// 主要作用就是为了找到堆上的变量
///
-(void)__blockVariables{
    
    NSLog(@"===========__block变量============");
    
    __block NSString * blockStr = @"block say hi";
    NSLog(@"原始字符串 : %@ == %p",blockStr,blockStr);
    
    self.mallocBlock = ^(NSString * test) {
//        blockStr = @"hello world";
        NSLog(@"block 内部 : %@ == %p",blockStr,blockStr);
    };
    
//    blockStr = @"hello world";
    
    self.mallocBlock(@"test");
    
    NSLog(@"block 外部 : %@ == %p",blockStr,blockStr);

    NSLog(@"");
}



/// 3、static 修饰的临时变量，截获了外部变量的指针
/// 实际上在 block 内部是这样的
/// struct xxx{
///     NSString **staticStr;
/// }
/// 他是一个二级指针，拿到的是 我们 static 这个对象的指针地址
/// &staticStr ，使用时，通过 NSString **staticStr = cself->staticStr
/// 的方式，拿到 *staticStr 来使用
///

-(void)staticVariables{
    
    NSLog(@"===========static变量============");
    static NSString * staticStr = @"block say hi";
    NSLog(@"原始字符串 : %@ == %p",staticStr,staticStr);
    
    self.mallocBlock = ^(NSString * test) {

        NSLog(@"block 内部 : %@ == %p",staticStr,staticStr);
    };
    
//    staticStr = @"hello world";
    
    self.mallocBlock(@"test");
    
    NSLog(@"block 外部 : %@ == %p",staticStr,staticStr);
    
    NSLog(@"");
}



/// 4、属性
/// 对于属性block，如果我们使用self. 调用，则捕获的是self
/// 捕获分为两种情况
/// 1、__weak typeof(self)weakSelf = self;
///  捕获参数为： typeof (self) weakSelf;
/// 2、如果使用 _ 或者 self. 调用
///  捕获参数为： BSBlockController *self;
///
/// 如果1、2两种都用了，那么就会有两个参数
/// typeof (self) weakSelf;
/// BSBlockController *self;
///
/// 而在使用的时候，捕获的self会通过mes_send sel_registName 的方式找到
/// 我们需要的参数值（为什么用 sel_registName 没明白）
///


///调用源码 ：clang -x objective-c -rewrite-objc -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk BSBlockController.m
/*
 
 struct __BSBlockController__propertyVariables_block_impl_0 {
   struct __block_impl impl;
   struct __BSBlockController__propertyVariables_block_desc_0* Desc;
   
   typeof (self) weakSelf;
   BSBlockController *self;
   __BSBlockController__propertyVariables_block_impl_0(void *fp, struct __BSBlockController__propertyVariables_block_desc_0 *desc, typeof (self) _weakSelf, BSBlockController *_self, int flags=0) : weakSelf(_weakSelf), self(_self) {
     impl.isa = &_NSConcreteStackBlock;
     impl.Flags = flags;
     impl.FuncPtr = fp;
     Desc = desc;
   }
 };
 
 static void __BSBlockController__propertyVariables_block_func_0(struct __BSBlockController__propertyVariables_block_impl_0 *__cself, NSString *test) {
   
 typeof (self) weakSelf = __cself->weakSelf; // bound by copy
   BSBlockController *self = __cself->self; // bound by copy

         NSLog((NSString *)&__NSConstantStringImpl__var_folders_j3_4lmzsc5j1d9dx6shwz2p_3w80000gn_T_BSBlockController_c495ff_mi_62,((NSString *(*)(id, SEL))(void *)objc_msgSend)((id)((BlockTest *(*)(id, SEL))(void *)objc_msgSend)((id)weakSelf, sel_registerName("test")), sel_registerName("blockTestStr")),((BlockTest *(*)(id, SEL))(void *)objc_msgSend)((id)self, sel_registerName("test")));
     }
 */


-(void)propertyVariables{
    
    NSLog(@"===========属性============");
    
    self.test = [[BlockTest alloc]init];
    self.test.blockTestStr = @"123";
    NSLog(@"原始对象 : %@ == %p",self.test.blockTestStr ,self.test);
    
//    __weak typeof(self)weakSelf = self;
    __unsafe_unretained typeof(self)weakSelf = self;

    self.mallocBlock = ^(NSString * test) {

        NSLog(@"block 内部 : %@ == %p",weakSelf.test.blockTestStr,test);
    };
    
//    self.test.blockTestStr = @"hello world";
    
    self.mallocBlock(@"test");
    
    NSLog(@"block 外部 : %@ == %p",self.test.blockTestStr,self.test);
    
    NSLog(@"");
}


@end




#pragma mark - BlockTest
@implementation BlockTest


-(void)testBlock:(void (^)(NSString * _Nonnull))testBlock{
    
    NSLog(@"BlockTest 参数:%@",testBlock);
    NSLog(@"BlockTest 参数:%@",[testBlock class]);
    testBlock(@"param block");
//    NSLog(@"copy Block 参数:%@",[testBlock copy]);
//    NSLog(@"copy Block 参数:%@",[[testBlock copy] class]);
}


@end
