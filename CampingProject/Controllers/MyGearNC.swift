//
//  MyGearNC.swift
//  CampingProject
//
//  Created by 고정근 on 2022/01/07.
//

import Foundation
import UIKit
import RxSwift

class MyGearNC : UINavigationController {
    
    
    let userVM: UserViewModel = UserViewModel.shared
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myGearVC = self.viewControllers[0] as! MyGearViewController
        
        userVM.loadUserGearRx()
            .subscribe(onNext : { result in
                for i in result {
                    myGearVC.myGear.append(MyGearViewModel(myGear:CellData(id: i.id, name: i.name, gearTypeId: i.gearTypeId, gearTypeName: i.gearTypeName, color: i.color, company: i.company, capacity: i.capacity, price: i.price, buyDt: i.buyDt)))
                }
            }).disposed(by: disposeBag)

        
    }
}
