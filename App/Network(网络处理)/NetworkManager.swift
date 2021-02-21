//
//  NetworkManager.swift
//  App
//
//  Created by 张海彬 on 2020/11/27.
//

import Moya
import HandyJSON
import Alamofire
/// 定义Model的父类
class BaseModel<T:NSObject>: NSObject {
    var code:Int?
    var msg:String?
    var value:T?
}
class BaseBasicModel: NSObject {
    var code:Int?
    var msg:String?
    var value:String?
}


class BaseArrayModel<T:NSObject>: NSObject {
    var code:Int?
    var msg:String?
    var value:[T]?
}

///定义在处理过程中可能出现的Error
enum RxSwiftMoyaError{
    ///解析json时出错
    case ParseJSONError(msg:String = "解析json时出错",code:Int = -999)
    ///其他错误
    case OtherError(msg:String = "其他错误"   ,code:Int = -998)
    ///返回的结果有错
    case ResponseError(msg:String = "返回的结果有错"   ,code:Int = -997)
    ///请求返回错误 （根据请求码判断）
    case RequestFailedError(msg:String = "请求返回错误"   ,code:Int = -996)
    var displayMessage: String {
        switch self {
        case .ParseJSONError(let content ,_):
            return content
        case .OtherError(let content ,_):
            return content
        case .ResponseError(let content ,_):
            return content
        case .RequestFailedError(let content ,_):
            return content
        }
    }
    
    var code:Int {
        switch self {
        case .ParseJSONError(_ ,let number):
            return number
        case .OtherError(_ ,let number):
            return number
        case .ResponseError(_ ,let number):
            return number
        case .RequestFailedError(_ ,let number):
            return number
        }
    }
    
}

///让其实现Swift.Error 协议
extension RxSwiftMoyaError: Swift.Error {}
/// 扩展PrimitiveSequence让其支持转换成model
public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func mapModel<T: HandyJSON>(_ type: T.Type) -> Single<Any> {
        return map { response in
            ///判断Response类型
            //            guard let response = response as? Moya.Response else {
            //                throw RxSwiftMoyaError.ResponseError()
            //            }
            
            ///判断请求码
            guard (200...209) ~= response.statusCode else {
                throw RxSwiftMoyaError.RequestFailedError()
            }
            
            ///转json
            guard let json = try? JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as? [String: Any] else {
                throw RxSwiftMoyaError.ResponseError()
            }
//            let code = json["code"]
//            if code as! Int != 0 {
//                throw RxSwiftMoyaError.ResponseError(msg: json["msg"] as! String, code: 222)
//            }
            ///使用HandyJSON库，映射成指定模型
            let object = JSONDeserializer<T>.deserializeFrom(dict: json)
            guard let model = object else {
                throw RxSwiftMoyaError.ParseJSONError()
            }
            return model
        }
    }
    func mapModel<T: HandyJSON>(_ type: T.Type,designatedPath:String?) -> Single<Any> {
        return map { response in
            ///判断Response类型
            //            guard let response = response as? Moya.Response else {
            //                throw RxSwiftMoyaError.ResponseError()
            //            }
            
            ///判断请求码
            guard (200...209) ~= response.statusCode else {
                throw RxSwiftMoyaError.RequestFailedError()
            }
            
            ///转json
            guard let json = try? JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as? [String: Any] else {
                throw RxSwiftMoyaError.ResponseError()
            }
            
            let code = json["code"]
            if let totalfup = (code as? NSString)?.doubleValue {
                if totalfup != 0 {
                    throw RxSwiftMoyaError.ResponseError(msg: json["msg"] as! String, code: 222)
                }
            }
          
            ///使用HandyJSON库，映射成指定模型
            let object = JSONDeserializer<T>.deserializeFrom(dict: json, designatedPath: designatedPath)
            guard let model = object else {
                throw RxSwiftMoyaError.ParseJSONError()
            }
            return model
        }
    }
}


struct RequestProvider<T:TargetType> {
    
