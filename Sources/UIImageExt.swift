
//
//  UIImageExt.swift
//  GKitPhotoPick
//
//  Created by Auto Jiang on 2017/4/10.
//  Copyright © 2017年 Auto Jiang. All rights reserved.
//

import UIKit
import Foundation
import ImageIO

extension UIImage {
    //处理gif图片显示
    static func animatedGif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        
        let count = CGImageSourceGetCount(source)
        guard count > 1 else {
            if let origImg = UIImage(data: data) {
                return origImg
            } else {
                return nil
            }
        }
        
        var animatedImage: UIImage
        var images = [UIImage]();
        var duration: TimeInterval = 0.0
        
        for i in 0..<count {
            guard let image = CGImageSourceCreateImageAtIndex(source, i, nil) else {
                continue
            }
            
            var frameDuration = 0.1
            let cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, i, nil)!
            let frameProperties =  cfFrameProperties as NSDictionary
            let gifProperties = frameProperties[kCGImagePropertyGIFDictionary as String] as! NSDictionary
            
            let delayTimeUnclampedProp = gifProperties[kCGImagePropertyGIFUnclampedDelayTime as String] as? NSNumber
            if ((delayTimeUnclampedProp) != nil) {
                frameDuration = Double((delayTimeUnclampedProp?.floatValue)!);
            } else {
                let delayTimeProp = gifProperties[kCGImagePropertyGIFDelayTime as String] as? NSNumber
                if ((delayTimeProp) != nil) {
                    frameDuration = Double((delayTimeProp?.floatValue)!)
                }
            }
            if (frameDuration < 0.011) {
                frameDuration = 0.100;
            }
            duration =  duration + frameDuration
            images.append(UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .up))
        }
        
        if (duration == 0.0) {
            duration = TimeInterval((1.0 / 10.0) * Float(count))
        }
        animatedImage = UIImage.animatedImage(with: images, duration: duration)!
        return animatedImage;
    }
    
    //图片压缩
    func scaleToMaxSidePixels(maxSidePixels: CGFloat, minStretchSidePixels: CGFloat) -> UIImage {
        if (self.size.width <= minStretchSidePixels || self.size.height <= minStretchSidePixels){
            return self;
        }
        return scaleToMaxSidePixels(maxSidePixels: maxSidePixels)
    }
    
    func scaleToMaxSidePixels(maxSidePixels: CGFloat) -> UIImage {
        if (maxSidePixels <= 0) {
            return self;
        }
        
        if (self.size.width <= maxSidePixels && self.size.height <= maxSidePixels) {
            return self;
        }
        
        let maxSide = (self.size.width >= self.size.height) ? self.size.width : self.size.height;
        let scaleRate = maxSidePixels / maxSide;
        let newWidth = self.size.width * scaleRate;
        let newHeight = self.size.height * scaleRate;
        return self.scaleToSize(newSize: CGSize(width: newWidth, height: newHeight))
    }
    
    func scaleToSize(newSize: CGSize ) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0);
        self.draw(in:CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if let image = newImage {
            return image
        }
        return self;
    }
}
