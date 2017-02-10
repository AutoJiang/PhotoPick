//
//  UIImage+MSSScale.h
//  MSSBrowse
//
//  Created by 于威 on 15/12/6.
//  Copyright © 2015年 于威. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GKitImageBrowseScale)

// 得到图像显示完整后的frame
- (CGRect)gkit_imagebrowse_getBigImageRectSizeWithScreenWidth:(CGFloat)screenWidth screenHeight:(CGFloat)screenHeight;
@end
