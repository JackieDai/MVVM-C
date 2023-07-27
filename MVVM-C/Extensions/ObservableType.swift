//
//  ObservableType.swift
//  MVVM-C
//
//  Created by LingXiao Dai on 2023/7/27.
//

import RxSwift
import RxCocoa

extension ObservableType {
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver(onErrorRecover: { error in
            return Driver.empty()
        })
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

extension PrimitiveSequenceType where Trait == SingleTrait {
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return self.primitiveSequence.asDriver(onErrorRecover: { error in
            return Driver.empty()
        })
    }
}
