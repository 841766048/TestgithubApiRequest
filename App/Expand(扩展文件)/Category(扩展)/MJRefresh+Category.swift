//
//  MJRefresh+Category.swift
//  App
//
//  Created by 张海彬 on 2020/12/20.
//

import Foundation
/**
 ControlEvent专门用于描述UI控件所产生的事件，它具有以下特征:
 ●不会产生error事件
 ●- -定在MainScheduler订阅(主线程订阅)
 ●一定在MainScheduler监听(主线程监听)
 ●共享附加作用
 */
//对MJRefreshComponent增加rx扩展
public extension Reactive where Base: MJRefreshComponent {
    //正在刷新事件
    var refreshing: ControlEvent<Void> {
        let source = Observable<Void>.create { [weak control = self.base] observer in
            if let control = control {
                control.refreshingBlock = {
                    observer.onNext(())
                }
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
}
/**
 
 	
 	extension Reactive where Base: MJRefreshComponent {
      
    
     	var refreshing: ControlEvent<Void> {
         	let source: Observable<Void> = Observable.create {
             	[weak control = self.base] observer  in
             	if let control = control {
                 	control.refreshingBlock = {
                     	observer.on(.next(()))
                 	}
             	}
             	return Disposables.create()
         	}
         	return ControlEvent(events: source)
     	}
      
     	//停止刷新
     	var endRefreshing: Binder<Bool> {
         	return Binder(base) { refresh, isEnd in
             	if isEnd {
                 	refresh.endRefreshing()
             	}
         	}
     	}
 	}
 
 */



//MARK:下拉刷新
public extension Reactive where Base: MJRefreshHeader {
    
    var beginRefreshing: Binder<Void> {
        return Binder(base) { (header, _) in
            header.beginRefreshing()
        }
    }
    
    var isRefreshing: Binder<Bool> {
        return Binder(base) { header, refresh in
            if refresh && header.isRefreshing {
                return
            } else {
                refresh ? header.beginRefreshing() : header.endRefreshing()
            }
        }
    }
}


//MARK:上拉加载
public enum RxMJRefreshFooterState {
    
    case `default`
    case noMoreData
    case hidden
}

extension RxMJRefreshFooterState: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .default: return "默认状态"
        case .noMoreData: return "没有更多数据了"
        case .hidden: return "隐藏"
        }
    }
}

extension RxMJRefreshFooterState: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return description
    }
}

public extension Reactive where Base: MJRefreshFooter {
    
    var refreshFooterState: Binder<RxMJRefreshFooterState> {
        return Binder(base) { footer, state in
            switch state {
            case .default:
                footer.isHidden = false
                footer.resetNoMoreData()
            case .noMoreData:
                footer.isHidden = false
                footer.endRefreshingWithNoMoreData()
            case .hidden:
                footer.isHidden = true
                footer.resetNoMoreData()
            }
        }
    }
}


