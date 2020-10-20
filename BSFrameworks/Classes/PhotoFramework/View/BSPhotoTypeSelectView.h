//
//  BSPhotoTypeSelectView.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//拍照类型选择枚举
typedef enum : NSUInteger {
    SELECTTYPE_VIDEO = 0,   //拍照类型：视频
    SELECTTYPE_PIC,         //拍照类型：图片
} SELECTTYPE;

@protocol BSPhotoTypeSelectViewDelegate <NSObject>

@optional
-(void)BSPhotoTypeSelectViewSelectedType:(SELECTTYPE)selectType;

@end

@interface BSPhotoTypeSelectView : UIView

@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) NSMutableArray *btns;
@property (nonatomic ,weak) id<BSPhotoTypeSelectViewDelegate> delegate;

@property (nonatomic ,assign) SELECTTYPE selectType;

@end

NS_ASSUME_NONNULL_END
