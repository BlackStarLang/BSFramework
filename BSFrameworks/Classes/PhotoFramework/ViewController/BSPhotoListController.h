//
//  BSPhotoListController.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BSPhotoGroupModel ;

@interface BSPhotoListController : UIViewController

@property (nonatomic ,strong) BSPhotoGroupModel *groupModel;

@property (nonatomic ,strong) NSMutableArray *selectDataArr;

@end

NS_ASSUME_NONNULL_END
