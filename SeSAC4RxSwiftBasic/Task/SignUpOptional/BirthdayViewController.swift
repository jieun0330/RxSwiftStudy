//
//  BirthdayViewController.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 3/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
//        label.text = "2023년"
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
        let label = UILabel()
//        label.text = "33월"
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
//        label.text = "99일"
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let nextButton = PointButton(title: "가입하기")
    
    // Observable 만들기 -> Observer -> subject
    // BehaviorSubject: 초기화면에서 값을 보여줄 때 많이 쓴다
    private let year = PublishSubject<Int>() // BehaviorSubject(value: 2024) //Observable.just(2024)
    private let month = PublishSubject<Int>() //BehaviorSubject(value: 3) //Observable.just(3)
    private let day = PublishSubject<Int>() //어떤 타입을 작성할지 써주고 (비어있는)인스턴스 생성? //BehaviorSubject(value: 29) //Observable.just(29)
    
    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()
//        test()
//        test2()
    }
    
    private func test2() {
        let publish = BehaviorSubject(value: 100) // BehaviorSubject는 초기값이 있음
        // 구독 전에는 이벤트를 못받는데 초기값이 왜 있을까요?
        
        // 구독 전에는 이벤트를 못 받음 -> 초기값이 없다
//        publish.onNext(1)
//        publish.onNext(2) // 구독 전인에 2 왜 나옴? -> 구독하기 직전 값을 전달해줌 -> Behavior의 특성 -> 강의자료에 있음
        
        publish.subscribe { value in
            print(value)
        } onError: { _ in
            print("error")
        } onCompleted: {
            print("completed")
        } onDisposed: {
            print("disposed")
        }
        .disposed(by: disposebag)
        
        // 구독 해제 후
        publish.onNext(3)
        publish.onNext(4)
        
        publish.onCompleted()
        
        publish.onNext(5)
        publish.onNext(6)
        
    }
    
    private func test() {
        let publish = PublishSubject<Int>()
        
        // 구독 전에는 이벤트를 못 받음 -> 초기값이 없다
        publish.onNext(1)
        publish.onNext(2)
        
        publish.subscribe { value in
            print(value)
        } onError: { _ in
            print("error")
        } onCompleted: {
            print("completed")
        } onDisposed: {
            print("disposed")
        }
        .disposed(by: disposebag)
        
        // 구독 해제 후
        publish.onNext(3)
        publish.onNext(4)
        
        publish.onCompleted()
        
        publish.onNext(5)
        publish.onNext(6)
        
    }

    private func bind() {
        
        year
            .observe(on: MainScheduler.instance) // 🚨 main에서 동작하니까 이걸 쓰는건가 ?
            .subscribe(with: self, onNext: { owner, value in
                owner.yearLabel.text = "\(value)년"
            })
        //            .subscribe { value in  // on: 매개변수를 생략한 메서드
        //                self.yearLabel.text = "\(value)년"
        //            }
            .disposed(by: disposebag)
        
        month
            .map { "\($0)월" } // 애초에 Int -> String으로 바꾸는 작업 // UI에서 작업하는게 아니니까 main이 아닌 background에서 작업하는거여도 상관없다
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, value in
                owner.monthLabel.text = value
            })
            .disposed(by: disposebag)
        
        day
            .map { "\($0)일" }
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposebag)
        
        // 🚨Observable이면 namespace가 붙는다?
        birthDayPicker.rx.date // 버튼 탭 액션같은거라면 보여지는게 선택적인데 datepicker는 선택하지 않아도 보여질 확률이 100%
            .bind(with: self) { owner, date in
                
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                
                // Observable
                //                print(component.day, component.month, component.year)
                owner.year.onNext(component.year!)
                owner.month.on(.next(component.month!))
                owner.day.onNext(component.day!)
            }
            .disposed(by: disposebag)
    }
    
    @objc func nextButtonClicked() {
        print("가입완료")
    }
    
    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
}
