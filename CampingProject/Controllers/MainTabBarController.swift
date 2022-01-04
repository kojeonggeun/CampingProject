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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
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



