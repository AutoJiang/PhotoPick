//
//  MSSBrowseCollectionViewCell.h
//  MSSBrowse
//
//  Created by 于威 on 15/12/5.
//  Copyright © 2015年 于威. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKitImageBrowseLoadingImageView.h"
#import "GKitImageBrowseZoomScrollView.h"

@class GKitImageBrowseCollectionViewCell;

typedef void(^GKitImageBrowseCollectionViewCellTapBlock)(GKitImageBrowseCollectionViewCell *browseCell);
typedef void(^GKitImageBrowseCollectionViewCellLongPressBlock)(GKitImageBrowseCollectionViewCell *browseCell);

@interface GKitImageBrowseCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)GKitImageBrowseZoomScrollView *zoomScrollView; // 滚动视图
@property (nonatomic,strong)GKitImageBrowseLoadingImageView *loadingView; // 加载视图

- (void)tapClick:(GKitImageBrowseCollectionViewCellTapBlock)tapBlock;
- (void)longPress:(GKitImageBrowseCollectionViewCellLongPressBlock)longPressBlock;

@end
