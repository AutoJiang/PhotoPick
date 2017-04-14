//
//  AssetTool.swift
//  GKitPhotoPick
//
//  Created by Auto Jiang on 2017/2/9.
//  Copyright © 2017年 Auto Jiang. All rights reserved.
//

import UIKit
import AssetsLibrary
import ImageIO

class AssetTool {
    //转化UIimage
    public static func imageFromAsset(representation:ALAssetRepresentation) -> UIImage? {
        let da: Data = dataFromAsset(representation: representation)
        return UIImage.animatedGif(data: da as Data!)
    }
    
    //转化NSData
    public static func dataFromAsset(representation:ALAssetRepresentation) -> Data {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(representation.size()))
        var error : NSError?
        let length = representation.getBytes(buffer, fromOffset: Int64(0), length: Int(representation.size()), error: &error)
        let da =  NSData(bytes: buffer, length: length)
        return da as Data
    }
}

