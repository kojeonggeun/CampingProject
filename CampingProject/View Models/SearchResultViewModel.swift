
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
    var fetchMoreDatas: PublishRelay<Void> { get }
    
}
public protocol SearchResultOutput{
    var searchUsers: BehaviorRelay<[SearchUser]> { get }
    var isLoadingSpinnerAvaliable: PublishRelay<Bool> { get }
    var isEmptySearchData: PublishRelay<Bool> { get }
}

public protocol SearchResultViewModelType {
    var inputs: SearchResultInput { get }
    var outputs: SearchResultOutput { get }
    
}

class SearchResultViewModel: SearchResultViewModelType,SearchResultInput,SearchResultOutput  {
    let store = Store.shared
    let disposeBag = DisposeBag()
    
    var inputs: SearchResultInput { return self }
    var outputs: SearchResultOutput { return self }
    
    var searchText: PublishRelay<String> = PublishRelay<String>()
    var searchUsers: BehaviorRelay<[SearchUser]> = BehaviorRelay<[SearchUser]>(value: [])
    var fetchMoreDatas: PublishRelay<Void> = PublishRelay<Void>()
    var refreshCompelted: PublishRelay<Void> = PublishRelay<Void>()
    var isLoadingSpinnerAvaliable: PublishRelay<Bool> = PublishRelay<Bool>()
    var isEmptySearchData: PublishRelay<Bool> = PublishRelay<Bool>()
    
    private var text = ""
    private var page = 0
    private var size = 5
    private var totalPage = 1
    private var isPaginationRequestStillResume = false
    
    
    init(){
        searchText
            .do{ self.text = $0 ;self.refreshTriggered()}
            .subscribe(onNext:{ input in
                switch input{
                case "":
                    self.isEmptySearchData.accept(true)
                default:
                    self.fetchData(page:self.page)
                }
        })
        .disposed(by: self.disposeBag)
        
        fetchMoreDatas.subscribe(onNext:{[weak self] _ in
            guard let self = self else { return }
            self.fetchData(page: self.page)
        })
        .disposed(by: disposeBag)
    
        
    }
    
    func fetchData(page: Int){
        if isPaginationRequestStillResume  { return }
        
//      검색 된 데이터의 totalPage를 넘으면 호출 안되게
        if page > totalPage  {
            isPaginationRequestStillResume = false
            isLoadingSpinnerAvaliable.accept(false)
            return
        }
    
        isPaginationRequestStillResume = true
        isLoadingSpinnerAvaliable.accept(true)
        
        if page <= 1 {
            isLoadingSpinnerAvaliable.accept(false)
        }
        
        self.store.searchUserRx(searchText: text,page: page)
            .subscribe(onNext:{[weak self] result in
            if !result.users.isEmpty {
                self?.isEmptySearchData.accept(false)
                self?.handleData(data: result)
                self?.isLoadingSpinnerAvaliable.accept(false)
                self?.isPaginationRequestStillResume = false
            } else {
                self?.isEmptySearchData.accept(true)
            }
            
        })
        .disposed(by: disposeBag)
        
        
    }
//    다음 page의 데이터를 가져와 합친 후 page 를 +1 해준다.
    func handleData(data: SearchResult ) {
//        리스트의 size는 5로 고정
        totalPage = data.total / size

        let newData = data.users
        if page == 0 {
            self.totalPage = data.total
            self.searchUsers.accept(newData)
        }
        else {
            let oldDatas = self.searchUsers.value
            self.searchUsers.accept(oldDatas + newData)
        }
        page += 1
    }
    
    func refreshTriggered() {
        isPaginationRequestStillResume = false
        page = 0
        self.searchUsers.accept([])
        
    }
    
}
