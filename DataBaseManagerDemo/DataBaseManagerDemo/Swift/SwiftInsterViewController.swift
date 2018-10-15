//
//  SwiftInsterViewController.swift
//  DataBaseManagerDemo
//
//  Created by wudan on 2018/10/15.
//  Copyright © 2018 wudan. All rights reserved.
//

import UIKit

class SwiftInsterViewController: UIViewController {
    
    
    @IBOutlet weak var address_TF: UITextField!
    @IBOutlet weak var phone_TF: UITextField!
    @IBOutlet weak var name_TF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Swift-添加数据"
    }

    @IBAction func insterTouched(_ sender: Any) {
        if (name_TF.text?.count)! == 0 || (phone_TF.text?.count)! == 0 || (address_TF.text?.count)! == 0 {
            HUDManager.hud.showHUD(controller: self, content: "完善信息")
            return
        }
        
        let model = Model()
        model.name = name_TF.text
        model.address = address_TF.text
        model.phone = phone_TF.text
        view.endEditing(true)
        
        WDDataBaseManager.defaultManger.insert(model: model, successBlock: {
           HUDManager.hud.showHUD(controller: self, content: "添加成功")
        }, failBlock: {
             HUDManager.hud.showHUD(controller: self, content: "添加失败")
        })
    }
    
    @IBAction func queryTouched(_ sender: Any) {
        let vc:SwiftDataViewController = SwiftDataViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
