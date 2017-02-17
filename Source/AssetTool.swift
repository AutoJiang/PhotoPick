//
//  AssetTool.swift
//  GKitPhotoPick
//
//  Created by Auto Jiang on 2017/2/9.
//  Copyright © 2017年 Auto Jiang. All rights reserved.
//

import UIKit
import AssetsLibrary
class AssetTool{
    //转化UIimage
    public static func imageFromAsset(representation:ALAssetRepresentation) -> UIImage {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(representation.size()))
        var error : NSError?
        let length = representation.getBytes(buffer, fromOffset: Int64(0), length: Int(representation.size()), error: &error)
        let da :Data =  NSData(bytes: buffer, length: length) as Data
        return UIImage.sd_animatedGIF(with: da)
    }
}
