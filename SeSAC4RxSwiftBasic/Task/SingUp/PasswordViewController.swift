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

final class PasswordViewController: UIViewController {
   
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    private let descriptionLabel = UILabel()
    private let validText = Observable.just("8자 이상 입력해주세요")
    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        configureLayout()
        bind()
         
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(PhoneViewController(), animated: true)
    }
    
    func configureLayout() {
        [passwordTextField, descriptionLabel, nextButton].forEach {
            view.addSubview($0)
        }
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func bind() {
        
        validText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposebag)
        
        let validatePassword = passwordTextField.rx.text.orEmpty
            .map { $0.count >= 8 }
        
        validatePassword
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemPink : .lightGray
                owner.nextButton.backgroundColor = color
            }
            .disposed(by: disposebag)
        
        validatePassword
            .bind(to: descriptionLabel.rx.isHidden, nextButton.rx.isEnabled)
            .disposed(by: disposebag)
    }
}
