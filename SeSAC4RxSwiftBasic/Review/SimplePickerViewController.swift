//
//  SimplePickerViewController.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 3/26/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

// 1,2,3
// 1,2,3 attribute
// 빨, 주, 노
final class SimplePickerViewController: BaseViewController {
    
    private let pickerView1 = UIPickerView()
    
    private let disposebag = DisposeBag()
    
    private let items = Observable.just([1,2,3])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items.bind(to: pickerView1.rx.itemTitles) { _, item in // 여기가 왜 Int, Int 두개지??
            return "\(item)"
        }
        .disposed(by: disposebag)
        
        pickerView1.rx.modelSelected(Int.self)
            .bind { value in
                print(value)
            }
            .disposed(by: disposebag)
    }
    
    override func configureHierarchy() {
        [pickerView1].forEach {
            view.addSubview($0)
        }
        
        pickerView1.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.height.equalTo(100)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .white
    }
}
