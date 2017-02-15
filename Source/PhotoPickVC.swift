//
//  PhotoPickVC.swift
//  PhotoPick
//
//  Created by Auto Jiang on 2016/12/14.
//  Copyright © 2016年 Auto Jiang. All rights reserved.
//

import UIKit
import AssetsLibrary

public protocol PhotoPickDelegate: class {
    
    func photoPick(pickVC: PhotoPickVC, assetImages: [AssetImage]) -> Void
    
    func photoPickCancel(pickVC: PhotoPickVC) -> Void
    //TODO: 添加取消回调
    //TODO: 单张图片是否需要特殊
}

extension PhotoPickDelegate {
    
    func photoPick(pickVC : PhotoPickVC, assetImages : [AssetImage]) -> Void {}
    func photoPickCancel(pickVC: PhotoPickVC) -> Void {}
    
}

//TODO: 明确定义对外提供的参数（JPG压缩率、图片最大分辨率、长微博图片规则、是否需要GIF、是否显示拍照、选择图片数量控制、单张图片是否可以编辑、是否显示序号）


public class PhotoPickVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let kCellSpacing: CGFloat = 3

    private let kBottomBarHeight: CGFloat = 50
    
    private let cellColumnCount: Int
    
    private let cellSize: CGFloat
    
    private let bottomBar = UIView()
    
    private let library: ALAssetsLibrary = ALAssetsLibrary()
    
    public weak var delegate: PhotoPickDelegate?
    
    public let config: PhotoPickConfig = PhotoPickConfig()
    

    var groups : [ALAssetsGroup]? //TODO: 去除
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.cellSize, height: self.cellSize)
        layout.minimumLineSpacing = self.kCellSpacing
        layout.minimumInteritemSpacing = self.kCellSpacing
        let cV = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        cV.delegate = self
        cV.dataSource = self
        cV.backgroundColor = UIColor.white
        cV.register(PhotoCell.self ,forCellWithReuseIdentifier: PhotoCell.identifier)
        cV.register(CameraCell.self ,forCellWithReuseIdentifier: CameraCell.identifier)
        return cV
    }()
    
    var showLbl = CircleLabel() // TODO: 改名

    let isShowCamera :Bool
    
    enum SourceType {
        case all
        case group
    }
    
    var sourceType: SourceType = .all
    
    var photoModels = [PhotoModel]()
    var selectedPhotoModels = [PhotoModel]() {
        didSet{
            reloadLabel()
        }
    }
    
    var photosDidSelected : ([PhotoModel],_ isDone:Bool) -> Void = { _ in } //TODO: 去除
    
    /// 对外提供
    public init(isShowCamera : Bool = true, maxSelectImagesCount:Int = 9, cellColumnCount:Int = 3) {
        config.maxSelectImagesCount = maxSelectImagesCount
        config.jpgQuality = 0.5
        self.cellColumnCount = cellColumnCount
        cellSize = (CGFloat(UIScreen.main.bounds.width) - CGFloat(self.cellColumnCount - 1) * kCellSpacing ) / CGFloat(self.cellColumnCount)
        self.isShowCamera = isShowCamera
        super.init(nibName: nil, bundle: nil)
    }
    
    /// 相册页面初始化
    convenience init(title:String? = "照片选择", group:[ALAssetsGroup], selectedPhotos:[PhotoModel], maxSelectImagesCount:Int = 9){ //TODO: title直接根据group决定
        self.init(isShowCamera:false,maxSelectImagesCount: maxSelectImagesCount, cellColumnCount : 4)
        self.groups = group
        sourceType = .group
        self.selectedPhotoModels = selectedPhotos //TODO: 无需传递
        self.title = title
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        self.createView()
        
        //TODO: 移到
        if groups == nil{
            self.searchPhotos()
        } else {
            self.enumerateAssets()
        }
    }

    func createView(){
        view.addSubview(collectionView)

        let y = self.view.frame.height - kBottomBarHeight
        let width = self.view.frame.width
        bottomBar.frame = CGRect(x: 0, y: y, width: width, height: kBottomBarHeight)
        bottomBar.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.view.addSubview(bottomBar)
        
        //按钮
        let scanBtn = UIButton(frame: CGRect(x: 12, y: 17, width: 38, height: 18))
        scanBtn.setTitle("预览", for: .normal)
        scanBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        scanBtn.setTitleColor(UIColor.white, for: .normal)
        scanBtn.backgroundColor = UIColor.clear
        bottomBar.addSubview(scanBtn)
        
        let confirmBtn = UIButton(frame: CGRect(x: width - 50, y: 17, width: 38, height: 18))
        confirmBtn.setTitle("确定", for: .normal)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        confirmBtn.setTitleColor(UIColor.yellow, for: .normal)
        confirmBtn.backgroundColor = UIColor.clear
        confirmBtn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        bottomBar.addSubview(confirmBtn)
        
        self.showLbl = CircleLabel(frame: CGRect(x: self.view.frame.width - 80, y: 13, width: 25, height: 25))
        
        if sourceType == .all {
            let btnL = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
            btnL.setTitle("取消", for: .normal)
            btnL.setTitleColor(UIColor.black, for: .normal)
            btnL.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
            let leftBar = UIBarButtonItem(customView: btnL)
            self.navigationItem.leftBarButtonItem = leftBar
            
            let btnR = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
            btnR.setTitle("相册", for: .normal)
            btnR.setTitleColor(UIColor.black, for: .normal)
            btnR.addTarget(self, action: #selector(openGroupPhotoVC), for: .touchUpInside)
            
            let rightBar = UIBarButtonItem(customView: btnR)
            self.navigationItem.rightBarButtonItem = rightBar
        }
    }
    
    func openGroupPhotoVC() {
        let groupVC =  PhotoPickGroupVC(selectedPhotos: self.selectedPhotoModels)
        groupVC.cancelBack = { [unowned self] array in
            self.selectedPhotoModels = array
            self.collectionView.reloadData()
        }
        groupVC.confirm = { [unowned self] array in
            self.selectedPhotoModels = array
            self.confirm()
        }
        self.navigationController?.pushViewController(groupVC, animated: true)
    }
    
    
    func searchPhotos() {
        self.groups = Array<ALAssetsGroup>()
        library.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock:{
            group, stop in
            guard let g = group else {
                if (self.groups?.count)! > 0 {
                    //遍历
                    self.enumerateAssets()
                }else {
                    print("没有相册列表")
                }
                return
            }
            g.setAssetsFilter(ALAssetsFilter.allPhotos())
            if g.numberOfAssets() > 0{
                self.groups?.append(g)
            }
        }, failureBlock: { error in
            print("遍历失败")
        })
    }

    func enumerateAssets(){
        for group: ALAssetsGroup in self.groups! {
            group.enumerateAssets(options: .reverse, using: { (result, index, stop) in
                guard let r = result else{
                    //                    self.showImage()
                    self.collectionView.reloadData()
                    return
                }
                let model = PhotoModel(asset: r, isSelect: false)
                self.photoModels.append(PhotoModel(asset: r, isSelect: self.selectedPhotoModels.contains(model)))
            })
        }
    }
    
    func confirm(){
        if let delegate = delegate {
            delegate.photoPick(pickVC: self, assetImages: PhotoModel.convertToAssetImages(photoModels: selectedPhotoModels))
            photosDidSelected(selectedPhotoModels, true)
        }
        dismissVC()
    }
    
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
        if let delegate = delegate {
            delegate.photoPickCancel(pickVC: self)
        }
    }
    
    func popVC() {
        //self.delegate?.PhotoPick(pickVC: self, PhotoModels: self.selectedPhotoModels)
        photosDidSelected(selectedPhotoModels,false)
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func reloadLabel() {
        guard self.selectedPhotoModels.count > 0 else {
            self.showLbl.removeFromSuperview()
            return
        }
        self.showLbl.addAnimate()
        self.showLbl.text = "\(self.selectedPhotoModels.count)"
        self.bottomBar.addSubview(showLbl)
    }
    
    //TODO: 迁移到CameraCell
    // MARK: - UIImagePickerControllerDelegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if picker.sourceType == .camera {
            //图片存入相册
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            UIImageWriteToSavedPhotosAlbum( image, nil, nil, nil);
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDelegate

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isShowCamera ? photoModels.count + 1 : photoModels.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 && isShowCamera {
            let cell: CameraCell =  collectionView.dequeueReusableCell(withReuseIdentifier: CameraCell.identifier, for: indexPath) as! CameraCell
            cell.host = self
            return cell
        }
        
        let cell: PhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as! PhotoCell
        
        let model: PhotoModel = photoModels[getPhotoRow(indexPath: indexPath)]
        cell.bind(image: model.image)
        if model.isSelect {
            let index = self.selectedPhotoModels.index(of: model)
            cell.cellSelect(index: "\(index!+1)")
        } else {
            cell.cellUnselect()
        }
        
        cell.selectChangeCallback = {[weak self] photoCell in
            guard let sSelf = self else {
                return
            }
            
            //取消选中
            if model.isSelect {
                let index = sSelf.selectedPhotoModels.index(of: model)
                sSelf.selectedPhotoModels.remove(at: index!)
                photoCell.cellUnselect()
                model.isSelect = false
                sSelf.collectionView.reloadData()
            }
            
            //选中
            else if sSelf.selectedPhotoModels.count < sSelf.config.maxSelectImagesCount {
                sSelf.selectedPhotoModels.append(model)
                model.isSelect = true
                photoCell.cellSelect(animated: true, index: "\(sSelf.selectedPhotoModels.count)")
            }
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 && isShowCamera {
            //TODO: 迁移到CameraCell
            let controller = UIImagePickerController()
            controller.sourceType = .camera
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
            return
        }
        
        let photoShowVC = PhotoShowVC()
        photoShowVC.assets = self.photoModels //TODO: 改成必填参数
        photoShowVC.selectedPhotoModels = self.selectedPhotoModels //TODO: 改成必填参数
        photoShowVC.index = getPhotoRow(indexPath: indexPath) //TODO: 改成必填参数
        photoShowVC.cancelBack = { _ in
//            self.selectedPhotoModels = array
            self.collectionView.reloadData()
        }
        photoShowVC.confirmBack = { _ in
//            self.selectedPhotoModels = array
        }
        self.navigationController?.pushViewController(photoShowVC, animated: true)
        
    }
    
    private func getPhotoRow(indexPath: IndexPath) -> Int {
        return isShowCamera ? indexPath.row - 1 : indexPath.row
    }
}
