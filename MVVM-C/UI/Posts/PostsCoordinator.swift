//
//  PostsCoordinator.swift
//  MVVM-C
//
//  Created by LingXiao Dai on 2023/7/27.
//

import UIKit
import RxSwift
import RxCocoa

class PostsCoordinator: BaseCoordinator<Void> {
    private let navigationController: UINavigationController
    private let dependencies: AppDependencyType
    
    init(navigationController: UINavigationController, dependencies: AppDependencyType) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    override func start() -> Observable<Void> {
        let viewContoller = PostsListViewController()
        
        navigationController.viewControllers = [viewContoller]
        
        let avm: Attachable<PostsListViewModel> = .detached(dependencies)
        let viewModel = viewContoller.attach(wrapper: avm)
        
        viewModel.selectedPost
            .drive(onNext: { [weak self] selection in
                self?.showDetailView(with: selection)
            })
            .disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    private func showDetailView(with post: String) {
        let viewController = UIViewController()
        viewController.title = post
        navigationController.showDetailViewController(viewController, sender: nil)
    }
}
