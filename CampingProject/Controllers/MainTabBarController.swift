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
//        스토리보드가 서로 다를때
        let mainSB: UIStoryboard = UIStoryboard(name: "MyGear", bundle: nil)
        let objVC = mainSB.instantiateViewController(withIdentifier: "myGearView") as! MyGearViewController

        APIManager.shared.loadUserGear( completion: { userData in
            if userData{
                for i in UserGearViewModel.shared.userGears{
                    objVC.myGear.append(MyGearViewModel(myGear:CellData(id: i.id, name: i.name, gearTypeId: i.gearTypeId, gearTypeName: i.gearTypeName, color: i.color, company: i.company, capacity: i.capacity, price: i.price, buyDt: i.buyDt)))
                }
            }
        })
        print(objVC)
        self.setViewControllers([objVC], animated: false)
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



