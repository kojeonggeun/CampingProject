//
//  SearchResultViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/11/03.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

public protocol SearchResultInput{
    var searchText: PublishRelay<String> { get }
    var page: PublishRelay<Int> { get }
}
public protocol SearchResultOutput{
    var searchUser: PublishRelay<SearchResult> { get }
    var loadUser: PublishRelay<SearchResult> { get }
}

public protocol SearchResultViewModelType {
    var inputs: SearchResultInput { get }
    var outputs: SearchResultOutput { get }
    
}

class SearchResultViewModel: SearchResultViewModelType,SearchResultInput,SearchResultOutput  {
    let apiManager = APIManager.shared
    let store = Store.shared
    let userGearVM = UserGearViewModel.shared
    let disposeBag = DisposeBag()
    var inputs: SearchResultInput { return self }
    var outputs: SearchResultOutput { return self }
    
    var searchText: PublishRelay<String> = PublishRelay<String>()
    var searchUser: PublishRelay<SearchResult> = PublishRelay<SearchResult>()
    var loadUser: PublishRelay<SearchResult> = PublishRelay<SearchResult>()
    var page: PublishRelay<Int> = PublishRelay<Int>()
    init(){

        searchText
            .map{ text in self.store.searchUserRx(searchText: text)}
            .flatMap{ $0 }
            .subscribe(onNext:{ result in
                self.searchUser.accept(result)
            }).disposed(by: self.disposeBag)
        
        
        let asd = Observable.combineLatest(page, searchText)
        
        asd.subscribe(onNext: { result in
            self.store.searchUserRx(searchText: result.1,page: result.0).subscribe(onNext: { data in
                self.searchUser.accept(data)
            })
        })
        
    }
    
    
}
