//
//  GearListViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/03.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    let userVM = UserViewModel.shared
    
//    MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        let searchUserNC = storyboard?.instantiateViewController(withIdentifier: "searchUserNC") as! SearchUserNC
        let profileNC = storyboard?.instantiateViewController(withIdentifier: "profileNC") as! ProfileNC
        
//        스토리보드 파일이 서로 다를때
        let mainSB: UIStoryboard = UIStoryboard(name: "MyGear", bundle: nil)
        let myGearNC = mainSB.instantiateViewController(withIdentifier: "myGearNC") as! MyGearNC

        self.setViewControllers([myGearNC,searchUserNC,profileNC], animated: false)
    }

}

extension MainTabBarController: UITabBarControllerDelegate {
    
//    장비등록화면 수정 추후 예정
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//
//        if tabBarController.viewControllers![2] != viewController {
//            return true
//        } else {
//            let modalViewController = asdf()
//            self.present(modalViewController, animated: true)
//            return false
//        }
//    }
    

    
}



