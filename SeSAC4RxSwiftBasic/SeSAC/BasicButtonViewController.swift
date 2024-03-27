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

final class BasicButtonViewController: UIViewController {
    
    private let button = UIButton()
    private let label = UILabel()
    private let textField = UITextField()
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        textField // UI
            .rx
            .text // ControlProperty<String?>, textField.text와 다르다! 중간에 rx가 끼워져있어서 rx에서 쓰는 text는 또 다르다!
            .orEmpty // ControlProperty<String>, 옵셔널 값을 벗겨준다
            .map { $0.count > 4 } // Bool
//            .map { $0.count } // Int, 이렇게 나눌 수도 있음
//            .map { $0 > 4 } // Bool
        // 👆🏻 옵저버블이 되는거고
        // 👇🏻 어떻게 처리할래, stream
            .bind { value in
                self.button.backgroundColor = value ? .red : .blue
            }
            .disposed(by: bag) // subscribe 끝내는거

        // 버튼 클릭되는 액션을 RxSwift로!
        // Observable: 버튼 탭
        button // UIButton
            .rx // Reactive<UIButton>, Rx스럽게 래핑
            .tap // ControlEvent<Void>
            .subscribe { _ in  // 이벤트를 받기 위해선 구독을 해야한다
                self.label.text = "버튼이 클릭되었습니다"         // Observer: 레이블에 텍스트
            } // Rx의 대부분은 클로저 -> 생각보다 메모리 누수가 많이 생긴다 -> 추후에 잡아야 함!
            .disposed(by: bag) // 모든 Rx의 코드는 대부분 이걸로 마무리 된다?
        
        button.rx.tap.subscribe { _ in
            self.label.text = "버튼이 클릭되었습니다"
            self.present(BasicViewController(), animated: true)
        }
        .disposed(by: bag)
        
        button.rx.tap
            .bind { _ in
                self.label.text = "버튼이 클릭되었습니다"
            }
            .disposed(by: bag)
        
        //        button.rx.tap
        //            .bind(to: label.rx.text) // 다이렉트로 뷰 객체랑 연결해준다
        
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
