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

final class PhoneViewController: BaseViewController {
    
    private let viewModel = PhoneViewModel()
    
    private let phoneTextField: UITextField = {
        let textField = SignTextField(placeholderText: "휴대폰번호를 입력해주세요")
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let phoneDesicription = UILabel()
    
    private lazy var nextButton: UIButton = {
        let button = PointButton(title: "다음")
        button.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func configureHierarchy() {
        [phoneTextField, phoneDesicription, nextButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        phoneTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        phoneDesicription.snp.makeConstraints {
            $0.top.equalTo(phoneTextField.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(phoneTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .white
    }
    
    @objc private func nextButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }
    
    private func bind() {
        viewModel.phoneTextFieldLabel
            .asDriver()
            .drive(phoneTextField.rx.text)
            .disposed(by: disposebag)
        
        viewModel.phoneDescriptionLabel
            .asDriver()
            .drive(phoneDesicription.rx.text)
            .disposed(by: disposebag)
        
        phoneTextField.rx.text.orEmpty
            .bind(to: viewModel.phoneTextField)
            .disposed(by: disposebag)
        
        viewModel.validatePhoneNum
            .bind(to: phoneDesicription.rx.isHidden, nextButton.rx.isEnabled)
            .disposed(by: disposebag)
        
        viewModel.validatePhoneNum
            .map { $0 ? UIColor.systemPink : UIColor.lightGray }
            .bind(to: nextButton.rx.backgroundColor)
            .disposed(by: disposebag)
    }
}
