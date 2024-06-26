//
//  ShoppingTableTableViewCell.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 4/1/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class ShoppingTableTableViewCell: BaseTableViewCell {
    
    static let identifier = "ShoppingTableTableViewCell"
    
    private let viewModel = ShoppingTableViewModel()
    
    let check = UIButton().then {
        $0.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
    }
    
    let itemTitle = UILabel()
    
    let starButton = UIButton().then {
        $0.setImage(UIImage(systemName: "star"), for: .normal)
    }
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func configureHierarchy() {
        [check, itemTitle, starButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        check.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.size.equalTo(50)
        }
        
        itemTitle.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(check.snp.trailing).offset(10)
        }
        
        starButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
            $0.size.equalTo(50)
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = .white
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func configureCellItemTitle(element: String) {
        itemTitle.text = element
    }
    
    func configureCellButton(row: Int) {
        
        check.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.items[row].check.toggle()
                owner.viewModel.items[row].check ? owner.check.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal) : owner.check.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            }
            .disposed(by: disposeBag)
        
        starButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.items[row].star.toggle()
                owner.viewModel.items[row].star ? owner.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal) : owner.starButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
