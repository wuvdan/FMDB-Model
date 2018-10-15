//
//  Model.swift
//  DataBaseManagerDemo
//
//  Created by wudan on 2018/10/15.
//  Copyright © 2018 wudan. All rights reserved.
//

import UIKit

class Model: NSObject,NSCoding {
    @objc public var name:String?
    @objc public var phone:String?
    @objc public var address:String?
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(address, forKey: "address")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.address = aDecoder.decodeObject(forKey: "address") as? String
        self.phone = aDecoder.decodeObject(forKey: "phone") as? String
    }
}
