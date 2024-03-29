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

final class NicknameViewController: UIViewController {
   
    private let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    private let nextButton = PointButton(title: "다음")
    private let disposebag = DisposeBag()
    
    private var nickname = Observable.just("고래밥")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        configureLayout()
        
        nickname.subscribe(with: self) { owner, value in
            owner.nicknameTextField.text = value
        }
        .disposed(by: disposebag)
       
//        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        // subscribe -> UI에 특화된 bind
        nextButton.rx.tap // tap: TouchUpInside
            .bind(with: self, onNext: { owner, _ in // with: 메인 스레드에서 동작한다는 것을 보장
                owner.navigationController?.pushViewController(BirthdayViewController(), animated: true)
            })
            .disposed(by: disposebag) // 뷰의 deinit 시점과 동일하게 동작할 수 있도록
        
    }
    
    func configureLayout() {
        view.addSubview(nicknameTextField)
        view.addSubview(nextButton)
         
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
