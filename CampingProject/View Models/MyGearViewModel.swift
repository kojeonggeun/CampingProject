//
//  MyGearViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2022/01/06.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import RxCocoa

class MyGearViewModel {
    
    static let shared = MyGearViewModel()
 
    let apiManager = APIManager.shared
    let userVM = UserViewModel.shared

    
    let gears = BehaviorRelay<[CellData]>(value: [])
    let disposeBag = DisposeBag()
    
    init() {
        userVM.loadUserGearRx()
            .subscribe(onNext: { data in
                self.gears.accept(data)
            }).disposed(by: disposeBag)
        
        
    }
}
