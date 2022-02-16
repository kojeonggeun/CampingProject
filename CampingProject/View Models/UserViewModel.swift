//
//  UserViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2022/02/05.
//

import Foundation
import RxSwift
import RxCocoa

class UserViewModel {
    
    static let shared = UserViewModel()
    let store = Store.shared
    let apiManager = APIManager.shared
    let disposeBag = DisposeBag()

    private let user = PublishRelay<UserInfo>()
    
    var userObservable: Observable<UserInfo> {
        return user.asObservable()
    }

    init(){
        loadUser()
        
    }
    func loadUser(){
        store.loadUserInfoRx()
            .subscribe(onNext: { user in
                self.user.accept(user)
            }).disposed(by: disposeBag)
    }
    
}
