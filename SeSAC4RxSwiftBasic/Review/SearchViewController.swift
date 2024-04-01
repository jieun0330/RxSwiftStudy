//
//  SearchViewController.swift
//  SeSAC4RxSwiftBasic
//
//  Created by 박지은 on 4/1/24.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
   
    private let tableView: UITableView = {
       let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 180
        view.separatorStyle = .none
       return view
     }()
    
    let searchBar = UISearchBar()
      
    var data = ["A", "B", "C", "AB", "D", "ABC", "BBB", "EC", "SA", "AAAB", "ED", "F", "G", "H"]
    private lazy var items = BehaviorSubject(value: data)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        setSearchController()
        bind()
    }
     
    private func setSearchController() {
        view.addSubview(searchBar)
//        navigationItem.titleView = searchBar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonClicked))
    }
    
    @objc func plusButtonClicked() {
        let sample = ["A", "B", "C", "D", "E"]
        data.append(sample.randomElement()!) // sample을 데이터에 추가하고
        items.onNext(data) // data를 방출하면 되는거니까
        
//        items.onNext(sample) // items에 sample 데이터를 방출한다 -> 덮어씌움
        
    }

    
    private func configure() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(searchBar.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        
        items
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { row, element, cell in
                cell.appNameLabel.text = element
                cell.downloadButton.rx.tap
                    .bind(with: self) { owner, value in
                        print(value)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(with: self, onNext: { owner, indexPath in
                owner.data.remove(at: indexPath.row)
                owner.items.onNext(owner.data)
            })
            .disposed(by: disposeBag)
        
        // 검색했을때 해당되는거 나오게 하기
        searchBar.rx.text.orEmpty
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
        
        // 검색 버튼 눌렀을 때
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .distinctUntilChanged()
            .bind(with: self, onNext: { owner, value in
                
                let result = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
                
                owner.items.onNext(result)
                print(value)
                
            })
            .disposed(by: disposeBag)
    }
}
