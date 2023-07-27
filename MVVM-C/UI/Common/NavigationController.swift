//
//  NavigationController.swift
//  MVVM-C
//
//  Created by LingXiao Dai on 2023/7/26.
//

import UIKit

class NavigationController: UINavigationController, PrimaryContainerType {
    let detailPopCompletion: (UIViewController & PlaceholderViewControllerType) -> Void
    
    var detailView: DetailView = .placeholder
    
    func makePlaceholderViewController() -> UIViewController & PlaceholderViewControllerType {
        return PlaceholderViewController()
    }
    
    init(withPopDetailCompletion completion: @escaping (UIViewController & PlaceholderViewControllerType) -> Void) {
        self.detailPopCompletion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        switch detailView {
        case .collapsed:
            detailView = .placeholder
        case .separated:
            detailView = .placeholder
            detailPopCompletion(makePlaceholderViewController())
        case .placeholder:
            break
        }
        return super.popViewController(animated: animated)
    }

}
