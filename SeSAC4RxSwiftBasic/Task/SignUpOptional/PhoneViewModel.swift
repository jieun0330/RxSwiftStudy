//
//  PhoneViewModel.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 4/3/24.
//

import Foundation
import RxCocoa
import RxSwift

class PhoneViewModel {
    let phoneTextFieldLabel = BehaviorRelay(value: "010")
    let phoneDescriptionLabel = BehaviorRelay(value: "10자 이상 입력해주세요")
}
