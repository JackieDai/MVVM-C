//
//  PostsListViewController.swift
//  MVVM-C
//
//  Created by LingXiao Dai on 2023/7/27.
//

import UIKit
import RxSwift
import RxCocoa

class PostsListViewController: TableViewController, ViewModelAttaching {
    var bindings: PostsListViewModel.Bindings {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        return PostsListViewModel.Bindings(
            fetchTrigger: viewWillAppear,
            selection: tableView.rx.itemSelected.asDriver()
        )
    }
    
    var viewModel: Attachable<PostsListViewModel>!
    
    func bind(viewModel: PostsListViewModel) -> PostsListViewModel {
        viewModel.posts
            .drive(tableView.rx.items(cellIdentifier: PostTableViewCell.reuseID, cellType: PostTableViewCell.self)) { indexPathRow, viewModel, cell in
                cell.bind(to: viewModel)
            }
            .disposed(by: disposeBag)
        
        return viewModel
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Posts"
        
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.reuseID)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
    }

}


extension PostsListViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
