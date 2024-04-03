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

final class PhoneViewController: BaseViewController {
    
    private let viewModel = PhoneViewModel()
   
    private let phoneTextField = SignTextField(placeholderText: "휴대폰번호를 입력해주세요").then {
        $0.keyboardType = .numberPad
    }
    private let phoneDesicription = UILabel()
    private let nextButton = PointButton(title: "다음")
    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
        
    override func configureHierarchy() {
        [phoneTextField, phoneDesicription, nextButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
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
    
    override func configureView() {
        view.backgroundColor = .white
    }
    
    @objc private func nextButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }
    
    private func bind() {
        viewModel.phoneDescriptionLabel
            .bind(to: phoneDesicription.rx.text)
            .disposed(by: disposebag)
        
        viewModel.phoneTextFieldLabel
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
