//
//  PostsListViewModel.swift
//  MVVM-C
//
//  Created by LingXiao Dai on 2023/7/27.
//

import Foundation
import RxSwift
import RxCocoa

class PostsListViewModel: ViewModelType {
    
    
    typealias Dependency = AppDependencyType
    
    struct Bindings {
        let fetchTrigger: Driver<Void>
        let selection: Driver<IndexPath>
        
    }
    
    
//    let fetching: Driver<Bool>
    let posts: Driver<[String]>
    let selectedPost: Driver<String>
//    let errors: Driver<Error>
    
    required init(dependency: AppDependencyType, bindings: Bindings) {
        /*
         Cannot convert value of type '(Void) -> SharedSequence<DriverSharingStrategy, Any>' to expected argument type '(Void) -> SharedSequence<DriverSharingStrategy, [Any]>'
         */
        
        posts = bindings.fetchTrigger.flatMapLatest({ _ in
            return dependency.mockData().asDriverOnErrorJustComplete()
        })
        
        selectedPost = bindings.selection.withLatestFrom(self.posts, resultSelector: { (indexPath: IndexPath, posts: [String]) -> String in
           
            return posts[indexPath.row]
        })
        
        
    }
}

extension AppDependencyType {
    func mockData() -> Single<[String]> {
        Single<[String]>.create { single in
            single(.success(["1","2","3","4","5","6"]))
            return Disposables.create()
        }
    }
}
