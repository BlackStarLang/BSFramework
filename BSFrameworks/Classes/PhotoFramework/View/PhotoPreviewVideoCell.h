//
//  PhotoPreviewVideoCell.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/10/23.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>



@interface PhotoPreviewVideoCell : UICollectionViewCell

@property (nonatomic ,strong) UIImageView *imageView;

@property (nonatomic ,strong) AVPlayerLayer  *playerLayer;
@property (nonatomic ,strong) AVPlayer  *player;

@property (nonatomic ,strong) UIButton *replayBtn;

@property (nonatomic ,copy) void(^replayCallBack)(void);

@end


