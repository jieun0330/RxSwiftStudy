//
//  ShoppingTableViewController.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 4/1/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class ShoppingTableViewController: BaseViewController {
    
    private let viewModel = ShoppingTableViewModel()
    
    private let textField: UITextField =  {
        let textField = UITextField()
        textField.placeholder = "무엇을 구매하실 건가요?"
        textField.backgroundColor = .systemGray6
        return textField
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ShoppingTableTableViewCell.self, forCellReuseIdentifier: ShoppingTableTableViewCell.identifier)
        tableView.backgroundColor = .white
        tableView.rowHeight = 100
        return tableView
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func configureHierarchy() {
        [textField, addButton, tableView].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        textField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalTo(addButton.snp.leading)
            $0.height.equalTo(50)
        }
        
        addButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.equalTo(textField.snp.top)
            $0.size.equalTo(50)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        view.backgroundColor = .white
    }
    
    @objc private func addButtonClicked() {
        
        if textField.text?.trimmingCharacters(in: .whitespaces) == "" { return }
        let addItem = textField.text
        // addItem을 items에 더해주고
        viewModel.items.append(Item(item: addItem!))
        // onNext: Observable의 최신값을 emit
        // data의 최신값을 업데이트하는 느낌
        viewModel.data.onNext(viewModel.items)
        textField.text?.removeAll()
    }
    
    private func bind() {
        viewModel.data
            .bind(to: tableView.rx.items(cellIdentifier: ShoppingTableTableViewCell.identifier, cellType: ShoppingTableTableViewCell.self)) { row, element, cell in
                
                cell.configureCellItemTitle(element: element.item)
                cell.configureCellButton(row: row)
            }
            .disposed(by: disposeBag)
        
        viewModel.textField
            .bind(to: textField.rx.text.orEmpty)
            .disposed(by: disposeBag)        
    }
}
