//
//  PhotoCell.swift
//  PhotoPick
//
//  Created by Auto Jiang on 2016/12/16.
//  Copyright © 2016年 Auto Jiang. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    static let identifier = "PhotoCell"
    
    private var imageV = UIImageView()
    
    public var indexLbl = CircleLabel()
    
    var selectBtn = CircleButton()
    
    var btnEventBlock: ((_:PhotoCell) -> Void)?
    
    var menV = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let iV = UIImageView()
        iV.frame = self.bounds
        addSubview(iV)
        imageV = iV
        
        let btn = CircleButton(frame: CGRect(x: self.frame.size.width - 28, y: 3, width: 25, height: 25))
        btn.addTarget(self, action: #selector(PhotoCell.bntOnclick), for: .touchUpInside)
        self.addSubview(btn)
        selectBtn = btn
    }
    
    public func bind(image:UIImage){
        imageV.image = image
    }
    
    func bntOnclick(){
        self.btnEventBlock!(self)
        selectBtn.isSelected = !selectBtn.isSelected
    }
    
    func showCircle(isAnimate:Bool){
        self.menV = UIView(frame: self.bounds)
        menV.backgroundColor = UIColor.black
        menV.alpha = 0.3
        menV.isUserInteractionEnabled = false
        self.addSubview(menV)
        
        indexLbl = CircleLabel(frame: selectBtn.frame)
        self.addSubview(indexLbl)
        if isAnimate{
            indexLbl.addAnimate()
        }
    }
    
    func clearCicle(){
        indexLbl.removeFromSuperview()
        menV.removeFromSuperview()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}






