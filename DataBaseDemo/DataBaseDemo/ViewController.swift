//
//  ViewController.swift
//  DataBaseDemo
//
//  Created by wudan on 2018/10/10.
//  Copyright © 2018 wudan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var name_TF: UITextField!
    @IBOutlet weak var phone_TF: UITextField!
    @IBOutlet weak var addres_TF: UITextField!
    private var model:Model?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "添加数据"
    }

    @IBAction func addData(_ sender: Any) {
        
        if (name_TF.text?.count)! == 0 || (phone_TF.text?.count)! == 0 || (addres_TF.text?.count)! == 0 {
                showHUD(content: "完善信息")
            return
        }
        
        let model = Model()
        model.name = name_TF.text
        model.addres = addres_TF.text
        model.phone = phone_TF.text
        view.endEditing(true)
        
        WDDataBaseManager.defaultManger.insert(model: model, successBlock: {
            showHUD(content: "添加成功")
        }, failBlock: {
            showHUD(content: "添加失败")
        })
    }
    
    @IBAction func selectData(_ sender: Any) {
        let vc:DataViewController = DataViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func showHUD(content:String) {
        let alterController = UIAlertController.init(title: "温馨提示", message: content, preferredStyle: .alert)
        present(alterController, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                alterController.dismiss(animated: true, completion: nil)
            })
        }
    }
}

