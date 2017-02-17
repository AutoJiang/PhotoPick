//
//  BigPhotoCell.swift
//  PhotoPick
//
//  Created by jiang aoteng on 2016/12/18.
//  Copyright © 2016年 Auto Jiang. All rights reserved.
//

import UIKit

class BigPhotoCell: UICollectionViewCell,UIAccelerometerDelegate{
    
    public var zoomScrollView = GKitImageBrowseZoomScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(zoomScrollView);
    }
    
    func bind(model:PhotoModel){
        guard let representation = model.asset.defaultRepresentation() else {
            return ;
        }
        self.zoomScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.zoomScrollView.zoomScale = 1.0
        // 将scrollview的contentSize还原成缩放前
        
        self.zoomScrollView.contentSize = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        
        self.zoomScrollView.zoomImageView.image = AssetTool.imageFromAsset(representation: representation)
        let dimension = representation.dimensions()
        let width = self.frame.width
        let height = (width * dimension.height) / dimension.width
        self.zoomScrollView.zoomImageView.frame.size = CGSize(width: self.frame.width, height: height)
        self.zoomScrollView.zoomImageView.center = CGPoint(x: width/2, y: self.frame.height/2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
