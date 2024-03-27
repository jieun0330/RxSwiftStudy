//
//  PickerViewController.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 3/26/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

// 테이블뷰에 "영화", "애니메이션", "드라마", "기타" 가 보이게 ✅
// label 추가해서 선택한 셀 내용 보이게 하기
final class PickerViewController: BaseViewController {
    
    private let tableView = UITableView().then {
        $0.backgroundColor = .lightGray
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private let label = UILabel().then {
        $0.text = "테스트 라벨"
        $0.textColor = .black
    }
    
    private let items = Observable.just(["영화", "애니메이션", "드라마", "기타"])
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureHierarchy() {
        [tableView, label].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.height.equalTo(50)
        }
    }
    
    override func configureView() {
        items.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = element
            
            return cell
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .bind { tableCellString in
                self.label.text = tableCellString
            }
            .disposed(by: disposeBag)
    }
}
