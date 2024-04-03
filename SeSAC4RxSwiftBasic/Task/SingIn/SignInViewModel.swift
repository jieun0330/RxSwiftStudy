//
//  SignInViewModel.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

class SignInViewModel {
    let emailDescription = BehaviorRelay(value: "올바른 이메일 형식이 아닙니다")
    let passwordDescription = BehaviorRelay(value: "8자 이상 입력해주세요")
    
    let inputEmailTextField = BehaviorRelay(value: "")
    let inputPasswordTextField = BehaviorRelay(value: "")
    
    let outputEmailValidated: Observable<Bool>
    let outputPasswordValidated: Observable<Bool>
    let everythingValidated: Observable<Bool>
    
    init() {
        outputEmailValidated = inputEmailTextField.map { $0.contains("@") }
        outputPasswordValidated = inputPasswordTextField.map { $0.count >= 8 }
        everythingValidated = Observable.combineLatest(outputEmailValidated, outputPasswordValidated).map { $0 && $1 }
    }
}
