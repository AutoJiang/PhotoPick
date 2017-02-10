//
//  UIView+MSSLayout.h
//  MSSBrowse
//
//  Created by 于威 on 15/12/5.
//  Copyright © 2015年 于威. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GKitImageBrowseLayout)

- (CGFloat)gkit_imagebrowse_Left;
- (CGFloat)gkit_imagebrowse_Right;
- (CGFloat)gkit_imagebrowse_Bottom;
- (CGFloat)gkit_imagebrowse_Top;
- (CGFloat)gkit_imagebrowse_Height;
- (CGFloat)gkit_imagebrowse_Width;

- (void)gkit_imagebrowse_setX:(CGFloat)x;
- (void)gkit_imagebrowse_setY:(CGFloat)y;
- (void)gkit_imagebrowse_setWidth:(CGFloat)width;
- (void)gkit_imagebrowse_setHeight:(CGFloat)height;

- (void)gkit_imagebrowse_setFrameInSuperViewCenterWithSize:(CGSize)size;

@end
