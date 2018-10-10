//
//  DataViewController.swift
//  DataBaseDemo
//
//  Created by wudan on 2018/10/10.
//  Copyright © 2018 wudan. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    private var tableView: UITableView?
    
    public var backVCBlock:((_ model:Model)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "查看数据，侧滑删除"


        self.tableView = UITableView.init(frame: self.view.bounds)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.view.addSubview(self.tableView!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView?.reloadData()
    }
}

extension DataViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WDDataBaseManager.defaultManger.selectAll().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
        }
        cell?.selectionStyle = .none
        cell!.textLabel?.textAlignment = .center
        cell?.textLabel?.numberOfLines = 0;
        
        let model:Model = WDDataBaseManager.defaultManger.selectAll()[indexPath.row] as! Model
        
        cell?.textLabel?.text = model.name
        cell?.detailTextLabel?.text = model.phone
        
        return cell!
    }
}

extension DataViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model:Model = WDDataBaseManager.defaultManger.selectAll()[indexPath.row] as! Model
        let vc:UpdataViewController = UpdataViewController()
        vc.model = model
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let model:Model = WDDataBaseManager.defaultManger.selectAll()[indexPath.row] as! Model
        if editingStyle == UITableViewCell.EditingStyle.delete {
            WDDataBaseManager.defaultManger.delete(uid: model.wd_fmdb_id!, successBlock: {
                print("成功")
            }, failBlock: {
                print("失败")
            })
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}
