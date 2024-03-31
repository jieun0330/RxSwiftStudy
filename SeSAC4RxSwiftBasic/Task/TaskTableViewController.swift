//
//  TaskTableViewController.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 3/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

final class TaskTableViewController: BaseViewController {
    
    private let tableView = UITableView().then {
        $0.backgroundColor = .lightGray
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    private let textField = UITextField().then {
        $0.backgroundColor = .orange
    }
    
    private let disposeBag = DisposeBag()
    
    let items = Observable.just([
        "First Item",
        "Second Item",
        "Third Item"
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        items
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(element) @ row \(row)"
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe { indexPath in
                print(indexPath)
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .subscribe { model in
                print(model)
            }.disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        [textField, tableView].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        textField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(50)
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
}
