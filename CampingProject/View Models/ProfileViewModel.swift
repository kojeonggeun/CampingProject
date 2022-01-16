//
//  ProfileViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/12/28.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel {
    
    let userVM = UserViewModel.shared
    let disposeBag = DisposeBag()
    static let shared = ProfileViewModel()
    
    var followerObservable = BehaviorSubject<Int>(value: 0)
    var followingObservable = BehaviorSubject<Int>(value: 0)
    

    lazy var totalFollower = followerObservable.map {
        $0
    }
    
    lazy var totalFollowing = followingObservable.map {
        $0 
    }
    
    init() {
        userVM.loadFollowerRx()
            .subscribe(onNext: { follower in
                self.followerObservable.onNext(follower.friends.count)
            }).disposed(by: disposeBag)
        
        userVM.loadFollowingRx()
            .subscribe(onNext: { following in
                self.followingObservable.onNext(following.friends.count)
            }).disposed(by: disposeBag)
  
    }
    
    func reloadFollowing(){
        self.userVM.loadFollowingRx()
            .subscribe(onNext: { following in
                print(following.friends.count)
                self.followingObservable.onNext(following.friends.count)
        }).disposed(by: disposeBag)
    }

    func clearUserCount(){
        followerObservable
            .onNext(0)
            
        followingObservable
            .onNext(0)
    }
}
