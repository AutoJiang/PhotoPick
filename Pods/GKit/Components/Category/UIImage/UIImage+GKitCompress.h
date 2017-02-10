//
// Created by DonYang on 1/25/16.
// Copyright (c) 2016 sdg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (GKitCompress)

/**
 * 先保证图片最大长宽满足maxSidePixels,如果过大则做等比缩放
 * 再针对图片质量(0.01-1范围)做压缩
 */
- (NSData *)gkit_compressToJpegWithQuality:(CGFloat)quality maxSidePixels:(CGFloat)maxSidePixels;

/**
 * minStretchSidePixels当有一边小于等于这个长度时，不对图片做等比压缩
 * 进行等比压缩的图片，压缩后长边宽度必须小于等于maxSidePixels
 * 再针对图片质量(0.01-1范围)做压缩
 */
- (NSData *)gkit_compressToJpegWithQuality:(CGFloat)quality maxSidePixels:(CGFloat)maxSidePixels minStretchSidePixels:(CGFloat)minStretchSidePixels;

/**
 * minStretchSidePixels当有一边小于等于这个长度时，不对图片做等比压缩
 * 进行等比压缩的图片，压缩后长边宽度必须小于等于maxSidePixels
 * longPictureRate长图片的长宽比例，大于等于这个比例的图片不做分辨率缩放
 * 再针对图片质量(0.01-1范围)做压缩
 */
- (NSData *)gkit_compressToJpegWithQuality:(CGFloat)quality maxSidePixels:(CGFloat)maxSidePixels minStretchSidePixels:(CGFloat)minStretchSidePixels longPictureRate:(CGFloat)longPictureRate;

/**
 * 将图片在像素不变的情况下压缩到小于maxBytesCount大小的jpg文件
 * maxBytesCount小于等于0代表不做限制
 */
- (NSData *)gkit_compressToJpegWithMaxBytesCount:(NSInteger)maxBytesCount;

/**
 * 先保证图片最大长宽满足maxSidePixels,如果过大则做等比缩放
 * 再判断大小是否适合,如果不符合maxBytesCount,再做压缩
 * 两个参数小于等于0代表不做限制
 */
- (NSData *)gkit_compressToJpegWithMaxBytesCount:(NSInteger)maxBytesCount
                                   maxSidePixels:(CGFloat)maxSidePixels;

/**
 * 将图片缩放到新的大小
 */
- (UIImage *)gkit_scaleToSize:(CGSize)newSize;

/**
 * 等比缩放图片,最大边框不得大于maxSidePixels,
 * 如果宽高都小于maxSidePixels则不做处理
 * maxSidePixels小于等于0代表不做限制
 */
- (UIImage *)gkit_scaleToMaxSidePixels:(CGFloat)maxSidePixels;

/**
 * 长微博情况特殊处理，当有一边小于等于minStretchSidePixels时，不做等比缩放
 */
- (UIImage *)gkit_scaleToMaxSidePixels:(CGFloat)maxSidePixels minStretchSidePixels:(CGFloat)minStretchSidePixels;
@end
