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
    
    @IBOutlet weak var friendCollectionView: UICollectionView!
    
    var userInfo: UserInfo? = nil
    var apiManager = APIManager.shared
    var userVM = UserViewModel.shared
    var profileVM = ProfileViewModel.shared
    
    var friendGear: [MyGearRepresentable] = []
    
    let disposeBag = DisposeBag()
    
    
//    MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        friendCollectionView.register(UINib(nibName:String(describing: MyGearCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "myGearViewCell")
        
        guard let info = userInfo else { return }
        guard let userInfo = info.user else { return }
        guard let status = info.status else { return }
        
        if status == "FOLLOWING"{
            followButton.setTitle("팔로잉☑️", for: .normal)
            followButton.tintColor = .brown
        }
        
        self.title = userInfo.email
        userName.text = userInfo.name
        userFollower.text = "\(info.followerCnt)"
        userFollowing.text = "\(info.followingCnt)"
        userDesc.text = userInfo.phone
//               TODO: 친구장비 가져오는거 구현해야함
        apiManager.loadSearchUserGear(id: userInfo.id)
        

        
    }
    @IBAction func followBtn(_ sender: Any) {
        
        if userInfo?.status! == "FOLLOWING" {
            userVM.loadDeleteFollowergRx(id: userInfo!.user!.id)
                .subscribe(onNext: { result in
                    self.followButton.setTitle("팔로우", for: .normal)
                    self.followButton.tintColor = .blue
                    self.profileVM.reLoadFollowing()
                }).disposed(by: disposeBag)
        } else {
            apiManager.followRequst(id: userInfo!.user!.id, isPublic: userInfo!.user!.isPublic, completion: { data in
                self.followButton.setTitle("팔로잉☑️", for: .normal)
                self.followButton.tintColor = .brown
                self.profileVM.reLoadFollowing()
            })
        }
    }
    
   }

extension FriendInfoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myGearViewCell", for: indexPath) as? MyGearCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    
}
//
//extension FriendInfoViewController: UICollectionViewDelegate{
//    
//}
