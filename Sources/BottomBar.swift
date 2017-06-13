//
//  BottomBar.swift
//  GKitPhotoPick
//
//  Created by Auto Jiang on 2017/2/17.
//  Copyright © 2017年 Auto Jiang. All rights reserved.
//

import UIKit

class BottomBar: UIView {
    
    static let kBottomBarHeight: CGFloat = 50
    
    var goShowPage = {}
    
    var onConfirm = {}
    
    private let previewBtn: UIButton = {
        //预览按钮
        let previewBtn = UIButton(frame: CGRect(x: 12, y: 0, width: 38, height: BottomBar.kBottomBarHeight))
        previewBtn.setTitle("预览", for: .normal)
        previewBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        previewBtn.setTitleColor(UIColor.white, for: .normal)
        previewBtn.backgroundColor = UIColor.clear
        previewBtn.addTarget(self, action: #selector(doGoShowPage), for: .touchUpInside)
        previewBtn.isHidden = true
        return previewBtn
    }()
    
    func updatePickedPhotoCount(count: Int){
        if count == 0 {
            indexLbl.isHidden = true
            previewBtn.isHidden = true
            return
        }
        previewBtn.isHidden = false
        indexLbl.isHidden = false
        indexLbl.text = "\(count)"
        indexLbl.addAnimate()
    }
    
    private lazy var indexLbl: CircleLabel = {
        let v = CircleLabel(frame: CGRect(x: self.frame.width - 80, y: 13, width: 25, height: 25))
        v.isHidden = true
        return v
    }()

    override init(frame: CGRect) {
        let width: CGFloat = UIScreen.main.bounds.width
        let y: CGFloat = UIScreen.main.bounds.height - BottomBar.kBottomBarHeight
        super.init(frame: CGRect(x: 0, y: y, width: width, height: BottomBar.kBottomBarHeight))
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        addSubview(previewBtn)
        
        //确定按钮
        let confirmBtn = UIButton(frame: CGRect(x: width - 50, y: 0, width: 38, height: BottomBar.kBottomBarHeight))
        confirmBtn.setTitle("确定", for: .normal)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        confirmBtn.setTitleColor(PhotoPickConfig.shared.tintColor, for: .normal)
        confirmBtn.backgroundColor = UIColor.clear
        confirmBtn.addTarget(self, action: #selector(doOnConfirm), for: .touchUpInside)
        addSubview(confirmBtn)
        
        //选中图片数字
        addSubview(indexLbl)
    }
    
    func doGoShowPage(){
        goShowPage()
    }
    
    func doOnConfirm(){
        onConfirm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
