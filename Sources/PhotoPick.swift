//
//  PhotoPick.swift
//  GKitPhotoPick
//
//  Created by Auto Jiang on 2017/4/12.
//  Copyright © 2017年 Auto Jiang. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary

public enum PhotoPickType {
    case editedSinglePhoto //需要编辑成方形图片的单张图片
    case normal            //无需编辑
    case showCamera        //内部显示显示拍照
    case systemCamera      //直接调用系统拍照
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
        switch type {
            
        case .normal:
            if !isALAssetsLibraryAvailable(from: fromVC) {
                return
            }
            let pv =  PhotoPickVC(isShowCamera: false, maxSelectImagesCount: count)
            pv.delegate = self
            let nav = UINavigationController(rootViewController: pv)
            fromVC.present(nav, animated: true, completion: nil)
            
        case .editedSinglePhoto:
            if !isALAssetsLibraryAvailable(from: fromVC) {
                return
            }
            let imagePC = UIImagePickerController()
            imagePC.allowsEditing = true
            imagePC.delegate = self
            imagePC.sourceType = .photoLibrary
            fromVC.present(imagePC, animated: true, completion: nil)
            imagePick = imagePC
            
        case .showCamera:
            if !isALAssetsLibraryAvailable(from: fromVC) || !isCameraAvailable(from: fromVC){
                return
            }
            let pv =  PhotoPickVC(isShowCamera: true, maxSelectImagesCount: count)
            pv.delegate = self
            let nav = UINavigationController(rootViewController: pv)
            fromVC.present(nav, animated: true, completion: nil)
            
        case .systemCamera:
            if !isCameraAvailable(from: fromVC){
                return
            }
            let imagePC = UIImagePickerController()
            imagePC.allowsEditing = true
            imagePC.delegate = self
            imagePC.sourceType = .camera
            fromVC.present(imagePC, animated: true, completion: nil)
            imagePick = imagePC
        }
    }
    
    internal static func showOneCancelButtonAlertView(from: UIViewController, title: String, subTitle: String?) {
        let alertController = UIAlertController(title: title, message: subTitle, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(action)
        from.present(alertController, animated: true, completion: nil)
    }
    
    private func isALAssetsLibraryAvailable(from: UIViewController) -> Bool {
        let authStatus = ALAssetsLibrary.authorizationStatus()
        if authStatus == .restricted || authStatus == .denied {
            PhotoPick.showOneCancelButtonAlertView(from: from, title: "相册无法打开", subTitle: "应用相册权限受限,请在设置中启用")
            return false
        }
        return true
    }
    
    private func isCameraAvailable(from: UIViewController) -> Bool {
        guard UIImagePickerController.isCameraDeviceAvailable(.rear) else {
            PhotoPick.showOneCancelButtonAlertView(from: from, title: "摄像头无法使用", subTitle: nil)
            return false
        }
        
        let mediaType = AVMediaTypeVideo
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: mediaType)
        if authStatus == .restricted || authStatus == .denied {
            PhotoPick.showOneCancelButtonAlertView(from: from, title: "相机无法打开", subTitle: "应用相机权限受限,请在设置中启用")
            return false
        }
        return true
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
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        picker.dismiss(animated: true, completion: nil)
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
