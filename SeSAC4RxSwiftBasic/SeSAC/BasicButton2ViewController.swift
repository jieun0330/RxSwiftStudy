//
//  BasicButtonViewController.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 3/26/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class BasicButton2ViewController: UIViewController {
    
    private let button = UIButton()
    private let label = UILabel()
    private let textField = UITextField()
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    private func example() {
        // 1. subscribe: next, complete, error
        button.rx.tap
            .subscribe { [weak self] _ in
                guard let self else { return }
                
                DispatchQueue.main.async {
                    self.label.text = "클릭했어요"
                    self.textField.text = "클릭했어요"
                }
            }
            .disposed(by: bag)
        /*
         여기서 발생할 수 있는 문제 2가지!?
         1️⃣ self: 클로저 구문이기 때문에 self라는 녀석이 캡쳐가 될 수 있음
         -> 해결하기 위해서는 weak self를 쓰던가 할 수 있다
         2️⃣ self.background -> 메인스레드에서 코드를 작성하지 않으면 문제가 생겼었음 -> 탭 액션을 하는 과정안에 네트워크 통신이 있다면 UI관련은 main 스레드 안에 넣는게 좋다
         subscribe 안에 동작이 -> main인지 global인지 써주는게 좋다 ?
         */
        
        // 2. 1번 코드를 개선해보자
        // RX에서는 scheduler라는 것을 제공한다
        button.rx.tap
            .observe(on: MainScheduler.instance) // 이 친구를 만나게되면 무조건 main 스레드에서 동작하게끔 한다
            .subscribe { [weak self] _ in
                guard let self else { return }
                
                self.label.text = "클릭했어요"
                self.textField.text = "클릭했어요"
            }
            .disposed(by: bag)
        
        // 3. weak self를 대신하는 기능
        button.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(with: self,  // subscribe를 위에서 다시 한번 호출?, with를 갖고있는 녀석은
                       onNext: { owner, _ in // self가 해결이 되서 owner 자리로 들어온다
                self.label.text = "클릭했어요"
                self.textField.text = "클릭했어요"
            })
            .disposed(by: bag)
        
        // 4. subscribe -> bind로 바꾸면 앞에 있는 observe가 필요없진다
        // bind는 -> main thread에서 동작하는것이 보장되어있다 + next만
        button.rx.tap
            .bind(with: self,
                       onNext: { owner, _ in
                self.label.text = "클릭했어요"
                self.textField.text = "클릭했어요"
            })
            .disposed(by: bag)
        
        // 5. stream을 똑똑하게 바꾸는 법
        button.rx.tap
            .map { "클릭했어요" }
            .bind(to: label.rx.text, textField.rx.text)
            .disposed(by: bag)
        
        // quiz
        // label.rx.text에는 왜 subscribe가 안될까?
        // -> subject 개념
//        button.rx.tap.subscribe(<#T##observer: ObserverType##ObserverType#>)
//        
//        textField.rx.text.subscribe(<#T##observer: ObserverType##ObserverType#>)
//        
//        label.rx.text
    }
    
    private func configureView() {
        
        view.backgroundColor = .white
        
        [button, label, textField].forEach {
            view.addSubview($0)
        }
        
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(300)
        }
        
        label.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(100)
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
        
        button.backgroundColor = .lightGray
        button.setTitle("테스트 버튼", for: .normal)
        
        label.text = "테스트 레이블"
        label.textColor = .black
        
        textField.placeholder = "텍스트필드"
        textField.backgroundColor = .lightGray
    }
}
