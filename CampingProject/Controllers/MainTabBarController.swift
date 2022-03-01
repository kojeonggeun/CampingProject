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
    
    let userGearVM = UserGearViewModel.shared
    let viewModel = ProfileViewModel.shared

    let apiManger = APIManager.shared
    let disposeBag = DisposeBag()
    
//    MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.delegate = self
        let searchUserNC = storyboard?.instantiateViewController(withIdentifier: "searchUserNC") as! SearchUserNC
        let profileNC = storyboard?.instantiateViewController(withIdentifier: "profileNC") as! ProfileNC
//        스토리보드 파일이 서로 다를때
        let myGearSB: UIStoryboard = UIStoryboard(name: "MyGear", bundle: nil)
        let myGearNC = myGearSB.instantiateViewController(withIdentifier: "myGearNC") as! MyGearNC
        
        self.setViewControllers([myGearNC,searchUserNC,profileNC], animated: false)
        
        var swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture))
        swipe.numberOfTouchesRequired = 1
        swipe.direction = .left
        self.view.addGestureRecognizer(swipe)
        
        swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture))
        swipe.numberOfTouchesRequired = 1
        swipe.direction = .right
        self.view.addGestureRecognizer(swipe)
        
    }

    @objc private func swipeGesture(swipe: UISwipeGestureRecognizer){
        switch swipe.direction{
        case .left:
            if selectedIndex > 0 {
                self.selectedIndex = self.selectedIndex - 1
            }
            break
        case .right:
            if selectedIndex > 3 {
                self.selectedIndex = self.selectedIndex - 1
            }
            break
        default:
            break
        }
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



