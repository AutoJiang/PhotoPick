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
    private var asset : ALAsset
    private let maxSidePixels : CGFloat = 1280
    private let minStretchSidePixels : CGFloat = 440
    
    init(asset : ALAsset) {
        self.asset = asset
    }
    //返回原图
    func image() -> UIImage {
        return AssetTool.imageFromAsset(representation: asset.defaultRepresentation())
    }
    
    //返回压缩图 compress
    func imageWithCompress() -> UIImage {
        let image = self.image()
        return image.gkit_scale(toMaxSidePixels: maxSidePixels, minStretchSidePixels: minStretchSidePixels)
    }
}
