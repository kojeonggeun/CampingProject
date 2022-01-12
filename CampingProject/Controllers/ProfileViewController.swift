//
//  ProfileViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/28.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController, ReloadData {
  
    
    @IBOutlet weak var gearQuantity: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var follower: UILabel!
    @IBOutlet weak var following: UILabel!
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileIntro: UITextView!
    
    let userGearVM = UserGearViewModel.shared
    let viewModel = ProfileViewModel.shared
    let userVM: UserViewModel = UserViewModel.shared
    let apiManger = APIManager.shared
    let disposeBag = DisposeBag()
    
    var imageUrl: String = ""
    
    
    @IBAction func moveFollower(_ sender: Any) {
        
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "followerView") as! FollowerViewController
        
        for i in apiManger.followers{
            pushVC.followerData.append(FriendViewModel(searchFriend: Friend(id: i.id, friendId: i.friendId, name: i.name, profileUrl: i.profileUrl, email: i.email, status: i.status), friendType: "follower"))
        }
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    @IBAction func moveFollowing(_ sender: Any) {
        
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "followingView") as! FollowingViewController
        for i in apiManger.followings{
            pushVC.followingData.append(FriendViewModel(searchFriend: Friend(id: i.id, friendId: i.friendId, name: i.name, profileUrl: i.profileUrl, email: i.email, status: i.status), friendType: "following"))
        }
        self.navigationController?.pushViewController(pushVC, animated: true)
        
    }
    @IBAction func showProfileEdit(_ sender: Any) {
        let pushEditVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileEditViewController") as! ProfileEditViewController
        pushEditVC.image = imageUrl
        pushEditVC.delegate = self
        self.navigationController?.pushViewController(pushEditVC, animated: true)
        
    }
    //      09/29
//      TODO: 유저정보에서 프로필 이미지 가져와야 함 -> 따로 유저 정보 저장하는 뷰모델 필요할듯?
//      TODO: 프로필 수정 기능 구현 해야 함
//      TODO: 친구 추가, 요청 & 승인 기능 구현 해야 함


//  MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.layer.borderWidth = 5
        profileImage.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        profileImage.layer.backgroundColor = CGColor(red: 249, green: 228, blue: 200, alpha: 1)
        
        profileIntro.isEditable = false
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        Rx로 변경할것
        gearQuantity.text = "\(userGearVM.userGears.count)"

        self.userVM.loadFollowerRx()
            .subscribe(onNext: { follower in
                self.viewModel.followerObservable.onNext(follower.friends.count)
            }).disposed(by: self.disposeBag)
    }
    
    
    func loadData() {
        
        self.userVM.loadFollowingRx()
            .subscribe(onNext: { following in
                self.viewModel.followingObservable.onNext(following.friends.count)
            }).disposed(by: self.disposeBag)
        
        viewModel.totalFollower
            .map { "\($0)"}
            .observe(on: MainScheduler.instance)
            .bind(to:self.follower.rx.text)
            .disposed(by: self.disposeBag)

        viewModel.totalFollowing
            .map { "\($0)" }
            .observe(on: MainScheduler.instance)
            .bind(to:self.following.rx.text)
            .disposed(by: self.disposeBag)
        
        userVM.loadUserInfoRx()
            .subscribe (onNext: { userInfo in
                    if userInfo.user?.userImageUrl != "" {
                        self.imageUrl = userInfo.user!.userImageUrl
                    } else {
                        self.imageUrl = "https://doodleipsum.com/700/avatar-2?i"
                    }

                    let url = URL(string: self.imageUrl)
                    let data = try? Data(contentsOf: url!)
        //            TODO: 프로필 이미지 수정 좀 이상함
                    
                    let image = UIImage(data: data!)
                    self.profileImage.image = image

                    self.profileName.text = userInfo.user?.name
                    self.profileIntro.text = userInfo.user?.aboutMe
            }).disposed(by: disposeBag)
    }
}
