//
//  BirthdayViewModel.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

class BirthdayViewModel {
    
    // Subject는 Observerble + Observer의 역할 모두를 할 수 있는건데
    // year, month, day는 지금 뷰컨에서 label에 보여지는 녀석이라 UI 담당만 하고있어
    // 그래서 Subject에서 -> Relay로 변경이 가능해
    let year = BehaviorRelay<String>(value: "0")
    let month = BehaviorRelay<String>(value: "0")
    let day = BehaviorRelay<String>(value: "0")
    let todayDate: BehaviorSubject<Date> = BehaviorSubject(value: .now)
    
    private let disposeBag = DisposeBag()
    
    init() {
        todayDate
            .bind(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                // picker에 있는 날짜를 -> owner.year
                // owner.year가 publishSubject라서
                // bind 작업 필요없이 바로 onNext ?
                guard let year = component.year else { return }
                guard let month = component.month else { return }
                guard let day = component.day else { return }
                owner.year.accept("\(year)")
                owner.month.accept("\(month)")
                owner.day.accept("\(day)")
            }
            .disposed(by: disposeBag)
    }
}
