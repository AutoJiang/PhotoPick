//
//  CameraCell.swift
//  PhotoPick
//
//  Created by Auto Jiang on 2016/12/23.
//  Copyright © 2016年 Auto Jiang. All rights reserved.
//

import UIKit

class CameraCell: UICollectionViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    static let identifier = "CameraCell"
    
    var host: UIViewController?
    
    var doneTakePhoto: ([AssetImage]) -> Void = {_ in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let title = UILabel(frame: frame)
        title.text = "拍摄"
        title.font = UIFont.systemFont(ofSize: 30)
        title.textColor = UIColor.yellow
        title.textAlignment = .center
        self.addSubview(title)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture));
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapGesture() {
        if let vc = host {
            let controller = UIImagePickerController()
            controller.sourceType = .camera
            controller.delegate = self
            vc.present(controller, animated: true, completion: nil)
        }

    }
    // MARK: - UIImagePickerControllerDelegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if picker.sourceType == .camera {

            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            //图片存入相册
            //UIImageWriteToSavedPhotosAlbum( image, nil, nil, nil);
            
            let assetUrl = info[UIImagePickerControllerReferenceURL]
            //PhotoGroupManager().assetForURL(assetUrl)
            let assetimage = AssetImage(image: image)
            doneTakePhoto([assetimage])
            
        }
    }
}
