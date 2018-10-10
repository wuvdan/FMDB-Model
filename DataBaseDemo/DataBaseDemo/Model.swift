//
//  Model.swift
//  DataBaseDemo
//
//  Created by wudan on 2018/10/10.
//  Copyright © 2018 wudan. All rights reserved.
//

import UIKit

class Model: NSObject , NSCoding{

    public var name:String?
    public var phone:String?
    public var addres:String?
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(addres, forKey: "addres")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.addres = aDecoder.decodeObject(forKey: "addres") as? String
        self.phone = aDecoder.decodeObject(forKey: "phone") as? String
    }
}
