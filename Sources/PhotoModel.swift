//
//  CellModel.swift
//  PhotoPick
//
//  Created by jiang aoteng on 2016/12/18.
//  Copyright © 2016年 Auto Jiang. All rights reserved.
//

import UIKit
import AssetsLibrary

class PhotoModel: NSObject {
    var asset : ALAsset
    var isSelect : Bool = false
    
    var image: UIImage {
        return UIImage(cgImage: asset.thumbnail().takeUnretainedValue(), scale: 1.0, orientation: .up)
    }
    
    init(asset:ALAsset, isSelect:Bool) {
        self.asset = asset
        self.isSelect = isSelect
    }

    override func isEqual(_ object: Any?) -> Bool {
        let obj = object as! PhotoModel
        let a = obj.asset.defaultRepresentation().url()
        let b = self.asset.defaultRepresentation().url()
        return a?.absoluteString == b?.absoluteString
    }
    
    static func convertToPickedPhotos(photoModels: [PhotoModel]) -> [PickedPhoto] {
        return photoModels.map{ PickedPhoto(asset: $0.asset)}
    }
}
