//
//  ViewController.swift
//  PhotoPick
//
//  Created by Auto Jiang on 2016/12/14.
//  Copyright © 2016年 Auto Jiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PhotoPickDelegate {
    
    private var showView :UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let width = view.frame.width
        let height = view.frame.height;
        
        let button = UIButton()
        button.frame.size = CGSize(width: width - 50, height: 44)
        button.center = CGPoint(x: 0.5*width, y: 0.9*height)
        view.addSubview(button)
        button.setTitle("图片选择", for: .normal)
        button.backgroundColor = UIColor.orange
        button.addTarget(self, action: #selector(buttonOnclick), for: .touchUpInside)
    }
    
    func showImages(photos:Array<AssetImage>) {
        let view = UIView(frame: CGRect(x: 10, y: 100, width: 300, height: 300))
        self.view.addSubview(view);
        showView = view
        let width = 100
        for var i in 0...2 {
            for var j in 0...2 {
                let index = i * 3 + j
                if  index >= photos.count{
                    break
                }
                let X = j * width
                let Y = i * width
                let imageV = UIImageView(frame: CGRect(x: X, y: Y, width: width, height: width))
                let obj = photos[index]
                let image : UIImage = obj.image();
                imageV.image = image
                imageV.contentMode = .scaleAspectFill
                imageV.clipsToBounds = true
                view.addSubview(imageV)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonOnclick(){
        let pv =  PhotoPickVC(isShowCamera: true)
        let nav = UINavigationController(rootViewController: pv)
        self.present(nav, animated: true, completion: nil)
        pv.delegate = self
        if let v = showView {
            v.removeFromSuperview()
        }
    }
    
    func photoPick(pickVC: PhotoPickVC, assetImages: [AssetImage]) {
        self.showImages(photos: assetImages)
    }
}

