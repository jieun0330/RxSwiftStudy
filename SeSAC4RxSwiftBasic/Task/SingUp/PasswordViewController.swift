//
//  PasswordViewController.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 3/29/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

import UIKit
import SnapKit

final class PasswordViewController: BaseViewController {
    
    private let viewModel = PasswordViewModel()
    
    private let passwordTextField: UITextField = {
        let textField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
        textField.isSecureTextEntry = true
        return textField
    }()
    private lazy var nextButton: UIButton = {
        let button = PointButton(title: "다음")
        button.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        return button
    }()
    private let descriptionLabel = UILabel()
    
    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    @objc private func nextButtonClicked() {
        print(#function)
        navigationController?.pushViewController(PhoneViewController(), animated: true)
    }
    
    override func configureHierarchy() {
        [passwordTextField, descriptionLabel, nextButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(passwordTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .white
    }
    
    private func bind() {
        
        viewModel.validText
            .asDriver()
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposebag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordTextField)
            .disposed(by: disposebag)
        
        viewModel.validatePassword
            .map{ $0 ? UIColor.systemPink : UIColor.lightGray }
            .bind(to: nextButton.rx.backgroundColor)
            .disposed(by: disposebag)
        
        viewModel.validatePassword
            .bind(to: descriptionLabel.rx.isHidden, nextButton.rx.isEnabled)
            .disposed(by: disposebag)
    }
}
