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
    
    ///是否为gif图
    public var isGIF: Bool {
        get{
            return asset?.defaultRepresentation().filename().components(separatedBy: ".").last == "GIF"
        }
    }
    
    ///若是gif, 使用Data数据流传输到服务器
    public var gifData: Data {
        get{
            if let asset = asset{
                return AssetTool.dataFromAsset(representation: (asset.defaultRepresentation())!)
            }
            return UIImagePNGRepresentation(privateImage!)!
        }
    }
    
    ///相册获取的图片
    init(asset : ALAsset) {
        self.asset = asset
    }
    
    ///用于拍照时获取的图片
    init(image: UIImage) {
        self.privateImage = image
    }
    
}
