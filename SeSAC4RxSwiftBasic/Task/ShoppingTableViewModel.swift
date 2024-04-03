//
//  ShoppingTableViewModel.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 4/4/24.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingTableViewModel {
    
    var items: [Item] = [Item(item: "그립톡 구매하기"),
                                 Item(item: "사이다 구매"),
                                 Item(item: "아이패드 케이스 최저가 알아보기"),
                                 Item(item: "양말")]
    
    lazy var data = BehaviorSubject(value: items)
    
    let textField = PublishSubject<String>()
    
    private let disposeBag = DisposeBag()
    
    init() {
        textField
        //            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                
                let result = value.isEmpty ? owner.items : owner.items.filter { $0.item.contains(value) }
                owner.data.onNext(result)
            }
            .disposed(by: disposeBag)
    }
}
