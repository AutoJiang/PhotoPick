//
//  PhotoPick.swift
//  GKitPhotoPick
//
//  Created by Auto Jiang on 2017/4/12.
//  Copyright © 2017年 Auto Jiang. All rights reserved.
//

import UIKit

public enum PhotoPickType {
    case editedSinglePhoto //需要编辑成方形图片的单张图片
    case normal            //无需编辑
    case showCamera        //内部显示显示拍照
}

public protocol PhotoPickDelegate: class {
    
    func photoPick(pothoPick: PhotoPick, assetImages: [PickedPhoto]) -> Void
    
    func photoPickCancel(pothoPick: PhotoPick) -> Void
}

public extension PhotoPickDelegate {
    
    func photoPickCancel(pothoPick: PhotoPick) -> Void{}
}


public class PhotoPick: NSObject, PhotoPickVCDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //单例
    static public let shared = PhotoPick()
    
    private override init() {}
    
    public weak var delegate: PhotoPickDelegate?
    
    private var imagePick: UIImagePickerController?
    
    public func show(fromVC: UIViewController, type: PhotoPickType = .normal, delegate: PhotoPickDelegate) {
        self.delegate = delegate
        let count = PhotoPickConfig.shared.maxSelectImagesCount
        if type == .normal {
            let pv =  PhotoPickVC(isShowCamera: false, maxSelectImagesCount: count)
            pv.delegate = self
            let nav = UINavigationController(rootViewController: pv)
            fromVC.present(nav, animated: true, completion: nil)
        }else if type == .editedSinglePhoto {
            let imagePC = UIImagePickerController()
            imagePC.allowsEditing = true
            imagePC.delegate = self
            imagePC.sourceType = .photoLibrary
            fromVC.present(imagePC, animated: true, completion: nil)
            imagePick = imagePC
        }else if type == .showCamera {
            let pv =  PhotoPickVC(isShowCamera: true, maxSelectImagesCount: count)
            pv.delegate = self
            let nav = UINavigationController(rootViewController: pv)
            fromVC.present(nav, animated: true, completion: nil)
        }
    }

    ///MARK: PhotoPickVCDelegate
    func photoPick(pickVC: PhotoPickVC, assetImages: [PickedPhoto]) {
        if let delegate = self.delegate {
            delegate.photoPick(pothoPick: self, assetImages: assetImages)
        }
    }
    
    func photoPickCancel(pickVC: PhotoPickVC) {
        if let delegate = self.delegate {
            delegate.photoPickCancel(pothoPick: self)
        }
    }
    
    ///MARK: UIImagePickerControllerDelegate

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        let model = PickedPhoto(image: image )
        if let delegate = self.delegate {
            delegate.photoPick(pothoPick: self, assetImages: [model])
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if let delegate = self.delegate {
            delegate.photoPickCancel(pothoPick: self)
        }
        guard let vc = imagePick else {
            return
        }
        vc.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        if PhotoPickConfig.shared.isAutoClearDisk {
            PickedPhoto.clearDisk()
        }
    }
}
