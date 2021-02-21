//
//  RequestGithubApiNetworkService.swift
//  App
//
//  Created by 张海彬 on 2021/2/21.
//

import Foundation

public enum GithubApiRequest{
    case requestGithubApi 
}

extension GithubApiRequest: TargetType{
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var baseURL: URL {
        return URL(string: "https://api.github.com/")!
    }
    
    public var path: String {
        return ""
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Task {
        return .requestPlain
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
}


class RequestGithubApiNetworkService {
    func requestGithubApi()  -> Driver<[MyTableSection]>{
        return Observable.create { (observer) -> Disposable in
            NetworkManager<GithubApiRequest,GithubApiModel>.requestBasic(.requestGithubApi, success: { (model) in
                
                
                var value:[Dictionary<String,String>] = []
                if let dict = model.toJSON() {
                    for (key,any) in dict {
                        let str = any as! String
                        value.append(["title":key,"value":str])
                    }
                }
                let section = MyTableSection(header: Date().toformatterTimeString(), items: value)
//                insertDataTable
                let json = model.toJSONString(prettyPrint: true)
                
                SQLiteManager.shareManger().insertDataTable(timer: section.header, json: json)
                
                observer.onNext([section])
            }, error: { (error) in
                NSObject().appearController()?.showHUDWithError(error: error.displayMessage)
                observer.onNext([])
            })
            return Disposables.create()
        }.asDriver(onErrorDriveWith: Driver.empty())
    }
}

class RequestGithubApiHistoryServer {
    func requestGithubApiHistory()  -> Driver<[MyTableSection]>{
        return Observable.create { (observer) -> Disposable in
            SQLiteManager.shareManger().queryDataTable { (values) in
                observer.onNext(values)
            }
            return Disposables.create()
        }.asDriver(onErrorDriveWith: Driver.empty())
    }
}
