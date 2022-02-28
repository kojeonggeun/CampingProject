//
//  FriendViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/11/06.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

public protocol FriendInput {
    func loadFollwers()
    func loadFollwings()
}

public protocol FriendOutput {
    var follwers: Observable<Friends> { get }
    var follwings: Observable<Friends> { get }
}

public protocol FriendViewModelType {
    var inputs: FriendInput { get }
    var outputs: FriendOutput { get }
    
}


class FriendViewModel: FriendInput,FriendOutput, FriendViewModelType {
    let manager = APIManager.shared
    let store = Store.shared
    let disposeBag = DisposeBag()
    var inputs: FriendInput { return self }
    var outputs: FriendOutput { return self }
    
    private var _follwers: PublishRelay<Friends> = PublishRelay<Friends>()
    private var _follwings: PublishRelay<Friends> = PublishRelay<Friends>()
    
    var follwers: Observable<Friends>{ return self._follwers.asObservable()}
    var follwings: Observable<Friends>{ return self._follwings.asObservable()}
    
    func loadFollwers(){
        store.loadFollowerRx()
            .subscribe(onNext: { follwer in
                self._follwers.accept(follwer)
            })
            .disposed(by: disposeBag)
    }
    
    func loadFollwings() {
        store.loadFollowingRx()
            .subscribe(onNext: { follwing in
                self._follwings.accept(follwing)
            })
            .disposed(by: disposeBag)
    }
}
