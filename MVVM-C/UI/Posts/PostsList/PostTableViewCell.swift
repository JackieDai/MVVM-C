//
//  PostTableViewCell.swift
//  MVVM-C
//
//  Created by LingXiao Dai on 2023/7/27.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class PostTableViewCell: UITableViewCell {
    
    private(set) var disposeBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
        }
        titleLabel.backgroundColor = .red
        titleLabel.text = "sadfasd"
    }
    
    // FIXME: @lingxiao should covert string to ViewModel
    func bind(to viewModel: String) {
        
        titleLabel.text = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
