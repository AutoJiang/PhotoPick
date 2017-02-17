//
//  PickedPhoto.swift
//  GKitPhotoPick
//
//  Created by Auto Jiang on 2017/2/13.
//  Copyright © 2017年 Auto Jiang. All rights reserved.
//

import UIKit
import AssetsLibrary

public class PickedPhoto: NSObject {
    enum PhotoType {
        case asset(asset: ALAsset)
        case image(image: UIImage)
    }
    
    private var asset : ALAsset?
    private var privateImage: UIImage?
    private let maxSidePixels : CGFloat = 1280
    private let minStretchSidePixels : CGFloat = 440
    
    ///原图
    public var originalImage: UIImage {
        get{
            if let privateImage = privateImage {
                return privateImage
            }
            
            return AssetTool.imageFromAsset(representation: asset!.defaultRepresentation())
        }
    }
    
    ///返回压缩图 compress
    public var image: UIImage {
        get{
            return self.originalImage.gkit_scale(toMaxSidePixels: maxSidePixels, minStretchSidePixels: minStretchSidePixels)
        }
    }
    
    /// TODO
    public var isGIF: Bool {
        return false
    }
    
    ///创建一个图片文件路径，创建后由外部自行删除
    public func newAnImageFile() -> String {
        return ""
    }
    
    init(asset : ALAsset) {
        self.asset = asset
    }
    
    init(image: UIImage) {
        self.privateImage = image
    }
    
}
