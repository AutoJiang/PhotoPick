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
    
    //cell状态改变回调
    public var selectChangeCallback: ((_:PhotoCell) -> Void) = {_ in}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iv)
        addSubview(selectBtn)
        addSubview(ivMaskView)
        addSubview(indexLbl)
    }
    
    public func bind(image: UIImage){
        iv.image = image
    }
    
    public func cellUnselect(){
        indexLbl.isHidden = true
        ivMaskView.isHidden = true
    }
    
    public func cellSelect(animated:Bool = false, index: String? = nil){
        ivMaskView.isHidden = false
        indexLbl.isHidden = false
        if let index = index {
            indexLbl.text = index
        }
        if animated {
            indexLbl.addAnimate()
        }
    }
    
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
        let btn = CircleButton(frame: CGRect(x: self.frame.size.width - 30, y: 2, width: 28, height: 28))
        btn.addTarget(self, action: #selector(PhotoCell.onSelectChange), for: .touchUpInside)
        return btn
    }()
    
    private lazy var ivMaskView: UIView = {
        let maskView:UIView = UIView(frame: self.bounds)
        maskView.backgroundColor = UIColor.black
        maskView.alpha = 0.3
        maskView.isUserInteractionEnabled = false
        maskView.isHidden = true
        return maskView
    }()
    
    @objc private func onSelectChange(){
        self.selectChangeCallback(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}






