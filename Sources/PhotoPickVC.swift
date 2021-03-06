//
//  PhotoPickVC.swift
//  PhotoPick
//
//  Created by Auto Jiang on 2016/12/14.
//  Copyright © 2016年 Auto Jiang. All rights reserved.
//

import UIKit

protocol PhotoPickVCDelegate: class {
    
    func photoPick(pickVC: PhotoPickVC, assetImages: [PickedPhoto]) -> Void
    func photoPickCancel(pickVC: PhotoPickVC) -> Void
}

extension PhotoPickVCDelegate {
    
    func photoPickCancel(pickVC: PhotoPickVC) -> Void {}
    
}

public class PhotoPickVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    private static let kCellSpacing: CGFloat = 3
    
    weak var delegate: PhotoPickVCDelegate?
    
    private let config: PhotoPickConfig = PhotoPickConfig.shared
    
    private let groupManager = PhotoGroupManager()
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.sourceType.cellSize, height: self.sourceType.cellSize)
        layout.minimumLineSpacing = PhotoPickVC.kCellSpacing
        layout.minimumInteritemSpacing = PhotoPickVC.kCellSpacing
        let cV = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        cV.delegate = self
        cV.dataSource = self
        cV.backgroundColor = UIColor.white
        cV.register(PhotoCell.self ,forCellWithReuseIdentifier: PhotoCell.identifier)
        cV.register(CameraCell.self ,forCellWithReuseIdentifier: CameraCell.identifier)
        return cV
    }()
    
    private lazy var bottomBar: BottomBar = BottomBar()
    
    private enum SourceType {
        case all
        case group(photoGroup: PhotoGroup) //分组内显示照片列表时始终没有拍照功能
        
        var hasCamera: Bool {
            switch self {
            case .group(photoGroup: _):
                return false
            case .all:
                return PhotoPickConfig.shared.needShowCamera
            }
        }
        
        var cellColumnCount: Int {
            switch self {
            case .group(photoGroup: _):
                return 4
            case .all:
                return 3
            }
        }
        
        var cellSize: CGFloat {
            return (CGFloat(UIScreen.main.bounds.width) - CGFloat(cellColumnCount - 1) * PhotoPickVC.kCellSpacing ) / CGFloat(cellColumnCount)
        }
    }
    
    private var sourceType: SourceType = .all
    
    private var photoModels = [PhotoModel](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    private var selectedPhotoModels = [PhotoModel]() {
        didSet{
            bottomBar.updatePickedPhotoCount(count: selectedPhotoModels.count)
            collectionView.reloadData()
        }
    }
    
    /// 对外提供
    public init(isShowCamera: Bool = true, maxSelectImagesCount: Int = 9) {
        config.maxSelectImagesCount = maxSelectImagesCount
        config.jpgQuality = 0.5
        config.needShowCamera = isShowCamera
        super.init(nibName: nil, bundle: nil)
        title = "照片选择"
    }
    
    /// 相册页面初始化
    init(group: PhotoGroup){
        sourceType = .group(photoGroup: group)
        super.init(nibName: nil, bundle: nil)
        title = group.name()
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
        
        navigationController?.navigationBar.barTintColor = PhotoPickConfig.shared.NavBarColor
        
        // 获取数据
        switch sourceType {
        case .all:
            setupNavBarForSourceTypeAll()
            groupManager.findAllPhotoModels { [unowned self] (models) in
                self.photoModels = models
            }
            
        case let .group(photoGroup: group):
            groupManager.findAllPhotoModelsByGroup(by: group, callback: { [unowned self] (models) in
                self.photoModels = models
            })
        }
        
        /// 注册通知，监听系统图片发生变化时，进行数据更新
//        NotificationCenter.default.addObserver(self, selector: #selector(assetsLibraryChanged), name: NSNotification.Name.ALAssetsLibraryChanged, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    
    
    private func setupNavBarForSourceTypeAll(){
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
        
        if isCancel {
            performCancelDelegate()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDelegate

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sourceType.hasCamera ? photoModels.count + 1 : photoModels.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 && sourceType.hasCamera {
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
            cell.cellSelect(animated: model.isLastSelect, index: "\(index!+1)")
            model.isLastSelect = false
        } else {
            cell.cellUnselect()
        }
        
        
        cell.selectChangeCallback = {[unowned self] photoCell in
            //取消选中
            if model.isSelect {
                let index = self.selectedPhotoModels.index(of: model)
                self.selectedPhotoModels.remove(at: index!)
                photoCell.cellUnselect()
                model.isSelect = false
            }
            
            //选中
            else if self.selectedPhotoModels.count < self.config.maxSelectImagesCount {
                self.selectedPhotoModels.append(model)
                model.isSelect = true
                photoCell.cellSelect(animated: true, index: "\(self.selectedPhotoModels.count)")
                model.isLastSelect = true
            }else{//可选图片已达上限
                PhotoPick.showOneCancelButtonAlertView(from: self, title: "可选图片已达上限", subTitle: nil)
            }
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 && sourceType.hasCamera {
            return
        }
        goPhotoShowVC(allAssets: photoModels, selectedPhotoModels: selectedPhotoModels, index: getPhotoRow(indexPath: indexPath))
    }
    
    private func goPhotoShowVC(allAssets: [PhotoModel], selectedPhotoModels: [PhotoModel], index: Int) {
        let photoShowVC = PhotoShowVC(assets: allAssets, selectedPhotoModels: selectedPhotoModels, index: index, maxSelectImagesCount:config.maxSelectImagesCount)
        photoShowVC.cancelBack = { [unowned self] array in
            self.selectedPhotoModels = array
        }
        photoShowVC.confirmBack = { [unowned self] array in
            self.selectedPhotoModels = array
            self.confirmOnClick()
        }
        self.navigationController?.pushViewController(photoShowVC, animated: true)
    }
    
    private func getPhotoRow(indexPath: IndexPath) -> Int {
        return sourceType.hasCamera ? indexPath.row - 1 : indexPath.row
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
}
