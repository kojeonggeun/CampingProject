//
//  ProfileViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/12/28.
//

import Foundation
import RxSwift
import RxCocoa

public protocol ProfileInput {
    func loadProfileInfo()
}

public protocol ProfileOutput {
    var followerCount: Observable<Int> { get }
    var followingCount: Observable<Int> { get }
    var gearCount: Observable<Int> { get }
    var profile: Observable<UserInfo> { get }
}

public protocol ProfileViewModelType {
    var inputs: ProfileInput { get }
    var outputs: ProfileOutput { get }

}

class ProfileViewModel: ProfileViewModelType, ProfileInput, ProfileOutput {

    let store = Store.shared
    let disposeBag = DisposeBag()
    let apiManager = APIManager.shared


    var inputs: ProfileInput { return self }
    var outputs: ProfileOutput { return self }

    private var _follower = PublishRelay<Int>()
    private var _following = PublishRelay<Int>()
    private var _gear = PublishRelay<Int>()
    private var _profile = PublishRelay<UserInfo>()


    var followerCount: Observable<Int> { return self._follower.asObservable() }
    var followingCount: Observable<Int> { return self._following.asObservable() }
    var gearCount: Observable<Int> { return self._gear.asObservable() }
    var profile: Observable<UserInfo> { return self._profile.asObservable() }
    
    func loadProfileInfo() {
        
        store.loadFollowerRx()
            .subscribe(onNext: {[weak self] follower in
                self?._follower.accept(follower.total)
            }).disposed(by: disposeBag)

        store.loadFollowingRx()
            .subscribe(onNext: {[weak self] following in
                self?._following.accept(following.total)
            }).disposed(by: disposeBag)
        
        store.loadUserInfoRx()
            .subscribe(onNext: {[weak self] userInfo in
                self?._profile.accept(userInfo)
                self?._gear.accept(userInfo.gearCnt)
            }).disposed(by: disposeBag)
    }
}
