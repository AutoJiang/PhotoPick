//
//  UIView+MSSLayout.m
//  MSSBrowse
//
//  Created by 于威 on 15/12/5.
//  Copyright © 2015年 于威. All rights reserved.
//

#import "UIView+GKitImageBrowseLayout.h"

@implementation UIView (GKitImageBrowseLayout)

- (CGFloat)gkit_imagebrowse_Left
{
    return CGRectGetMinX(self.frame);
}

- (CGFloat)gkit_imagebrowse_Right
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)gkit_imagebrowse_Bottom
{
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)gkit_imagebrowse_Top
{
    return CGRectGetMinY(self.frame);
}

- (CGFloat)gkit_imagebrowse_Height
{
    return CGRectGetHeight(self.frame);
}

- (CGFloat)gkit_imagebrowse_Width
{
    return CGRectGetWidth(self.frame);
}

- (void)gkit_imagebrowse_setX:(CGFloat)x
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (void)gkit_imagebrowse_setY:(CGFloat)y
{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (void)gkit_imagebrowse_setWidth:(CGFloat)width
{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (void)gkit_imagebrowse_setHeight:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (void)gkit_imagebrowse_setFrameInSuperViewCenterWithSize:(CGSize)size
{
    self.frame = CGRectMake((self.superview.gkit_imagebrowse_Width - size.width) / 2, (self.superview.gkit_imagebrowse_Height - size.height) / 2, size.width, size.height);
}

@end
