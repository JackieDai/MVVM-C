//
//  SplitViewDelegate.swift
//  MVVM-C
//
//  Created by LingXiao Dai on 2023/7/26.
//

import UIKit

final class SplitViewDelegate: NSObject {
    let detailNavigationController: UINavigationController
    
    init(detailNavigationController: UINavigationController) {
        self.detailNavigationController = detailNavigationController
    }
    
    /// Changes the view controller displayed in the detail navigation controller.
    /// - Parameters:
    ///   - primaryContainer: The `PrimaryContainerType` containing the `.detailView` used to update the detail nav controller.
    ///   - animated: If `true`, animates the update.
    func updateSecondaryWithDetail(from primaryContainer: PrimaryContainerType, animated: Bool = false) {
        switch primaryContainer.detailView {
        case .collapsed(let detailVC):
            detailNavigationController.setViewControllers([detailVC], animated: animated)
        case .separated(let detailVC):
            detailNavigationController.setViewControllers([detailVC], animated: animated)
        case .placeholder:
            detailNavigationController.setViewControllers([primaryContainer.makePlaceholderViewController()], animated: animated)
        }
    }
    
    /// Sets view of detail navigation controller to a placeholder view controller.
    /// - Parameter viewController: Placeholder view controller to use.
    func replaceDetail(withEmpty viewController: UIViewController & PlaceholderViewControllerType) {
        detailNavigationController.setViewControllers([viewController], animated: true)
    }
}


extension SplitViewDelegate: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        /// Prevent selection of the same tab twice (which would reset its navigation controller)
        return tabBarController.selectedViewController == viewController ? false : true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard
            let splitVC = tabBarController.splitViewController,
            let selectedNavigationVC = viewController as? PrimaryContainerType else {
            fatalError("\(#function) FAILED : wrong view controller type")
        }
        
        if !splitVC.isCollapsed {
            updateSecondaryWithDetail(from: selectedNavigationVC)
        }
        
    }
}

extension SplitViewDelegate: UISplitViewControllerDelegate {
    // MARK: Collapsing the Interface
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        guard
            let tabBarController = splitViewController.viewControllers.first as? UITabBarController,
            let navigationControllers = tabBarController.viewControllers as? [PrimaryContainerType] else {
            fatalError("\(#function) FAILED : wrong view controller type")
        }
        
        navigationControllers.forEach { $0.collapseDetail() }
        
        return true
    }
    
    // MARK: Expanding the Interface
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        guard
            let tabBarController = primaryViewController as? UITabBarController,
            let navigationControllers = tabBarController.viewControllers as? [PrimaryContainerType],
            let selectedNavController = tabBarController.selectedViewController as? PrimaryContainerType else {
                fatalError("\(#function) FAILED : wrong view controller type")
        }
        
        navigationControllers.forEach { $0.separateDetail() }
        
        if case .placeholder = selectedNavController.detailView, splitViewController.preferredDisplayMode == .primaryHidden {
            splitViewController.preferredDisplayMode = .allVisible
        }
        
        updateSecondaryWithDetail(from: selectedNavController)
        
        return detailNavigationController
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
        guard
            let tabBarController = splitViewController.viewControllers.first as? UITabBarController,
            let selectedNavController = tabBarController.selectedViewController as? UINavigationController
                & PrimaryContainerType else {
                    fatalError("\(#function) FAILED : wrong view controller type")
        }
        
        vc.navigationItem.leftItemsSupplementBackButton = true
        vc.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem

        if splitViewController.isCollapsed {
            selectedNavController.pushViewController(vc, animated: true)
            selectedNavController.detailView = .collapsed(vc)
        } else {
            switch selectedNavController.detailView {
            /// Animate only the initial presentation of the detail vc
            case .placeholder:
                detailNavigationController.setViewControllers([vc], animated: true)
            default:
                detailNavigationController.setViewControllers([vc], animated: false)
            }
            selectedNavController.detailView = .separated(vc)
        }
        return true /// Prevent UIKit from performing default behavior
    }
}
