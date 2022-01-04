//
//  FriendInfoViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/12/18.
//

import Foundation
import UIKit
import RxSwift

class FriendInfoViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userFollower: UILabel!
    @IBOutlet weak var userFollowing: UILabel!
    @IBOutlet weak var userGear: UILabel!
    @IBOutlet weak var userDesc: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    
    
    var userInfo: UserInfo? = nil
    var apiManager = APIManager.shared
    var userVM = UserViewModel.shared
    var profileVM = ProfileViewModel.shared
    let disposeBag = DisposeBag()
    
    
//    MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""

        guard let info = userInfo else { return }
        guard let status = info.status else { return }
        
        if status == "FOLLOWING"{
            followButton.setTitle("팔로잉☑️", for: .normal)
            followButton.tintColor = .brown
        }
        
        self.title = info.user?.email
        userName.text = info.user?.name
        userFollower.text = "\(info.followerCnt)"
        userFollowing.text = "\(info.followingCnt)"
        userDesc.text = info.user?.phone
        
        apiManager.loadSearchUserGear(id: info.user!.id)
        

        
    }
    

    @IBAction func followBtn(_ sender: Any) {
        if userInfo?.status! == "FOLLOWING" {
            userVM.loadDeleteFollowergRx(id: userInfo!.user!.id)
                .subscribe(onNext: { result in
                    self.followButton.setTitle("팔로우", for: .normal)
                    self.followButton.tintColor = .blue
                    self.profileVM.loadFollowing()
                })
        } else {
            apiManager.followRequst(id: userInfo!.user!.id, isPublic: userInfo!.user!.isPublic, completion: { data in
                self.followButton.setTitle("팔로잉☑️", for: .normal)
                self.followButton.tintColor = .brown
                self.profileVM.loadFollowing()
            })
        }
    }
    
    }



