//
//  MSSBrowseZoomScrollView.m
//  MSSBrowse
//
//  Created by 于威 on 15/12/5.
//  Copyright © 2015年 于威. All rights reserved.
//

#import "GKitImageBrowseZoomScrollView.h"
#import "GKitImageBrowseDefine.h"

@interface GKitImageBrowseZoomScrollView ()

@property (nonatomic,copy)GKitImageBrowseZoomScrollViewTapBlock tapBlock;
@property (nonatomic,assign)BOOL isSingleTap;

@end

@implementation GKitImageBrowseZoomScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createZoomScrollView];
    }
    return self;
}

- (void)createZoomScrollView
{
    self.delegate = self;
    _isSingleTap = NO;
    self.minimumZoomScale = 1.0f;
    self.maximumZoomScale = 3.0f;
    
    _zoomImageView = [[UIImageView alloc]init];
    _zoomImageView.userInteractionEnabled = YES;
    _zoomImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_zoomImageView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _zoomImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    // 延中心点缩放
    CGRect rect = _zoomImageView.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    if (rect.size.width < self.gkit_imagebrowse_Width) {
        rect.origin.x = floorf((self.gkit_imagebrowse_Width - rect.size.width) / 2.0);
    }
    if (rect.size.height < self.gkit_imagebrowse_Height) {
        rect.origin.y = floorf((self.gkit_imagebrowse_Height - rect.size.height) / 2.0);
    }
    _zoomImageView.frame = rect;
}

- (void)tapClick:(GKitImageBrowseZoomScrollViewTapBlock)tapBlock
{
    _tapBlock = tapBlock;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    if(touch.tapCount == 1)
    {
        [self performSelector:@selector(singleTapClick) withObject:nil afterDelay:0.17];
    }
    else if (touch.tapCount > 2)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        // 防止先执行单击手势后还执行下面双击手势动画异常问题
        if(!_isSingleTap)
        {
            CGPoint touchPoint = [touch locationInView:_zoomImageView];
            [self zoomDoubleTapWithPoint:touchPoint];
        }
    }
}

- (void)singleTapClick
{
    _isSingleTap = YES;
    if(_tapBlock)
    {
        _tapBlock();
    }
}

- (void)zoomDoubleTapWithPoint:(CGPoint)touchPoint
{
    if(self.zoomScale > self.minimumZoomScale)
    {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }
    else
    {
        CGFloat width = self.bounds.size.width / self.maximumZoomScale;
        CGFloat height = self.bounds.size.height / self.maximumZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x - width / 2, touchPoint.y - height / 2, width, height) animated:YES];
    }
}

- (void)setMaxMinZoomScalesForCurrentBounds
{
    
    // Reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    
    // Bail if no image
    if (_zoomImageView.image == nil) return;
    
    //    _photoImageView.frame = [ZLPhotoRect setMaxMinZoomScalesForCurrentBoundWithImageView:_photoImageView];
    // Reset position
    _zoomImageView.frame = CGRectMake(0, 0, _zoomImageView.frame.size.width, _zoomImageView.frame.size.height);
    
    // Sizes
    CGSize boundsSize = [UIScreen mainScreen].bounds.size;
    CGSize imageSize = _zoomImageView.image.size;
    
    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    
    CGFloat minScale = MIN(xScale, yScale);
    CGFloat maxScale = MAX(xScale, yScale);
    // use minimum of these to allow the image to become fully visible
    // Image is smaller than screen so no zooming!
    if (xScale >= 1 && yScale >= 1) {
        minScale = MIN(xScale, yScale);
    }
    
    if (xScale >= yScale * 2) {
        // Initial zoom
        self.maximumZoomScale = 1.0;
        self.minimumZoomScale = maxScale;
    }else {
        self.maximumZoomScale = yScale * 1.2;
        self.minimumZoomScale = xScale;
    }
    
    self.zoomScale = self.minimumZoomScale;
    
    // If we're zooming to fill then centralise
    if (self.zoomScale != minScale) {
        if (yScale >= xScale) {
            self.scrollEnabled = NO;
        }
    }
    
    // Layout
    [self setNeedsLayout];
    
}


@end
