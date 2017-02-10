//
//  CellModel.swift
//  PhotoPick
//
//  Created by jiang aoteng on 2016/12/18.
//  Copyright © 2016年 Auto Jiang. All rights reserved.
//

import UIKit
import AssetsLibrary

class AssetModel: NSObject {
    var asset : ALAsset
    var isSelect : Bool
    
    init(asset:ALAsset, isSelect:Bool) {
        self.asset = asset
        self.isSelect = isSelect
    }

    override func isEqual(_ object: Any?) -> Bool {
        let obj = object as! AssetModel
        let a = obj.asset.defaultRepresentation().url()
        let b = self.asset.defaultRepresentation().url()
        return a?.absoluteString == b?.absoluteString
    }
    
    public func didSelected(selected:Bool) {
        isSelect = selected
        if isSelect {
            let image = AssetTool.imageFromAsset(representation: asset.defaultRepresentation())
            SDImageCache.shared().store(image, forKey: asset.defaultRepresentation().url().absoluteString)
        }else{
            SDImageCache.shared().removeImage(forKey: asset.defaultRepresentation().url().absoluteString)
        }
    }
}
