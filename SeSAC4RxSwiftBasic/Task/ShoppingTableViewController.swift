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

struct Item {
    var check: Bool = false
    var item: String
    var star: Bool = false
}

final class ShoppingTableViewController: BaseViewController {
    
    private let searchBar = UITextField().then {
        $0.placeholder = "무엇을 구매하실 건가요?"
        $0.backgroundColor = .systemGray6
    }
    
    private lazy var addButton = UIButton().then {
        $0.setTitle("추가", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
    }
    
    private let tableView = UITableView().then {
        $0.register(ShoppingTableTableViewCell.self, forCellReuseIdentifier: ShoppingTableTableViewCell.identifier)
        $0.backgroundColor = .white
        $0.rowHeight = 100
    }
    
    private var items: [Item] = [Item(item: "그립톡 구매하기"), Item(item: "사이다 구매")]
//    private var items = ["그립톡 구매하기", "사이다 구매", "아이패드 케이스 최저가 알아보기", "양말"]
    
    private lazy var data = BehaviorSubject(value: items)
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func configureHierarchy() {
        [searchBar, addButton, tableView].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalTo(addButton.snp.leading)
            $0.height.equalTo(50)
        }
        
        addButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.equalTo(searchBar.snp.top)
            $0.size.equalTo(50)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        view.backgroundColor = .white
    }
    
    @objc private func addButtonClicked() {
        let addItem = searchBar.text
        items.append(Item(item: addItem!))
        data.onNext(items)
        searchBar.text?.removeAll()
    }
    
    private func bind() {
        data
            .bind(to: tableView.rx.items(cellIdentifier: ShoppingTableTableViewCell.identifier, cellType: ShoppingTableTableViewCell.self)) { row, element, cell in
                
                cell.itemTitle.text = element.item
                cell.check.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.items[row].check.toggle()
                        owner.items[row].check ? cell.check.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal) : cell.check.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                        
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.starButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.items[row].star.toggle()
                        owner.items[row].star ? cell.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal) : cell.starButton.setImage(UIImage(systemName: "star"), for: .normal)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
//            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                
                let result = value.isEmpty ? owner.items : owner.items.filter { $0.item.contains(value) }
                owner.data.onNext(result)
            }
            .disposed(by: disposeBag)
    }
}
