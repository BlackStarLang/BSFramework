//
//  BSPhotoManagerController.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/5/21.
//

#import "BSPhotoManagerController.h"
#import "BSPhotoGroupController.h"
#import "BSPhotoListController.h"
#import "BSPhotoDataManager.h"


@interface BSPhotoManagerController ()

@property (nonatomic ,copy) NSMutableArray *dataSource;

@end

@implementation BSPhotoManagerController

-(instancetype)init{
    
    self = [super init];

    if (self) {
        BSPhotoGroupController *root = [[BSPhotoGroupController alloc]init];
        self = [super initWithRootViewController:root];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubViews];
    [self masonryLayout];
}


-(void)initSubViews{
    

}


-(void)masonryLayout{
    
    
}

-(void)getGroupListData{
    
    [BSPhotoDataManager getPhotoLibraryGroupModel:^(BSPhotoGroupModel *groupModel) {
        
        if (self.autoPush) {
            BSPhotoListController *photoListVC = [[BSPhotoListController alloc]init];
            photoListVC.groupModel = groupModel;
            photoListVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self pushViewController:photoListVC animated:YES];
        }
    }];
}

#pragma mark - set method

-(void)setAutoPush:(BOOL)autoPush{
    _autoPush = autoPush;
    
    [self getGroupListData];
}









#pragma mark - init 属性初始化


-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}





@end
