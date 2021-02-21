//
//  SQLiteManager.swift
//  App
//
//  Created by 张海彬 on 2021/2/21.
//

import UIKit
import Foundation
public class SQLiteManager: NSObject {
    // 创建单例
    private static let manger: SQLiteManager = SQLiteManager()
    class func shareManger() -> SQLiteManager {
        return manger
    }
    
    // 数据库名称
    private let dbName = "test.db"
    
    // 数据库地址
    lazy var dbURL: URL = {
        // 根据传入的数据库名称拼接数据库的路径
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask,
                 appropriateFor: nil, create: true)
            .appendingPathComponent(dbName)
        print("数据库地址：", fileURL)
        return fileURL
    }()
    
    // FMDatabase对象（用于对数据库进行操作）
    lazy var db: FMDatabase = {
        let database = FMDatabase(url: dbURL)
        return database
    }()
    
    // FMDatabaseQueue对象（用于多线程事务处理）
    lazy var dbQueue: FMDatabaseQueue? = {
        // 根据路径返回数据库
        let databaseQueue = FMDatabaseQueue(url: dbURL)
        return databaseQueue
    }()
    
    // 创建表
    func createTable() {
        // 编写SQL语句（id: 主键  name和age是字段名）
        let sql = "CREATE TABLE IF NOT EXISTS GithubApi( \n" +
            "id INTEGER PRIMARY KEY AUTOINCREMENT, \n" +
            "time TEXT, \n" +
            "json INTEGER \n" +
            "); \n"
        
        // 执行SQL语句（注意点: 在FMDB中除了查询意外, 都称之为更新）
        let db = SQLiteManager.shareManger().db
        if db.open() {
            if db.executeUpdate(sql, withArgumentsIn: []){
                print("创建表成功")
            }else{
                print("创建表失败")
            }
        }
        db.close()
    }
    // 插入数据
    func insertDataTable(timer:String,json:String?){
        // 编写SQL语句
        let sql = "INSERT INTO GithubApi (time, json) VALUES (?,?);"
         
        // 执行SQL语句
        let db = SQLiteManager.shareManger().db
        if db.open() {
            if db.executeUpdate(sql, withArgumentsIn: [timer, json ?? ""]){
                print("插入成功")
                if let vc = NSObject().appearController() {
                    if vc.isKind(of: RequestGithubApiHistoryVC.self) {
                        //设置推送内容
                        let content = UNMutableNotificationContent()
                        content.title = "有新的数据来了"
                        content.subtitle = ""
                        content.body = "请求到了新的数据，请下拉刷新"
                        content.badge = 0
                        //设置通知触发器，10秒钟后触发推送通知。
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
                        UNUserNotificationCenter.addUpdateNotification(content: content, trigger: trigger) { (isSuccess, identifier) in
                            NSLog("\(isSuccess),标识符：\(identifier)")
                        }
                    }
                }
            }else{
                print("插入失败")
            }
        }
        db.close()
    }
    // 查询
    func queryDataTable(_ completionHandler:@escaping ([MyTableSection]) ->Void) {
        // 编写SQL语句
        let sql = "SELECT * FROM GithubApi ORDER BY id desc"
         
        // 执行SQL语句
        let db = SQLiteManager.shareManger().db
        if db.open() {
            if let res = db.executeQuery(sql, withArgumentsIn: []){
                // 遍历输出结果
                var result:[MyTableSection] = []
                
                while res.next() {
                    let _ = res.int(forColumn: "id")
                    let time = res.string(forColumn: "time")!
                    let json = res.string(forColumn: "json")
                    
                    var value:[Dictionary<String,String>] = []
                    if let dict = json?.toDictionary() {
                        for (key,any) in dict {
                            let str = any as! String
                            value.append(["title":key,"value":str])
                        }
                    }
                    let mode = MyTableSection(header: time, items: value)
                    result.append(mode)
                }
                completionHandler(result)
            }else{
                completionHandler([])
            }
        }else{
            completionHandler([])
        }
        db.close()
    }
    
}

