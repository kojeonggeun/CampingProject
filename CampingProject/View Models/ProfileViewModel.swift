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
    
    let store = Store.shared
    let disposeBag = DisposeBag()
    static let shared = ProfileViewModel()
    
    var follower = BehaviorRelay<Int>(value: 0)
    var following = BehaviorRelay<Int>(value: 0)
    

    lazy var totalFollower = follower.map {
        $0
    }
    
    lazy var totalFollowing = following.map {
        $0 
    }
    
    init() {
        store.loadFollowerRx()
            .subscribe(onNext: { follower in
                self.follower.accept(follower.friends.count)
            }).disposed(by: disposeBag)
        
        store.loadFollowingRx()
            .subscribe(onNext: { following in
                self.following.accept(following.friends.count)
            }).disposed(by: disposeBag)
  
    }
    
    func reloadFollowing(){
        self.store.loadFollowingRx()
            .subscribe(onNext: { following in
                self.following.accept(following.friends.count)
        }).disposed(by: disposeBag)
    }

    func clearUserCount(){
        follower
            .accept(0)
            
        following
            .accept(0)
    }
}
