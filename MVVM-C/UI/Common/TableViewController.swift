//
//  TableViewController.swift
//  MVVM-C
//
//  Created by LingXiao Dai on 2023/7/27.
//

import UIKit
import RxSwift
import RxCocoa

class TableViewController: UITableViewController, ErrorAlertDisplayable {

    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: - View Methods

    func setupTableView() {
        // This is necessary since UITableViewController automatically sets tableview delegate and dataSource to self
        tableView.delegate = nil
        tableView.dataSource = nil

        tableView.tableFooterView = UIView() // Prevent empty rows
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseID)
    }

}
