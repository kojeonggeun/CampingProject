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
    var profileInfo: PublishSubject<UserInfo> { get }

    func reloadFollowing()
    func clearUserCount()
}

public protocol ProfileViewModelType {
    var inputs: ProfileInput { get }
    var outputs: ProfileOutput { get }

}

class ProfileViewModel: ProfileViewModelType, ProfileInput, ProfileOutput {

    let store = Store.shared
    let userVM = UserViewModel.shared
    let disposeBag = DisposeBag()
    static let shared = ProfileViewModel()

    var inputs: ProfileInput { return self }
    var outputs: ProfileOutput { return self }

    private var _follower = BehaviorRelay<Int>(value: 0)
    private var _following = BehaviorRelay<Int>(value: 0)
    private var _gear = BehaviorRelay<Int>(value: 0)

    var profileInfo = PublishSubject<UserInfo>()

    var followerCount: Observable<Int> { return self._follower.asObservable() }
    var followingCount: Observable<Int> { return self._following.asObservable() }
    var gearCount: Observable<Int> { return self._gear.asObservable() }

    func loadProfileInfo() {
        store.loadFollowerRx()
            .subscribe(onNext: {[weak self] follower in
                self?._follower.accept(follower.contents.count)
            })
            .disposed(by: disposeBag)

        store.loadFollowingRx()
            .subscribe(onNext: {[weak self] following in
                self?._following.accept(following.contents.count)
            })
            .disposed(by: disposeBag)

        UserViewModel().userObservable
            .subscribe(onNext: {[weak self] userInfo in
                self?.profileInfo.onNext(userInfo)
                self?._gear.accept(userInfo.gearCnt)
        })
        .disposed(by: disposeBag)
    }
    
    func reloadFollowing() {
        self.store.loadFollowingRx()
            .subscribe(onNext: {[weak self] following in
                self?._following.accept(following.contents.count)
        })
        .disposed(by: disposeBag)
    }

    func clearUserCount() {
        _follower.accept(0)
        _following.accept(0)
    }
}