    static func endpointClosure(for target: T) -> Endpoint {
        let url = target.baseURL.appendingPathComponent(target.path).absoluteString
        var endpoint = Endpoint(url: url, sampleResponseClosure: {.networkResponse(200,target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
        endpoint = endpoint.adding(newHTTPHeaderFields:["Content-Type" : "application/x-www-form-urlencoded","ECP-COOKIE" : ""])
        return endpoint
    }
    /// 获取请求供应商
    /// - Returns: 请求对象
    static func requestProvider() -> MoyaProvider<T> {
        let networkPlugin = NetworkActivityPlugin {(type, requestModel) in
            switch type {
            case .began:
                // 开始请求
                DispatchQueue.main.async{
                    NSObject.startAnimatingHUD()
                }
            case .ended:
                // 结束请求
                DispatchQueue.main.async{
                    NSObject.stopAnimatingHUD()
                }
            }
        }
        #if DEBUG
        let provider = MoyaProvider<T>(plugins: [NetworkLoggerPlugin(),networkPlugin])
        #else
        let provider = MoyaProvider<T>(plugins: [networkPlugin])
        #endif
        return provider
    }
    
    static func requestEndpointProvider() ->MoyaProvider<T> {
        let networkPlugin = NetworkActivityPlugin {(type, requestModel) in
            switch type {
            case .began:
                // 开始请求
                DispatchQueue.main.async{
                    NSObject.startAnimatingHUD()
                }
            case .ended:
                // 结束请求
                DispatchQueue.main.async{
                    NSObject.stopAnimatingHUD()
                }
            }
        }
      

        #if DEBUG
        let provider = MoyaProvider<T>(endpointClosure: endpointClosure,plugins: [NetworkLoggerPlugin(),networkPlugin])
        #else
        let provider = MoyaProvider<T>(endpointClosure: endpointClosure,plugins: [networkPlugin])
        #endif
        return provider
    }
}

class NetworkManager<T:TargetType,U:NSObject>:NSObject{

    static func request(_ target: T) -> Single<Any>{
        let networkPlugin = NetworkActivityPlugin {(type, requestModel) in
            switch type {
            case .began:
                // 开始请求
                DispatchQueue.main.async{
                    startAnimatingHUD()
                }
            case .ended:
                // 结束请求
                DispatchQueue.main.async{
                    stopAnimatingHUD()
                }
            }
        }
        //初始化请求的provider
        #if DEBUG
        let provider = MoyaProvider<T>(plugins: [NetworkLoggerPlugin(),networkPlugin])
        #else
        let provider = MoyaProvider<T>(plugins: [networkPlugin])
        #endif
        return provider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .mapModel(U.self)
    }
    
    
    /// 请求
    /// - Parameters:
    ///   - target: 请求类
    ///   - successCallback: 服务器连接成功，且数据正确返回（同时会自动将数据转换成 JSON 对象，方便使用）
    ///   - errorCallback: 服务器连接成功，但数据返回错误（同时会返回错误信息）
    ///   - failureCallback: 服务器连接不上，网络异常等（同时会返回错误信息。必要的话，还可以在此增加自动重新请求的机制。）
    static func rx_request(
        _ target: T,
        success successCallback: @escaping (_ model:U) -> Void,
        error errorCallback: @escaping (RxSwiftMoyaError) -> Void
    ) {
        
        /**
         AccessTokenPlugin 管理AccessToken的插件
         CredentialsPlugin 管理认证的插件
         NetworkActivityPlugin 管理网络状态的插件
         NetworkLoggerPlugin 管理网络log的插件
         */
        let networkPlugin = NetworkActivityPlugin {(type, requestModel) in
            switch type {
            case .began:
                // 开始请求
                DispatchQueue.main.async{
                    startAnimatingHUD()
                }
            case .ended:
                // 结束请求
                DispatchQueue.main.async{
                    stopAnimatingHUD()
                }
            }
        }
        //初始化请求的provider
        #if DEBUG
        let provider = MoyaProvider<T>(plugins: [NetworkLoggerPlugin(),networkPlugin])
        #else
        let provider = MoyaProvider<T>(plugins: [networkPlugin])
        #endif
        let _ = provider.rx.request(target)
            .mapModel(U.self)
            .subscribe(onSuccess: { (response) in
                successCallback(response as! U)
            }, onError: { (error) in
                NSLog((error as! RxSwiftMoyaError).displayMessage)
                errorCallback((error as! RxSwiftMoyaError))
            })
    }
    
    static func request(
        _ target: T,
        isAddToken:Bool = true,
        isLoading:Bool = true,
        success successCallback: @escaping (_ model:BaseModel<U>) -> Void,
        error errorCallback: @escaping (RxSwiftMoyaError) -> Void
    ){
        if isAddToken {
            guard refreshTokenBeOverdue() else {
                errorCallback(.OtherError(msg: "token过期", code: -100000))
                // UIApplication.shared.currentAppDelegate?.logOutChangeConfigure()
                return;
            }
        }
        let networkPlugin = NetworkActivityPlugin {(type, requestModel) in
            switch type {
            case .began:
                // 开始请求
                DispatchQueue.main.async{
                    if isLoading {
                        startAnimatingHUD()
                    }
                    NSLog("开始请求")
                }
            case .ended:
                // 结束请求
                DispatchQueue.main.async{
                    if isLoading {
                        stopAnimatingHUD()
                    }
                    NSLog("结束请求")
                }
            }
        }
        //初始化请求的provider
        #if DEBUG
        let provider = MoyaProvider<T>(plugins: [NetworkLoggerPlugin(),networkPlugin])
        #else
        let provider = MoyaProvider<T>(plugins: [networkPlugin])
        #endif
        
        provider.request(target) { result in
            stopAnimating(nil)
            switch result {
            case let .success(response):
                do {
                    // NSLog("200 - 299: \(response.data)")
                    try _ = response.filterSuccessfulStatusCodes()
                    //如果数据返回成功则直接将结果转为JSON
                    if let object = JSONDeserializer<BaseModel<U>>.deserializeFrom(json: try response.mapString()) {
                        DispatchQueue.main.async{
                            successCallback(object)
                        }
                    }else{
                        DispatchQueue.main.async{
                            errorCallback(.ParseJSONError(msg: "json解析出错"))
                        }
                    }
                }
                catch let error {
                    //如果数据获取失败，则返回错误状态码
                    DispatchQueue.main.async{
                        errorCallback(.ResponseError(msg: error.localizedDescription))
                    }
                }
            case let .failure(error):
                switch error {
                case .imageMapping( _):
                    NSLog("错误原因：\(error.errorDescription ?? "")")
                case .jsonMapping( _):
                    NSLog("错误原因：\(error.errorDescription ?? "")")
                case .statusCode( _):
                    NSLog("错误原因：\(error.errorDescription ?? "")")
                case .stringMapping( _):
                    NSLog("错误原因：\(error.errorDescription ?? "")")
                case .underlying( _,  _):
                    NSLog("错误原因：\(error.errorDescription ?? "")")
                case .requestMapping:
                    NSLog("错误原因：\(error.errorDescription ?? "")")
                case .objectMapping(_, _): break
                    
                case .encodableMapping(_):break
                    
                case .parameterEncoding(_):break
                    
                }
                DispatchQueue.main.async{
                    errorCallback(.RequestFailedError(msg: error.errorDescription ?? ""))
                }

            }
        }
        
        
    }
	
    static func requestValueArr(
        _ target: T,
        isAddToken:Bool = true,
        isLoading:Bool = true,
        success successCallback: @escaping (_ model:BaseArrayModel<U>) -> Void,
        error errorCallback: @escaping (RxSwiftMoyaError) -> Void
    ){
        if isAddToken {
            guard refreshTokenBeOverdue() else {
                errorCallback(.OtherError(msg: "token过期", code: -100000))
                // UIApplication.shared.currentAppDelegate?.logOutChangeConfigure()
                return;
            }
        }
        let networkPlugin = NetworkActivityPlugin {(type, requestModel) in
            switch type {
            case .began:
                // 开始请求
                DispatchQueue.main.async{
                    if isLoading {
                        startAnimatingHUD()
                    }
                    NSLog("开始请求")
                }
            case .ended:
                // 结束请求
                DispatchQueue.main.async{
                    if isLoading {
                        stopAnimatingHUD()
                    }
                    NSLog("结束请求")
                }
            }
        }
        //初始化请求的provider
        #if DEBUG
        let provider = MoyaProvider<T>(plugins: [NetworkLoggerPlugin(),networkPlugin])
        #else
        let provider = MoyaProvider<T>(plugins: [networkPlugin])
        #endif
        provider.request(target) { result in
            stopAnimating(nil)
            switch result {
            case let .success(response):
                do {
                    // NSLog("200 - 299: \(response.data)")
                    try _ = response.filterSuccessfulStatusCodes()
                    //如果数据返回成功则直接将结果转为JSON
                    if let object = JSONDeserializer<BaseArrayModel<U>>.deserializeFrom(json: try response.mapString()) {
                        DispatchQueue.main.async{
                            successCallback(object)
                        }
                    }else{
                        DispatchQueue.main.async{
                            errorCallback(.ParseJSONError(msg: "json解析出错"))
                        }
                    }
                }
                catch let error {
                    //如果数据获取失败，则返回错误状态码
                    DispatchQueue.main.async{
                        errorCallback(.ResponseError(msg: error.localizedDescription))
                    }
                }
            case let .failure(error):
                switch error {
                case .imageMapping( _):
                    NSLog("错误原因：\(error.errorDescription ?? "")")
                case .jsonMapping( _):
                    NSLog("错误原因：\(error.errorDescription ?? "")")
                case .statusCode( _):
                    NSLog("错误原因：\(error.errorDescription ?? "")")
                case .stringMapping( _):
                    NSLog("错误原因：\(error.errorDescription ?? "")")
                case .underlying( _,  _):
                    NSLog("错误原因：\(error.errorDescription ?? "")")
                case .requestMapping:
                    NSLog("错误原因：\(error.errorDescription ?? "")")
                case .objectMapping(_, _): break
                    
                case .encodableMapping(_):break
                    
                case .parameterEncoding(_):break
                    
                }
                DispatchQueue.main.async{
                    errorCallback(.RequestFailedError(msg: error.errorDescription ?? ""))
                }

            }
        }
        
    }
    
    
    static func requestBasic(
        _ target: T,
        isAddToken:Bool = false,
        isLoading:Bool = true,
        success successCallback: @escaping (_ model:U) -> Void,
        error errorCallback: @escaping (RxSwiftMoyaError) -> Void
    ){
        if isAddToken {
            guard refreshTokenBeOverdue() else {
                errorCallback(.OtherError(msg: "token过期", code: -100000))
                // UIApplication.shared.currentAppDelegate?.logOutChangeConfigure()
                return;
            }
        }
        let networkPlugin = NetworkActivityPlugin {(type, requestModel) in
            switch type {
            case .began:
                // 开始请求
                DispatchQueue.main.async{
                    if isLoading {
                        startAnimatingHUD()
                    }
                    NSLog("开始请求")
                }
            case .ended:
                // 结束请求
                DispatchQueue.main.async{
                    if isLoading {
                        stopAnimatingHUD()
                    }
                    NSLog("结束请求")
                }
            }
        }
        //初始化请求的provider
        #if DEBUG
        let provider = MoyaProvider<T>(plugins: [NetworkLoggerPlugin(),networkPlugin])
        #else
        let provider = MoyaProvider<T>(plugins: [networkPlugin])
        #endif
        provider.request(target) { result in
            stopAnimating(nil)
            switch result {
            case let .success(response):
                do {
                    // NSLog("200 - 299: \(response.data)")
                    try _ = response.filterSuccessfulStatusCodes()
                    //如果数据返回成功则直接将结果转为JSON
                    if let object = JSONDeserializer<U>.deserializeFrom(json: try response.mapString()) {
                        DispatchQueue.main.async{
                            successCallback(object)
                        }
                    }else{
                        DispatchQueue.main.async{
                            errorCallback(.ParseJSONError(msg: "json解析出错"))
                        }
                    }
                }
                catch let error {
                    //如果数据获取失败，则返回错误状态码
                    DispatchQueue.main.async{
                        errorCallback(.ResponseError(msg: error.localizedDescription))
                    }
                }
            case let .failure(error):
                switch error {
                case .imageMapping( _):
                    NSLog("错误原因：\(error.errorDescription ?? "")")
                case .jsonMapping( _):
                    NSLog("错误原因：\(error.errorDescription ?? "")")
                case .statusCode( _):
                    NSLog("错误原因：\(error.errorDescription ?? "")")
                case .stringMapping( _):
                    NSLog("错误原因：\(error.errorDescription ?? "")")
                case .underlying( _,  _):
                    NSLog("错误原因：\(error.errorDescription ?? "")")
                case .requestMapping:
                    NSLog("错误原因：\(error.errorDescription ?? "")")
                case .objectMapping(_, _): break
                    
                case .encodableMapping(_):break
                    
                case .parameterEncoding(_):break
                    
                }
                DispatchQueue.main.async{
                    errorCallback(.RequestFailedError(msg: error.errorDescription ?? ""))
                }

            }
        }
        
    }
}


/// 添加公共请求头
func addHeader() ->[String:String]{
    var hearder = [String:String]()
    addToken(headParams: &hearder)
    return hearder
}

/// 添加token到请求头
/// - Parameter headParams: 请求头内容字典对象
func addToken( headParams:inout [String:String]){
    switch accessTokenBeOverdue() {
    case .beOverdue:
        NSLog("过期")
        refreshAccessToken()
        headParams[token_Key] = "Bearer \(Defaults.access_token)"
    case .aboutToExpire:
        NSLog("即将过期")
        headParams[token_Key] = "Bearer \(Defaults.access_token)"
        refreshAccessToken(isSynchronization: false)
    case .notExpired:
        NSLog("未过期")
        headParams[token_Key] = "Bearer \(Defaults.access_token)"
    }
    
}
///MARK:token是否过期
extension DefaultsKeys{
    /// 刷新时候用的token
    var refresh_token: DefaultsKey<String> { .init("refresh_token", defaultValue: "") }
    /// token
    var access_token: DefaultsKey<String> { .init("access_token", defaultValue: "") }
    /// access_token过期时间
    var accessTokenExpiresTime: DefaultsKey<String> { .init("accessTokenExpiresTime", defaultValue: "") }
    /// refresh_token过期时间
    var refreshTokenExpiresTime: DefaultsKey<String> { .init("refreshTokenExpiresTime", defaultValue: "") }
}

/// accessToken的状态
enum TokenBeOverdue:String {
    case beOverdue = "过期" /// 小于60
    case aboutToExpire = "即将过期"/// 大于60 小于 300
    case notExpired = "未过期" /// 大于300
    
}
///MARK:access_token是否过期
func accessTokenBeOverdue() -> TokenBeOverdue {
    let endDateString = Defaults.accessTokenExpiresTime
    guard endDateString.count > 0 else {
        return .beOverdue
    }
    
    let time = endDateString.getTimeDifference()
    if time > 300 {
        return .notExpired
    }else if(time > 60 && time < 300 ){
        return .aboutToExpire
    }else{
        return .beOverdue
    }
}
///MARK:refresh_token是否过期
func refreshTokenBeOverdue() -> Bool {
    let endDateString = Defaults.refreshTokenExpiresTime
    guard endDateString.count > 0 else {
        return false
    }
    return endDateString.isTheTimeExpired()
}

/// 刷新access_token
/// - Parameter isSynchronization: 是否是同步请求
func refreshAccessToken(isSynchronization:Bool = true){
    guard refreshTokenBeOverdue() else {
        // refreshToken 过期，返回登录界面
        // UIApplication.shared.currentAppDelegate?.logOutChangeConfigure()
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: logOut), object: nil, userInfo: nil)
        return
    }
    //创建URL对象
    let urlString:String="\(Token_URL)oauth/token"
    let url = URL(string:urlString)
    //创建请求对象
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    let paramter = "refresh_token=\(Defaults.refresh_token)&grant_type=refresh_token&client_id=App_Grid_iOS&client_secret=zeMpDVdwfzntg@UHmUdtbbAScAC9Dlwf"
    // 将字符串转换成数据
    request.httpBody = paramter.data(using: .utf8)
    let semaphore:DispatchSemaphore? = isSynchronization ? DispatchSemaphore(value: 0):nil
    requestRefreshAccessToken(request: request, semaphore: semaphore)
    _ = semaphore?.wait(timeout: DispatchTime.distantFuture)
}

func requestRefreshAccessToken(request:URLRequest,semaphore:DispatchSemaphore?) {
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request,
                                    completionHandler: {(data, response, error) -> Void in
                                        if error != nil{
                                            NSLog(error!)
                                        }else{
                                            let result = dataToDictionary(data: data!)
                                            if let dataDict = result{
                                                if let value = dataDict["value"] as? Dictionary<String, Any> {
                                                    Defaults.access_token = value["access_token"] as! String
                                                    Defaults.refresh_token = value["refresh_token"] as! String
                                                    Defaults.accessTokenExpiresTime = value["accessTokenExpiresTime"] as! String
                                                    Defaults.refreshTokenExpiresTime = value["refreshTokenExpiresTime"] as! String
                                                }
                                            }
                                        }
                                        semaphore?.signal()
                                    }) as URLSessionTask
    //使用resume方法启动任务
    dataTask.resume()
}

func dataToDictionary(data:Data) ->Dictionary<String, Any>?{
    do{
        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        let dic = json as! Dictionary<String, Any>
        return dic
    }catch _ {
        NSLog("失败")
        return nil
    }
    
}

func filerMsg<T:NSObject>(event:Event<T>) -> Bool {
    if let err = event.error as? RxSwiftMoyaError {
        NSObject().appearController()?.showHUDWithError(error: err.displayMessage)
        return false
    }else if let err = event.error {
        NSObject().appearController()?.showHUDWithError(error: err.localizedDescription)
        return false
    }
    return true
}
