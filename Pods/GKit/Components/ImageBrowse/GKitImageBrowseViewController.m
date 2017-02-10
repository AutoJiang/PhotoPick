//
//  MSSBrowseNetworkViewController.m
//  MSSBrowse
//
//  Created by 于威 on 16/4/26.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "GKitImageBrowseViewController.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "UIView+GKitImageBrowseLayout.h"
#import "UIImage+GKitImageBrowseScale.h"
#import "UIImageView+WebCache.h"

@implementation GKitImageBrowseViewController

- (void)loadBrowseImageWithDataSource:(NSArray *)dataSource currentIndex:(NSInteger)index Cell:(GKitImageBrowseCollectionViewCell *)cell deviceOrientation:(UIDeviceOrientation)orientation
{
    GKitImageBrowseModel *browseItem = dataSource[index];
    // 停止加载
    [cell.loadingView stopAnimation];
    UIImageView *imageView = cell.zoomScrollView.zoomImageView;
    BOOL needDownloadImage = NO;
    if (browseItem.bigImageUrl) {
        // 判断大图是否存在
        if([[SDImageCache sharedImageCache] diskImageExistsWithKey:browseItem.bigImageUrl])
        {
            // 取消当前请求防止复用问题
            [imageView sd_cancelCurrentImageLoad];
            // 如果存在直接显示图片
            imageView.image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:browseItem.bigImageUrl];
        }
        // 如果大图不存在
        else
        {
            self.isFirstOpen = NO;
            needDownloadImage = YES;
            // 加载大图
            [self loadBigImageWithBrowseItem:browseItem cell:cell deviceOrientation:orientation];
        }
    } else if(browseItem.bigImageLocalPath) {
        NSData *imageData = [[NSData alloc]initWithContentsOfFile:browseItem.bigImageLocalPath];
        imageView.image = [[UIImage alloc]initWithData:imageData];
    }
    else if(browseItem.bigImage)
    {
        imageView.image = browseItem.bigImage;
    }
    else if(browseItem.bigImageData)
    {
        imageView.image = [[UIImage alloc]initWithData:browseItem.bigImageData];
    }
    
    if (!needDownloadImage) {
        [self showBigImage:imageView browseItem:browseItem deviceOrientation:orientation];
    }

    if (self.preloadingBigImage) {
        [self downloadNeighborImage:dataSource currentIndex:index];
    }
}

- (void)downloadNeighborImage:(NSArray *)dataSource currentIndex:(NSInteger)currentIndex
{
    GKitImageBrowseModel *beforeBrowseItem;
    GKitImageBrowseModel *afterBrowseItem;
    if (currentIndex != 0) {
        beforeBrowseItem = dataSource[currentIndex - 1];
    }
    if (currentIndex != dataSource.count - 1) {
        afterBrowseItem = dataSource[currentIndex + 1];
    }
    if (beforeBrowseItem.bigImageUrl && ![[SDImageCache sharedImageCache]diskImageExistsWithKey:beforeBrowseItem.bigImageUrl]) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:beforeBrowseItem.bigImageUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
        }];
    }
    if (afterBrowseItem.bigImageUrl && ![[SDImageCache sharedImageCache]diskImageExistsWithKey:afterBrowseItem.bigImageUrl]) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:afterBrowseItem.bigImageUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
        }];
    }
}

- (void)showBigImage:(UIImageView *)imageView browseItem:(GKitImageBrowseModel *)browseItem deviceOrientation:(UIDeviceOrientation)orientation
{
    // 当大图frame为空时，需要大图加载完成后重新计算坐标
    CGRect tempRect = [imageView.image gkit_imagebrowse_getBigImageRectSizeWithScreenWidth:[UIScreen mainScreen].bounds.size.width screenHeight:[UIScreen mainScreen].bounds.size.height];
    if (orientation != UIDeviceOrientationPortrait) {
        tempRect = [imageView.image gkit_imagebrowse_getBigImageRectSizeWithScreenWidth:[UIScreen mainScreen].bounds.size.height screenHeight:[UIScreen mainScreen].bounds.size.width];
    }
    CGRect bigRect = [self getBigImageRectIfIsEmptyRect:tempRect bigImage:imageView.image];
    // 第一次打开浏览页需要加载动画
    if(self.isFirstOpen)
    {
        self.isFirstOpen = NO;
        imageView.frame = [self getFrameInWindow:browseItem.smallImageView];
        
        [UIView animateWithDuration:0.5 animations:^{
            imageView.frame = bigRect;
        }];
    }
    else
    {
        imageView.frame = bigRect;
    }
}

// 加载大图
- (void)loadBigImageWithBrowseItem:(GKitImageBrowseModel *)browseItem cell:(GKitImageBrowseCollectionViewCell *)cell deviceOrientation:(UIDeviceOrientation)orientation
{
    UIImageView *imageView = cell.zoomScrollView.zoomImageView;
    __weak typeof(UIImageView) *weakImageView = imageView;
    // 加载圆圈显示
    [cell.loadingView startAnimation];
    // 默认为屏幕中间
    [imageView gkit_imagebrowse_setFrameInSuperViewCenterWithSize:CGSizeMake(browseItem.smallImageView.gkit_imagebrowse_Width, browseItem.smallImageView.gkit_imagebrowse_Height)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:browseItem.bigImageUrl] placeholderImage:browseItem.smallImageView.image options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 关闭图片浏览view的时候，不需要继续执行小图加载大图动画
        if(self.collectionView.userInteractionEnabled)
        {
            // 停止加载
            [cell.loadingView stopAnimation];
            if(error)
            {
                [self showBrowseRemindViewWithText:@"图片加载失败"];
            }
            else
            {
                // 当大图frame为空时，需要大图加载完成后重新计算坐标

                CGRect tempRect = [weakImageView.image gkit_imagebrowse_getBigImageRectSizeWithScreenWidth:[UIScreen mainScreen].bounds.size.width screenHeight:[UIScreen mainScreen].bounds.size.height];
                if (orientation != UIDeviceOrientationPortrait) {
                    tempRect = [imageView.image gkit_imagebrowse_getBigImageRectSizeWithScreenWidth:[UIScreen mainScreen].bounds.size.height screenHeight:[UIScreen mainScreen].bounds.size.width];
                }
                CGRect bigRect = [self getBigImageRectIfIsEmptyRect:tempRect bigImage:image];
                // 图片加载成功
                [UIView animateWithDuration:0.5 animations:^{
                    weakImageView.frame = bigRect;
                }];
            }
        }
    }];
}

// 当大图frame为空时，需要大图加载完成后重新计算坐标
- (CGRect)getBigImageRectIfIsEmptyRect:(CGRect)rect bigImage:(UIImage *)bigImage
{
    if(CGRectIsEmpty(rect))
    {
        return [bigImage gkit_imagebrowse_getBigImageRectSizeWithScreenWidth:self.screenWidth screenHeight:self.screenHeight];
    }
    return rect;
}

@end
