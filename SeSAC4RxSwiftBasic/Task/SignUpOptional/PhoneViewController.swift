//
//  PhoneViewController.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 3/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

final class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "휴대폰번호를 입력해주세요").then {
        $0.keyboardType = .numberPad
    }
    private let phoneTextFieldLabel = Observable.just("010")
    private let phoneDesicription = UILabel()
    private let phoneDescriptionLabel = Observable.just("10자 이상 입력해주세요")
    private let nextButton = PointButton(title: "다음")
    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        configureLayout()
        bind()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }

    
    func configureLayout() {
        [phoneTextField, phoneDesicription, nextButton].forEach {
            view.addSubview($0)
        }
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        phoneDesicription.snp.makeConstraints {
            $0.top.equalTo(phoneTextField.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func bind() {
        phoneDescriptionLabel
            .bind(to: phoneDesicription.rx.text)
            .disposed(by: disposebag)
        phoneTextFieldLabel
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposebag)
        
        let validatePhoneNum = phoneTextField.rx.text.orEmpty
            .map { $0.count >= 10 }
        
        validatePhoneNum
            .bind(to: phoneDesicription.rx.isHidden, nextButton.rx.isEnabled)
            .disposed(by: disposebag)
        
        validatePhoneNum
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemPink : .lightGray
                owner.nextButton.backgroundColor = color
            }
            .disposed(by: disposebag)
    }
}
