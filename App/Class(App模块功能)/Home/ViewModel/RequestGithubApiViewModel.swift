//
//  RequestGithubApiViewModel.swift
//  App
//
//  Created by 张海彬 on 2021/2/21.
//

import Foundation

/// GithubApi模型类
class GithubApiModel: NSObject {
    var authorizations_url:String?
    var code_search_url:String?
    var commit_search_url:String?
    var current_user_authorizations_html_url:String?
    var current_user_repositories_url:String?
    var current_user_url:String?
    var emails_url:String?
    var emojis_url:String?
    var events_url:String?
    var feeds_url:String?
    var followers_url:String?
    var following_url:String?
    var gists_url:String?
    var hub_url:String?
    var issue_search_url:String?
    var issues_url:String?
    var keys_url:String?
    var label_search_url:String?
    var notifications_url:String?
    var organization_repositories_url:String?
    var organization_teams_url:String?
    var organization_url:String?
    var public_gists_url:String?
    var rate_limit_url:String?
    var repository_search_url:String?
    var repository_url:String?
    var starred_gists_url:String?
    var starred_url:String?
    var user_organizations_url:String?
    var user_repositories_url:String?
    var user_search_url:String?
    var user_url:String?
}


class RequestGithubApiViewModel: ViewModelType {
    let disposedBag = DisposeBag()
    
    func transform(_ input:  RequestGithubApiViewModel.Input) -> RequestGithubApiViewModel.Output {
        //网络请求服务
        let networkService = RequestGithubApiNetworkService()
        
        let result = BehaviorRelay<[MyTableSection]>(value: [])
        
        let request = input
            .dataRequest
            .flatMapLatest { _ in
                return networkService.requestGithubApi()
            }.share(replay: 1)
        
        request.bind(to: result).disposed(by: disposedBag)
        
        let output = Output(result: result)
   
        return output
    }
}

extension RequestGithubApiViewModel {
    struct Input {
        let dataRequest: Observable<Void>
    }
}

extension RequestGithubApiViewModel {
    struct Output {
        //表格数据序列
        let result:BehaviorRelay<[MyTableSection]>

    }
}
