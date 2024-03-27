//
//  ReviewBasicViewController.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 3/26/24.
//

import UIKit
import RxCocoa
import RxSwift

// just, from. repeatElement, take
final class ReviewBasicViewController: UIViewController {
    
    private var disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        testJust()
//        testFrom()
//        testRepeat()
        testInterval()
    }
    
    func testJust() {
        Observable.just([1,2,3,4,5])
            .subscribe { value in
                print(value)
            } onError: { _ in
                print("error")
            } onCompleted: {
                print("completed")
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: disposebag)
// disposeBag: disposable을 담는 가방인데 disposeBag 객체 자체가 deinit되는 순간 내부에 있는 dispose() 메서드를 호출하는데 별도의 작업을 하지 않아도 자신이 갖고있던 disposable 모두 dispose() 시켜버림
    }
    
    func testFrom() {
        Observable.from([1,2,3,4,5]) // from: 배열의 값을 방출
            .subscribe { value in
                print(value)
            } onError: { _ in
                print("error")
            } onCompleted: {
                print("completed")
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: disposebag)
    }
    
    func testRepeat() {
        Observable.repeatElement("cyndi") // 이렇게만 하면 미친듯이 반복되기 때문에
            .take(10)
            .subscribe { value in
                print(value)
            } onError: { _ in
                print("error")
            } onCompleted: {
                print("completed")
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: disposebag)
    }
    
    func testInterval() {
        // 이걸 다른 곳에도 쓰고싶다면
        let interval = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        let intervalValue = interval
            .subscribe(onNext: { value in
                print(value)
            }, onError: { _ in
                print("error")
            }, onCompleted: {
                print("completed")
            }, onDisposed: {
                print("disposed")
            })
//            .disposed(by: disposebag)
        // 무한으로 프린트되니까
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.disposebag = DisposeBag()
            intervalValue.dispose()
        }
    }
}

