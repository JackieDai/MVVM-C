//
//  PrimaryContainerType.swift
//  MVVM-C
//
//  Created by LingXiao Dai on 2023/7/26.
//

import UIKit

//typealias PrimaryContainerType = SplitTabRootViewControllerType & PlaceholderFactory

protocol PrimaryContainerType: SplitTabRootViewControllerType, PlaceholderFactory { }

/// Represents state of detail view controller in split view controller.
enum DetailView {
    case collapsed(UIViewController)
    case separated(UIViewController)
    case placeholder
}


protocol SplitTabRootViewControllerType: AnyObject {
    /// Called to update secondary view controller with `PlaceholderViewControllerType` when popping view controller.
    var detailPopCompletion: (UIViewController & PlaceholderViewControllerType) -> Void { get }
    
    /// Represents state of detail view controller in split view controller.
    var detailView: DetailView { get set }
    
    /// Add detail view controller to `viewControllers` if it is visible and update `detailView`.
    func collapseDetail()
    
    /// Remove detail view controller from `viewControllers` if it is visible and update `detailView`.
    func separateDetail()
}

extension SplitTabRootViewControllerType where Self: UINavigationController {
    func collapseDetail() {
        switch detailView {
        case .separated(let detailVC):
            viewControllers += [detailVC]
            detailView = .collapsed(detailVC)
        default:
            return
        }
    }
    
    func separateDetail() {
        switch detailView {
        case .collapsed(let detailVC):
            viewControllers.removeLast()
            detailView = .separated(detailVC)
        default:
            return
        }
    }
    
    
}


/// Represents empty detail view controller.
protocol PlaceholderViewControllerType: AnyObject {}

protocol PlaceholderFactory {
    /// Factory method to produce tab-specific placeholder for secondary view controller.
    func makePlaceholderViewController() -> UIViewController & PlaceholderViewControllerType
}
