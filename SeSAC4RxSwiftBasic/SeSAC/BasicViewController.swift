//
//  BasicViewController.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 3/26/24.
//

import UIKit
import RxSwift
import RxCocoa

final class BasicViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        //        testJust()
        //        testFrom()
        //        testRepeat()
        //        testOf()
        testInterval()
    }
    
    deinit { // 뷰컨 시점이 deinit될때 dispose가 알아서 될거임
        print(self)
    }
    
    private func testJust() {
        Observable.just([1, 2, 3, 4, 5]) // 가지고있는 요소를 한번에 내보내는 기능
            .subscribe { value in
                print(value)
            } onError: { error in
                print("error")
            } onCompleted: {
                print("Completed")
            } onDisposed: {
                print("Disposed")
            }
            .disposed(by: disposeBag) // 메모리 정리
    }
    
    private func testFrom() {
        Observable.from([1, 2, 3, 4, 5]) // 요소 안에 있는것을 하나씩 내보내는 기능 -> next 이벤트가 3번 전달됐다는 의미
            .subscribe { value in
                print(value)
            } onError: { error in
                print("error")
            } onCompleted: {
                print("Completed") // 메모리에서 사라져도 된다는걸 인지하고
            } onDisposed: {
                print("Disposed") // 메모리에서 싹다 이 코드가 내려갔다는 것을 의미한다 -> 유한 시퀀스
            }
            .disposed(by: disposeBag) // 메모리 정리
    }
    
    private func testRepeat() { // .repeatElement: 무한 시퀀스
        Observable.repeatElement("cyndi").take(10) // take: 10번만 반복해줄래?
            .subscribe { value in
                print(value)
            } onError: { error in
                print("error")
            } onCompleted: {
                print("Completed")
            } onDisposed: {
                print("Disposed")
            }
            .disposed(by: disposeBag)
    }
    
    private func testOf() {
        // 가변매개변수: 여러가지 배열이 들어갈 수 있음, 같은 타입이면 방출이 모두 가능?
        Observable.of([1,2,3], [1,1,1], [5,5,5]) // of: 여러개의 값을 방출하는데 1이 구독되면 다음 2, 3을 방출하고, [1,2,3]이면 다 방출한다
            .subscribe { value in
                print(value)
            } onError: { error in
                print("error")
            } onCompleted: {
                print("Completed")
            } onDisposed: {
                print("Disposed")
            }
            .disposed(by: disposeBag)
    }
    
    private func testInterval() {
        // 여기는 <Int> 왜 명시했나요? -> 그냥 다른데는 삭제했을 뿐~~~
        // 특정 간격 기준으로 Int를 방출하겠다
        let interval = Observable<Int>.interval(.seconds(1), // 시간 간격
                                 scheduler: MainScheduler.instance) // main, gloabl 스레드를 정함, 실무에서 잘 안씀, 이런거구나~ 정도로 알고있으면 됨
        let intervalValue = interval
        .subscribe { value in
            print("next", value)
        } onError: { _ in
            print("error")
        } onCompleted: {
            print("completed")
        } onDisposed: {
            print("disposed")
        }
//        .dispose() // 즉시 종료?
//        .disposed(by: disposeBag) // 영원히 종료되지 않는다
        
        let intervalValue2 = interval
        .subscribe { value in
            print("value2 next", value)
        } onError: { _ in
            print("error")
        } onCompleted: {
            print("completed")
        } onDisposed: {
            print("disposed")
        }
//        .disposed(by: disposeBag)
        
        // 5초 뒤에 메모리가 정리가 되면 좋겠다
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            
            self.disposeBag = DisposeBag() // 🎒에 모아서 한꺼번에 버리게끔 인스턴스를 새로 생성해준다
            
            // 일일이 필요한 시점이 되면 메모리가 정리 -> 하다보면 모든 구독을 해제해주는게 힘들 수 있다
//            intervalValue.dispose() // 구독에 대한 일정을 끊어버린다!?
//            intervalValue2.dispose()
        }
    }
}
