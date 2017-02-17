//
//  AssetImage.swift
//  GKitPhotoPick
//
//  Created by Auto Jiang on 2017/2/13.
//  Copyright © 2017年 Auto Jiang. All rights reserved.
//

import UIKit
import AssetsLibrary

public class AssetImage: NSObject {
    private var asset : ALAsset?
    private var privateImage: UIImage?
    private let maxSidePixels : CGFloat = 1280
    private let minStretchSidePixels : CGFloat = 440
    
    //原图
    public var image: UIImage {
        get{
            if let privateImage = privateImage {
                return privateImage
            }
            
            return AssetTool.imageFromAsset(representation: asset!.defaultRepresentation())
        }
    }
    //返回压缩图 compress
    public var compressedImage:UIImage{
        get{
            return self.image.gkit_scale(toMaxSidePixels: maxSidePixels, minStretchSidePixels: minStretchSidePixels)
        }
    }
    
    init(asset : ALAsset) {
        self.asset = asset
    }
    
    init(image: UIImage) {
        self.privateImage = image
    }
    
}
