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

class ProfileViewController: UIViewController {
    let viewModel = ProfileViewModel()
    let disposeBag = DisposeBag()
    let store = Store.shared
    var imageUrl: String = ""

// MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"a", style: .plain, target: self, action: #selector(showPreferences))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(showPreferences))
        profileImage.circular(borderwidth: 4, bordercolor: UIColor.white.cgColor)
      
        profileIntro.isEditable = false
        
        setBind()
     
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputs.loadProfileInfo()
    }
   
    func setBind() {
        viewModel.outputs.followerCount
            .map { "\($0)"}
            .asDriver(onErrorJustReturn: "0")
            .drive(self.follower.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.followingCount
            .map { "\($0)" }
            .asDriver(onErrorJustReturn: "0")
            .drive(self.following.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.gearCount
            .map { "\($0)" }
            .asDriver(onErrorJustReturn: "0")
            .drive(self.gearQuantity.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.profile
            .subscribe(onNext:{ userInfo in

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
    
  
    @objc func showPreferences(){
        guard let VC = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as? NavigationController else {return}
        VC.modalPresentationStyle = .custom
        VC.transitioningDelegate = self
        VC.id = self

        present(VC, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var gearQuantity: UILabel!
    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var follower: UILabel!
    @IBOutlet weak var following: UILabel!

    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileIntro: UITextView!

    @IBAction func moveFollower(_ sender: Any) {

        guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "followerView") as? FollowerViewController else {return}
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    @IBAction func moveFollowing(_ sender: Any) {

        guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "followingView") as? FollowingViewController else {return}
        self.navigationController?.pushViewController(pushVC, animated: true)

    }
    @IBAction func showProfileEdit(_ sender: Any) {
        guard let pushEditVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileEditViewController") as? ProfileEditViewController else {return}
        pushEditVC.image = imageUrl
        self.navigationController?.pushViewController(pushEditVC, animated: true)

    }
}

extension ProfileViewController: UIViewControllerTransitioningDelegate{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
