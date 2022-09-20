//
//  BSCategoryVC.m
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2021/3/8.
//  Copyright © 2021 blackstar_lang@163.com. All rights reserved.
//

#import "BSCategoryVC.h"
#import "BSCategoryOrigin.h"
#import "BSCategryOriginSubClass.h"
#import "BSCategoryOrigin+Mutimethod.h"

@interface BSCategoryVC ()

@end

@implementation BSCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showMethod];
//    [self showSubMethod];
}



-(void)showMethod{
    [BSCategoryOrigin factory];
    BSCategoryOrigin *origin = [[BSCategoryOrigin alloc]init];
    //打印所有属性、所有成员变量、所有方法（打印实例方法还是类方法，请看showTotalInfo内部注释）
    [origin showTotalInfo];
//    [origin test];
    
    //测试： 通过关联属性在分类里添加自定义属性，是否可以触发kvo
    //结果： 可以，因为分类里实现了set方法，而kvo通过创建派生子类，重写set方法，调用
    //      setvalueandnotify 方法触发kvo
    [origin addObserver:self forKeyPath:@"kvoTest" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
//    origin.kvoTest = @"123";
    [origin setValue:@"345" forKey:@"kvoTest"];
}

-(void)showSubMethod{
    BSCategryOriginSubClass  *subOrigin = [[BSCategryOriginSubClass alloc]init];
//    subOrigin.kvoTest = @"haha";
    [subOrigin setValue:@"345" forKey:@"kvoTest"];
    ///子类是可以调用父类的私有方法的，只不过不能直接调用，可以通过perform的方式调用
    ///因此：即便是分类的私有属性，只要实现了set方法，就可以响应kvo
    [subOrigin performSelector:@selector(initSubProperty)];
    [subOrigin showTotalInfo];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [BSCategryOriginSubClass performSelector:@selector(priveFactory)];
        [BSCategryOriginSubClass performSelector:@selector(priveFactory) withObject:nil afterDelay:2];
        [[NSRunLoop currentRunLoop]run];
        
    });

}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    NSLog(@" keyPath == %@",keyPath);

    if ([keyPath isEqualToString:@"kvoTest"]) {
        BSCategoryOrigin *obj = object;
        NSLog(@"object == %@ == %@",obj,change);
    }
    
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
