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

final class SignUpViewController: UIViewController {

    private let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    private let validationButton = UIButton()
    private let nextButton = PointButton(title: "다음")
    private let disposeBag = DisposeBag()
    
//    private let email = "a@a.com"
//    private let sampleEmail = Observable.just("a@a.com")
    private let buttonColor = Observable.just(UIColor.blue)
    private let sampleEmail = BehaviorSubject(value: "a@a.com") // subject는 이벤트를 받을 수도 있다
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        configureLayout()
        configure()
        
//        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PasswordViewController(), animated: true)
            }
            .disposed(by: disposeBag)

//        emailTextField.rx.text.orEmpty
//            .bind(with: self) { owner, value in
//                owner.emailTextField.text = value
//            }
//            .disposed(by: disposeBag)
        
        sampleEmail
            .bind(with: self) { owner, value in
                owner.emailTextField.text = value
            }
            .disposed(by: disposeBag)
        
        // sampleEmail -> 바로 TextField로 보내기
        sampleEmail
            .bind(to: emailTextField.rx.text)
            .disposed(by: disposeBag)
          
        validationButton.rx.tap
            .bind(with: self) { owner, _ in
//                owner.emailTextField.text = "b@b.com"
//                owner.sampleEmail.bind(to: "b@b.com")
                // = 로 값을 바꾸지 않는다
                owner.sampleEmail.onNext("b@b.com")
                // Observable은 이벤트를 보내기만 하지, 받을 순 없다 -> 그래서 subject 개념이 등장 -> 위에 BehaviorSubject
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
    

    func configure() {
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = UIColor.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
