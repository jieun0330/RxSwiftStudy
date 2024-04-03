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
    
    private lazy var addButton = UIButton().then {
        $0.setTitle("추가", for: .normal)
        $0.setTitleColor(.orange, for: .normal)
        $0.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
    }
    
    private let disposeBag = DisposeBag()
    
    private var items = ["First Item", "Second Item", "Third Item"]
    
    private lazy var data = BehaviorSubject(value: items)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
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
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(addButton.snp.leading)
            $0.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(textField)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(50)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .white
    }
    
    private func bind() {
        
        data
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(element) @ row \(row)"
                return cell
            }
            .disposed(by: disposeBag)
                
        tableView.rx.itemSelected
            .bind(with: self, onNext: { owner, indexPath in
                owner.items.remove(at: indexPath.row)
                owner.data.onNext(owner.items)
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func addButtonClicked() {
        // 1️⃣ 추가 버튼 누르면
        // 3️⃣ items에 추가 (Observer)
        if textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" { return }
        items.append(textField.text!)
        // 4️⃣ data를 최신값으로 emit
        data.onNext(items)
        textField.text?.removeAll()
    }
}
