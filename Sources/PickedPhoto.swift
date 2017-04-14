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
    
    static let path = "/Documents/PhotoPick/"
    
    ///原图
    public var originalImage: UIImage {
        get{
            if let privateImage = privateImage {
                return privateImage
            }
            
            return AssetTool.imageFromAsset(representation: asset!.defaultRepresentation())!
        }
    }
    
    ///返回压缩图 compress
    public var image: UIImage? {
        get{
            return originalImage.scaleToMaxSidePixels(maxSidePixels: maxSidePixels, minStretchSidePixels: minStretchSidePixels)
        }
    }
    
    ///是否为gif图
    public var isGIF: Bool {
        get{
            return asset?.defaultRepresentation().filename().components(separatedBy: ".").last == "GIF"
        }
    }
    
    ///若是gif, 使用Data数据流传输到服务器
    public var data: Data {
        get{
            if let asset = asset{
                return AssetTool.dataFromAsset(representation: (asset.defaultRepresentation())!)
            }
            return UIImagePNGRepresentation(privateImage!)!
        }
    }
    
    public var name: String {
        get{
            if let asset = asset{
                return asset.defaultRepresentation().filename()
            }
            let date = Date(timeIntervalSinceNow: 0)
            return "\(date.timeIntervalSince1970)"
        }
    }
    
    public var imagePath: String {
        get{
            let fileManager = FileManager.default
            let directPath = NSHomeDirectory() + PickedPhoto.path
            if !fileManager.fileExists(atPath: directPath){
                do {
                    try fileManager.createDirectory(atPath: directPath, withIntermediateDirectories: true, attributes: nil)
                } catch {
                }
            }
            let imagePath: String = directPath + name
            fileManager.createFile(atPath: imagePath, contents: data, attributes: nil)
            return "file://" + imagePath
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
    
    static func clearDisk(){
        let fileManager = FileManager.default
        let imagesPath: String = NSHomeDirectory() + PickedPhoto.path
            do {
                try fileManager.removeItem(atPath: imagesPath)
            } catch {
        }
    }
}
