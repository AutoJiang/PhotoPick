//
//  PhotoPickVC.swift
//  PhotoPick
//
//  Created by Auto Jiang on 2016/12/14.
//  Copyright © 2016年 Auto Jiang. All rights reserved.
//

import UIKit
import AssetsLibrary

protocol PhotoPickDelegate {
    //返回keys数组，使用时调用 SDImageCache.shared().imageFromDiskCache(forKey: key)返回图片
    func photoPick(pickVC : PhotoPickVC, imageKeys : [String]) -> Void
    //返回缩略图数组
    func photoPick(pickVC : PhotoPickVC, thumbnails : [UIImage]) -> Void

    func photoPick(pickVC : PhotoPickVC, images : [UIImage]) -> Void
    func photoPick(pickVC : PhotoPickVC, datas : [NSData]) -> Void
}

extension PhotoPickDelegate{
    func photoPick(pickVC : PhotoPickVC, imageKeys : [String]) -> Void{}
    func photoPick(pickVC : PhotoPickVC, images : [UIImage]) -> Void{}
    
    func photoPick(pickVC : PhotoPickVC, thumbnails : [UIImage]) -> Void{}
    func photoPick(pickVC : PhotoPickVC, datas : [NSData]) -> Void{}
}

class PhotoPickVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //间距
    private let SPACING :CGFloat = 3
    //tabar高度
    private let tabH :CGFloat = 50
    
    private let iPhotosCell = "photoCell"
    
    private let iCanimaCell = "canimaCell"
    //最大可选择个数
    private let maximumNumberOfImages = 999
    //图片压缩系数
    private let quality : CGFloat = 0.5
    
    private let maxSidePixels : CGFloat = 1280
    
    private let minStretchSidePixels : CGFloat = 440
    //列数
    private var COUNT = 3
    
    //cell宽高
    private var PW :CGFloat = 50
    
    var delegate : PhotoPickDelegate?
    lazy var vidio : UIImagePickerController = {
        let v = UIImagePickerController()
        v.sourceType = .camera
        v.delegate = self
        return v
    }()
    let library = ALAssetsLibrary()
    var groups : [ALAssetsGroup]?
    
    var assets = [AssetModel]()
    var collectionView : UICollectionView?
    var showLbl = CircleLabel()

    var isShowCanima = true
    
    //底部栏
    let tabBarView = UIView()
    //被选照片
    var photos = [AssetModel]() {
        didSet{
            updateLabel()
        }
    }
    
    var photosDidSelected : ([AssetModel],_ isDone:Bool) -> Void = { _ in }
    
    init(title:String? = "照片选择", isShowCanima : Bool , group:[ALAssetsGroup]?, selectedPhotos: [AssetModel]?=[AssetModel]()) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        self.isShowCanima = isShowCanima
        self.groups = group
        if !isShowCanima {
            self.COUNT = 4
        }
        PW = (CGFloat(UIScreen.main.bounds.width) - CGFloat(COUNT - 1) * SPACING ) / CGFloat(COUNT)
        self.photos = selectedPhotos!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        self.createView()
        if groups == nil{
            self.searchPhotos()
        }else{
            self.enumerateAssets()
        }
    }

    func createView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: PW, height: PW)
        layout.minimumLineSpacing = SPACING
        layout.minimumInteritemSpacing = SPACING
        let cV = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        cV.delegate = self
        cV.dataSource = self
        cV.backgroundColor = UIColor.white
        self.view.addSubview(cV)
        cV.register(PhotoCell.self ,forCellWithReuseIdentifier: iPhotosCell)
        cV.register(CanimaCell.self ,forCellWithReuseIdentifier: iCanimaCell)
        collectionView = cV
        
        let y = self.view.frame.height - tabH
        let width = self.view.frame.width
        tabBarView.frame = CGRect(x: 0, y: y, width: width, height: tabH)
        tabBarView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.view.addSubview(tabBarView)
        
        //按钮
        let scanBtn = UIButton(frame: CGRect(x: 12, y: 17, width: 38, height: 18))
        scanBtn.setTitle("预览", for: .normal)
        scanBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        scanBtn.setTitleColor(UIColor.white, for: .normal)
        scanBtn.backgroundColor = UIColor.clear
        tabBarView.addSubview(scanBtn)
        
        let confirmBtn = UIButton(frame: CGRect(x: width - 50, y: 17, width: 38, height: 18))
        confirmBtn.setTitle("确定", for: .normal)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        confirmBtn.setTitleColor(UIColor.yellow, for: .normal)
        confirmBtn.backgroundColor = UIColor.clear
        confirmBtn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        tabBarView.addSubview(confirmBtn)
        
        self.showLbl = CircleLabel(frame: CGRect(x: self.view.frame.width - 80, y: 13, width: 25, height: 25))
        
        if isShowCanima {
            let btnL = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
            btnL.setTitle("取消", for: .normal)
            btnL.setTitleColor(UIColor.black, for: .normal)
            btnL.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
            let leftBar = UIBarButtonItem(customView: btnL)
            self.navigationItem.leftBarButtonItem = leftBar
            
            let btnR = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
            btnR.setTitle("相册", for: .normal)
            btnR.setTitleColor(UIColor.black, for: .normal)
            btnR.addTarget(self, action: #selector(openGroupPhotos), for: .touchUpInside)
            
            let rightBar = UIBarButtonItem(customView: btnR)
            self.navigationItem.rightBarButtonItem = rightBar
        }else{
            let btnL = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
            btnL.setTitle("返回", for: .normal)
            btnL.setTitleColor(UIColor.black, for: .normal)
            btnL.addTarget(self, action: #selector(popVC), for: .touchUpInside)
            let leftBar = UIBarButtonItem(customView: btnL)
            self.navigationItem.leftBarButtonItem = leftBar
        }
    }
    func openGroupPhotos() {
        let gVC =  PhotoPickGroupVC(selectedPhotos: self.photos)
        gVC.cancelBack = { [unowned self] array in
            self.photos = array
            self.collectionView?.reloadData()
        }
        gVC.confirm = { [unowned self] array in
            self.photos = array
            self.confirm()
        }
        self.navigationController?.pushViewController(gVC, animated: true)
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
        for var group :ALAssetsGroup in self.groups! {
            group.enumerateAssets(options: .reverse, using: { (result, index, stop) in
                guard let r = result else{
                    //                    self.showImage()
                    self.collectionView?.reloadData()
                    return
                }
                let model = AssetModel(asset: r, isSelect: false)
                self.assets.append(AssetModel(asset: r, isSelect: self.photos.contains(model)))
            })
        }
    }
    
    func confirm(){
        if let del = delegate {
            del.photoPick(pickVC: self, imageKeys: changeImagesKeys(photos: photos))
            photosDidSelected(photos, true)
            //del.PhotoPick(pickVC: self, AssetModels: photos)
//                del.PhotoPick(pickVC: self, images: changeImages(photos: self.photos))
//            del.PhotoPick(pickVC: self, datas: changeImagesDatas(photos: self.photos))
//            del.PhotoPick(pickVC: self, thumbnails: changeImagesThumbnails(photos: self.photos))
        }
        dismissVC()
    }
    
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func popVC() {
        //self.delegate?.PhotoPick(pickVC: self, AssetModels: self.photos)
        photosDidSelected(photos,false)
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateLabel() {
        guard self.photos.count > 0 else {
            self.showLbl.removeFromSuperview()
            return
        }
        self.showLbl.addAnimate()
        self.showLbl.text = "\(self.photos.count)"
        self.tabBarView.addSubview(showLbl)
    }
//MARK: - 图片处理
    func changeImages(photos:[AssetModel]) -> [UIImage] {
        var array = [UIImage]()
        for obj in photos {
            let image = AssetTool.imageFromAsset(representation: obj.asset.defaultRepresentation())
      //          UIImage(cgImage: obj.asset.defaultRepresentation().fullResolutionImage().takeUnretainedValue(), scale: 1.0 , orientation: obj.asset.defaultRepresentation().orientation())
            array.append(image.gkit_scale(toMaxSidePixels: maxSidePixels, minStretchSidePixels: minStretchSidePixels))
        }
        return array
    }
    
    func changeImagesDatas(photos:[ALAsset]) -> [NSData]{
        var array = [NSData]()
        for obj in photos {
            let image = UIImage(cgImage: obj.defaultRepresentation().fullResolutionImage().takeUnretainedValue(), scale: 1.0 , orientation: .up)
            array.append(image.gkit_compressToJpeg(withQuality: quality, maxSidePixels: maxSidePixels, minStretchSidePixels: minStretchSidePixels) as NSData)
        }
        return array
    }
    func changeImagesThumbnails(photos:[ALAsset]) -> [UIImage] {
        var array = [UIImage]()
        for obj in photos {
            let image = UIImage(cgImage: obj.thumbnail().takeUnretainedValue(), scale: 1.0 , orientation: .up)
            array.append(image)
        }
        return array
    }
    
    func changeImagesKeys(photos:[AssetModel]) -> [String]{
        var array = [String]()
        for obj in photos {
            let key = obj.asset.defaultRepresentation().url().absoluteString
            array.append(key)
        }
        return array
    }
    
// MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if picker.sourceType == .camera {
            //图片存入相册
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            UIImageWriteToSavedPhotosAlbum( image, nil, nil, nil);
            delegate?.photoPick(pickVC: self, images: [image])
        }
        self.dismiss(animated: true, completion: nil)
    }
    
