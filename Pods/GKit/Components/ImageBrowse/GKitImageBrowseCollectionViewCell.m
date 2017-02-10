//
//  MSSBrowseCollectionViewCell.m
//  MSSBrowse
//
//  Created by 于威 on 15/12/5.
//  Copyright © 2015年 于威. All rights reserved.
//

#import "GKitImageBrowseCollectionViewCell.h"
#import "GKitImageBrowseDefine.h"

@interface GKitImageBrowseCollectionViewCell ()

@property (nonatomic,copy)GKitImageBrowseCollectionViewCellTapBlock tapBlock;
@property (nonatomic,copy)GKitImageBrowseCollectionViewCellLongPressBlock longPressBlock;

@end

@implementation GKitImageBrowseCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self createCell];
    }
    return self;
}

- (void)createCell
{
    _zoomScrollView = [[GKitImageBrowseZoomScrollView alloc]init];
    __weak __typeof(self)weakSelf = self;
    [_zoomScrollView tapClick:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.tapBlock(strongSelf);
    }];
    [self.contentView addSubview:_zoomScrollView];
    
    _loadingView = [[GKitImageBrowseLoadingImageView alloc]init];
    [_zoomScrollView addSubview:_loadingView];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
    [self.contentView addGestureRecognizer:longPressGesture];
}

- (void)tapClick:(GKitImageBrowseCollectionViewCellTapBlock)tapBlock
{
    _tapBlock = tapBlock;
}

- (void)longPress:(GKitImageBrowseCollectionViewCellLongPressBlock)longPressBlock
{
    _longPressBlock = longPressBlock;
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture
{
    if(_longPressBlock)
    {
        if(gesture.state == UIGestureRecognizerStateBegan)
        {
            _longPressBlock(self);
        }
    }
}

@end
