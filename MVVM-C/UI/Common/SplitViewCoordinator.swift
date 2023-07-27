//
//  SplitViewCoordinator.swift
//  MVVM-C
//
//  Created by LingXiao Dai on 2023/7/26.
//

import UIKit
import RxSwift
import RxCocoa
class SplitViewCoordinator: BaseCoordinator<Void> {
    enum SectionTab {
        case posts
        case albums
        case todos
        case profile
        
        var title: String {
            switch self {
            case .posts:
                return "Posts"
            case .albums:
                return "Albums"
            case .todos:
                return "Todos"
            case .profile:
                return "Profile"
            }
        }
        
        
        var image: UIImage {
            switch self {
            case .posts:
                return #imageLiteral(resourceName: "PostsTabIcon")
            case .albums:
                return #imageLiteral(resourceName: "AlbumsTabIcon")
            case .todos:
                return #imageLiteral(resourceName: "TodosTabIcon")
            case .profile:
                return #imageLiteral(resourceName: "ProfileTabIcon")
            }
        }
    }
    
    private let window: UIWindow
    
    private let dependencies: AppDependencyType
    
    private let viewDelegate: SplitViewDelegate
    
    init(window: UIWindow, dependencies: AppDependencyType) {
        self.window = window
        self.dependencies = dependencies
        
        let detailNavigationVC = DetailNavigationController()
        
        self.viewDelegate = SplitViewDelegate(detailNavigationController: detailNavigationVC)
    }
    
    override func start() -> Observable<Void> {
        let tabBarController = UITabBarController()
        let tabs: [SectionTab] = [.posts, .albums, .todos, .profile]
        
        let arr = config(tabBarcontroller: tabBarController, withTabs: tabs)
        let coordinationResults = Observable.from(arr).merge()
        
        if let initialPrimaryView = tabBarController.selectedViewController as? PrimaryContainerType {
            viewDelegate.updateSecondaryWithDetail(from: initialPrimaryView)
        }
        
        let splitCtrl = UISplitViewController()
        splitCtrl.delegate = viewDelegate
        splitCtrl.viewControllers = [tabBarController, viewDelegate.detailNavigationController]
        splitCtrl.preferredDisplayMode = .allVisible
        window.rootViewController = splitCtrl
        window.makeKeyAndVisible()
        
        let result = coordinationResults
            .take(1)
        return result

    }
    
    private func config(tabBarcontroller: UITabBarController, withTabs tabs: [SectionTab]) -> [Observable<Void>] {
        let navControllers = tabs.map { tab -> UINavigationController in
            let navController = NavigationController(withPopDetailCompletion: viewDelegate.replaceDetail)
            
            navController.tabBarItem = UITabBarItem(title: tab.title, image: tab.image, selectedImage: nil)
            
            return navController
        }
        
        tabBarcontroller.viewControllers = navControllers
        tabBarcontroller.delegate = viewDelegate
        tabBarcontroller.view.backgroundColor = UIColor.white
        
        let arr = zip(tabs, navControllers)
        
        let result: [Observable<Void>] = arr.map { (tab, navCtrl) in
            // FIXME: @lingxiao need to specify the accurate coordinator for splitCoordinator
//            switch tab {
//            case .posts:
//                let coordinator = PostsCoordinator(navigationController: navCtrl, dependencies: dependencies)
//                return coordinator(to: coordinator)
//            }
            
            let coordinator = PostsCoordinator(navigationController: navCtrl, dependencies: dependencies)
            return self.coordinator(to: coordinator)
        }
        
        return result
        
    }
    
    
    
}
