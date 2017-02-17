//
//  GKitPhotoPickGroupVC.swift
//  PhotoPick
//
//  Created by Auto Jiang on 2016/12/22.
//  Copyright © 2016年 Auto Jiang. All rights reserved.
//

import UIKit

//相册列表
class PhotoPickGroupVC: UIViewController,UITableViewDelegate,UITableViewDataSource,PhotoPickDelegate {
    
    private let groupsCell = "groupsCell"
    
    private let cellHeight: CGFloat = 60
    
    private var tableView = UITableView()
    
    private var groups = [PhotoGroup]()
    
    var cancelBack: ([PhotoModel])-> Void = {_ in}
    
    var confirmDismiss:([PickedPhoto])-> Void = {_ in}
    
    private let mgr = PhotoGroupManager()
    
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

//MARK: UITableViewDataSourceDelegate
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
        cell?.bind(model: group)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = self.groups[indexPath.row]
        let photoPick = PhotoPickVC(group: group)
        photoPick.delegate = self
        self.navigationController?.pushViewController(photoPick, animated: true)
        return
    }
    
    //MARK: PhotoPickDelegate
    func photoPick(pickVC: PhotoPickVC, assetImages: [PickedPhoto]) {
        self.confirmDismiss(assetImages);
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
    
    func bind(model:PhotoGroup){
        self.textLabel?.text = model.name()
        self.imageView?.image = UIImage(cgImage: model.assetGroup.posterImage().takeUnretainedValue()
            , scale: 1.0, orientation: .up)
        self.detailTextLabel?.text = "(\(model.assetGroup.numberOfAssets()))"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
