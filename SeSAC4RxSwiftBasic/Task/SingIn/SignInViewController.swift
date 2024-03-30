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

final class SignInViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    private let emailValidateLabel = UILabel()
    private let emailDescription = Observable.just("올바른 이메일 형식이 아닙니다")
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    private let passwordValidateLabel = UILabel()
    private let passwordDescription = Observable.just("8자 이상 입력해주세요")
    let signInButton = PointButton(title: "로그인")
    let signUpButton = UIButton()
    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        configureLayout()
        configure()
        bind()
        
        signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
    }
    
    @objc func signUpButtonClicked() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    func configure() {
        signUpButton.setTitle("회원이 아니십니까?", for: .normal)
        signUpButton.setTitleColor(.black, for: .normal)
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(emailValidateLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordValidateLabel)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        emailValidateLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordValidateLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func bind() {
        let emailValidated = emailTextField.rx.text.orEmpty
            .map{ $0.contains { value in
                value == "@"
            } }
        
        emailDescription
            .bind(to: emailValidateLabel.rx.text)
            .disposed(by: disposebag)
        
        let passwordValidated = passwordTextField.rx.text.orEmpty
            .map{ $0.count >= 8 }
        
        passwordDescription
            .bind(to: passwordValidateLabel.rx.text)
            .disposed(by: disposebag)
        
        // email 형식이 맞으면 "올바른~"을 지우고, 로그인 버튼 활성화 시켜보자
        emailValidated
            .bind(to: emailValidateLabel.rx.isHidden)
            .disposed(by: disposebag)
        
        passwordValidated
            .bind(to: passwordValidateLabel.rx.isHidden, signInButton.rx.isEnabled)
            .disposed(by: disposebag)
        
        // email 형식이 맞으면 로그인 버튼 색상을 바꿔보자
        passwordValidated
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemPink : .lightGray
                owner.signInButton.backgroundColor = color
            }
            .disposed(by: disposebag)
    }
}
