//
//  FriendInfoViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/12/18.
//

import Foundation
import UIKit

class FriendInfoViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userFollower: UILabel!
    @IBOutlet weak var userFollowing: UILabel!
    @IBOutlet weak var userGear: UILabel!
    @IBOutlet weak var userDesc: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var friendInfo: UserInfo? = nil
    
//    MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""

        guard let info = friendInfo else { return }
        guard let status = info.status else { return }
        
        if status == "FOLLOWING"{
            followButton.setTitle("팔로잉☑️", for: .normal)
            followButton.tintColor = .brown
        }
        self.title = info.user.email
        userName.text = info.user.name
        userFollower.text = "\(info.followerCnt)"
        userFollowing.text = "\(info.followingCnt)"
        userDesc.text = info.user.phone
    }
}
