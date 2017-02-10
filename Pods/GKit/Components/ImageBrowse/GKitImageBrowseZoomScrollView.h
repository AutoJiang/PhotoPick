//
//  MSSBrowseZoomScrollView.h
//  MSSBrowse
//
//  Created by 于威 on 15/12/5.
//  Copyright © 2015年 于威. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GKitImageBrowseZoomScrollViewTapBlock)(void);

@interface GKitImageBrowseZoomScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic,strong)UIImageView *zoomImageView;

- (void)setMaxMinZoomScalesForCurrentBounds;

- (void)tapClick:(GKitImageBrowseZoomScrollViewTapBlock)tapBlock;

@end
