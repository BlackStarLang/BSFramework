//
//  BSPhotoGroupController.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/3/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSPhotoGroupController : UIViewController

@property (nonatomic ,strong) UIColor *mainColor;
@property (nonatomic ,strong) NSMutableArray *selectDataArr;

@property (nonatomic ,assign) NSInteger allowSelectMaxCount;
@property (nonatomic ,assign) NSInteger currentSelectedCount;


@end

NS_ASSUME_NONNULL_END
