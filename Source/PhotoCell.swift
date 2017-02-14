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
    
    private lazy var iv: UIImageView = {
        let iV = UIImageView() //TODO lazy var
        iV.frame = self.bounds
        return iV
    }()
    
    public var indexLbl = CircleLabel()
    
    var selectBtn = CircleButton()
    
    var btnEventBlock: ((_:PhotoCell) -> Void)?
    
    private lazy var ivMaskView: UIView = {
        let maskView:UIView = UIView(frame: self.bounds)
        maskView.backgroundColor = UIColor.black
        maskView.alpha = 0.3
        maskView.isUserInteractionEnabled = false
        maskView.isHidden = true
        return maskView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iv)
        
        let btn = CircleButton(frame: CGRect(x: self.frame.size.width - 28, y: 3, width: 25, height: 25))
        btn.addTarget(self, action: #selector(PhotoCell.bntOnclick), for: .touchUpInside)
        self.addSubview(btn)
        selectBtn = btn
        
        addSubview(ivMaskView)
    }
    
    public func bind(image:UIImage){
        iv.image = image
    }
    
    func bntOnclick(){
        self.btnEventBlock!(self)
        selectBtn.isSelected = !selectBtn.isSelected
    }
    
    func showCircle(isAnimate:Bool){
        
        ivMaskView.isHidden = false
        
        indexLbl = CircleLabel(frame: selectBtn.frame) //TODO 改成成员变量
        self.addSubview(indexLbl)
        if isAnimate{
            indexLbl.addAnimate()
        }
    }
    
    func clearCicle(){
        indexLbl.removeFromSuperview()
        ivMaskView.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}






