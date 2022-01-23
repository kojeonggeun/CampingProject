//
//  asdf.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/06.
//

import Foundation
import UIKit
import TextFieldEffects
import RxSwift
import RxCocoa
import simd

class GearDetailViewController: UIViewController {
    @IBOutlet weak var detailTableVC: UIView!
    @IBOutlet weak var detailCollectionVC: UIView!
    
    var imageArray: [ImageData] = []
    var gearId: Int = -1
    let apiManager = APIManager.shared
    
    let userGearVM = UserGearViewModel.shared
    let userVM = UserViewModel.shared
    let DidDeleteGearPost: Notification.Name = Notification.Name("DidDeleteGearPost")
    let DidDeleteCatogoryGearPost: Notification.Name = Notification.Name("DidDeleteCatogoryGearPost")
    
    let disposeBag:DisposeBag = DisposeBag()
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "장비 상세"
        requestData()
    }
    
    @IBAction func showDeleteAlert(_ sender: Any) {
        
        let id: Int = userGearVM.userGears[gearId].id

        let alert = UIAlertController(title: nil, message: "장비를 삭제 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "삭제", style: .default) { action in
            self.userGearVM.deleteUserGear(gearId: id, row: self.gearId)
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: self.DidDeleteGearPost, object: nil, userInfo: ["delete": true,"gearRow": self.gearId])
            NotificationCenter.default.post(name: self.DidDeleteCatogoryGearPost, object: nil)
        })
        alert.addAction(UIAlertAction(title: "취소", style: .default) { action in
            return
        })
        present(alert, animated: true)

    }
    @IBAction func gearEdit(_ sender: Any) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "GearEditView") as! GearEditViewController
        pushVC.gearRow = self.gearId
        
        self.navigationController?.pushViewController(pushVC, animated: true)
        
    }
    
    func requestData(){
        
        let userId = apiManager.userInfo?.user?.id
        
        userVM.loadDetailUserGearRx(userId: userId!, gearId: gearId)
            .subscribe(onNext: { data in
                    print(data)
            })
        
    }



}
