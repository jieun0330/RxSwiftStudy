//
//  SingUpViewController.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 3/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignUpViewController: BaseViewController {
    
    private let viewModel = SignUpViewModel()
    
    private let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    
    private lazy var validationButton: UIButton = {
        let button = UIButton()
        button.setTitle("중복확인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(validationButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = PointButton(title: "다음")
        button.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let buttonColor = Observable.just(UIColor.blue)
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    @objc private func nextButtonClicked() {
        print(#function)
    }
    
    @objc private func validationButtonClicked() {
        print(#function)
    }
    
    override func configureHierarchy() {
        [emailTextField, validationButton, nextButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        
        validationButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(emailTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configureView() {
        
        view.backgroundColor = .white
    }
    
    private func bind() {
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PasswordViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.sampleEmail
            .asDriver()
            .drive(emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        validationButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.sampleEmail.accept("b@b.com")
            }
            .disposed(by: disposeBag)
        
        buttonColor
            .bind(to: nextButton.rx.backgroundColor,
                  emailTextField.rx.tintColor, // 텍스트필드 커서 색상
                  emailTextField.rx.textColor)
            .disposed(by: disposeBag)
        
        buttonColor
            .map { $0.cgColor }
            .bind(to: emailTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
    }
}
