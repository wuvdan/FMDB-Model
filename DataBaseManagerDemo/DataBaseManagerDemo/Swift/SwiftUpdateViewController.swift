//
//  SwiftUpdateViewController.swift
//  DataBaseManagerDemo
//
//  Created by wudan on 2018/10/15.
//  Copyright © 2018 wudan. All rights reserved.
//

import UIKit

class SwiftUpdateViewController: UIViewController {
    
    @IBOutlet weak var address_TF: UITextField!
    @IBOutlet weak var phone_TF: UITextField!
    @IBOutlet weak var name_TF: UITextField!
    public var model:Model?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Swift-更新数据"
        name_TF.text = model!.name
        address_TF.text = model!.address
        phone_TF.text = model!.phone
    }
    
    @IBAction func updateTouched(_ sender: Any) {
        if (name_TF.text?.count)! == 0 || (phone_TF.text?.count)! == 0 || (address_TF.text?.count)! == 0 {
            HUDManager.hud.showHUD(controller: self, content: "完善信息")
            return
        }
        
        let model = Model()
        model.name = name_TF.text
        model.address = address_TF.text
        model.phone = phone_TF.text
        view.endEditing(true)
        
        WDDataBaseManager.defaultManger.update(model: model, uid: Int32(self.model!.wd_fmdb_id), successBlock: {
            HUDManager.hud.showHUD(controller: self, content: "修改失败", completeBlock: {
                self.navigationController?.popViewController(animated: true)
            })
            
        }, failBlock: {
             HUDManager.hud.showHUD(controller: self, content: "修改失败")
        })
    }
}
