//
//  ViewModelAttaching.swift
//  MVVM-C
//
//  Created by LingXiao Dai on 2023/7/27.
//

import UIKit
import RxSwift
import RxCocoa

protocol ViewModelAttaching: AnyObject {
    associatedtype ViewModel: ViewModelType
    
    var bindings: ViewModel.Bindings {
        get
    }
    
    var viewModel: Attachable<ViewModel>! {
        get
        set
    }
    
    func attach(wrapper: Attachable<ViewModel>) -> ViewModel
    
    func bind(viewModel: ViewModel) -> ViewModel
}


extension ViewModelAttaching where Self: UIViewController {
    func attach(wrapper: Attachable<ViewModel>) -> ViewModel {
        viewModel = wrapper
        loadViewIfNeeded()
        let vm = viewModel.bind(bindings)
        return bind(viewModel: vm)
    }
}
