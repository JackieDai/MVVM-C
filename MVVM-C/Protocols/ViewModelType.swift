//
//  ViewModelType.swift
//  MVVM-C
//
//  Created by LingXiao Dai on 2023/7/27.
//

import Foundation

protocol ViewModelType {
    associatedtype Dependency
    associatedtype Bindings
    
    init(dependency: Dependency, bindings: Bindings)
}

enum Attachable<VM: ViewModelType> {
    // 分拆
    case detached(VM.Dependency)
    // 链接
    case attached(VM.Dependency, VM)
    
    mutating func bind(_ bindings: VM.Bindings) -> VM {
        switch self {
        case .detached(let dependency):
            let vm = VM(dependency: dependency, bindings: bindings)
            self = .attached(dependency, vm)
            return vm
        case .attached(let dependency, _):
            let vm = VM(dependency: dependency, bindings: bindings)
            self = .attached(dependency, vm)
            return vm
        }
    }
}
