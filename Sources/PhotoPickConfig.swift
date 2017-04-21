//
//  PhotoPickConfig.swift
//  GKitPhotoPick
//
//  Created by Auto Jiang on 2017/2/14.
//  Copyright © 2017年 Auto Jiang. All rights reserved.
//

import Foundation
import UIKit

//TODO: 明确定义对外提供的参数（JPG压缩率、图片最大分辨率、长微博图片规则、是否需要GIF、是否显示拍照、选择图片数量控制、单张图片是否可以编辑、是否显示序号）

public class PhotoPickConfig: NSObject {
    
    //单例
    private override init(){}
    
    public static let shared = PhotoPickConfig()
    
    /// 最多可选图片数量(默认9)
    public var maxSelectImagesCount: Int = 9
    
    /// 当返回JPG图片时自动进行的压缩系数(默认0.5)
    public var jpgQuality: CGFloat = 0.5

    /// 最长宽
    public var maxLongSidePixel: CGFloat = 1280
    
    /// TODO:
    public var maxShortSidePixel: CGFloat = 720
    
    /// 是否需要显示摄像头(默认: true)
    public var needShowCamera: Bool = true
    
    /// 是否需要GIF(默认: true)
    public var needGIF: Bool = true
    
    /// 是否允许编辑(只有单张图片时才有效)
    public var enableEdit: Bool = false
    
    /// 允许编辑时图片未撑满全屏需要填充背景颜色
    public var editFillColor: UIColor = UIColor.black
    
    /// 是否需要
    public var needShowOrder: Bool = true
    
    /// 是否自动清理图片文件缓存
    public var isAutoClearDisk: Bool = true
    
    //控件颜色
    public var tintColor: UIColor = UIColor.orange
    
    //导航栏颜色
    public var NavBarColor: UIColor = UIColor.yellow
    
    /// 是否是长微博
    public var isLongImage: (_ width: CGFloat, _ height: CGFloat) -> Bool = { (width, height) in
        if width == 0 || height == 0 {
            return false
        }
        
        return width/height > 3 || height/width > 3
    }
}
