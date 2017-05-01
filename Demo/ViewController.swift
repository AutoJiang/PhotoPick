//
//  ViewController.swift
//  Demo
//
//  Created by Auto Jiang on 2017/4/17.
//
//

import UIKit
import PhotoPick

class ViewController: UIViewController, PhotoPickDelegate {
    
    private var showView :UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        let titleAray = ["编辑成方形图片的单张图片","普通相册选图","相册选图(带拍照)","系统拍照"]
        var y: CGFloat = 350
        for i in 0...3 {
            y = createBtns(posY: y, tag: i, title: titleAray[i])
        }
    }
    
    func createBtns(posY: CGFloat, tag: Int, title: String) -> CGFloat{
        let width = view.frame.width
        let button = UIButton()
        button.frame.size = CGSize(width: width - 50, height: 30)
        button.center = CGPoint(x: 0.5 * width, y: posY)
        view.addSubview(button)
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor.orange
        button.tag = tag
        button.addTarget(self, action: #selector(buttonOnclick), for: .touchUpInside)
        return posY + 50
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
                print(photos[index].imagePath)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonOnclick(button: UIButton){
        if let v = showView {
            v.removeFromSuperview()
        }
        let tag = button.tag
        if tag == 0 {
            PhotoPick.shared.show(fromVC: self, type: .editedSinglePhoto, delegate: self)
        }else if tag == 1 {
            PhotoPick.shared.show(fromVC: self, type: .normal, delegate: self)
        }else if tag == 2 {
            PhotoPick.shared.show(fromVC: self, type: .showCamera, delegate: self)
        }else if tag == 3 {
            PhotoPick.shared.show(fromVC: self, type: .systemCamera, delegate: self)
        }
    }
    
    
    func photoPick(pothoPick: PhotoPick, assetImages: [PickedPhoto]) {
        self.showImages(photos: assetImages)
    }
    
}
