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
    let userGearVM = UserGearViewModel.shared
    let viewModel = ProfileViewModel()
    let store: Store = Store.shared
    let apiManger = APIManager.shared
    let disposeBag = DisposeBag()
    
    var imageUrl: String = ""
    
//  MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.layer.borderWidth = 5
        profileImage.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        profileImage.layer.backgroundColor = CGColor(red: 249, green: 228, blue: 200, alpha: 1)

        profileIntro.isEditable = false
        
        setBind()
    }

    func setBind() {
        viewModel.inputs.loadProfileInfo()
        
        viewModel.outputs.followerCount
            .map { "\($0)"}
            .asDriver(onErrorJustReturn: "0")
            .drive(self.follower.rx.text)
            .disposed(by: self.disposeBag)

        viewModel.outputs.followingCount
            .map { "\($0)" }
            .asDriver(onErrorJustReturn: "0")
            .drive(self.following.rx.text)
            .disposed(by: self.disposeBag)

        viewModel.outputs.gearCount
            .map { "\($0)" }
            .asDriver(onErrorJustReturn: "0")
            .drive(self.gearQuantity.rx.text)
            .disposed(by: self.disposeBag)

        
        viewModel.outputs.profileInfo
            .subscribe(onNext: { userInfo in
                if userInfo.user?.userImageUrl != "" {
                    self.imageUrl = userInfo.user!.userImageUrl
                } else {
                    self.imageUrl = "https://doodleipsum.com/700/avatar-2?i"
                }

                let url = URL(string: self.imageUrl)
                let data = try? Data(contentsOf: url!)
                let image = UIImage(data: data!)
                
                self.profileImage.image = image
                self.profileName.text = userInfo.user?.name
                self.profileIntro.text = userInfo.user?.aboutMe
            }).disposed(by: disposeBag)
 
    }
    
    @IBOutlet weak var gearQuantity: UILabel!
    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var follower: UILabel!
    @IBOutlet weak var following: UILabel!

    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileIntro: UITextView!
    
    @IBAction func moveFollower(_ sender: Any) {
        
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "followerView") as! FollowerViewController
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    @IBAction func moveFollowing(_ sender: Any) {
        
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "followingView") as! FollowingViewController
        self.navigationController?.pushViewController(pushVC, animated: true)
        
    }
    @IBAction func showProfileEdit(_ sender: Any) {
        let pushEditVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileEditViewController") as! ProfileEditViewController
        pushEditVC.image = imageUrl
        pushEditVC.delegate = self
        self.navigationController?.pushViewController(pushEditVC, animated: true)
        
    }
}
