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
        let v = UIImageView()
        v.frame = self.bounds
        return v
    }()
    
    private lazy var indexLbl: CircleLabel = {
        let v: CircleLabel = CircleLabel(frame: self.selectBtn.frame)
        v.isHidden = true
        return v
    }()
    
    private lazy var selectBtn: CircleButton = {
        let btn = CircleButton(frame: CGRect(x: self.frame.size.width - 28, y: 3, width: 25, height: 25))
        btn.addTarget(self, action: #selector(PhotoCell.onClick), for: .touchUpInside)
        return btn
    }()
    
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
        addSubview(selectBtn)
        addSubview(ivMaskView)
        addSubview(indexLbl)
    }
    
    public func cellUnselect(){
        indexLbl.isHidden = true
        ivMaskView.isHidden = true
    }
    
    public func cellSelect(isAnimate:Bool = false, index: String? = nil){
        ivMaskView.isHidden = false
        indexLbl.isHidden = false
        if let index = index {
            indexLbl.text = index
        }
        if isAnimate{
            indexLbl.addAnimate()
        }
    }
    
    public func bind(image: UIImage? = nil){
        if let image = image {
            iv.image = image
        }
    }
    
    func onClick(){
        self.btnEventBlock!(self)
        selectBtn.isSelected = !selectBtn.isSelected
    }
    
    func showCircle(isAnimate:Bool){
        ivMaskView.isHidden = false
        indexLbl.isHidden = false
        if isAnimate{
            indexLbl.addAnimate()
        }
    }
    
    func clearCicle(){
        indexLbl.isHidden = true
        ivMaskView.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}






