//
//  MSSBrowseBaseViewController.h
//  MSSBrowse
//
//  Created by 于威 on 16/4/26.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKitImageBrowseCollectionViewCell.h"
#import "GKitImageBrowseModel.h"

@interface GKitImageBrowseBaseVC : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIViewControllerTransitioningDelegate>

@property (nonatomic,assign)BOOL isEqualRatio;// 大小图是否等比（默认为等比）
@property (nonatomic,assign)BOOL preloadingBigImage;//是否预加载大图 (默认 YES)
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,assign)BOOL isFirstOpen;
@property (nonatomic,assign)CGFloat screenWidth;
@property (nonatomic,assign)CGFloat screenHeight;

- (instancetype)initWithBrowseItemArray:(NSArray *)browseItemArray currentIndex:(NSInteger)currentIndex;
- (void)showBrowseViewController;

// 子类重写此方法
- (void)loadBrowseImageWithDataSource:(NSArray *)dataSource currentIndex:(NSInteger)index Cell:(GKitImageBrowseCollectionViewCell *)cell deviceOrientation:(UIDeviceOrientation)orientation;
- (void)showBrowseRemindViewWithText:(NSString *)text;
// 获取指定视图在window中的位置
- (CGRect)getFrameInWindow:(UIView *)view;

@end
