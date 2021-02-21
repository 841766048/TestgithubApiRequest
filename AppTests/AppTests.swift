//
//  AppTests.swift
//  AppTests
//
//  Created by 张海彬 on 2021/2/21.
//

import XCTest

@testable import App

class AppTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        // 判断接口能否正常请求到
        let networkExpection = expectation(description: "networkDownSuccess")
        AF.request("https://api.github.com/")
            .responseJSON { response in
                print("response = \(response)")
                XCTAssertNotNil(response)
                networkExpection.fulfill()
            }
        let result = XCTWaiter(delegate: self).wait(for: [networkExpection], timeout:  1)
        if result == .timedOut {
            print("超时")
        }else if result == .completed {
            print("请求成功")
        }else{
            print("其余错误")
        }
       	// 测试数据是否能插入成功
        let dict = ["emails_url":"https://api.github.com/user/emails",
                    "user_organizations_url":"https://api.github.com/user"]
        
       
        SQLiteManager.shareManger().insertDataTable(timer: "1111", json: convertDictionaryToJSONString(dict: dict as NSDictionary) ?? "")
        
        
    }
    
    func convertDictionaryToJSONString(dict:NSDictionary?)->String {
        let data = try? JSONSerialization.data(withJSONObject: dict!, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        return jsonStr! as String
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
