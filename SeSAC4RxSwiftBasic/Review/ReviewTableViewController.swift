//
//  ReviewTableViewController.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 3/26/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class ReviewTableViewController: BaseViewController {
    
    // 테이블뷰에 보여질 item Observable 만들어주고 ✅
    // row 선택했을땐 indexPath 프린트만 해주고
    // modelSelected는 뭐지
    
    private let tableView = UITableView().then {
        $0.backgroundColor = .lightGray
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private let item = Observable.just([ // just: 안에 있는 요소는 다 방출한다고 보면 됨
        "First Item", "Second Item", "Third Item"
                                       ])
    
    private let disposeBag = DisposeBag()
    
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
        
        item
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(element) @ row \(row)"
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind { indexPath in
            print(indexPath)
        }
        .disposed(by: disposeBag)
        // itemSelected는 indexPath만 전달하고
        
        // modelSelected -> Observable로부터 받아온 데이터를 저장하고 있는 형태
        
        tableView.rx.modelSelected(String.self)
            .bind { value in
                print(value) // element 요소들이 프린트 찍히는건가?
            }
            .disposed(by: disposeBag)
    }
}
