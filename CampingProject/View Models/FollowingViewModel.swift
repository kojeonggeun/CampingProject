//
//  FollowingViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2022/03/02.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

public protocol FollowingInput {
    func loadFollowings()

    var fetchMoreDatas: PublishRelay<Void> { get }
    var searchText: PublishRelay<String> { get }
}

public protocol FollowingOutput {
    var followings: Observable<[Friend]> { get }
    var isLoadingSpinnerAvaliable: PublishRelay<Bool> { get }
}

public protocol FollowingViewModelType {
    var inputs: FollowingInput { get }
    var outputs: FollowingOutput { get }

}

class FollowingViewModel: FollowingInput, FollowingOutput, FollowingViewModelType {
    let store = Store.shared
    let disposeBag = DisposeBag()

    var inputs: FollowingInput { return self }
    var outputs: FollowingOutput { return self }

    private var _followings: BehaviorRelay<[Friend]> = BehaviorRelay<[Friend]>(value: [])

    var followings: Observable<[Friend]> { return self._followings.asObservable()}

    var fetchMoreDatas: PublishRelay<Void> = PublishRelay<Void>()
    var searchText: PublishRelay<String> = PublishRelay<String>()
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
            .disposed(by: disposeBag)

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

        self.store.loadFollowingRx(searchText: text, page: page)
            .subscribe(onNext: {[weak self] result in
                guard let self = self else { return }
                if !result.contents.isEmpty || !self._followings.value.isEmpty {
                    self.handleData(data: result)
                    self.isLoadingSpinnerAvaliable.accept(false)
                    self.isPaginationRequestStillResume = false
                } else if self.text != ""{
                    self._followings.accept([Friend.init(name: self.text)])
                }
            })
            .disposed(by: disposeBag)
    }
//    다음 page의 데이터를 가져와 합친 후 page 를 +1 해준다.
    func handleData(data: Friends ) {
//      가져오는 리스트의 size는 5로 고정

        totalPage = data.total / size

        let newData = data.contents

        if page == 0 {
            self.totalPage = data.total
            self._followings.accept(newData)
        } else {
            let oldDatas = self._followings.value
            self._followings.accept(oldDatas + newData)
        }
        page += 1
    }

    func loadFollowings() {
        store.loadFollowingRx()
            .subscribe(onNext: { following in
                self._followings.accept(following.contents)
            })
            .disposed(by: disposeBag)
    }

    func refreshTriggered() {
        isPaginationRequestStillResume = false
        page = 0
        self._followings.accept([])
    }
}
