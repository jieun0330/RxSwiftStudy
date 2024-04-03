//
//  SearchViewModel.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    var data = ["A", "B", "C", "AB", "D", "ABC", "BBB", "EC", "SA", "AAAB", "ED", "F", "G", "H"]
    
    lazy var items = BehaviorSubject(value: data)
    
    //searchBar.rx.text.orEmpty
    let inputQuery = PublishSubject<String>()
    
    private let disposeBag = DisposeBag()
    
    init() {
        inputQuery
        // 검색하고 1초 뒤
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
        // 동일한 검색어 호출 방지
            .distinctUntilChanged()
            .bind(with: self, onNext: { owner, value in
                
                let result = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
                
                owner.items.onNext(result)
                print(value)
                
            })
            .disposed(by: disposeBag)
    }
}
