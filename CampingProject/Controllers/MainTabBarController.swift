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
        
        userVM.loadFollower()
        userVM.loadFollowing()
        
        
        
    }
}


