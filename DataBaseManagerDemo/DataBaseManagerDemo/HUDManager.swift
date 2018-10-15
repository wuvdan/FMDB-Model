//
//  HUDManager.swift
//  DataBaseManagerDemo
//
//  Created by wudan on 2018/10/15.
//  Copyright © 2018 wudan. All rights reserved.
//

import UIKit

class HUDManager: NSObject {
    
    @objc public static let hud = HUDManager()

    @objc open func showHUD(controller:UIViewController , content:String) {
        let alterController = UIAlertController.init(title: "温馨提示", message: content, preferredStyle: .alert)
        controller.present(alterController, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                alterController.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    @objc open func showHUD(controller:UIViewController, content:String, completeBlock:(() -> Void)? = nil) {
        let alterController = UIAlertController.init(title: "温馨提示", message: content, preferredStyle: .alert)
        controller.present(alterController, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                alterController.dismiss(animated: true, completion: {
                    completeBlock!()
                })
            })
        }
    }
}
