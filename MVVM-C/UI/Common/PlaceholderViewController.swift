//
//  PlaceholderViewController.swift
//  MVVM-C
//
//  Created by LingXiao Dai on 2023/7/26.
//

import UIKit
import ColorCompatibility

class PlaceholderViewController: UIViewController, PlaceholderViewControllerType {
    
    let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "EmptyViewBackground")
        view.tintColor = ColorCompatibility.systemGray2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let displayModeButtonItem = splitViewController?.displayModeButtonItem {
            navigationItem.leftBarButtonItem = displayModeButtonItem
        }
    }
    
    func setupView() {
        view.backgroundColor = ColorCompatibility.systemBackground
        view.addSubview(backgroundImageView)
        navigationItem.leftItemsSupplementBackButton = true
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.widthAnchor.constraint(equalToConstant: 180),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 180),
            backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

}
