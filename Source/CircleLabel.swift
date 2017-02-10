//
//  CircleLabel.swift
//  PhotoPick
//
//  Created by Auto Jiang on 2016/12/23.
//  Copyright © 2016年 Auto Jiang. All rights reserved.
//

import UIKit

class CircleLabel: UILabel {
    lazy private var animate :CABasicAnimation = {
        let ca = CABasicAnimation(keyPath: "transform.scale")
        ca.fromValue = 1.0
        ca.toValue = 1.2
        ca.duration = 0.1
        ca.autoreverses = true
        return ca
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = frame.width / 2
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.yellow
        self.textColor = UIColor.black
        self.textAlignment = .center
    }
    
    func addAnimate() {
        self.layer.add(animate, forKey: "scale")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.layer.removeAnimation(forKey: "scale")
    }
}
