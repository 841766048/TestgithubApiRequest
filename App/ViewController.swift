//
//  ViewController.swift
//  App
//
//  Created by 张海彬 on 2020/11/26.
//

import UIKit
import Alamofire
class ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavBar.title = "首页"
        
        AF.request("https://api.github.com/")
                 .responseJSON { response in
                     print(response.request)  // original URL request
                     print(response.response) // URL response
                     print(response.data)     // server data
                     print(response.result)   // result of response serialization

                     if let JSON = response.value {
                         print("JSON: \(JSON)") //具体如何解析json内容可看下方“响应处理”部分
                        print("JSON: \(type(of: JSON))") 
                     }
                 }
        
    }
    deinit {
        NSLog("内存清理")
    }

}




