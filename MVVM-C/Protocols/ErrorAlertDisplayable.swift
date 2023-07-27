//
//  ErrorAlertDisplayable.swift
//  MVVM-C
//
//  Created by LingXiao Dai on 2023/7/27.
//

import UIKit
import RxSwift
import RxCocoa

protocol ErrorAlertDisplayable {
    var errorAlert: Binder<String> {
        get
    }
}

extension ErrorAlertDisplayable where Self: UIViewController {
    var errorAlert: Binder<String> {
        return Binder<String>.init(self) { viewController, msg in
            let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alert.addAction(action)
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
}
