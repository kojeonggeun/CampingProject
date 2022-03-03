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

public protocol SearchResultInput {
    var searchText: PublishRelay<String> { get }
    var fetchMoreDatas: PublishRelay<Void> { get }
}

public protocol SearchResultOutput {
    var searchUsers: Observable<[SearchUser]> { get }
    var isLoadingSpinnerAvaliable: PublishRelay<Bool> { get }
}

public protocol SearchResultViewModelType {
    var inputs: SearchResultInput { get }
    var outputs: SearchResultOutput { get }
}

class SearchResultViewModel: SearchResultViewModelType, SearchResultInput, SearchResultOutput {
    let store = Store.shared
    let disposeBag = DisposeBag()

    var inputs: SearchResultInput { return self }
    var outputs: SearchResultOutput { return self }

    private let _searchUsers = BehaviorRelay<[SearchUser]>(value: [])

    var searchUsers: Observable<[SearchUser]> { return _searchUsers.asObservable() }
    var searchText: PublishRelay<String> = PublishRelay<String>()
    var fetchMoreDatas: PublishRelay<Void> = PublishRelay<Void>()
    var isLoadingSpinnerAvaliable: PublishRelay<Bool> = PublishRelay<Bool>()

    private var text = ""
    private var page = 0
    private var size = 10
    private var totalPage = 1
    private var isPaginationRequestStillResume = false

    init() {
        searchText
            .do { self.text = $0; self.refreshTriggered()}
            .subscribe(onNext: { _ in
                self.fetchData(page: self.page)
        })
        .disposed(by: self.disposeBag)

        fetchMoreDatas.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.fetchData(page: self.page)
        })
        .disposed(by: disposeBag)

    }

    func fetchData(page: Int) {
//      중복 호출 막기 위해
        if isPaginationRequestStillResume { return }

//      검색 된 데이터의 totalPage를 넘으면 호출 안되게
        if page > totalPage {
            isPaginationRequestStillResume = false
            isLoadingSpinnerAvaliable.accept(false)
            return
        }

        isPaginationRequestStillResume = true
        isLoadingSpinnerAvaliable.accept(true)

        if page <= 1 {
            isLoadingSpinnerAvaliable.accept(false)
        }

        self.store.searchUserRx(searchText: text, page: page)
            .subscribe(onNext: {[weak self] result in
                guard let self = self else { return }

                if !result.users.isEmpty || !self._searchUsers.value.isEmpty {
                    self.handleData(data: result)
                    self.isLoadingSpinnerAvaliable.accept(false)
                    self.isPaginationRequestStillResume = false
                } else {
                    self._searchUsers.accept([SearchUser.init(name: self.text)])
                }
            })
            .disposed(by: disposeBag)
    }
//    다음 page의 데이터를 가져와 합친 후 page 를 +1 해준다.
    func handleData(data: SearchResult ) {
//      가져오는 리스트의 size는 5로 고정
        totalPage = data.total / size

        let newData = data.users
        if page == 0 {
            self.totalPage = data.total
            self._searchUsers.accept(newData)
        } else {
            let oldDatas = self._searchUsers.value
            self._searchUsers.accept(oldDatas + newData)
        }
        page += 1
    }

    func refreshTriggered() {
        isPaginationRequestStillResume = false
        page = 0
        self._searchUsers.accept([])
    }
}
