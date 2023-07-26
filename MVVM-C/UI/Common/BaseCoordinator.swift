//
//  BaseCoordinator.swift
//  MVVM-C
//
//  Created by LingXiao Dai on 2023/7/26.
//

import Foundation
import RxSwift

/// Base abstract coordinator generic over the return type of the `start` method.
class BaseCoordinator<ResultType>: CoordinatorType {
    
    /// Typealias which allows to access a ResultType of the Coordainator by `CoordinatorName.CoordinationResult`.
    typealias CoordinatorResult = ResultType
        
    /// Utility `DisposeBag` used by the subclasses.
    let disposeBag = DisposeBag()
    
    /// 唯一标识
    internal let identifier = UUID()
    
    /// Dictionary of the child coordinators. Every child coordinator should be added
    /// to that dictionary in order to keep it in memory.
    /// Key is an `identifier` of the child coordinator and value is the coordinator itself.
    /// Value type is `Any` because Swift doesn't allow to store generic types in the array.
    private var childCoordinators = [UUID: Any]()
    
    
    /// Stores coordinator to the `childCoordinators` dictionary.
    /// - Parameter coordinator: child coordinator to store
    private func store<T: CoordinatorType>(coordinator: T) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    /// Release coordinator from the `childCoordinators` dictionary.
    /// - Parameter coordinator: Coordinator to release.
    private func free<T: CoordinatorType>(coordinator: T) {
        childCoordinators[coordinator.identifier] = nil
    }
    
    /// 1. Stores coordinator in a dictionary of child coordinators.
    /// 2. Calls method `start()` on that coordinator.
    /// 3. On the `onNext:` of returning observable of method `start()` removes coordinator from the dictionary.
    /// 
    /// - Parameter coordinator: Coordinator to start.
    /// - Returns: Result of `start()` method.
    func coordinator<T: CoordinatorType, U>(to coordinator: T) -> Observable<U> where U == T.CoordinatorResult {
        store(coordinator: coordinator)
        return coordinator.start().do(onNext: {[weak self] _ in self?.free(coordinator: coordinator)})
    }
    
    /// Starts job of the coordinator.
    /// - Returns: Result of coordinator job.
    func start() -> RxSwift.Observable<ResultType> {
        fatalError("Start method should be implemented")
    }
}

// MARK: - CustomStringConvertible
extension BaseCoordinator: CustomStringConvertible {
    var description: String {
        return "\(type(of: self))"
    }
}
