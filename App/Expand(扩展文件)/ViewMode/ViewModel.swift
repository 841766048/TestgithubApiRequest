//
//  ViewModel.swift
//  App
//
//  Created by 张海彬 on 2020/12/22.
//

import Foundation

public protocol ViewModelType {
    /// 输入信号源
    associatedtype Input
    /// 输出信号源
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
