//
//  TabBarController.swift
//  DataBaseManagerDemo
//
//  Created by wudan on 2018/10/15.
//  Copyright © 2018 wudan. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let swift:SwiftInsterViewController = SwiftInsterViewController()
        swift.tabBarItem = UITabBarItem.init(tabBarSystemItem: .bookmarks, tag: 10)
        let s_nav = UINavigationController.init(rootViewController: swift)
        
        
        let oc:OCInsterViewController = OCInsterViewController()
        oc.tabBarItem = UITabBarItem.init(tabBarSystemItem: .contacts, tag: 11)
        let o_nav = UINavigationController.init(rootViewController: oc)
        
        viewControllers = [s_nav, o_nav]
    }
}
