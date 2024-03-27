//
//  ReviewButtonViewController.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 3/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

final class ReviewButtonViewController: BaseViewController {
    
    private let label = UILabel().then {
        $0.text = "테스트"
        $0.textColor = .black
    }
    
    private let textField = UITextField().then {
        $0.backgroundColor = .lightGray
        $0.placeholder = "텍스트필드"
    }
    
    private let button = UIButton().then {
        $0.setTitle("테스트 버튼", for: .normal)
        $0.backgroundColor = .blue
    }
    
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureHierarchy() {
        [label, textField, button].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        label.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.height.equalTo(50)
        }
    }
    
    // 텍스트필드 글자 4글자 이상이면 백그라운드 색상 바꿔주기
    override func configureView() {
        view.backgroundColor = .white
        
        // 1. subscribe, dispatchqueue (코드 내부에 네트워크 통신 코드가 함께 있을 경우?)
//        button.rx.tap
//            .subscribe { _ in
//                // UI를 그리는 건 -> main thread가 하는 동작이니까 dispatchQueue로 따로 빼준다
//                DispatchQueue.main.async {
//                    self.label.text = "버튼이 클릭되었습니다"
//                }
//            }
//            .disposed(by: bag)
        
        // 2. mainScheduler
//        button.rx.tap
//            .observe(on: MainScheduler.instance) // MainScheduler = DispatchQueue.main
//            .subscribe { [weak self] _ in
//                guard let self else { return }
//                self.label.text = "버튼이 클릭되었습니다"
//            }
//            .disposed(by: bag)
        
        // 3. weak self 대신
        button.rx.tap
            .observe(on: MainScheduler.instance)
//            .subscribe(with: <#T##Object#>, onNext: <#T##((Object, Void) -> Void)?##((Object, Void) -> Void)?##(Object, Void) -> Void#>)
            .subscribe(with: self) { owner, _ in
                owner.label.text = "버튼이 클릭되었습니다"
//                self.label.text = "버튼이 클릭되었습니다"
            }
            .disposed(by: bag)
        
        // 4. subscribe 대신
        // subscribe 대신 bind를 작성하면 main thread에서 작동하는 것이 보장
        button.rx.tap
            .bind(with: self) { owner, _ in
                owner.label.text = "버튼이 클릭되었습니다"
            }
            .disposed(by: bag)
        
        // 5. map
        button.rx.tap
            .map { "클릭했어요" }
            .bind(to: label.rx.text) // to Observer
            .disposed(by: bag)
        
//        button.rx.tap.bind { _ in
//            self.label.text = "버튼이 클릭되었습니다"
//        }
//        .disposed(by: bag) // bind는 클릭한 액션 후 completed도 error도 없는건데, label이 버튼이 클릭되었습니다 로 바뀌려면 bind가 아닌 subscribe로 바꾸는게 맞겠다
        // 라고 생각했지만 버튼 누르는 액션은 오류날 일이 없으니 bind로 써도 됩니다
        
//        button.rx.tap.subscribe { _ in
//            self.label.text = "버튼이 클릭되었습니다"
//        } onError: { _ in
//            print("error")
//        } onCompleted: {
//            print("completed")
//        } onDisposed: {
//            print("disposed")
//        }
//        .disposed(by: bag)
        
        

        // 텍스트필드도 글자 입력하는 액션이 오류날일 없으니 bind ?
        textField.rx.text.orEmpty // orEmpty: 옵셔널 바인딩
            .map{ $0.count > 4 }
            .bind { value in
                self.button.backgroundColor = value ? .red : .blue
            }
            .disposed(by: bag)
    }
}
