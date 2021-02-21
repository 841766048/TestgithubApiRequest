//
//  RequestGithubApiHistoryViewModel.swift
//  App
//
//  Created by 张海彬 on 2021/2/21.
//

import Foundation



class RequestGithubApiHistoryViewModel: ViewModelType {
    let disposedBag = DisposeBag()
    
    func transform(_ input:  RequestGithubApiHistoryViewModel.Input) -> RequestGithubApiHistoryViewModel.Output {
        //网络请求服务
        let networkService = RequestGithubApiHistoryServer()
        
        let header = input
            .headerRefresh
            .flatMapLatest { _ in
                return networkService.requestGithubApiHistory()
            }.share(replay: 1)
        
        let endHeader = header.map { _ in false }
            .asDriver(onErrorJustReturn: false)
        
        let tableData = BehaviorRelay<[MyTableSection]>(value: [])
        
        header.bind(to: tableData).disposed(by: disposedBag)
        
        let output = Output(result: tableData, endHeaderRefreshing: endHeader)
   
        return output
    }
}

extension RequestGithubApiHistoryViewModel {
    struct Input {
        let headerRefresh: Observable<Void>
    }
}

extension RequestGithubApiHistoryViewModel {
    struct Output {
        //表格数据序列
        let result:BehaviorRelay<[MyTableSection]>
        //停止刷新状态序列
        let endHeaderRefreshing: Driver<Bool>
    }
}