// MARK: - UICollectionViewDelegate

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isShowCanima ? assets.count + 1 : assets.count
    }
    
    var isAdd = false
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 && isShowCanima {
            return collectionView.dequeueReusableCell(withReuseIdentifier: iCanimaCell, for: indexPath)
        }
        let cell :PhotoCell  = collectionView.dequeueReusableCell(withReuseIdentifier: iPhotosCell, for: indexPath) as! PhotoCell
        
        var row = indexPath.row
        if isShowCanima {
            row -= 1
        }
        let data : AssetModel = assets[row]
        let asset = data.asset
        
        let image = UIImage(cgImage: asset.thumbnail().takeUnretainedValue()
            , scale: 1.0, orientation: .up)
        cell.bind(image: image)
        
        cell.clearCicle()
        let model = AssetModel(asset: asset, isSelect: false)
        if photos.contains(model) {
            let index = self.photos.index(of: model)
            if index == (self.photos.count - 1) {
                cell.showCircle(isAnimate: isAdd)
            }else{
                cell.showCircle(isAnimate: false)
            }
            
            cell.indexLbl.text = "\(index!+1)"
        }
        
        cell.selectBtn.isSelected = data.isSelect
        
        cell.btnEventBlock = { _  in
            if !self.photos.contains(model) {
                if self.photos.count < self.maximumNumberOfImages {
                    self.photos.append(model)
                    self.isAdd = true
                }else{
                    self.isAdd = false
                }
            }else{
                let index = self.photos.index(of: model)
                self.photos.remove(at: index!)
                self.isAdd = false
            }
            data.didSelected(selected:!data.isSelect)
            
            self.collectionView?.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 && isShowCanima {
            self.present(self.vidio, animated: true, completion: nil)
            return
        }
        
        var row = indexPath.row
        if isShowCanima {
            row -= 1
        }
        let bigPhotoShow = PhotoShowVC()
        bigPhotoShow.assets = self.assets
        bigPhotoShow.photos = self.photos
        bigPhotoShow.index = row
        bigPhotoShow.cancelBack = { [unowned self] array in
            self.photos = array
            self.collectionView?.reloadData()
        }
        bigPhotoShow.confirmBack = { [unowned self] array in
            self.photos = array
        }
        self.navigationController?.pushViewController(bigPhotoShow, animated: true)
        
    }
}
