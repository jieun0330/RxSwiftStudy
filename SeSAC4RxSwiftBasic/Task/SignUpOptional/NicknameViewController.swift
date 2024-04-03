//
//  NicknameViewController.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 3/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NicknameViewController: BaseViewController {
    
    private let viewModel = NicknameViewModel()
    
    private let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
        
    private let nextButton = PointButton(title: "다음")
    
    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func configureHierarchy() {
        [nicknameTextField, nextButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        nicknameTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .white
    }
    
    private func bind() {
        
        viewModel.nickname
            .asDriver()
            .drive(nicknameTextField.rx.text)
            .disposed(by: disposebag)

        // subscribe -> UI에 특화된 bind
        nextButton.rx.tap // tap: TouchUpInside
            .bind(with: self, onNext: { owner, _ in // with: 메인 스레드에서 동작한다는 것을 보장
                owner.navigationController?.pushViewController(BirthdayViewController(), animated: true)
            })
            .disposed(by: disposebag) // 뷰의 deinit 시점과 동일하게 동작할 수 있도록
    }
}
