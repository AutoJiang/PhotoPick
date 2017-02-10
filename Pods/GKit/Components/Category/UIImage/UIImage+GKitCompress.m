//
// Created by DonYang on 1/25/16.
// Copyright (c) 2016 sdg. All rights reserved.
//

#import "UIImage+GKitCompress.h"


@implementation UIImage (GKitCompress)

- (NSData *)gkit_compressToJpegWithMaxBytesCount:(NSInteger)maxBytesCount {
    if (maxBytesCount <= 0) {
        return UIImageJPEGRepresentation(self, 1);
    }

    NSData *data = UIImageJPEGRepresentation(self, 1);
    if (data.length <= maxBytesCount) {
        return data;
    }

    CGFloat step = 0.05f;
    CGFloat compression = 1;
    while (data.length > maxBytesCount && compression > 0) {
        compression -= step;
        data = UIImageJPEGRepresentation(self, compression);
    }

    if (data.length > maxBytesCount) {
        return nil;
    }

    return data;
}

- (NSData *)gkit_compressToJpegWithQuality:(CGFloat)quality maxSidePixels:(CGFloat)maxSidePixels {
    if (quality < 0.01 || quality > 1) {
        quality = 0.5;
    }
    UIImage *newImage = [self gkit_scaleToMaxSidePixels:maxSidePixels];
    return UIImageJPEGRepresentation(newImage, quality);
}

- (NSData *)gkit_compressToJpegWithQuality:(CGFloat)quality maxSidePixels:(CGFloat)maxSidePixels minStretchSidePixels:(CGFloat)minStretchSidePixels {
    if (quality < 0.01 || quality > 1) {
        quality = 0.5;
    }
    
    if (self.size.width <= minStretchSidePixels || self.size.height <= minStretchSidePixels){
        return UIImageJPEGRepresentation(self, quality);
    }
    
    return [self gkit_compressToJpegWithQuality:quality maxSidePixels:maxSidePixels];
}

- (NSData *)gkit_compressToJpegWithQuality:(CGFloat)quality maxSidePixels:(CGFloat)maxSidePixels minStretchSidePixels:(CGFloat)minStretchSidePixels longPictureRate:(CGFloat)longPictureRate {
    
    if (quality < 0.01 || quality > 1) {
        quality = 0.5;
    }
    
    if ((self.size.height / self.size.width) >= longPictureRate){
        return UIImageJPEGRepresentation(self, quality);
    }
    
    return [self gkit_compressToJpegWithQuality:quality maxSidePixels:maxSidePixels minStretchSidePixels:minStretchSidePixels];
}

- (NSData *)gkit_compressToJpegWithMaxBytesCount:(NSInteger)maxBytesCount maxSidePixels:(CGFloat)maxSidePixels {
    UIImage *newImage = [self gkit_scaleToMaxSidePixels:maxSidePixels];
    return [newImage gkit_compressToJpegWithMaxBytesCount:maxBytesCount];
}

- (UIImage *)gkit_scaleToSize:(CGSize)newSize {
    //from: http://stackoverflow.com/questions/2658738/the-simplest-way-to-resize-an-uiimage
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



- (UIImage *)gkit_scaleToMaxSidePixels:(CGFloat)maxSidePixels {
    if (maxSidePixels <= 0) {
        return self;
    }

    if (self.size.width <= maxSidePixels && self.size.height <= maxSidePixels) {
        return self;
    }

    CGFloat maxSide = (self.size.width >= self.size.height) ? self.size.width : self.size.height;
    CGFloat scaleRate = maxSidePixels / maxSide;
    CGFloat newWidth = self.size.width * scaleRate;
    CGFloat newHeight = self.size.height * scaleRate;
    return [self gkit_scaleToSize:CGSizeMake(newWidth, newHeight)];
}


- (UIImage *)gkit_scaleToMaxSidePixels:(CGFloat)maxSidePixels minStretchSidePixels:(CGFloat)minStretchSidePixels {
    if (self.size.width <= minStretchSidePixels || self.size.height <= minStretchSidePixels){
        return self;
    }
    
    return [self gkit_scaleToMaxSidePixels:maxSidePixels];
}

@end
