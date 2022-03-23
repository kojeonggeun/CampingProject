//
//  SearchUserViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2022/01/14.
//

import Foundation
import RxSwift
import RxCocoa

public protocol SearchUserDetailInput {
    func loadSearchInfo(id: Int)
    var followButtonTouched: PublishRelay<Void> { get }
}
public protocol SearchUserDetailOutput {
    var searchGears: Observable<[CellData]> { get }
    var searchUser: Observable<UserInfo> { get }
    var isCheckable: Observable<Bool> { get }
    var isStatus: Observable<String> { get }
}
public protocol SearchUserDetailViewModelType {
    var inputs: SearchUserDetailInput { get }
    var outputs: SearchUserDetailOutput { get }
}

class SearchUserDetailViewModel: SearchUserDetailViewModelType, SearchUserDetailInput, SearchUserDetailOutput {
    let store = Store.shared
    let loginId: Int = APIManager.shared.userInfo!.user!.id
    let disposeBag = DisposeBag()

    var inputs: SearchUserDetailInput { return self }
    var outputs: SearchUserDetailOutput { return self }

    var userId: Int = 0
    
    private let _searchGears = PublishRelay<[CellData]>()
    private let _searchUser = PublishRelay<UserInfo>()
    private let _checkUserId = PublishRelay<Bool>()
    private let _checkStatus = PublishRelay<String>()
    
    var searchGears: Observable<[CellData]> {
        return _searchGears.asObservable()
    }
    var searchUser: Observable<UserInfo> {
        return _searchUser.asObservable()
    }
    var isCheckable: Observable<Bool> {
        return _checkUserId.asObservable()
    }
    var isStatus: Observable<String> {
        return _checkStatus.asObservable()
    }
    var followButtonTouched: PublishRelay<Void> = PublishRelay<Void>()

    init(){

        followButtonTouched.withLatestFrom(isStatus)
            .subscribe(onNext:{ [weak self] status in
                guard let self = self else { return }
    
                if status == "NONE" || status == "FOLLOWER"{
                    self.store.followRequstRx(id: self.userId).subscribe(onNext:{_ in
                        self._checkStatus.accept("FOLLOWING")
                        self.loadSearchInfo(id: self.userId)
                        
                    }).disposed(by: self.disposeBag)
                } else {
                    self.store.deleteFollowerRx(id: self.userId).subscribe(onNext:{_ in
                        self._checkStatus.accept("NONE")
                        self.loadSearchInfo(id: self.userId)
                    }).disposed(by: self.disposeBag)
                }
            })
            .disposed(by: disposeBag)
        
        
        
    }
    func loadSearchInfo(id: Int) {
        userId = id
        if id == loginId {
            _checkUserId.accept(true)
        }

        store.loadSearchUserGearRx(userId: id)
            .subscribe(onNext: { gears in
                self._searchGears.accept(gears)
            })
            .disposed(by: disposeBag)

        store.loadFriendInfoRx(userId: id)
            .subscribe(onNext: { user in
                self._searchUser.accept(user)
                self._checkStatus.accept(user.status!)
            })
            .disposed(by: disposeBag)
        
        
    }
}
