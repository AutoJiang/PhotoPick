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
}

class PhotoGroupManager {
    //TODO: singleton
    
    func findAllGroups(callback: ([PhotoGroup]) -> Void){
        
    }
    
    func findAllPhotoModels(callback: ([PhotoModel]) -> Void){
        
    }
    
    func findAllPhotoModels(by group: PhotoGroup, callback: ([PhotoModel]) -> Void){
        
    }
    
    func clear(){
        
    }
}
