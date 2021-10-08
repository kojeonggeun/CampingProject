//
//  ProfileViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/28.
//

import Foundation
import UIKit


class ProfileViewController: UIViewController {
    
    @IBOutlet weak var gearQuantity: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var userGearVM = UserGearViewModel.shared
    var url: String = ""
    
    let userManager: UserViewModel = UserViewModel.shared
    
//      09/29
//      TODO: 유저정보에서 프로필 이미지 가져와야 함 -> 따로 유저 정보 저장하는 뷰모델 필요할듯?
//      TODO: 프로필 수정 기능 구현 해야 함
//      TODO: 친구 추가, 요청 & 승인 기능 구현 해야 함


    //  MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.userManager.userImage[0].user.userImageUrl != nil {
            url = self.userManager.userImage[0].user.userImageUrl
        } else {
            url = "https://doodleipsum.com/700/avatar-2?i"
        }
        print(url)
        DispatchQueue.global().async {
//            let url = URL(string: self.url)
            let url = URL(string: "https://doodleipsum.com/700/avatar-2?i")
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                self.profileImage.image = image
            }
        }
        
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.layer.borderWidth = 5
        profileImage.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        profileImage.layer.backgroundColor = CGColor(red: 249, green: 228, blue: 200, alpha: 1)
//        profileImage.clipsToBounds = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gearQuantity.text = "\(userGearVM.userGears.count)"
    }
}
