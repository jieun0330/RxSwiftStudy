//
//  BasicTableViewController.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 3/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BasicTableViewController: UIViewController {
    
    private let tableView = UITableView()
    private let disposeBag = DisposeBag()
    
    let items = Observable.just([ // just: 요소 모두 전달
        "First Item",
        "Second Item",
        "Third Item"
    ])

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()

        items
        .bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! // Rx는 dataSource와 delegate 기반으로 되어있어서 등록해줘야한다
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe { indexPath in
                print(indexPath)
            } onDisposed: {
                print("disposed")
                
                /*
                 테이블뷰 같은 경우는 중단되면 안된다
                 테이블뷰가 살아있는 한 계속 떠있어야 한다
                 "disposed"는 프린트되지않다가 -> BasicTableViewController가 사라지면 프린트 된다
                 
                 DisposeBag 클래스가 deinit이 될 때, dispose 메서드가 호출이 된다.
                 */
                
            } // 메모리가 잘 정리되고있는 지 확인?
            // 붙인 이유: 메모리 리소스가 잘 정리되었을 때 눈으로 확인하기 위해
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .subscribe { model in
                print(model)
            }.disposed(by: disposeBag)
    }
    
    deinit {
        print(self)
    }
    
    private func configureView() {
        view.backgroundColor = .white
        tableView.backgroundColor = .lightGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        [tableView].forEach {
            view.addSubview($0)
        }
                
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
