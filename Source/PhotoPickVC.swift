//
//  PhotoPickVC.swift
//  PhotoPick
//
//  Created by Auto Jiang on 2016/12/14.
//  Copyright © 2016年 Auto Jiang. All rights reserved.
//

import UIKit

public protocol PhotoPickDelegate: class {
    
    func photoPick(pickVC: PhotoPickVC, assetImages: [PickedPhoto]) -> Void
    func photoPickCancel(pickVC: PhotoPickVC) -> Void

}

extension PhotoPickDelegate {
    
    func photoPickCancel(pickVC: PhotoPickVC) -> Void {}
    
}

//TODO: 明确定义对外提供的参数（JPG压缩率、图片最大分辨率、长微博图片规则、是否需要GIF、是否显示拍照、选择图片数量控制、单张图片是否可以编辑、是否显示序号）

public class PhotoPickVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    private let kCellSpacing: CGFloat = 3
    
    private let cellColumnCount: Int
    
    private let cellSize: CGFloat
    
    public weak var delegate: PhotoPickDelegate?
    
    public let config: PhotoPickConfig = PhotoPickConfig()
    
    private let groupManager = PhotoGroupManager()

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
    
    private lazy var bottomBar: BottomBar = BottomBar()

    private let isShowCamera :Bool
    
    enum SourceType {
        case all
        case group(photoGroup: PhotoGroup) //分组内显示照片列表时始终没有拍照功能
    }
    
    private var sourceType: SourceType = .all
    
    private var photoModels = [PhotoModel](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    private var selectedPhotoModels = [PhotoModel]() {
        didSet{
            reloadLabel()
            collectionView.reloadData()
        }
    }
    
    /// 对外提供
    public init(isShowCamera: Bool = true, maxSelectImagesCount: Int = 9, cellColumnCount: Int = 3) {
        config.maxSelectImagesCount = maxSelectImagesCount
        config.jpgQuality = 0.5
        self.cellColumnCount = cellColumnCount
        cellSize = (CGFloat(UIScreen.main.bounds.width) - CGFloat(self.cellColumnCount - 1) * kCellSpacing ) / CGFloat(self.cellColumnCount)
        self.isShowCamera = isShowCamera
        super.init(nibName: nil, bundle: nil)
        title = "照片选择"
    }
    
    /// 相册页面初始化
    convenience init(group: PhotoGroup, maxSelectImagesCount: Int = 9){
        self.init(isShowCamera: false, maxSelectImagesCount: maxSelectImagesCount, cellColumnCount : 4)
        sourceType = .group(photoGroup: group)
        title = group.name()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray
        
        view.addSubview(collectionView)
        
        view.addSubview(bottomBar)
        bottomBar.goShowPage = {[unowned self] in
            self.goPhotoShowVC(allAssets: self.selectedPhotoModels, selectedPhotoModels: self.selectedPhotoModels, index: 0)
        }
        bottomBar.onConfirm = {[unowned self] in
            self.confirmOnClick()
        }
        
        switch sourceType {
        case .all:
            let btnL = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
            btnL.setTitle("取消", for: .normal)
            btnL.setTitleColor(UIColor.black, for: .normal)
            btnL.addTarget(self, action: #selector(concelBtnOnClick), for: .touchUpInside)
            let leftBar = UIBarButtonItem(customView: btnL)
            self.navigationItem.leftBarButtonItem = leftBar
            
            let btnR = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
            btnR.setTitle("相册", for: .normal)
            btnR.setTitleColor(UIColor.black, for: .normal)
            btnR.addTarget(self, action: #selector(openGroupPhotoVC), for: .touchUpInside)
            
            let rightBar = UIBarButtonItem(customView: btnR)
            self.navigationItem.rightBarButtonItem = rightBar
            
            groupManager.findAllPhotoModels { [unowned self] (models) in
                self.photoModels = models
            }
            
        case let .group(photoGroup: group):
            groupManager.findAllPhotoModelsByGroup(by: group, callback: { [unowned self] (models) in
                self.photoModels = models
            })
        }

    }
    
    // 打开相册列表
    @objc private func openGroupPhotoVC() {
        let groupVC =  PhotoPickGroupVC()
        groupVC.cancelBack = { [unowned self] array in
            self.selectedPhotoModels = array
        }
        groupVC.confirmDismiss = { [unowned self] aassetImages in
            self.performPickDelegate(assetImages: aassetImages)
            self.dismissVC(isCancel: false)
        }
        self.navigationController?.pushViewController(groupVC, animated: true)
    }
    
    private func performPickDelegate(assetImages:[PickedPhoto]){
        if let delegate = delegate {
            delegate.photoPick(pickVC: self, assetImages: assetImages)
        }
    }
    
    private func performCancelDelegate(){
        if let delegate = delegate {
            delegate.photoPickCancel(pickVC: self)
        }
    }
    
    private func confirmOnClick(){
        performPickDelegate(assetImages: PhotoModel.convertToPickedPhotos(photoModels: selectedPhotoModels))
        dismissVC(isCancel: false)
    }
    
    @objc private func concelBtnOnClick() {
        dismissVC(isCancel: true)
    }
    
    private func dismissVC(isCancel:Bool) {
        self.dismiss(animated: true, completion: nil)
        if isCancel {
            performCancelDelegate()
        }
    }

    private func reloadLabel() {
        bottomBar.setPickedPhotoCount(count: selectedPhotoModels.count)
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
            cell.doneTakePhoto = { [unowned self] models  in
                self.performPickDelegate(assetImages: models)
                self.dismissVC(isCancel: false)
                self.dismissVC(isCancel: false)
            }
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
            return
        }
        goPhotoShowVC(allAssets: photoModels, selectedPhotoModels: selectedPhotoModels, index: getPhotoRow(indexPath: indexPath))
    }
    
    private func goPhotoShowVC(allAssets: [PhotoModel], selectedPhotoModels: [PhotoModel], index: Int )
    {
        let photoShowVC = PhotoShowVC(assets: allAssets, selectedPhotoModels: selectedPhotoModels, index: index, maxSelectImagesCount:config.maxSelectImagesCount)
        photoShowVC.cancelBack = { array in
            self.selectedPhotoModels = array
        }
        photoShowVC.confirmBack = { array in
            self.selectedPhotoModels = array
            self.confirmOnClick()
        }
        self.navigationController?.pushViewController(photoShowVC, animated: true)
    }
    
    private func getPhotoRow(indexPath: IndexPath) -> Int {
        return isShowCamera ? indexPath.row - 1 : indexPath.row
    }
}
