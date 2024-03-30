//
//  SimpleValidationViewController.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 3/27/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class SimpleValidationViewController: BaseViewController {
    
    private let disposebag = DisposeBag()

    private let userName = UILabel().then {
        $0.text = "Username"
    }
    
    private let userNameTextField = UITextField().then {
        $0.backgroundColor = .lightGray
    }
    
    private let userNameValidationLabel = UILabel().then {
        $0.text = "Username has to be at least 5 characters"
        $0.textColor = .red
    }
    
    private let password = UILabel().then {
        $0.text = "Password"
    }

    private let passwordTextField = UITextField().then {
        $0.backgroundColor = .lightGray
    }
    
    private let passwordValidationLabel = UILabel().then {
        $0.text = "Password has to be at least 5 characters"
        $0.textColor = .red
    }
    
    private let validationButton = UIButton().then {
        $0.setTitle("Do something", for: .normal)
        $0.backgroundColor = .green
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureHierarchy() {
        [userName, userNameTextField, userNameValidationLabel, password, passwordTextField, passwordValidationLabel, validationButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        userName.snp.makeConstraints {
            $0.leading.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        userNameTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(userName.snp.bottom).offset(5)
            $0.height.equalTo(30)
        }
        
        userNameValidationLabel.snp.makeConstraints {
            $0.top.equalTo(userNameTextField.snp.bottom).offset(5)
            $0.leading.equalTo(userNameTextField)
        }
        
        password.snp.makeConstraints {
            $0.top.equalTo(userNameValidationLabel.snp.bottom).offset(20)
            $0.leading.equalTo(userName)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(password.snp.bottom).offset(5)
            $0.height.equalTo(30)
        }
        
        passwordValidationLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(5)
            $0.leading.equalTo(passwordTextField)
        }
        
        validationButton.snp.makeConstraints {
            $0.top.equalTo(passwordValidationLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .white
        
        let validatedName = userNameTextField.rx.text.orEmpty
            .map { $0.count > 5 }
        
        let validatedPassword = passwordTextField.rx.text.orEmpty
            .map { $0.count > 5 }
        
        // 🚨 combineLatest
        let everythingValidated = Observable.combineLatest(validatedName, validatedPassword) { $0 && $1 }
        
        validationButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showAlert()
            }
            .disposed(by: disposebag)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "This is wonderful", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(ok)
        present(alert, animated: true)
    }
}

