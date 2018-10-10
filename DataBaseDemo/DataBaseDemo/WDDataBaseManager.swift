//
//  WDDataBaseManager.swift
//  DataBaseDemo
//
//  Created by wudan on 2018/10/10.
//  Copyright © 2018 wudan. All rights reserved.
//

import UIKit
import FMDB

class WDDataBaseManager: NSObject {
    
    // 单例模式
    static let defaultManger = WDDataBaseManager()
    
    typealias successBlock = () ->Void
    typealias failBlock = () ->Void
    
    private var tableName:String?
    
    // 创建数据库
    lazy var fmdb:FMDatabase = {
        let path = NSHomeDirectory().appending("/Documents/dispatchInfo.db")
        let db = FMDatabase(path: path)
        return db
    }()
    
    // 创建表
    func creatTable(tableName:String) -> Void {
        fmdb.open()
        self.tableName = tableName
        let creatSql = "create table if not exists \(tableName) (id integer primary key autoincrement,model BLOB)"
        let result = fmdb.executeUpdate(creatSql, withArgumentsIn:[])
        if result{
            print("创建表成功")
        }
    }
    
    //删除表
    func dropTable() -> Void {
        let sql = "drop table if exists " + tableName!
        let result = fmdb.executeUpdate(sql, withArgumentsIn:[])
        if result{
            print("删除表成功")
        }
    }
    
    //插入数据
    func insert(model:NSObject, successBlock: successBlock, failBlock: failBlock) -> Void {
        print(NSHomeDirectory())
        
        let modelData = try! NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: false)
        let insertSql = "insert into " + tableName! + " (model) values(?)"

        do {
            try fmdb.executeUpdate(insertSql, values: [modelData])
            successBlock()
        } catch {
            print(fmdb.lastError())
            failBlock()
        }
    }
    
    //更新数据
    func update(model:NSObject,uid:Int32, successBlock: successBlock, failBlock: failBlock) -> Void {
        
        let modelData = try! NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: false)
        
        let updateSql = "update " + tableName! + " set model = ? where id = ?"
        
        do {
            try fmdb.executeUpdate(updateSql, values: [modelData, uid])
            successBlock()
        } catch {
            print(fmdb.lastError())
            failBlock()
        }
    }
    
    //删除数据
    func delete(uid:Int32, successBlock: successBlock, failBlock: failBlock) -> Void {
        let deleteSql = "delete from " + tableName! + " where id = ?"
        do {
            try fmdb.executeUpdate(deleteSql, values: [uid])
        } catch {
            print(fmdb.lastError())
        }
    }
    
    //查询全部数据
    func selectAll() -> [NSObject] {
        var tmpArr = [NSObject]()
        let selectSql = "select * from " + tableName!
        
        do {
            let rs = try fmdb.executeQuery(selectSql, values:nil)
            while rs.next() {
                var model = NSObject()
                let modelData  = rs.data(forColumn:"model")
                let id = rs.int(forColumn: "id")
                model = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(modelData!) as! NSObject
                model.wd_fmdb_id = id
                tmpArr.append(model)
            }
        } catch {
            print(fmdb.lastError())
        }
        return tmpArr
    }
}


private var wd_id_key: String = "key"

extension NSObject {
    open var wd_fmdb_id:Int32? {
        get {
            return (objc_getAssociatedObject(self, &wd_id_key) as? Int32)
        } set(newValue) {
            objc_setAssociatedObject(self, &wd_id_key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
