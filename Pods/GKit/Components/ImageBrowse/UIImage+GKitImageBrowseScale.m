//
//  UIImage+MSSScale.m
//  MSSBrowse
//
//  Created by 于威 on 15/12/6.
//  Copyright © 2015年 于威. All rights reserved.
//

#import "UIImage+GKitImageBrowseScale.h"

@implementation UIImage (GKitImageBrowseScale)

// 得到图像显示完整后的宽度和高度
- (CGRect)gkit_imagebrowse_getBigImageRectSizeWithScreenWidth:(CGFloat)screenWidth screenHeight:(CGFloat)screenHeight
{
    CGSize imgSize = self.size;
    if (imgSize.width == 0 || imgSize.height == 0) {
        imgSize = CGSizeMake(screenWidth, screenHeight);
    }
    CGFloat widthRatio = screenWidth / imgSize.width;
    CGFloat heightRatio = screenHeight / imgSize.height;
    CGFloat scale = MIN(widthRatio, heightRatio);
    CGFloat width = scale * self.size.width;
    CGFloat height = scale * self.size.height;
    return CGRectMake((screenWidth - width) / 2, (screenHeight - height) / 2, width, height);
}

@end
