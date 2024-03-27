//
//  SimpleTableViewController.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 3/27/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class SimpleTableViewController: BaseViewController {
    
    private let tableView = UITableView().then {
        $0.backgroundColor = .lightGray
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private let items = Observable.just(0...20).map { $0 }
    
    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureHierarchy() {
        [tableView].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell",
                                         cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element)"
            }
                                         .disposed(by: disposebag)
        
//        tableView.rx.itemSelected.bind { <#IndexPath#> in
//            
//        }
    }
}
