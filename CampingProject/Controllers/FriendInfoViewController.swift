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
    
    var friendInfo: UserInfo? = nil
    
//    MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(friendInfo)
        guard let info = friendInfo else { return }

        userName.text = info.user.name
        userFollower.text = "\(info.followerCnt)"
        userFollowing.text = "\(info.followingCnt)"
    }
}
