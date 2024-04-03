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

final class BirthdayViewController: BaseViewController {
    
    private let viewModel = BirthdayViewModel()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    private let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    private lazy var nextButton: UIButton = {
        let button = PointButton(title: "가입하기")
        button.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let year = PublishSubject<String>()
    private let month = PublishSubject<String>()
    private let day = PublishSubject<String>()
    
    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    @objc private func nextButtonClicked() {
        let vc = SampleViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    override func configureHierarchy() {
        [infoLabel, containerStackView, birthDayPicker, nextButton].forEach {
            view.addSubview($0)
        }
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
    }
    
    override func configureConstraints() {
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
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
    
    override func configureView() {
        view.backgroundColor = .white
    }
    
    private func bind() {
        viewModel.year
        // driver로 변환하고싶을 때 asDriver 메서드를 사용한다
            .asDriver()
            .map { "\($0)년" }
            .drive(yearLabel.rx.text)
            .disposed(by: disposebag)
        
        let adultYear = viewModel.year.map { Int($0)! <= 2017 }
        
        adultYear
            .bind(with: self) { owner, value in
                let validTextColor: UIColor = value ? .systemBlue : .systemRed
                owner.infoLabel.textColor = validTextColor
                let validText: String = value ? "가입 가능한 나이입니다" : "만 17세 이상만 가입 가능합니다."
                owner.infoLabel.text = validText
                let validButtonColor: UIColor = value ? .systemBlue : .lightGray
                owner.nextButton.backgroundColor = validButtonColor
            }
            .disposed(by: disposebag)
        
        adultYear
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposebag)
        
        viewModel.month
            .asDriver()
            .map { "\($0)월" }
            .drive(monthLabel.rx.text)
            .disposed(by: disposebag)
        
        viewModel.day
            .asDriver()
            .map { "\($0)일" }
            .drive(dayLabel.rx.text)
            .disposed(by: disposebag)
        
        birthDayPicker.rx.date
            .bind(to: viewModel.todayDate)
            .disposed(by: disposebag)
    }
}
