//
//  PhotoGroup.swift
//  GKitPhotoPick
//
//  Created by Auto Jiang on 2017/2/14.
//  Copyright © 2017年 Auto Jiang. All rights reserved.
//

import Foundation
import AssetsLibrary

struct PhotoGroup {
    
    var assetModel: [PhotoModel]
    var assetGroup: ALAssetsGroup
    var name: String = ""
    
    static func findAllGroups(callback: ([PhotoGroup]) -> Void){
        
    }
    
    static func findAllPhotoModels(callback: ([PhotoModel]) -> Void){
        
    }
    
    static func findAllPhotoModels(by group: PhotoGroup, callback: ([PhotoModel]) -> Void){
        
    }

}
