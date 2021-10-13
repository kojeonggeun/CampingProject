//
//  ProfileViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/28.
//

import Foundation
import UIKit



class ProfileViewController: UIViewController, ReloadData {
  
    
    @IBOutlet weak var gearQuantity: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileIntro: UITextView!
    
    var userGearVM = UserGearViewModel.shared
    var imageUrl: String = ""
    
    let userVM: UserViewModel = UserViewModel.shared
    
    @IBAction func showProfileEdit(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileEditViewController") as? ProfileEditViewController else {
                return
            }
        vc.image = imageUrl
        vc.delegate = self
        present(vc, animated: true)
        
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
        
        reloadData()
        
    }
    
    func reloadData() {
        
        if self.userVM.userInfo[0].user.userImageUrl != "" {
            imageUrl = self.userVM.userInfo[0].user.userImageUrl
        } else {
            imageUrl = "https://doodleipsum.com/700/avatar-2?i"
        }
        
        DispatchQueue.global().async {
            self.userVM.loadUserInfo(completion: { check in
                let url = URL(string: self.userVM.userInfo[0].user.userImageUrl)
                let data = try? Data(contentsOf: url!)
                
    //            TODO: 프로필 이미지 수정 좀 이상함
                DispatchQueue.main.async {
                    let image = UIImage(data: data!)
                    self.profileImage.image = image
                    
                    self.profileName.text = self.userVM.userInfo[0].user.name
                    self.profileIntro.text = self.userVM.userInfo[0].user.phone
                }
            })
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gearQuantity.text = "\(userGearVM.userGears.count)"
        
    }

}
