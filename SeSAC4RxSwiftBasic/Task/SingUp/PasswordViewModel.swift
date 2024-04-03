//
//  PasswordViewModel.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

class PasswordViewModel {
    let validText = BehaviorRelay(value: "8자 이상 입력해주세요")
    let passwordTextField = BehaviorRelay(value: "")
    let validatePassword: Observable<Bool>
    
    init() {
        validatePassword = passwordTextField.map { $0.count >= 8 }
    }
}
