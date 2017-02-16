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
    
    let cellHeight: CGFloat = 60
    
    var tableView = UITableView()
    
    var groups = [PhotoGroup]()
    
    var cancelBack: ([PhotoModel])-> Void = {_ in}
    
    var confirm:([AssetImage])-> Void = {_ in}
    
    let mgr = PhotoGroupManager()
    
    init() {
        super.init(nibName: nil, bundle: nil)
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
        
        mgr.findGroupGroupAll { [unowned self] (groups) in
            self.groups = groups
            self.tableView.reloadData()
        }
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
        let group = groups[indexPath.row]
        cell?.bind(model: group.assetGroup)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = self.groups[indexPath.row]
        let photoPick = PhotoPickVC(group: group, maxSelectImagesCount: 4)
        photoPick.delegate = self
        self.navigationController?.pushViewController(photoPick, animated: true)
        return
    }
    
    func photoPick(pickVC: PhotoPickVC, assetImages: [AssetImage]) {
        self.confirm(assetImages);
    }
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
        self.detailTextLabel?.text = "(\(model.numberOfAssets()))"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
