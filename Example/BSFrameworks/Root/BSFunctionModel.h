//
//  BSFunctionModel.h
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/6/2.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@class BSFunctionItem;

@interface BSFunctionModel : NSObject

@property (nonatomic ,strong , readonly) NSMutableArray<BSFunctionItem *> * funcArr;

-(void)getFunctionArr;

@end




@interface BSFunctionItem : NSObject


@property (nonatomic ,copy) NSString *title;

/// 跳转目标的名称
@property (nonatomic ,copy) NSString *pushTargetName;


@end
