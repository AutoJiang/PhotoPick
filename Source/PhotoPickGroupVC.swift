//
//  GKitPhotoPickGroupVC.swift
//  PhotoPick
//
//  Created by Auto Jiang on 2016/12/22.
//  Copyright © 2016年 Auto Jiang. All rights reserved.
//

import UIKit
import AssetsLibrary
//相册列表
class PhotoPickGroupVC: UIViewController,UITableViewDelegate,UITableViewDataSource,PhotoPickDelegate {
    
    let groupsCell = "groupsCell"
    
    let cellHeight : CGFloat = 60
    
    var tableView = UITableView()
    
    let library = ALAssetsLibrary()
    
    var groups = [ALAssetsGroup]()
    
    var selectedPhotoModels = [PhotoModel]()
    
    var cancelBack : ([PhotoModel])-> Void = {_ in}
    
    var confirm :([PhotoModel])-> Void = {_ in}
    
    init(selectedPhotos:[PhotoModel]) {
        super.init(nibName: nil, bundle: nil)
        self.selectedPhotoModels = selectedPhotos
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        self.navigationItem.title = "照片"
        
        library.enumerateGroupsWithTypes(ALAssetsGroupAll, usingBlock: { group,stop in
            if let g = group {
                self.groups.append(g)
            }else{
                self.tableView.reloadData()
            }
        }, failureBlock: { error in
            
        })
        
        let btnL = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        btnL.setTitle("返回", for: .normal)
        btnL.setTitleColor(UIColor.black, for: .normal)
        btnL.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        let leftBar = UIBarButtonItem(customView: btnL)
        self.navigationItem.leftBarButtonItem = leftBar
    }
    
    func popVC() {
        self.cancelBack(self.selectedPhotoModels)
        let _ = self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: groupsCell) as? GroupCell
        if cell == nil{
            cell = GroupCell(style: .value1, reuseIdentifier: groupsCell)
        }
        let data = groups[indexPath.row]
        cell?.bind(model: data)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.groups[indexPath.row]
        let photoPick = PhotoPickVC(title: data.value(forProperty: ALAssetsGroupPropertyName) as! String, group: [data], selectedPhotos: self.selectedPhotoModels)
        photoPick.delegate = self
        photoPick.photosDidSelected = { photoModels , isDone in
            self.selectedPhotoModels = photoModels
            if isDone {
                self.confirm(self.selectedPhotoModels)
            }
        }
        self.navigationController?.pushViewController(photoPick, animated: true)
        return
    }
    
//MARK - PhotoPickViewDelegate
//    func photoPickView(pickVC: GKitPhotoPickVC, PhotoModels: [PhotoModel]) {
//        self.selectedPhotoModels = PhotoModels
//        self.confirm(self.selectedPhotoModels)
//    }
}

class GroupCell: UITableViewCell {
    lazy var subtitle :UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.groupTableViewBackground
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.addSubview(subtitle)
    }
    
    func bind(model:ALAssetsGroup){
        self.textLabel?.text = model.value(forProperty: ALAssetsGroupPropertyName) as? String
        self.imageView?.image = UIImage(cgImage: model.posterImage().takeUnretainedValue()
            , scale: 1.0, orientation: .up)
//        self.subtitle.text = "/(\(model.numberOfAssets())/)"
//        self.subtitle.frame = CGRect(x:(self.textLabel?.frame)!.maxX, y: 20, width: 100, height: 20)
        self.detailTextLabel?.text = "(\(model.numberOfAssets()))"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
