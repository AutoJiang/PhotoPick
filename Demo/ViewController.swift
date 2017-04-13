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
    
    func showImages(photos:[PickedPhoto]) {
        let view = UIView(frame: CGRect(x: 10, y: 100, width: 300, height: 300))
        self.view.addSubview(view);
        showView = view
        let width = 100
        for row in 0...2 {
            for col in 0...2 {
                let index = row * 3 + col
                if  index >= photos.count {
                    break
                }

                let iv = UIImageView(frame: CGRect(x: col * width, y: row * width, width: width, height: width))
                let image : UIImage = photos[index].image!;
                iv.image = image
                iv.contentMode = .scaleAspectFill
                iv.clipsToBounds = true
                view.addSubview(iv)
                print(photos[index].isGIF)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonOnclick(){
        if let v = showView {
            v.removeFromSuperview()
        }
        PhotoPick.share.show(fromVC: self, deleage: self)
    }
    
    
    func photoPick(pothoPick: PhotoPick, assetImages: [PickedPhoto]) {
        self.showImages(photos: assetImages)
    }
    
}

