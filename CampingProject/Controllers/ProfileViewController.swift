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
    
    var userGearVM = UserGearViewModel()
    
//      09/29
//      TODO: 유저정보에서 프로필 이미지 가져와야 함 -> 따로 유저 정보 저장하는 뷰모델 필요할듯?
//      TODO: 프로필 수정 기능 구현 해야 함
//      TODO: 친구 추가, 요청 & 승인 기능 구현 해야 함


    //  MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global().async {
            let url = URL(string: "https://doodleipsum.com/600?shape=circle&bg=D4E2D4")
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                self.profileImage.image = image
            }
        }

        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        profileImage.layer.borderWidth = 4
        profileImage.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gearQuantity.text = "\(userGearVM.userGears.count)"
    }
}
