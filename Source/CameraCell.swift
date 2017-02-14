//
//  CameraCell.swift
//  PhotoPick
//
//  Created by Auto Jiang on 2016/12/23.
//  Copyright © 2016年 Auto Jiang. All rights reserved.
//

import UIKit

class CameraCell: UICollectionViewCell {
    
    static let identifier = "CameraCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let title = UILabel(frame: frame)
        title.text = "拍摄"
        title.font = UIFont.systemFont(ofSize: 30)
        title.textColor = UIColor.yellow
        title.textAlignment = .center
        self.addSubview(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
