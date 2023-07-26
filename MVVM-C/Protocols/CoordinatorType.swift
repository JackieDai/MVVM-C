//
//  CoordinatorType.swift
//  MVVM-C
//
//  Created by LingXiao Dai on 2023/7/26.
//

import Foundation
import RxSwift

protocol CoordinatorType {
    associatedtype CoordinatorResult
    // 唯一标识
    var identifier: UUID {get}
    // TODO: @lingxiao try to understand it
    func start() -> Observable<CoordinatorResult>
}
