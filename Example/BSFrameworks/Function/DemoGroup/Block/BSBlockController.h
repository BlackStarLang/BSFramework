//
//  BSBlockController.h
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/12/30.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSBlockController : UIViewController



@end


@interface BlockTest : NSObject

@property (nonatomic ,strong) NSString *blockTestStr;

-(void)testBlock:(void(^)(NSString *testStr))testBlock;

@end


NS_ASSUME_NONNULL_END
