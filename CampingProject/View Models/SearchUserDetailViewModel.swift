//
//  SearchUserViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2022/01/14.
//

import Foundation
import RxSwift
import RxCocoa
public protocol SearchUserDetailInput{
    func loadSearchInfo(id: Int)
    
}
public protocol SearchUserDetailOutput{
    var searchGears: Observable<[CellData]> { get }
    var searchUser: Observable<UserInfo> { get }
    
}

public protocol SearchUserDetailViewModelType {
    var inputs: SearchUserDetailInput { get }
    var outputs: SearchUserDetailOutput { get }
    
}

class SearchUserDetailViewModel: SearchUserDetailViewModelType, SearchUserDetailInput, SearchUserDetailOutput {
    let store = Store.shared
    let userId: Int = APIManager.shared.userInfo!.user!.id
    let disposeBag = DisposeBag()
    
    private let _searchGears = PublishRelay<[CellData]>()
    private let _searchUser = PublishRelay<UserInfo>()
    
    var inputs: SearchUserDetailInput { return self }
    var outputs: SearchUserDetailOutput { return self }
    
    var searchGears: Observable<[CellData]>{
        return _searchGears.asObservable()
    }
    var searchUser: Observable<UserInfo>{
        return _searchUser.asObservable()
    }
    
    var searchGearObservable: Observable<[CellData]> {
        return searchGears.asObservable()
    }
    
    func loadSearchInfo(id: Int){
        print(id, userId)
        store.loadSearchUserGearRx(userId: id)
            .subscribe(onNext: { gears in
                self._searchGears.accept(gears)
            })
            .disposed(by: disposeBag)
        
        store.loadFriendInfoRx(userId: id)
            .subscribe(onNext: { user in
                self._searchUser.accept(user)
            })
            .disposed(by: disposeBag)
    }
        
}
