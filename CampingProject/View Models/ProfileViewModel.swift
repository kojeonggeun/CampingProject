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
    
    private var follower = BehaviorRelay<Int>(value: 0)
    private var following = BehaviorRelay<Int>(value: 0)
    private var gear = BehaviorRelay<Int>(value: 0)
    
    var profileInfo = PublishSubject<UserInfo>()
    
    var followerCount:Observable<Int> { return self.follower.asObservable() }
    var followingCount:Observable<Int> { return self.following.asObservable() }
    var gearCount:Observable<Int> { return self.gear.asObservable() }
   
    func loadProfileInfo() {
        store.loadFollowerRx()
            .subscribe(onNext: {[weak self] follower in
                self?.follower.accept(follower.friends.count)
            }).disposed(by: disposeBag)
        
        store.loadFollowingRx()
            .subscribe(onNext: {[weak self] following in
                self?.following.accept(following.friends.count)
            }).disposed(by: disposeBag)
        
        UserViewModel().userObservable
            .subscribe(onNext:{[weak self] userInfo in
                self?.profileInfo.onNext(userInfo)
                self?.gear.accept(userInfo.gearCnt)
        }).disposed(by: disposeBag)
    }
    
    
    func reloadFollowing(){
        self.store.loadFollowingRx()
            .subscribe(onNext: {[weak self] following in
                self?.following.accept(following.friends.count)
        }).disposed(by: disposeBag)
    }

    func clearUserCount(){
        follower.accept(0)
        following.accept(0)
    }
    
  
    
}


