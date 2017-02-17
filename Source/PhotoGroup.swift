//
//  PhotoGroup.swift
//  GKitPhotoPick
//
//  Created by Auto Jiang on 2017/2/14.
//  Copyright © 2017年 Auto Jiang. All rights reserved.
//

import Foundation
import AssetsLibrary

class PhotoGroup {
    
    var assetModels: [PhotoModel]?
    var assetGroup: ALAssetsGroup
    
    init(assetGroup:ALAssetsGroup) {
        self.assetGroup = assetGroup
    }
    
    func name() -> String {
        return assetGroup.value(forProperty: ALAssetsGroupPropertyName) as! String
    }
    
}

class PhotoGroupManager {
    //TODO: singleton
    private let library: ALAssetsLibrary = ALAssetsLibrary()
    
    private func findAllGroups(groupType: UInt32, groupsCallback: @escaping ([PhotoGroup]) -> Void){
        var groups = Array<PhotoGroup>()
        library.enumerateGroupsWithTypes(groupType, usingBlock:{
            group, stop in
            guard let g = group else {
                if groups.count > 0 {
                    //遍历
                    groupsCallback(groups)
                }else {
                    print("没有相册列表")
                }
                return
            }
            g.setAssetsFilter(ALAssetsFilter.allPhotos())
            if g.numberOfAssets() > 0 {
                groups.append(PhotoGroup(assetGroup: g))
            }
        }, failureBlock: { error in
            print("遍历失败")
        })
    }

    func findGroupGroupAll(groupsCallback: @escaping ([PhotoGroup]) -> Void){
        findAllGroups(groupType: ALAssetsGroupAll, groupsCallback: groupsCallback)
    }
    
    func findAllPhotoModelsByGroups(by groups: [PhotoGroup], callback: @escaping ([PhotoModel]) -> Void){
        var photoModels = [PhotoModel]()
        for group: PhotoGroup in groups {
            group.assetGroup.enumerateAssets(options: .reverse, using: { (result, index, stop) in
                guard let r = result else{
                    callback(photoModels)
                    return
                }
                let model = PhotoModel(asset: r, isSelect: false)
                photoModels.append(model)
            })
        }
    }
    
    func findAllPhotoModels(callback: @escaping ([PhotoModel]) -> Void){
        findAllGroups(groupType: ALAssetsGroupSavedPhotos, groupsCallback: { [unowned self]
            groups in
            self.findAllPhotoModelsByGroups(by: groups, callback: callback)
        })
    }
    /*
    func assetForURL(url:String, callback: @escaping (PhotoModel) -> Void){

        library.asset(for: URL(string: url), resultBlock: { asset in
            if let asset = asset {
                let model = PhotoModel(asset: asset, isSelect: true)
                callback(model)
            }
        }
            , failureBlock: ALAssetsLibraryAccessFailureBlock!)
    }
    */
}
