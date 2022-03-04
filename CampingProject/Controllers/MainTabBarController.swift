//
//  GearListViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/03.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MainTabBarController: UITabBarController {

    let store = Store.shared
    let apiManger = APIManager.shared
    let disposeBag = DisposeBag()

// MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let searchUserNC = storyboard?.instantiateViewController(withIdentifier: "searchUserNC") as? SearchUserNC else {return}
        guard let profileNC = storyboard?.instantiateViewController(withIdentifier: "profileNC") as? ProfileNC else {return}
//        스토리보드 파일이 서로 다를때
        let myGearSB: UIStoryboard = UIStoryboard(name: "MyGear", bundle: nil)
        guard let myGearNC = myGearSB.instantiateViewController(withIdentifier: "myGearNC") as? MyGearNC else {return}

        self.setViewControllers([myGearNC, searchUserNC, profileNC], animated: false)
    }
}
