//
//  AppDependency.swift
//  MVVM-C
//
//  Created by LingXiao Dai on 2023/7/26.
//

import Foundation

protocol HasClient {
    var client: APIClient {
        get
    }
}


protocol AppDependencyType: HasClient {}


struct AppDependency {
    let client: APIClient
    
    init() {
        self.client = .init()
    }
}

extension AppDependency: AppDependencyType {
    
}
