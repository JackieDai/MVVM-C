//
//  AppCoordinator.swift
//  MVVM-C
//
//  Created by LingXiao Dai on 2023/7/26.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class AppCoordinator: BaseCoordinator<Void> {
    private let window: UIWindow
    private let dependencies: AppDependencyType
    
    init(window: UIWindow) {
        self.window = window
        self.dependencies = AppDependency()
    }
    
    override func start() -> Observable<Void> {
        showSplitView()
    }
    
    private func showSplitView() -> Observable<Void> {
        let splitCoordinator = SplitViewCoordinator(window: window, dependencies: dependencies)
        let result = coordinator(to: splitCoordinator)
        return result
    }
}
