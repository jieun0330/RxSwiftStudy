//
//  SignInViewController.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 3/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

final class SignInViewController: BaseViewController {
    
    private let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    
    private let emailValidateLabel = UILabel()
    
    private let passwordTextField: UITextField = {
       let textField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let passwordValidateLabel = UILabel()
    
    private lazy var signInButton: UIButton = {
        let button = PointButton(title: "로그인")
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        button.setTitle("회원이 아니십니까?", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let viewModel = SignInViewModel()
    
    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    @objc private func signUpButtonClicked() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    override func configureHierarchy() {
        [emailTextField, emailValidateLabel, passwordTextField, passwordValidateLabel, signInButton, signUpButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        emailValidateLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(20)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(emailTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordValidateLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(20)
        }
        
        signInButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(passwordTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(signInButton.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .white
    }
    
    private func bind() {
        
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.inputEmailTextField)
            .disposed(by: disposebag)
        
        viewModel.emailDescription
            .asDriver()
            .drive(emailValidateLabel.rx.text)
            .disposed(by: disposebag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.inputPasswordTextField)
            .disposed(by: disposebag)
        
        viewModel.passwordDescription
            .asDriver()
            .drive(passwordValidateLabel.rx.text)
            .disposed(by: disposebag)
        
        // email 형식이 맞으면 "올바른~"을 지우고, 로그인 버튼 활성화 시켜보자
        viewModel.outputEmailValidated
            .bind(to: emailValidateLabel.rx.isHidden)
            .disposed(by: disposebag)
        
        viewModel.everythingValidated
            .bind(to: passwordValidateLabel.rx.isHidden, signInButton.rx.isEnabled)
            .disposed(by: disposebag)
        
        // 형식이 맞으면 로그인 버튼 색상을 바꿔보자
        viewModel.everythingValidated
            .map { $0 ? UIColor.systemPink : UIColor.lightGray }
            .bind(to: signInButton.rx.backgroundColor)
            .disposed(by: disposebag)
    }
}
